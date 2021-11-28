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
        if isTracking {
            guard let location = locations.first else {
                locationManager.requestLocation()
                return
            }
            self.delegate.didUpdateLocation(location: location)
            self.monitorRegionFrom(location:location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        locationManager.stopMonitoring(for: region)
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        if isTracking {
            locationManager.requestLocation()
        }
    }
    
    // MARK: - Authorization
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            switch manager.authorizationStatus {
            case .authorizedWhenInUse,.notDetermined: break
            default: self.delegate.didReceiveInsuffitientPermissions()
            }
        }
    }
}
