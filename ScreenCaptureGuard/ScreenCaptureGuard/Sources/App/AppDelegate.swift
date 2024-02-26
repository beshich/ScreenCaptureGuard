//
//  AppDelegate.swift
//  ScreenCaptureGuard
//
//  Created by Agatai Embeev on 25.02.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupRootView()
        return true
    }
}

private extension AppDelegate {
    
    func setupRootView() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = HomeViewController()
        window?.makeKeyAndVisible()
        
        ScreenCaputreGuard.shared.startPreventing()
    }
}
