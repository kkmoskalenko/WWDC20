import SwiftUI
import PlaygroundSupport

struct ContentView: View {
    @State var selection = [Int]()
    let characters = Array("SAVED")
    
    var word: String {
        String(selection.map { characters[$0] })
    }
    
    var body: some View {
        ZStack {
            Wheel(characters, selection: $selection.animation())
                .background(Circle()
                    .fill(Color.white))
                .animation(.none)
            
            Text(word)
                .font(.system(size: 80, weight: .black, design: .rounded))
                .foregroundColor(.orange)
                .transition(AnyTransition.scale
                    .combined(with: .opacity))
                .id(word)
                .zIndex(1)
        }.padding()
    }
}

PlaygroundPage.current.setLiveView(
    ContentView()
)
