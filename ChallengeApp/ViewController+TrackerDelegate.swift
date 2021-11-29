//
//  ViewController+TrackerDelegate.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import UIKit
import CoreLocation

extension ViewController: TrackerDelegate {
    
    func didReceiveInsuffitientPermissions() {
        let message = """
        Please change Privacy settings to Always Allow tracking.
        Without your permissions we will not be able to track your locations in background mode.
        """
        self.alert(message: message)
        
    }
    
    func didDetectDeviceLimitations() {
        let message = """
        Monitoring is not avaliable on this device :(
        """
        self.alert(message: message)
    }
    
    private func alert(message:String){
        let alert = UIAlertController(title: "Thank you!",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
}
