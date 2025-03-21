import SwiftUI

public class SpotlightManager: ObservableObject {
    @Published var steps: [SpotlightStep] = []
    @Published var currentIndex: Int = 0
    
    public init() { }
    
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


public struct SpotlightTargetPreferenceKey: PreferenceKey {
    public typealias Value = [UUID: CGRect]
    public static var defaultValue: [UUID: CGRect] = [:]
    
    public static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

public struct SpotlightTargetModifier: ViewModifier {
    let id: UUID
    
    public init(id: UUID) {
        self.id = id
    }
    
    public func body(content: Content) -> some View {
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
