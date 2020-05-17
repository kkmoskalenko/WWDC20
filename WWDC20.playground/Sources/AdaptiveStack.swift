import SwiftUI

public struct AdaptiveStack<Content: View>: View {
    let spacing: CGFloat?
    let content: () -> Content
    
    public var body: some View {
        GeometryReader { proxy in
            if proxy.size.width > proxy.size.height {
                HStack(spacing: self.spacing, content: self.content)
            } else {
                VStack(spacing: self.spacing, content: self.content)
            }
        }
    }
    
    public init(spacing: CGFloat? = nil, @ViewBuilder content: @escaping () -> Content) {
        self.spacing = spacing
        self.content = content
    }
}
