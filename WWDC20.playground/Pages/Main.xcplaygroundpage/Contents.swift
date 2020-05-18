import SwiftUI
import PlaygroundSupport

struct LevelView: View {
    @Binding var levelCompleted: Bool
    
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
                    } else if self.level.bonusWords.contains(selectedWord) {
                        withAnimation {
                            self.bonusWords.insert(selectedWord)
                        }
                    }
                }
                
                if self.filledWords.count == self.level.words.count {
                    self.levelCompleted = true
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
    
    init(_ level: Level, completion: Binding<Bool>) {
        self.level = level
        self.letters = Array(level.letters)
        
        self._levelCompleted = completion
    }
    
    init(for name: String, completion: Binding<Bool>) {
        self.init(Bundle.main.decode(
            Level.self, from: "\(name).json"
        ), completion: completion)
    }
}

struct ContentView: View {
    @State private var showingSheet = true
    @State private var showingAlert = false
    
    var body: some View {
        LevelView(for: "CrosswordSample", completion: $showingAlert)
            .sheet(isPresented: $showingSheet, content: sheetContent)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Congratulations! 🎉"),
                      message: Text("You've successfully completed the level"),
                      dismissButton: .default(Text("Got it!")
                    ))}
    }
    
    func sheetContent() -> some View {
        WelcomeView { self.showingSheet = false }
    }
}

PlaygroundPage.current.setLiveView(
    ContentView().padding()
)
