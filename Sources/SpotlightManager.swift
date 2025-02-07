import SwiftUI

public class SpotlightManager: ObservableObject {
    @Published var steps: [SpotlightStep] = []
    @Published var currentIndex: Int = 0
    
    public var currentStep: SpotlightStep? {
        guard currentIndex < steps.count else { return nil }
        return steps[currentIndex]
    }
    
    public func next() {
        if currentIndex < steps.count - 1 {
            currentIndex += 1
        } else {
            currentIndex = 0
            steps.removeAll()
        }
    }
    
    public func start(steps: [SpotlightStep]) {
        self.steps = steps
        self.currentIndex = 0
    }
}


struct SpotlightTargetPreferenceKey: PreferenceKey {
    typealias Value = [UUID: CGRect]
    static var defaultValue: [UUID: CGRect] = [:]
    
    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

struct SpotlightTargetModifier: ViewModifier {
    let id: UUID
    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { proxy in
                    Color.clear
                        .preference(key: SpotlightTargetPreferenceKey.self, value: [id: proxy.frame(in: .global)])
                }
            )
    }
}

public extension View {
    func spotlightTarget(id: UUID) -> some View {
        self.modifier(SpotlightTargetModifier(id: id))
    }
}
