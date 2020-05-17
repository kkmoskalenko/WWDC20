import SwiftUI

public struct CongratulationsView: View {
    public init() {}
    
    public var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(
                    colors: [.red, .orange]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
            
            VStack {
                Text("Congratulations! 🎉")
                    .font(.system(.largeTitle, design: .rounded))
                    .fontWeight(.black)
                
                Spacer().frame(height: 20)
                
                Text("You've successfully completed the level")
                    .font(.system(.title, design: .rounded))
                    .fixedSize(horizontal: false,
                               vertical: true)
            }.padding()
        }
        .foregroundColor(.white)
        .multilineTextAlignment(.center)
        .edgesIgnoringSafeArea(.all)
    }
}
