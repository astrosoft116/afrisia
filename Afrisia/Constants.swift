//
//  Constants.swift
//  Afrisia
//
//  Created by mobile on 4/29/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

struct Constants {

    static let GoogleAPIKey = "AIzaSyAKJKgXEeU__0abSVF8oGUc1lYBeJ6wEYs"
}

struct APIEndPoint {
    static let BaseUrl = "http://afrisia.info/mobile/api"
    static let ForgetPasswordURL = "\(APIEndPoint.BaseUrl)/user_retrieve_password"
    static let UserSignInURL = "\(APIEndPoint.BaseUrl)/user_login"
    static let UserSignUpURL = "\(APIEndPoint.BaseUrl)/user_signup"
    static let UserProfileUpdateURL = "\(APIEndPoint.BaseUrl)/user_profile_update"
    static let GetBusinessListURL = "\(APIEndPoint.BaseUrl)/search_business"
    static let GetBusinessTypeListURL = "\(APIEndPoint.BaseUrl)/get_category"
    static let GetMyBusinessListURL = "\(APIEndPoint.BaseUrl)/get_mybusiness"
    static let GetMyCommentsURL = "\(APIEndPoint.BaseUrl)/get_mycomments"
    static let GetMyFavoritsURL = "\(APIEndPoint.BaseUrl)/get_myfavorits"
    static let SendGeneralContactURL = "\(APIEndPoint.BaseUrl)/send_contact"
    static let SendLabelContactURL = "\(APIEndPoint.BaseUrl)/label_contact"
    static let SendBusinessTypeContactURL = "\(APIEndPoint.BaseUrl)/businessType_contact"
    static let SendBusinessContactURL = "\(APIEndPoint.BaseUrl)/business_contact"
    static let SendOfficialBusinessContactURL = "\(APIEndPoint.BaseUrl)/official_business_contact"
    static let AddBusinessURL = "\(APIEndPoint.BaseUrl)/add_newinstitution"
    
    static let ChangeFovoritURL = "\(APIEndPoint.BaseUrl)/change_favor"
    static let AddCommentURL = "\(APIEndPoint.BaseUrl)/add_comment"
    
    // Google rest apis
    static let GetPlaceAutoCompleteURL = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    static let GetPlaceDetailURL = "https://maps.googleapis.com/maps/api/place/details/json"
}

struct UserAuth {
    static let keyUserId = "user_id"
    static let keyUserEmail = "user_email"
    static let keyUserPassword = "user_password"
    static let keyLatitude = "latitude"
    static let keyLongitude = "longitude"
    static let facebookId = "facebook_id"
    static let resultCount = "result_count"
    static let searchDistance = "searchDistance"
}

enum ZodiacSings: String {
    
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"    
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
}
