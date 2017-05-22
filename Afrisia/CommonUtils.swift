//
//  CommonUtils.swift
//  Afrisia
//
//  Created by mobile on 4/27/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import Alamofire

class CommonUtils: NSObject{

    static let sharedInstance: CommonUtils = CommonUtils()
    
    var request: DataRequest?
    
    override init() {
        super.init()

    }    
    
    // MARK: - Adding the text to Image
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 20)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    
    //MARK: - Get Age from birthday
    
    func calcAge(birthday:String) -> Int {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "MMM dd, YYYY"
        let birthdayDate = dateFormater.date(from: birthday)
        let calendar: NSCalendar! = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let now: NSDate! = NSDate()
        let calcAge = calendar.components(.year, from: birthdayDate!, to: now as Date, options: [])
        let age = calcAge.year
        return age!
    }
    
    //MARK: - Get UIColor from rgba
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    // MARK : - Check email format
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func setRateColor(rate: Float) -> UIColor {
        var cgColor: UIColor = self.UIColorFromRGB(rgbValue: 14820136)
        
        if (rate >= 2.5) && (rate < 4.0) {
            
            cgColor = self.UIColorFromRGB(rgbValue: 15781921)
            
        } else if (rate >= 4.0) {
            
            cgColor = self.UIColorFromRGB(rgbValue: 10343463)
            
        }
        return cgColor
    }
    
}


class UserProfile: NSObject {
    
    static let sharedInstance = UserProfile()
    
    var userLabels: [UserLabelModel]!
    var businessTypeArray: [BusinessTypeModel]!
    var currentUser: UserModel?
    
    override init() {
        super.init()
        
        userLabels = [UserLabelModel]()
        businessTypeArray = [BusinessTypeModel]()
    }
    
    func saveUserInfomation() {
        let userDefault = UserDefaults.standard
        userDefault.setValue(currentUser?.id, forKey: UserAuth.keyUserId)
        userDefault.setValue(currentUser?.email, forKey: UserAuth.keyUserEmail)
        userDefault.setValue(currentUser?.password, forKey: UserAuth.keyUserPassword)
        userDefault.setValue(currentUser?.fbId, forKey: UserAuth.facebookId)
        
        userDefault.synchronize()
    }
    
    
    func removeUserInformation() {
        let userDefault = UserDefaults.standard
        userDefault.removeObject(forKey: UserAuth.keyUserId)
        userDefault.removeObject(forKey: UserAuth.keyUserEmail)
        userDefault.removeObject(forKey: UserAuth.keyUserPassword)
        userDefault.setValue(currentUser?.email, forKey: UserAuth.keyUserEmail)
        
        userDefault.removeObject(forKey: UserAuth.facebookId)
        
        userDefault.synchronize()
    }
    
    
    
    
    func getUserId() -> String? {
        let userDefault = UserDefaults.standard
        
        return userDefault.value(forKey: UserAuth.keyUserId) as? String
    }
    
    func getFacebookId() -> String? {
        let userDefault = UserDefaults.standard
        
        return userDefault.value(forKey: UserAuth.facebookId) as? String
    }
    
    
    
    func getUserEmail() -> String? {
        let userDefault = UserDefaults.standard
        
        return userDefault.value(forKey: UserAuth.keyUserEmail) as? String
    }
    
    func getUserPassword() -> String? {
        let userDefault = UserDefaults.standard
        
        return userDefault.value(forKey: UserAuth.keyUserPassword) as? String
    }
    
    func isLoggedIn() -> Bool {
        let userDefault = UserDefaults.standard

        if let _ = userDefault.value(forKey: UserAuth.keyUserId) as? String {
            return true
        }
        
        return false
    }
    
}
