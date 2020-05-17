import SwiftUI

public struct WordCapsule: View {
    var word: String
    var font: Font
    var removalDelay: Double
    
    private var paddingLength: CGFloat? {
        word.isEmpty ? 0 : nil
    }
    
    private var animation: Animation {
        Animation.interactiveSpring().delay(
            word.isEmpty ? removalDelay : 0
        )
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Text("\0")
            
            ForEach(Array(word), id: \.self) {
                Text(String($0))
                    .fontWeight(.semibold)
                    .transition(.asymmetric(
                        insertion: .scale,
                        removal: .opacity))
            }
        }
        .font(font)
        .padding(.vertical)
        .padding(.horizontal, paddingLength)
        .padding(.horizontal, paddingLength)
        .foregroundColor(.white)
        .background(Color.accentColor)
        .clipShape(Capsule())
        .animation(animation)
    }
    
    public init(_ word: String, font: Font = .system(
        .largeTitle, design: .rounded
        ), removalDelay: Double = 0.7
    ) {
        self.word = word
        self.font = font
        self.removalDelay = removalDelay
    }
}
