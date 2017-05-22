//
//  BusinessTypeModel.swift
//  Afrisia
//
//  Created by mobile on 4/30/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class BusinessTypeModel: NSObject {
    
    var id: String?
    var name: String?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.name = dict["business_type"] as? String
        self.id = dict["type_id"] as? String
    }
    
}
