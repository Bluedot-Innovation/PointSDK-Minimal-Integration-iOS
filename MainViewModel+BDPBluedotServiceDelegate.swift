//
//  MainViewModel+BDPBluedotServiceDelegate.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 13/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import Foundation
@preconcurrency import BDPointSDK

extension MainViewModel: @preconcurrency BDPBluedotServiceDelegate {
    
    //MARK: Called when Device's low power mode status changed
    func lowPowerModeDidChange(_ isLowPowerMode: Bool) {
        if isLowPowerMode {
            self.showAlert(title: "Low Power Mode", message: "Low Power Mode has been enabled on this device.  To restore full location precision, disable the setting at :\nSettings → Battery → Low Power Mode")
        }
    }
    
    //MARK: Called when location authorization status changed
    func locationAuthorizationDidChange(fromPreviousStatus previousAuthorizationStatus: CLAuthorizationStatus,
                                        toNewStatus newAuthorizationStatus: CLAuthorizationStatus) {
        self.authorizationStatus = newAuthorizationStatus
        
        switch authorizationStatus {
        case .denied:
            let appName = Bundle.main.object( forInfoDictionaryKey: "CFBundleDisplayName" )
            let title = "Location Services Required"
            let message = "This App requires Location Services which are currently set to \(authorizationStatus == .authorizedWhenInUse ? "while in using" : "disabled").  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n\(String(describing: appName)) ✓"
            self.showAlert(title: title, message: message)

        case .authorizedWhenInUse:
            let title = "Location Services set to 'While in Use'"
            let message = "You can ask for further location permission from user via this delegate method"
            self.showAlert(title: title, message: message)
        default:
            print("Authorization has been changed")
        }
    }
    
    //MARK: Called when location accuracy authorization status changed
    func accuracyAuthorizationDidChange(fromPreviousAuthorization previousAccuracyAuthorization: CLAccuracyAuthorization,
                                        toNewAuthorization newAccuracyAuthorization: CLAccuracyAuthorization) {
        switch newAccuracyAuthorization {
        case .reducedAccuracy:
            let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName")
            let title = "Accuracy Authorization set to Reduced Accuracy"
            let message = "This App requires Location Services which are currently set to Reduced Accuracy.  To restore Location Services, go to :\nSettings → Privacy →\nLocation Settings →\n\(String(describing: appName)) ✓"
            
            self.showAlert(title: title, message: message)
        default:
            print("Accuracy has been changed")
        }
    }
    
    func bluedotServiceDidReceiveError(_ error: Error!) {
        print("bluedotServiceDidReceiveError: \(error.localizedDescription)")
    }
}
