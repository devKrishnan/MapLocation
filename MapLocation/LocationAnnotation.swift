//
//  LocationAnnotation.swift
//  MapLocation
//
//  Created by radhakrishnan S on 01/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import Foundation
import MapKit
class Annotation : NSObject, MKAnnotation {
    private var information : Dictionary<String, Any>?
    init(geoCodedInformation : Dictionary<String, Any>) {
        self.information = geoCodedInformation
    }
    var coordinate: CLLocationCoordinate2D {
        let geometry = information?["geometry"] as! [String:AnyObject]
        let location = geometry["location"] as! [String:AnyObject]
        let coordinate =  CLLocationCoordinate2D(latitude: location["lat"] as! CLLocationDegrees , longitude: location["lng"] as! CLLocationDegrees)
        return coordinate
    }
    public var title: String? {
        if let list = information?["address_components"] as! [[String:AnyObject]]? {
            let address = list[0] as [String:AnyObject]
            let name = address["short_name"]
            return name as? String
        }
        return ""
    }
    
    public var subtitle: String? {
        if let list = information?["address_components"] as! [[String:AnyObject]]? {
            let address = list[1] as [String:AnyObject]
            let name = address["short_name"]
            return name as? String
        }
        return ""
    }
    
}
