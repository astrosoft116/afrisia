//
//  PlaceDetail.swift
//  Afrisia
//
//  Created by mobile on 5/3/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class AddressComponent: NSObject {
    var longName: String?
    var shortName: String?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.longName = dict["long_name"] as? String ?? ""
        self.shortName = dict["short_name"] as? String ?? ""
    }
}

class Geometry: NSObject {
    var location: LocationModel?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        if let location = dict["location"] as? [String: AnyObject?] {
            
            self.location = LocationModel(location)
            
        }
        
    }
}

class LocationModel: NSObject {
    var latitude: Float?
    var longitude: Float?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.latitude = dict["lat"] as? Float ?? 0.0
        self.longitude = dict["lng"] as? Float ?? 0.0
        
    }
}

class PlaceDetail: NSObject {
    
    var cityName: String?
    var fullAddress: String?
    var latitude: Float?
    var longitude: Float?

    var placeId: String?
    var addressComponents: [AddressComponent] = []
    var geometry: Geometry?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.fullAddress = dict["formatted_address"] as? String ?? ""
        
        if let results = dict["address_components"] as? [[String: AnyObject?]] {
            for result in results {
                print(result)
                self.addressComponents.append(AddressComponent(result))
            }
            
            print(self.addressComponents)

        }
        
        if let geometry = dict["geometry"] as? [String: AnyObject?] {
        
            self.geometry = Geometry(geometry)
        
        }
        
        self.placeId = dict["place_id"] as? String ?? ""
        
        if self.addressComponents.count > 2 {
            if let cityName = self.addressComponents[2].longName {
                self.cityName = cityName
            } else {
                self.cityName = ""
            }
        }
        
        
        
        self.latitude = self.geometry?.location?.latitude
        self.longitude = self.geometry?.location?.longitude
       
    }

}
