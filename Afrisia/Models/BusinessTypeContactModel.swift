//
//  BusinessTypeContactModel.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class BusinessTypeContactModel: NSObject {
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var typeName: String = ""
    var typeDescription: String = ""
    var typePhotoData: String = ""
    var cameraImage: UIImage = UIImage()
    
    override init() {
        super.init()
    }

}
