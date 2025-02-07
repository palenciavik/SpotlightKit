import SwiftUI

public struct SpotlightStep: Identifiable {
    public let id: UUID
    public let message: String
    public let position: Tooltip.TooltipPosition
}
