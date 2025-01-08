import UIKit
import SwiftUI
import UserNotifications

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            // Check if onboarding is complete
            let onboardingComplete = false//UserDefaults.standard.bool(forKey: "onboardingComplete")
            
            // Set the initial view
            if onboardingComplete {
                window.rootViewController = UIHostingController(rootView: MainTabView())
            } else {
                window.rootViewController = UIHostingController(rootView: OnboardingView())
            }

            self.window = window
            window.makeKeyAndVisible()
        }
        
        // Request notification permissions
        requestNotificationPermissions()
    }

    func requestNotificationPermissions() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else {
                print("Notification permission denied: \(String(describing: error))")
            }
        }
    }

    func scheduleRatingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Enjoying the App?"
        content.body = "If you're finding the blocker useful, please consider leaving us a review on the App Store!"
        content.sound = .default

        // Schedule notification for 24 hours later
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 60 * 60, repeats: false)
        let request = UNNotificationRequest(identifier: "RatingRequest", content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}
