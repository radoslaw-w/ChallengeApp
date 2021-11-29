//
//  Tracker.swift
//  ChallengeApp
//
//  Created by Radosław Winkler on 27/11/2021.
//

import Foundation
import CoreLocation
import Combine

class Tracker:NSObject {
    static let regionID = "regionIdentifier"
    
    let delegate:TrackerDelegate
    @Published var isTracking = false
    let moveSubject = PassthroughSubject<CLLocation,Never>()
    var cancellables = Set<AnyCancellable>()
    
    public lazy var locationManager:CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.requestAlwaysAuthorization()
        return locationManager
    }()
    
    public init(delegate:TrackerDelegate) {
        self.delegate = delegate
        super.init()
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self){
            self.delegate.didDetectDeviceLimitations()
        }
    }
    
    public func startTracking(){
        isTracking = true
        resumeMonitoring()
    }
    
    public func stopTracking(){
        isTracking = false
    }
    
    func monitorRegionFrom(location:CLLocation){
        let region = CLCircularRegion(center: location.coordinate, radius: 100, identifier: Self.regionID)
        region.notifyOnExit = true
        locationManager.startMonitoring(for: region)
    }
    
    func resumeMonitoring(){
        if isTracking {
            if let location = locationManager.location { 
                self.moveSubject.send(location)
                self.monitorRegionFrom(location:location)
            }else{
                locationManager.requestLocation()
            }
        }
    }
    
}
