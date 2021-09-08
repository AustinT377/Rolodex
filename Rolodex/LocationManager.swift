//
//  LocationManager.swift
//  Rolodex
//
//  Created by Austin Turner on 9/29/20.
//  Copyright © 2020 Austin Turner. All rights reserved.
//

import UIKit
import CoreLocation

class LocationManager: NSObject {
    let locationManager = CLLocationManager()
    //shared manager so the same location manager is used throught the app
    static let shared = LocationManager()
    
    func requestLocation() {
        let status = CLLocationManager.authorizationStatus()
        
        //can be used to take actions based on type of authorization
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            return
        case .denied, .restricted:
            return
        case .authorizedAlways, .authorizedWhenInUse:
            break
        @unknown default:
            return
        }
    }
    
    
    func getDistance(address: String, completion: ((Double?) -> ())? = nil){
        guard let currentLocation = self.locationManager.location
        else {
            completion?(nil)
            return
        }
        
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
            else {
                completion?(nil)
                return
            }
            //convert to miles
            var distance = currentLocation.distance(from: location) / 1609.344 
            distance = round(10 * distance) / 10

            completion?(distance)
        }
    }
}
