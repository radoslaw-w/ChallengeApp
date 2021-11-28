//
//  ViewController+TrackerDelegate.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import UIKit
import CoreLocation

extension ViewController: TrackerDelegate {
    
    func didUpdateLocation(location: CLLocation) {
        searchPhoto(at:location)
        
    }
    
    private func alert(message:String){
        let alert = UIAlertController(title: "Warning",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    func didReceiveInsuffitientPermissions() {
        let message = """
        Without your permissions we will not be able to track your location.
        Please change Privacy settings.
        """
        self.alert(message: message)
        
    }
    
    func didDetectDeviceLimitations() {
        let message = """
        Monitoring is not avaliable on this device
        """
        self.alert(message: message)
    }
    
    
    
}
