import SwiftUI

public struct WelcomeView: View {
    let action: () -> Void
    
    public init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    public var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack {
                    Spacer()
                    
                    VStack {
                        Text("Welcome to")
                        Text("Word Game")
                            .foregroundColor(.accentColor)
                    }
                    .font(.system(
                        size: 36, weight: .black, design: .rounded))
                    
                    VStack(alignment: .leading, spacing: 20) {
                        DetailView(
                            title: "Spell",
                            description: "Use a swipeable wheel of letters to spell a word.",
                            imageName: "a.circle")
                        
                        DetailView(
                            title: "Fill",
                            description: "An empty crossword pattern is filled with the entered words.",
                            imageName: "square.and.pencil")
                        
                        DetailView(
                            title: "Extra",
                            description: "You can find some extra words that don't fit in the puzzle.",
                            imageName: "star")
                    }
                    
                    Spacer(minLength: 50)
                    
                    Button(action: self.action) {
                        Text("Continue")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(RoundedRectangle(cornerRadius: 15)
                                .fill(Color.accentColor))
                    }.padding(.bottom)
                }
                .padding()
                .frame(maxWidth: 750 / 2, minHeight: proxy.size.height)
            }
        }
    }
    
    struct DetailView: View {
        var title: String
        var description: String
        var imageName: String
        
        var body: some View {
            HStack {
                Image(systemName: imageName)
                    .font(.largeTitle)
                    .foregroundColor(.accentColor)
                    .frame(width: 40)
                    .padding()
                
                VStack(alignment: .leading) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false,
                                   vertical: true)
                }
            }
        }
    }
}
