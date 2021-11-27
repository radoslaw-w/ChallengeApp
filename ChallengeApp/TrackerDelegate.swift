//
//  TrackerDelegate.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import Foundation
import CoreLocation

protocol TrackerDelegate{
    func didReceiveInsuffitientPermissions()
    func didDetectDeviceLimitations()
    func didUpdateLocation(location:CLLocation)
}
