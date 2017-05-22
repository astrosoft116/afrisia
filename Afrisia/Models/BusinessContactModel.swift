//
//  BusinessContactModel.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class BusinessContactModel: NSObject {

    var id: String = ""
    var name: String = ""
    var email: String = ""
    var businessName: String = ""
    var businessTypeId: String = ""
    var businessSite: String = ""
    var businessCity: String = ""
    var businessAddress: String = ""
    var businessDescription: String = ""
    var latitude: Float = 0.0
    var longitude: Float = 0.0
    var businessPhotoData: String = ""
    var cameraImage: UIImage = UIImage()
    
    override init() {
        super.init()
    }
}
