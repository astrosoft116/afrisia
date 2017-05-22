//
//  SearchItemModel.swift
//  Afrisia
//
//  Created by mobile on 5/1/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import CoreLocation

class SearchItemModel: NSObject {
    var userID: String?
    var businessName: String?
    var businessTypeID: String?
    var logicOperation: String?
    var labels: String?
    var tags: String?
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    
    override init() {
        
        super.init()
        
        userID = ""
        businessName = ""
        businessTypeID = ""
        logicOperation = "OR"
        labels = ""
        tags = ""
        latitude = 0.0
        longitude = 0.0
        
    }
}
