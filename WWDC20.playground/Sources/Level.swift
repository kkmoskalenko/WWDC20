public struct Level: Codable, Identifiable {
    public var id: String
    
    public var rowCount: Int
    public var colCount: Int
    public var letters: String
    public var words: Set<Word>
    public var bonusWords: Set<String>
    
    public struct Word: Codable, Hashable {
        public var word: String
        public var vertical: Bool
        public var rowIndex: Int
        public var colIndex: Int
    }
}

extension Level {
    public func findWord(_ string: String) -> Word? {
        words.first { $0.word == string }
    }
}
