//
//  UserModel.swift
//  Afrisia
//
//  Created by mobile on 5/1/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

// MARK: - Profile Label Detail

class ProfileLabel: NSObject {
    var id: String = ""
    var name: String = ""
    var property: String = ""
    
    override init() {
        super.init()
    }
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.name = dict["pre_label_name"] as? String ?? ""
        self.property = dict["pre_property"] as? String ?? ""
        self.id = dict["pre_label_id"] as? String ?? ""
    }
}


class UserModel: NSObject {
    
    var id: String = ""
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var photoURL: URL = URL(string: "https://")!
    var favoritColor: String = ""
    var birth: String = ""
    
    var namePrivate: Bool = false
    var psuedo: String = ""
    
    var businessCount: String = ""
    var commentCount: String = ""
    var favoritCount: String = ""
    
    var isAcceptable: Bool = true
    var isPublish: Bool = true
    
    var signupMode: String = "email"
    var photoData: String = ""
    var fbId: String = ""
    var gender: String = ""
    
    var labels: [ProfileLabel] = [ProfileLabel]()
    
    override init() {
        super.init()
    }

    
    init(_ dict: [String: AnyObject?]) {
        super.init()
        
        self.id = dict["user_id"] as? String ?? ""
        self.name = dict["user_name"] as? String ?? ""
        self.email = dict["user_email"] as? String ?? ""
        self.photoURL = URL(string: dict["user_photo_url"] as? String ?? "")!
        self.favoritColor = dict["user_favor_color"] as? String  ?? ""
        self.birth = dict["user_birth"] as? String  ?? ""
        
        self.psuedo = dict["user_psuedo"] as? String  ?? ""
        self.namePrivate = (dict["user_name_private"] as? String == "1") ? true : false
       
        self.businessCount = dict["user_business_count"] as? String  ?? ""
        self.commentCount = dict["user_comment_count"] as? String  ?? ""
        self.favoritCount = dict["user_favor_count"] as? String  ?? ""
        self.isAcceptable = (dict["user_acceptCheck"] as? String == "1") ? true : false
        self.isPublish = (dict["user_publishCheck"] as? String == "1") ? true : false
        self.password = ""
        self.signupMode = "email"
        self.photoData = ""
        self.fbId = dict["user_facebook_id"] as? String  ?? ""
        self.gender = ""
        
        if let details = dict["labels"] as? [[String: AnyObject]] {
            for detail in details {
                labels.append(ProfileLabel(detail))
            }
        }
    }
}
