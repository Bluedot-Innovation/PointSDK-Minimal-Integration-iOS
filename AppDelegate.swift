//
//  AppDelegate.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 13/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import BDPointSDK
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        requestNotificationPermissions()

        BDLocationManager.instance()?.pushNotifications.onNotificationReceived = { payload in
            print("Push received. zoneID: \(payload.zoneId)")
        }
        BDLocationManager.instance()?.pushNotifications.onNotificationClicked = { payload in
            print("Push clicked. zoneID: \(payload.zoneId)")
        }

        return true
    }

    private func requestNotificationPermissions() {
        Task {
            let center = UNUserNotificationCenter.current()
            do {
                guard try await center.requestAuthorization(options: [.alert, .sound, .badge]) else {
                    print("Push notification permission was denied")
                    return
                }

                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } catch {
                print("Push notification permission request failed: \(error.localizedDescription)")
            }
        }
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        BDLocationManager.instance()?.pushNotifications.register(deviceToken)
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Remote notification registration failed: \(error.localizedDescription)")
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        let handled = BDLocationManager.instance()?.pushNotifications.handleForeground(notification) ?? false
        return handled ? [.banner, .sound] : []
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        BDLocationManager.instance()?.pushNotifications.handleResponse(response)
        completionHandler()
    }
}
