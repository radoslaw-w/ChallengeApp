//
//  Tracker+CLLocationManagerDelegate.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import Foundation
import CoreLocation
import UIKit

extension Tracker: CLLocationManagerDelegate {
    
    // MARK: - Location updates
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        resumeMonitoring()
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        resumeMonitoring()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        resumeMonitoring()
    }
    
    // MARK: - Authorization
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways,.notDetermined: break
            default: self.delegate.didReceiveInsuffitientPermissions()
            }
    }
}
