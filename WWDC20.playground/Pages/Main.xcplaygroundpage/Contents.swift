import SwiftUI
import PlaygroundSupport

struct LevelView: View {
    @State private var selection = [Int]()
    @State private var filledWords: Set<Level.Word> = []
    @State private var bonusWords: Set<String> = []
    
    let level: Level
    let letters: [Character]
    
    var body: some View {
        let selectedWord = String(
            selection.map { letters[$0] })
        
        let binding = Binding(
            get: { self.selection },
            set: { newSelection in
                if newSelection.isEmpty {
                    if let foundWord = self.level.findWord(selectedWord) {
                        if !self.filledWords.contains(foundWord) {
                            self.filledWords.insert(foundWord)
                            AudioProvider.playSound(.triplePop())
                        }
                    } else if self.wordExists(selectedWord) {
                        withAnimation {
                            self.bonusWords.insert(selectedWord)
                        }
                    }
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
                
                self.makeCounter(self.bonusWords.count)
            }
        }
    }
    
    private func wordExists(_ word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(
            in: word, range: range, startingAt: 0,
            wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound &&
            word.count > 2
    }
    
    private func makeCounter(_ count: Int) -> some View {
        HStack {
            Text("Bonus words:")
                .font(.headline)
            Image(systemName: "\(count).circle.fill")
                .font(.title)
        }
        .foregroundColor(.accentColor)
        .id("Bonus \(count)")
        .transition(.scale)
        .padding()
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
    @State private var showingWelcome = true
    
    var body: some View {
        LevelView(for: "CrosswordSample")
            .sheet(isPresented: $showingWelcome) {
                WelcomeView { self.showingWelcome = false }
        }
    }
}

PlaygroundPage.current.setLiveView(
    ContentView().padding()
)
