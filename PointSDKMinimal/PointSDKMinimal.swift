//
//  PointSDKMinimal.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 12/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import SwiftUI

@main
struct PointSDKMinimal: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}
