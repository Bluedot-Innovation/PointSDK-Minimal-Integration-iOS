//
//  MainViewModel+BDPTempoTrackingDelegate.swift
//  PointSDKMinimal
//
//  Created by Nataliia Klymenko on 13/6/2025.
//  Copyright © 2025 Bluedot Innovation. All rights reserved.
//

import Foundation
@preconcurrency import BDPointSDK

extension MainViewModel: @preconcurrency BDPTempoTrackingDelegate {
    
    func tempoTrackingDidUpdate(_ tempoUpdate: TempoTrackingUpdate) {
        print("tempoTrackingDidUpdate: '\(tempoUpdate.destination?.name ?? "")' - eta:\(tempoUpdate.eta) minutes")
    }
    
    func didStopTrackingWithError(_ error: Error!) {
        print("didStopTrackingWithError: \(error.localizedDescription)")
        self.isTempoRunning = false
        self.showAlert(title: "didStopTrackingWithError", message: error.localizedDescription)
    }
    
    func tempoTrackingDidExpire() {
        print("tempoTrackingDidExpire")
        self.isTempoRunning = false
        self.showAlert(title: "tempoTrackingDidExpire")
    }
}
