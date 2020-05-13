import SwiftUI

struct CharacterView: View {
    private let string: String
    private let fontSize: CGFloat
    private let isSelected: Bool
    
    init(_ character: Character, fontSize: CGFloat, isSelected: Bool) {
        self.string = character.uppercased()
        self.fontSize = fontSize
        self.isSelected = isSelected
    }
    
    private var font: Font {
        .system(size: fontSize, weight: .bold, design: .rounded)
    }
    
    private var textColor: Color { isSelected ? .white : .black }
    private var background: some ShapeStyle {
        isSelected ? Color.orange : Color.clear
    }
    
    var body: some View {
        Text(string)
            .font(font)
            //.baselineOffset(0.05 * fontSize)
            .frame(maxWidth: .infinity)
            .foregroundColor(textColor)
            .background(Circle()
                .fill(background))
    }
}
