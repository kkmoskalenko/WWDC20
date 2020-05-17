import SwiftUI

private struct WheelSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct IdentifiableCharacter: Identifiable {
    var id: String { "\(index) \(character)" }

    let index: Int
    let character: Character
}

extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
    
    var penultimate: Element? {
        self[safe: count - 2]
    }
}

extension CGSize {
    var incircleRadius: CGFloat {
        min(width, height) / 2
    }
}

private func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
    let xDistance = from.x - to.x
    let yDistance = from.y - to.y
    
    return xDistance * xDistance + yDistance * yDistance
}

// MARK: - Wheel

public struct Wheel: View {
    private let characters: [IdentifiableCharacter]
    @Binding private var selectedIndices: [Int]
    
    @State private var size = CGSize.zero
    @State private var positions = [CGPoint]()
    @GestureState private var dragLocation: CGPoint?
    
    public init(_ characters: [Character], selection: Binding<[Int]>) {
        self.characters = characters.enumerated()
            .map(IdentifiableCharacter.init)
        self._selectedIndices = selection
    }
    
    private var charactersView: some View {
        ForEach(characters) { item in
            CharacterView(
                item.character, fontSize: self.fontSize,
                isSelected: self.selected(at: item.index)
            ).position(self.position(at: item.index))
        }
    }
    
    public var body: some View {
        GeometryReader { proxy in
            self.charactersView.anchorPreference(
                key: WheelSizeKey.self, value: .bounds
            ) { proxy[$0].size }
        }
        .background(Joins(
            points: selectedIndices.map { position(at: $0) },
            dragLocation: allSelected ? nil : dragLocation)
                .stroke(Color.accentColor, style: joinsStrokeStyle))
        .gesture(drag)
        .onPreferenceChange(WheelSizeKey.self) {
            self.size = $0
            self.updatePositions()
        }
    }
    
    private func updatePositions(radiusMult: CGFloat = 0.65, clockwise: Bool = false) {
        positions = characters.map { item in
            let segmentAngle: CGFloat = (2 * CGFloat.pi) / CGFloat(characters.count)
            let angle: CGFloat = segmentAngle * CGFloat(item.index) - 0.5 * CGFloat.pi
            let radius: CGFloat = radiusMult * size.incircleRadius
            
            var pos = CGPoint(
                x: radius * cos(angle),
                y: radius * sin(angle)
            )
            
            if !clockwise { pos.x *= -1 }
            
            pos.x += size.width / 2
            pos.y += size.height / 2
            
            return pos
        }
    }
    
    private var drag: some Gesture {
        DragGesture(minimumDistance: 0)
            .updating(self.$dragLocation) { value, state, _ in
                state = value.location
            }
            .onChanged { _ in
                if let selectedIndex = self.findSelection() {
                    if !self.selected(at: selectedIndex) {
                        self.selectedIndices.append(selectedIndex)
                    }
                    
                    if selectedIndex == self.selectedIndices.penultimate {
                        self.selectedIndices.removeLast()
                    }
                }
            }
            .onEnded { _ in self.selectedIndices.removeAll() }
    }
    
    private func position(at index: Int) -> CGPoint {
        positions[safe: index] ?? .zero
    }
    
    private func findSelection() -> Int? {
        guard let location = dragLocation
            else { return nil }
        
        return positions.lastIndex {
            CGPointDistanceSquared(
                from: $0, to: location
            ) < hitRadius * hitRadius
        }
    }
    
    private func selected(at index: Int) -> Bool {
        selectedIndices.contains(index)
    }
    
    private var allSelected: Bool {
        selectedIndices.count == characters.count
    }
    
    private var fontSize: CGFloat {
        0.55 * size.incircleRadius
    }
    
    private var hitRadius: CGFloat {
        0.5 * fontSize
    }
    
    private var joinsStrokeStyle: StrokeStyle {
        StrokeStyle(
            lineWidth: 0.1 * size.incircleRadius,
            lineCap: .round, lineJoin: .round
        )
    }
}

private struct Joins: Shape {
    var points: [CGPoint]
    var dragLocation: CGPoint?
    
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.addLines(points)
            
            if let point = dragLocation {
                path.addLine(to: point)
            }
        }
    }
}
