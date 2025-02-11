import SwiftUI
import SpotlightKit

struct ContentView: View {
    @StateObject var spotlightManager = SpotlightManager()
    @State private var targetFrames: [UUID: CGRect] = [:]
    
    let headerID = UUID()
    let searchBarID = UUID()
    let featuredProductsID = UUID()
    let tabBarID = UUID()
    
    var body: some View {
        ZStack {
            VStack(spacing: 16) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Welcome Back,")
                            .font(.headline)
                        Text("Jane Doe")
                            .font(.largeTitle)
                            .bold()
                    }
                    Spacer()
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                .padding()
                .spotlightTarget(id: headerID)
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search for items")
                        .foregroundColor(.gray)
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .padding(.horizontal)
                .spotlightTarget(id: searchBarID)
                
                Text("Featured")
                    .font(.title2)
                    .bold()
                    .padding(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(0..<5, id: \.self) { index in
                            VStack {
                                AsyncImage(url: URL(string: "https://picsum.photos/seed/\(index)/200/300")) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } placeholder: {
                                    ProgressView()
                                }
                                .frame(width: 150, height: 100)
                                .clipped()
                                .cornerRadius(8)
                                
                                Text("Item \(index + 1)")
                                    .font(.subheadline)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 3)
                        }
                    }
                    .padding(.all)
                }
                .spotlightTarget(id: featuredProductsID)
                
                Spacer()
                
                HStack {
                    Spacer()
                    bottomBarButton(icon: "house.fill", title: "Home")
                    Spacer()
                    bottomBarButton(icon: "heart", title: "Restart")
                    Spacer()
                    bottomBarButton(icon: "cart", title: "Onboarding")
                    Spacer()
                    bottomBarButton(icon: "person", title: "Here")
                    Spacer()
                }
                .padding()
                .background(Color(.systemGray6))
                .spotlightTarget(id: tabBarID)
            }
            .onPreferenceChange(SpotlightTargetPreferenceKey.self) { prefs in
                self.targetFrames = prefs
            }
            
            if let currentStep = spotlightManager.currentStep,
               let frame = targetFrames[currentStep.id] {
                SpotlightOverlay(targetFrame: frame,
                                 message: currentStep.message,
                                 onNext: { spotlightManager.next() },
                                 tooltipPosition: currentStep.position)
                .transition(.opacity)
            }
        }
        .onAppear {
            startOnboarding()
        }
    }
    
    private func startOnboarding() {
        let steps = [
            SpotlightStep(id: headerID,
                          message: "This is your profile header where you can view your account details.",
                          position: .auto),
            SpotlightStep(id: searchBarID,
                          message: "Tap here to search for items in the app.",
                          position: .auto),
            SpotlightStep(id: featuredProductsID,
                          message: "These are featured items we recommend for you.",
                          position: .auto),
            SpotlightStep(id: tabBarID,
                          message: "Use the tab bar at the bottom to navigate through the app. Tap here to restart onboarding",
                          position: .custom(xOffset: 0, yOffset: -160))
        ]
        spotlightManager.start(steps: steps)
    }
    
    /// bottom bar button which restarts onboarding when tapped.
    private func bottomBarButton(icon: String, title: String) -> some View {
        Button(action: {
            startOnboarding()
        }) {
            VStack {
                Image(systemName: icon)
                Text(title)
                    .font(.caption)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
