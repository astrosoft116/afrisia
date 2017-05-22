//
//  Business.swift
//  Afrisia
//
//  Created by mobile on 4/28/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import Foundation


enum PrivateType: String {
    case notAllow = "not allow"
    case allow = "allow"
    
    func boolType() -> Bool {
        switch self {
        case .notAllow:
            return false
        case .allow:
            return true
        }
    }
}


// MARK: - Business Label Detail

class BusinessLabelDetail: NSObject {
    var name: String?
//    var isPrivate: PrivateType = .notAllow
    var averageRate: Float = 0.0
    var numVote: Int = 0
    
    init(_ dict: [String: AnyObject?]) {
        super.init()
        
        self.name = dict["label_name"] as? String
//        self.isPrivate = PrivateType(rawValue: dict["label_private"] as? String ?? "") ?? .notAllow
        self.numVote = dict["vote_num"] as? Int ?? 0
        self.averageRate = dict["avg_rate"] as? Float ?? 0.0
    }
}

// MARK: - Comment Label Detail

class CommentLabel: NSObject {
    var name: String?
    var rate: Float = 0.0
    
    init(_ dict: [String: AnyObject?]?) {
        super.init()
        
        guard let dict = dict else {
            return
        }
        
        self.name = dict["label_name"] as? String
        self.rate = dict["label_rate"] as? Float ?? 0.0
    }
}


// MARK: - Business Comment

class BusinessComment: NSObject {
    var title: String?
    var userName: String?
    var userPhotoUrl: URL?
    var content: String?
    var date: String?
    var rateScore: Float?
    var rateCount: Int?
    var labels: [CommentLabel] = [CommentLabel]()
    
    init(_ dict: [String: AnyObject?]) {
        super.init()
        
        self.title = dict["comment_title"] as? String
        self.userName = dict["user_name"] as? String
        self.userPhotoUrl = URL(string: dict["user_photo_url"] as? String ?? "")
        self.content = dict["comment_content"] as? String
        self.rateScore = Float(dict["comment_rate_score"] as? String ?? "0")
        self.rateCount = Int(dict["comment_rate_num"] as? String ?? "0")

//        if let commentDate = dict["comment_date"] as? String {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "yyyy-MM-dd"
//            self.date = dateFormatter.date(from: commentDate)
//        }
        
        self.date = dict["comment_date"] as? String ?? ""
        
        if let commentLabels = dict["comment_label"] as? [[String: AnyObject]] {
            for commentLabel in commentLabels {
                labels.append(CommentLabel(commentLabel))
            }
        }
    }
}

class BusinessModel: NSObject {
    var id: String?
    var siteUrl: URL?
    var name: String?
    var address: String?
    var city: String?
    var content: String?
    var photoUrl: URL?
    var phoneNumber: String?
    var type: String?
    var latitude: String?
    var longitude: String?
    var rateScore: Float = 0.0
    var rateCount: Int?
    var isYours: Bool = false
    var isFavorite: Bool = false
    var commentCount: Int?
    var comments: [BusinessComment] = [BusinessComment]()
    var myComments: [BusinessComment] = [BusinessComment]()
    var labelDetails: [BusinessLabelDetail] = [BusinessLabelDetail]()
    var distance: Double = 0.0
    var businessRateIncludingLabes: Float = 0.0

    init(_ dict: [String: AnyObject?]) {
        super.init()
        
        self.id = dict["business_id"] as? String
        self.name = dict["business_name"] as? String
        self.type = dict["business_type"] as? String
        self.siteUrl = URL(string: dict["business_site"] as? String ?? "")
        self.address = dict["business_address"] as? String
        self.city = dict["business_city"] as? String
        self.content = dict["business_description"] as? String
        self.photoUrl = URL(string: dict["business_photo_url"] as? String ?? "")
        self.phoneNumber = dict["business_phone"] as? String
        self.latitude = dict["business_lati"] as? String
        self.longitude = dict["business_long"] as? String
        self.rateScore = dict["business_rate_score"] as? Float ?? 0.0
        self.rateCount = Int(dict["business_rate_num"] as? String ?? "0")
        self.isYours = (dict["yours"] as? Int ?? 0) == 1
        self.isFavorite = (dict["favor_status"] as? Int ?? 0) == 1
        self.distance = 0.0
        self.businessRateIncludingLabes = 0.0
        
        if let details = dict["label_detail"] as? [[String: AnyObject]] {
            for detail in details {
                labelDetails.append(BusinessLabelDetail(detail))
            }
        }
        
        if let commentList = dict["business_comment"] as? [[String: AnyObject]] {
            for comment in commentList {
                comments.append(BusinessComment(comment))
            }
        }
        
        if let commentList = dict["business_mycomment"] as? [[String: AnyObject]] {
            for comment in commentList {
                myComments.append(BusinessComment(comment))
            }
        }
    }
    
    
    
}
