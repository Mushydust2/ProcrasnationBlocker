import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @State private var onboardingCompleted = false // Tracks if onboarding is complete

    let onboardingData = [
        OnboardingPage(imageName: "onboarding1", title: "Take Control of Your Focus. Block Distractions, Boost Productivity.", description: "Utilize our Website, Video, and Image Blocking features to control your focus."),
        OnboardingPage(imageName: "onboarding2", title: "Block distracting websites", description: "Use this app to add websites you want to block while working."),
        OnboardingPage(imageName: "onboarding3", title: "Enable the Safari Extension", description: "To start blocking unwanted content, please enable the Safari extension in your device settings.")
    ]

    var body: some View {
        if onboardingCompleted {
            MainTabView() // Transition to the main app
        } else {
            VStack {
                TabView(selection: $currentPage) {
                    ForEach(0..<onboardingData.count, id: \.self) { index in
                        OnboardingPageView(page: onboardingData[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(.page(backgroundDisplayMode: .always)) // Dots below the TabView

                // "Next" button
                Button(action: {
                    if currentPage < onboardingData.count - 1 {
                        currentPage += 1
                    } else {
                        // Mark onboarding as complete
                        UserDefaults.standard.set(true, forKey: "onboardingComplete")
                        onboardingCompleted = true
                    }
                }) {
                    Text(currentPage == onboardingData.count - 1 ? "Get Started" : "Next")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }

                // "Go to Settings" button (only on the last onboarding page)
                if currentPage == onboardingData.count - 1 {
                    Button(action: openSafariExtensionSettings) {
                        Text("Go to Safari Extension Settings")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.horizontal)
                    }
                    .padding(.top, 10)
                }
            }
        }
    }

    private func openSafariExtensionSettings() {
        if let url = URL(string: "App-prefs:Safari&path=EXTENSIONS") {
            UIApplication.shared.open(url, options: [:], completionHandler: { success in
                if success {
                    print("Opened Safari Extension settings.")
                } else {
                    print("Failed to open Safari Extension settings.")
                }
            })
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 300)

            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)

            Text(page.description)
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()
        }
        .padding()
    }
}
