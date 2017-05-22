//
//  UserLabelModel.swift
//  Afrisia
//
//  Created by mobile on 4/29/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class UserLabelModel: NSObject {
    var id: String?
    var name: String?
    var property: String?
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.name = dict["label_name"] as? String
        self.property = dict["label_property"] as? String
        self.id = dict["label_id"] as? String
    }

}
