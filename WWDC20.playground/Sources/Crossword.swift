import SwiftUI

public struct Crossword: View {
    private let level: Level
    private let cells: [[Cell]]
    private let spacing: CGFloat
    
    public var body: some View {
        GeometryReader { self.makeBody($0.size) }
    }
    
    private func makeBody(_ size: CGSize) -> some View {
        let cellLength: CGFloat = {
            let rows = CGFloat(level.rowCount)
            let cols = CGFloat(level.colCount)
            
            return min(
                (size.width - spacing * (cols - 1)) / cols,
                (size.height - spacing * (rows - 1)) / rows
            )
        }()
        
        return VStack(spacing: spacing) {
            ForEach(0 ..< level.rowCount, id: \.self) { row in
                HStack(spacing: self.spacing) {
                    ForEach(0 ..< self.level.colCount, id: \.self) { column in
                        self.makeCell(
                            self.cells[row][column],
                            length: cellLength
                        )
                    }
                }
            }
        }
    }
    
    private func makeCell(_ cell: Cell, length: CGFloat) -> some View {
        let font = Font.system(
            size: 0.7 * length,
            weight: .medium,
            design: .rounded)
        
        let bgColor: Color = {
            switch cell {
            case .none: return Color.clear
            case .empty: return Color.gray.opacity(0.5)
            case .filled: return Color.blue
            }
        }()
        
        return Text(String(cell.character))
            .font(font)
            .frame(width: length, height: length)
            .foregroundColor(.white)
            .background(bgColor)
            .clipShape(RoundedRectangle(
                cornerRadius: 0.1 * length
            ))
    }
    
    public init(level: Level, filledWords: Set<Level.Word> = [], spacing: CGFloat = 0) {
        self.level = level
        self.cells = level.generateMatrix(
            with: filledWords)
        self.spacing = spacing
    }
}

extension Crossword {
    fileprivate enum Cell: Equatable {
        case none, empty
        case filled(Character)
        
        var isNone: Bool { self == .none }
        var isEmpty: Bool { self == .empty }
        
        var isFilled: Bool {
            if case .filled = self
            { return true }
            
            return false
        }
        
        var character: Character {
            switch self {
            case .none, .empty: return Character("\0")
            case .filled(let char): return char
            }
        }
    }
}

extension Level {
    fileprivate func generateMatrix(with filled: Set<Level.Word> = []) -> [[Crossword.Cell]] {
        var matrix: [[Crossword.Cell]] = Array(
            repeating: Array(repeating: .none, count: colCount),
            count: rowCount)
        
        for word in words {
            let chars = Array(word.word)
            for (i, char) in zip(chars.indices, chars) {
                let pos = word.vertical ?
                    (i + word.rowIndex, word.colIndex) :
                    (word.rowIndex, i + word.colIndex)
                
                if !matrix[pos.0][pos.1].isFilled {
                    matrix[pos.0][pos.1] = filled.contains(word) ?
                        .filled(char) : .empty
                }
            }
        }
        
        return matrix
    }
}
