import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    var body: some View {
        let level = Bundle.main.decode(
            Level.self, from: "CrosswordSample.json"
        )
        
        let filledWords = level.words
            .filter { $0.word.count < 5 }
        
        return Crossword(
            level: level,
            filledWords: filledWords,
            spacing: 3
        )
    }
}

PlaygroundPage.current.setLiveView(
    ContentView().padding()
)
