//
//  MainViewModel.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 13/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import Foundation
import BDPointSDK
import UIKit

@MainActor
class MainViewModel: NSObject, ObservableObject {

    // Use a project Id acquired from the Canvas UI.
    var projectId = "YourProjectId" // Canvas > Projects > Project ID
    
    // Use a Tempo Destination Id from the Canvas UI.
    var tempoDestinationId = "YourTempoDestinationId" // Canvas > Stores > Store Information > Destination ID
    
    @Published var showAlert = false
    @Published var alertTitle = ""
    @Published var alertMessage = ""
    
    @Published var isSDKInitialized = false
    @Published var isGeoTriggerRunning = false
    @Published var isTempoRunning = false

    var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    override init() {
        super.init()
        BDLocationManager.instance()?.bluedotServiceDelegate = self
        BDLocationManager.instance()?.geoTriggeringEventDelegate = self
        BDLocationManager.instance()?.tempoTrackingDelegate = self
    }

    //MARK: Initialize BDPoint SDK
    func initializeSDK() {
        if BDLocationManager.instance()?.isInitialized() == false {
            BDLocationManager.instance()?.initialize(
                withProjectId: projectId) { error in
                guard error == nil else {
                    print("Initialisation Error: \(String(describing: error?.localizedDescription))")
                    self.showAlert(title: "Initialisation Error", message: error?.localizedDescription ?? "")
                    return
                }
                
                print( "Initialised successfully with BDPoint SDK" )
                self.isSDKInitialized = true
            }
        }
    }
    
    func resetSDK() {
        if BDLocationManager.instance()?.isInitialized() == true {
            BDLocationManager.instance()?.reset(){ error in
                guard error == nil else {
                    print("Reset Error \(String(describing: error?.localizedDescription)) ")
                    self.showAlert(title: "Reset Error", message: error?.localizedDescription ?? "")
                    return
                }
                
                print("Point SDK Reset successfully")
                self.isSDKInitialized = false
                self.isGeoTriggerRunning = false
                self.isTempoRunning = false
            }
        } else {
            self.showAlert(title: "Error", message: "SDK is not initialised")
        }
    }
    
    //MARK: GeoTriggering
    func startGeoTriggering() {
        BDLocationManager.instance()?.startGeoTriggering() { error in
            guard error == nil else {
                print("Start Geotriggering Error:  \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Start Geotriggering Error", message: error?.localizedDescription ?? "")
                return
            }
            
            print("Start Geotriggering successfully")
            self.isGeoTriggerRunning = true
        }
    }
    
    func stopGeoTriggering() {
        BDLocationManager.instance()?.stopGeoTriggering() { error in
            guard error == nil else {
                print("Stop Geotriggering Error \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Stop Geotriggering Error", message: error?.localizedDescription ?? "")
                return
            }
            
            print("Stop Geotriggering successfully")
            self.isGeoTriggerRunning = false
        }
    }
    
    //MARK: Tempo
    func startTempo() {
        BDLocationManager.instance()?.startTempoTracking(withDestinationId: tempoDestinationId) { error in
            guard error == nil else {
                print("Start Tempo Error: \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Start Tempo Error", message: error?.localizedDescription ?? "")
                return
            }
            
            print("Start Tempo successfully")
            self.isTempoRunning = true
        }
    }
    
    func stopTempo() {
        BDLocationManager.instance()?.stopTempoTracking() { error in
            guard error == nil else {
                print("Stop Tempo Error \(String(describing: error?.localizedDescription))")
                self.showAlert(title: "Stop Tempo Error", message: error?.localizedDescription ?? "")
                return
            }
            
            print("Stop Tempo successfully")
            self.isTempoRunning = false
        }
    }
        
    //MARK: Private
    func requestLocationPermissions() {
        BDLocationManager.instance()?.requestWhenInUseAuthorization()
    }
    
    func notifyUser(title: String, message: String) {
        if UIApplication.shared.applicationState == .active {
            showAlert(title: title, message: message)
        } else {
            scheduleNotification(message: message)
        }
    }
    
    func showAlert(title: String, message: String = "") {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
        
    func scheduleNotification(message: String) {
        let content = UNMutableNotificationContent()
        content.title = "BDPoint notification"
        content.body = message
        content.sound = .default

        let request = UNNotificationRequest(identifier: "BDPointNotification",
                                            content: content,
                                            trigger: nil)

        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Notification error: \(error)")
            }
        }
    }
    
    func openLocationSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString),
              UIApplication.shared.canOpenURL(url) else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
