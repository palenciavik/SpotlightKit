import SwiftUI

public struct SpotlightStep: Identifiable {
    public let id: UUID
    let message: String
    let position: Tooltip.TooltipPosition
    
    public init(id: UUID, message: String, position: Tooltip.TooltipPosition) {
        self.id = id
        self.message = message
        self.position = position
    }
}
