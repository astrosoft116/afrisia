//
//  AdditionalComment.swift
//  Afrisia
//
//  Created by mobile on 5/4/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class AdditionalLabel: NSObject {
    var name: String?
    var commentTitle: String?
    var commentContent: String?
    var rate: Int?
    var property: String?
    
    override init() {
        super.init()
        
        self.name = ""
        self.commentTitle = ""
        self.commentContent = ""
        self.rate = 0
        self.property = "public"
        
    }
}

class AdditionalComment: NSObject {

    var userId: String?
    var businessId: String?
    var businessName: String?
    var commentTitle: String?
    var commentContent: String?
    var rate: Int?
    var labels: [AdditionalLabel]?
    
    override init() {
        super.init()
        
        self.businessId = ""
        self.businessName = ""
        self.userId = ""
        self.commentTitle = ""
        self.commentContent = ""
        self.rate = 0
        self.labels = []
        
    }
}
