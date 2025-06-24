//
//  AppDelegate.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 13/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        requestNotificationPermissions()
        
        return true
    }
    
    func requestNotificationPermissions() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                if try await center.requestAuthorization(options: [.alert, .sound]) == true {
                    print("Request Notification Permissions - Success")
                } else {
                    print("Request Notification Permissions - Success")
                }
                
            } catch {
                print("Request Notification Permissions - Error")
            }
        }
    }
}
