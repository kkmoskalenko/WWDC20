import SwiftUI
import PlaygroundSupport

struct LevelView: View {
    @State private var selection = [Int]()
    @State private var filledWords: Set<Level.Word> = []
    
    let level: Level
    let letters: [Character]
    
    var body: some View {
        let selectedWord = String(
            selection.map { letters[$0] })
        
        let binding = Binding(
            get: { self.selection },
            set: { newSelection in
                if let foundWord = self.level.findWord(selectedWord),
                    newSelection.isEmpty,
                    !self.filledWords.contains(foundWord)
                {
                    self.filledWords.insert(foundWord)
                    AudioProvider.playSound(.triplePop())
                }
                
                self.selection = newSelection
                AudioProvider.playSound(.pop(newSelection.count))
        })
        
        return AdaptiveStack(spacing: 30) {
            Crossword(
                level: self.level,
                filledWords: self.filledWords,
                spacing: 3
            ).animation(.easeInOut)
            
            VStack(spacing: 15) {
                WordCapsule(selectedWord)
                
                Wheel(self.letters, selection: binding)
                    .background(Circle().fill(Color(UIColor
                        .secondarySystemBackground
                    )))
                    .frame(maxWidth: 400, maxHeight: 400)
            }
        }
    }
    
    init(_ level: Level) {
        self.level = level
        self.letters = Array(level.letters)
    }
    
    init(for name: String) {
        self.init(Bundle.main.decode(
            Level.self, from: "\(name).json"
        ))
    }
}

struct ContentView: View {
    var body: some View {
        LevelView(for: "CrosswordSample")
    }
}

PlaygroundPage.current.setLiveView(
    ContentView().padding()
)
