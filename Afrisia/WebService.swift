//
//  ApiEndPoint.swift
//  Afrisia
//
//  Created by mobile on 4/29/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import Foundation
import Alamofire

class WebService: NSObject {
    
    // MARK: - Get Business List
    
    class func getBusinessList(searchItem: SearchItemModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
    
        let endpoint = APIEndPoint.GetBusinessListURL
        let params = [
            "user_id": searchItem.userID,
            "business_name": searchItem.businessName,
            "business_type": searchItem.businessTypeID,
            "search_text": searchItem.labels,
            "search_tags": searchItem.tags,
            "operation": searchItem.logicOperation
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in

            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Get My Business List

    
    class func getMyBusinessList(userId: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetMyBusinessListURL
        let params = [
            "user_id": userId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    //MARK: - Get My Comments
    
    class func getMyComments(userId: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetMyCommentsURL
        let params = [
            "user_id": userId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Get My Favorit Business List
    
    class func getMyFavorits(userId: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetMyFavoritsURL
        let params = [
            "user_id": userId
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Send General Contact
    
    class func sendGeneralContact(generalContact: GeneralContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.SendGeneralContactURL
        
        let params = [
          
            "full_name": generalContact.name,
            "user_email": generalContact.email,
            "subject": generalContact.messageTitle,
            "message": generalContact.messageContent
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }

    
    // MARK: - Send Label Contact
    
    class func sendLabelContact(labelContact: LabelContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.SendLabelContactURL
        var labelProperty: String!
        
        if  labelContact.labelProperty == true {
            labelProperty = "private"
        } else {
            labelProperty = "public"
        }
      
        let params = [
            "user_id": labelContact.id,
            "user_name": labelContact.name,
            "user_email": labelContact.email,
            "label_name": labelContact.labelName,
            "label_property": labelProperty,
            "label_description": ""
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Send BusinessType Contact
    
    class func sendBusinessTypeContact(businessTypeContact: BusinessTypeContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.SendBusinessTypeContactURL
        
        let params = [
            "user_id": businessTypeContact.id,
            "user_name": businessTypeContact.name,
            "user_email": businessTypeContact.email,
            "business_type": businessTypeContact.typeName,
            "type_description": businessTypeContact.typeDescription,
            "businessType_photo": businessTypeContact.typePhotoData
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Send Business Contact
    
    class func sendBusinessContact(businessContact: BusinessContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.SendBusinessContactURL
        
        let params = [
            "user_id": businessContact.id,
            "user_name": businessContact.name,
            "user_email": businessContact.email,
            "business_type_id": businessContact.businessTypeId,
            "business_name": businessContact.businessName,
            "business_description": businessContact.businessDescription,
            "business_site": businessContact.businessSite,
            "business_city": businessContact.businessCity,
            "business_address": businessContact.businessAddress,
            "business_lati": businessContact.latitude,
            "business_long": businessContact.longitude,
            "business_photo": businessContact.businessPhotoData
        ] as [String : Any]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    
    // MARK: - Send Official Business Contact
    
    class func sendOfficialBusinessContact(officialBusinessContact: OfficialBusinessContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.SendOfficialBusinessContactURL
        
        let params = [
            "user_id": officialBusinessContact.id,
            "user_name": officialBusinessContact.name,
            "user_email": officialBusinessContact.email,
            "user_phonenumber": officialBusinessContact.phoneNumber,
            "user_business_phonenumber": officialBusinessContact.businessNumber,
            "user_role": officialBusinessContact.role,
            "user_gender": officialBusinessContact.gender,
            "business_type_id": officialBusinessContact.businessTypeId,
            "business_name": officialBusinessContact.businessName,
            "business_description": officialBusinessContact.businessDescription,
            "business_site": officialBusinessContact.businessSite,
            "business_city": officialBusinessContact.businessCity,
            "business_address": officialBusinessContact.businessAddress,
            "business_lati": officialBusinessContact.latitude,
            "business_long": officialBusinessContact.longitude,
            "business_photo": officialBusinessContact.businessPhotoData
            ] as [String : Any]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Add Business
    
    class func addNewBusiness(businessContact: BusinessContactModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.AddBusinessURL
        
        let params = [
            "user_id": businessContact.id,
            "business_type": businessContact.businessTypeId,
            "business_name": businessContact.businessName,
            "business_description": businessContact.businessDescription,
            "business_site": businessContact.businessSite,
            "business_city": businessContact.businessCity,
            "business_address": businessContact.businessAddress,
            "business_lati": businessContact.latitude,
            "business_long": businessContact.longitude,
            "business_photo_data": businessContact.businessPhotoData
            ] as [String : Any]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    






    // MARK: - Get Business Type
    
    class func getBusinessTypeList(completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetBusinessTypeListURL
        let params = [
            "type_base": "business"
        ]
        
        print("ENDPOINT: %@ - Params:", endpoint, params)
        
        let request = Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
        request.responseJSON { (response) in

            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: -Change Favorite
    
    class func changeFavoritBusiness(businessId: String, userId: String, status: String,completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.ChangeFovoritURL
        let params = [
            "business_id": businessId,
            "user_id": userId,
            "favor": status
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Forget Password
    
    class func forgetPassword(email: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.ForgetPasswordURL
        let params = [
            "user_email": email
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }

    
    // MARK: -Sign In
    
    class func userLogin(email: String, password: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.UserSignInURL
        let params = [
            "user_email": email,
            "user_password": password,
            "login_mode": "email"
        ]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: -Sign Up With Email
    
    class func userSingupWithEmail(currentUser: UserModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.UserSignUpURL
     
        var userLabels: [[String: Any?]] = []
        
        for profileLabel in currentUser.labels {
            
            let privateOpt = (profileLabel.property == "private") ? true : false
            let labelItem = [
                "privateOpt": privateOpt,
                "name": profileLabel.name,
                "id": profileLabel.id
            ] as [String : Any]
            
            userLabels.append(labelItem)
        }
        
        let params = [
            "signup_mode": "email",
            "user_password": currentUser.password,
            "user_birthdate": currentUser.birth,
            "user_name": currentUser.name,
            "user_email": currentUser.email,
            "user_psuedo": currentUser.psuedo,
            "user_favor_color": currentUser.favoritColor,
            "user_name_private": currentUser.namePrivate,
            "user_acceptCheck": currentUser.isAcceptable,
            "user_publishCheck": currentUser.isPublish,
            "user_labels": userLabels
        ] as [String : Any?]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: -Sign Up With Facebook
    
    class func userSingupWithFb(currentUser: UserModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.UserSignUpURL

        
        
        let params = [
            
            "signup_mode": "fb",
            "logintype_id": currentUser.fbId,
            "user_name": currentUser.name,
            "user_email": currentUser.email,
            "user_gender": currentUser.gender,
            "user_photo_data": currentUser.photoData
            
        ] as [String : Any?]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
   
    
    // MARK: - Profile update
    
    class func userProfileUpdate(currentUser: UserModel, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.UserProfileUpdateURL
        
        var userLabels: [[String: Any?]] = []
        
        for profileLabel in currentUser.labels {
        
            let labelItem = [
                "pre_property": profileLabel.property,
                "pre_label_name": profileLabel.name,
                "pre_label_id": profileLabel.id
                ] as [String : Any]
            
            userLabels.append(labelItem)
        }
        
        let params = [
            "user_id": currentUser.id,
            "user_password": currentUser.password,
            "user_name": currentUser.name,
            "user_email": currentUser.email,
            "user_photo_data": currentUser.photoData,
            "user_acceptCheck": currentUser.isAcceptable,
            "user_publishCheck": currentUser.isPublish,
            "labels": userLabels
            ] as [String : Any?]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    // MARK: - Add comment
    
    class func addComment(newComment: AdditionalComment, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.AddCommentURL
        
        var commentLabels: [[String: Any?]] = []
        
        for commentLabel in newComment.labels! {
       
            let labelItem = [
                "property": commentLabel.property,
                "name": commentLabel.name,
                "title": commentLabel.commentTitle,
                "content": commentLabel.commentContent,
                "rate": commentLabel.rate
                ] as [String : Any]
            
            commentLabels.append(labelItem)
        }
        
        let params = [
            "business_id": newComment.businessId,
            "content": newComment.commentContent,
            "rate_score": newComment.rate,
            "title": newComment.commentTitle,
            "user_id": newComment.userId,
            "label": commentLabels
            ] as [String : Any?]
        
        Alamofire.request(endpoint, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }

    
    // MARK: - Get Place APIs
    
    class func getPlaceAutoComplete(input: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetPlaceAutoCompleteURL
        let params = [
            "key": Constants.GoogleAPIKey,
            "input": input
        ]
        
        let request = Alamofire.request(endpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
        
        CommonUtils.sharedInstance.request = request
        
        request.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    class func getPlaceDetail(placeId: String, completionBlock:@escaping (([String: AnyObject?]?, Error?) -> Void)) {
        
        let endpoint = APIEndPoint.GetPlaceDetailURL
        let params = [
            "key": Constants.GoogleAPIKey,
            "placeid": placeId
        ]
        
        let request = Alamofire.request(endpoint, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
        
        CommonUtils.sharedInstance.request = request
        
        request.responseJSON { (response) in
            
            switch response.result {
            case .success(let value):
                print(value)
                completionBlock(value as! [String: AnyObject], nil)
                break
            case .failure(let error):
                print(error)
                completionBlock(nil, error)
                break
            }
        }
    }
    
    
}
