import SwiftUI

public struct Tooltip: View {
    
    public enum TooltipPosition {
        case auto
        case above
        case below
        case left
        case right
        case custom(xOffset: CGFloat, yOffset: CGFloat)
    }
    
    let message: String
    
    public var body: some View {
        Text(message)
            .foregroundStyle(Color.primary)
            .padding()
            .background(Color(UIColor.systemBackground))
            .cornerRadius(8)
            .shadow(radius: 4)
    }
}
