import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State var selection = [Int]()
    let characters = Array("SAVED")
    
    var word: String {
        String(selection.map { characters[$0] })
    }
    
    var body: some View {
        VStack {
            WordCapsule(word)
            
            Wheel(characters, selection: $selection)
                .background(Circle().fill(Color.white))
        }.padding()
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
)
