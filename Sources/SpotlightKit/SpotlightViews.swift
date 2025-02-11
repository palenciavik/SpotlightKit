import SwiftUI

struct SpotlightMaskShape: Shape {
    let fullRect: CGRect
    let holeRect: CGRect
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.addRect(fullRect)
        path.addPath(Path(roundedRect: holeRect, cornerRadius: cornerRadius))
        return path
    }
}

public struct SpotlightOverlay: View {
    let targetFrame: CGRect
    public let message: String
    public let onNext: () -> Void

    let tooltipPosition: Tooltip.TooltipPosition
    
    public init(targetFrame: CGRect,
                message: String,
                onNext: @escaping () -> Void,
                tooltipPosition: Tooltip.TooltipPosition) {
        self.targetFrame = targetFrame
        self.message = message
        self.onNext = onNext
        self.tooltipPosition = tooltipPosition
    }

    @Environment(\.colorScheme) var colorScheme

    var overlayColor: Color {
        colorScheme == .dark
            ? Color.white.opacity(0.6) : Color.black.opacity(0.6)
    }

    public var body: some View {
        ZStack {
            overlayColor
                .mask(
                    SpotlightMaskShape(
                        fullRect: UIScreen.main.bounds,
                        holeRect: targetFrame,
                        cornerRadius: 8
                    )
                    .fill(style: FillStyle(eoFill: true))
                )
                .edgesIgnoringSafeArea(.all)
                .onTapGesture {
                    onNext()
                }

            tooltipView
        }
        .animation(.easeInOut, value: targetFrame)
    }

    @ViewBuilder
    private var tooltipView: some View {
        switch tooltipPosition {
        case .auto:
            // If target is in the lower half, place tooltip above; otherwise below.
            if targetFrame.midY > UIScreen.main.bounds.midY {
                VStack {
                    Spacer().frame(height: targetFrame.minY - 80)
                    Tooltip(message: message)
                        .padding(.horizontal)
                    Spacer()
                }
            } else {
                VStack {
                    Spacer().frame(height: targetFrame.maxY + 80)
                    Tooltip(message: message)
                        .padding(.horizontal)
                    Spacer()
                }
            }

        case .above:
            VStack {
                Spacer().frame(height: max(targetFrame.minY - 80, 0))
                Tooltip(message: message)
                    .padding(.horizontal)
                Spacer()
            }

        case .below:
            VStack {
                Spacer().frame(height: targetFrame.maxY + 20)
                Tooltip(message: message)
                    .padding(.horizontal)
                Spacer()
            }

        case .left:
            // Place the tooltip to the left of the target, center-aligned vertically.
            HStack {
                Spacer().frame(width: max(targetFrame.minX - 200, 0))
                VStack {
                    Spacer().frame(height: targetFrame.midY - 40)
                    Tooltip(message: message)
                    Spacer()
                }
                Spacer()
            }

        case .right:
            HStack {
                Spacer().frame(width: targetFrame.maxX + 20)
                VStack {
                    Spacer().frame(height: targetFrame.midY - 40)
                    Tooltip(message: message)
                    Spacer()
                }
                Spacer()
            }

        case .custom(let xOffset, let yOffset):
            Tooltip(message: message)
                .position(
                    x: targetFrame.midX + xOffset, y: targetFrame.midY + yOffset
                )
        }
    }
}
