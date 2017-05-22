//
//  RegisterViewController.swift
//  Afrisia
//
//  Created by mobile on 4/19/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import FBSDKLoginKit
import FBSDKCoreKit
import AlamofireImage

class RegisterViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var pseudoText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var dateText: UITextField!
    @IBOutlet weak var colorText: UITextField!
    @IBOutlet weak var labelInputText: UITextField!
    @IBOutlet weak var namePropertyImage: UIImageView!
    @IBOutlet weak var promotionCheckImage: UIImageView!
    @IBOutlet weak var offerCheckImage: UIImageView!
    @IBOutlet weak var labelInputPartView: UIView!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    @IBOutlet weak var datePickerBottomConstraint: NSLayoutConstraint!
    
    var currentUser: UserModel = UserModel()
    var profileLabelList: [ProfileLabel] = [ProfileLabel]()
    
    var userImage: UIImageView! = UIImageView()
    
    var labelList: [String] = []
    var labelListDropdown: DropDown!
    var selectedLabels: [String] = []
    
    var colorList: [String] = ["bleu", "vert", "rouge", "jaune", "violet", "marron", "rose", "noir", "blance"]
    var colorListDropdown: DropDown!
    
    var singleDate: Date = Date()
    var multipleDates: [Date] = []
    var zodiac: String = String()

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        self.getLabelList()
        self.setupColorListDropdownMenu()

        
        // Edit Event
        labelInputText.addTarget(self, action: #selector(RegisterViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    // MARK: - Label Add Part
    func getLabelList() {
        
        if let userLabels = UserProfile.sharedInstance.userLabels {
            
            for userLabel in userLabels {
                self.labelList.append(userLabel.name!)
            }
        }
        
        self.setupLabelListDropdownMenu()
        
    }
    
    func setupLabelListDropdownMenu () {
        self.labelListDropdown = DropDown(anchorView: labelInputPartView)
        self.labelListDropdown.dataSource = self.labelList
        self.labelListDropdown.dismissMode = .onTap
        self.labelListDropdown.topOffset = CGPoint(x: 0, y: -self.labelInputPartView.frame.size.height)
        self.labelListDropdown.direction = .top
        
        self.labelListDropdown.backgroundColor = UIColor.white
        
        if self.labelList.count > 0 {
            self.labelListDropdown.selectRow(at: 0)
        }
        
        self.labelListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.labelListDropdown.selectionAction = {(index: Int, item: String) in
            self.labelInputText.text = item
            self.labelInputText.tag = index
            //            self.filterTransactionsWith(index)
        }
    }
    
    func setupColorListDropdownMenu () {
        self.colorListDropdown = DropDown(anchorView: colorText)
        self.colorListDropdown.dataSource = self.colorList
        self.colorListDropdown.dismissMode = .onTap
        self.colorListDropdown.bottomOffset = CGPoint(x: 0, y: self.colorText.frame.size.height)
        self.colorListDropdown.direction = .any
        
        self.colorListDropdown.backgroundColor = UIColor.white
        self.colorListDropdown.selectRow(at: 0)
        
        self.colorListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.colorListDropdown.selectionAction = {(index: Int, item: String) in
            self.colorText.text = item
            
            if self.profileLabelList.count > 0 {
                self.pseudoText.text = self.profileLabelList[0].name + self.colorText.text! + self.zodiac
            } else {
                self.pseudoText.text = self.colorText.text! + self.zodiac
            }

        }
    }
    
    func textFieldDidChange (_ textField: UITextField) {
        
        let keyString: String = textField.text!
        let filteredLabelList = labelList.filter{($0.lowercased().range(of: keyString) != nil)}
        self.labelListDropdown.dataSource = filteredLabelList
        labelListDropdown.show()
        
        print(textField.text ?? String())
    }


    @IBAction func dissmissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func colorChooseButtonAction(_ sender: Any) {
        colorListDropdown.show()
    }
    @IBAction func namePropertyChangeButtonAction(_ sender: Any) {
        if currentUser.namePrivate == true {
            namePropertyImage.image = #imageLiteral(resourceName: "public")
            currentUser.namePrivate = false
        } else {
            namePropertyImage.image = #imageLiteral(resourceName: "secrect")
            currentUser.namePrivate = true
        }
    }
    
    @IBAction func facebookRegisterButtonAction(_ sender: Any) {
        
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if error != nil {
                print("Facebook login failed!")
            }
            
            if let result = result {
                print(result)
                self.getFacebookProfile(result.token.tokenString)
            }
        }
    }
    
    func getFacebookProfile(_ token: String) {
        let request = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,gender,picture.type(normal)"])
        
        let _ = request?.start(completionHandler: { (_, result, error) in
            if error != nil {
                print("Facebook login failed!")
            }
            
            if let result = result as? [String: AnyObject] {
                print(result)
                let email = result["email"] as! String
                let id = result["id"] as! String
                let name = result["name"] as! String
                let gender = result["gender"] as! String
                let picture = result["picture"] as? [String: AnyObject]
                let pictureData = picture?["data"] as! [String: AnyObject]
                print(pictureData)
                let photoUrl = pictureData["url"] as! String
          
                self.currentUser.signupMode = "fb"
                self.currentUser.name = name
                self.currentUser.email = email
                self.currentUser.fbId = id
                self.currentUser.gender = gender
                self.currentUser.photoData = photoUrl
//                
//                let chosenImage = UIImageView()
//                chosenImage.af_setImage(withURL: URL(string: photoUrl)!)
//             
//                
//
//                let imageData:NSData = (UIImagePNGRepresentation(chosenImage.image!)! as NSData?)!
//                
//  
//                let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
//                
//                self.currentUser.photoData = imageStr
//
                
                
                
                
                self.showProgressHUD()
                
                WebService.userSingupWithFb(currentUser: self.currentUser) { (result, error) in
                    
                    
                    self.hideProgressHUD()
                    
                    if let _ = error {
                        print("Error Found ---")
                    }
                    
                    let status = result?["status"] as? Int
                    
                    if status == 1 {
                        
                        let currentUser = result?["current_user"] as? [String: AnyObject]
                        UserProfile.sharedInstance.currentUser = UserModel(currentUser!)
   
                        UserProfile.sharedInstance.saveUserInfomation()
                        
                        let _ = self.navigationController?.popViewController(animated: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSignUpSuccess"), object: nil)
                        
                    } else if status == 2{
                        self.showMessageError("Erruer", "This signup failed!")
                        
                    }
                    
                }

            }
        })
    }

    @IBAction func calendarButtonAction(_ sender: Any) {
        
        datePickerBottomConstraint.constant = 0.0
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: { 
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @IBAction func didSelectBirthdayAction(_ sender: Any) {
        
        let selectDate = birthdayPicker.date
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "MMM dd, yyyy"

        self.dateText.text = dateFormate.string(from: selectDate)
        
        let calendar = Calendar.current
        
        let month = calendar.component(.month, from: selectDate)
        let day = calendar.component(.day, from: selectDate)
        
        zodiac = getZodiacSign(day: day, month: month)
        
        if profileLabelList.count > 0 {
            pseudoText.text = profileLabelList[0].name + colorText.text! + zodiac
        } else {
            pseudoText.text = colorText.text! + zodiac
        }
        
        print(CommonUtils.sharedInstance.calcAge(birthday: self.dateText.text!))

        datePickerBottomConstraint.constant = -250.0
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0.0, options: .allowUserInteraction, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    
    // MARK : - Zodica Sings
    
    func  getZodiacSign (day: Int, month: Int) -> String {
        if((month == 1 && day <= 20) || (month == 12 && day >= 22)) {
            return ZodiacSings.capricorn.rawValue
        } else if ((month == 1 && day >= 21) || (month == 2 && day <= 18)) {
            return ZodiacSings.aquarius.rawValue;
        } else if((month == 2 && day >= 19) || (month == 3 && day <= 20)) {
            return ZodiacSings.pisces.rawValue;
        } else if((month == 3 && day >= 21) || (month == 4 && day <= 20)) {
            return ZodiacSings.aries.rawValue;
        } else if((month == 4 && day >= 21) || (month == 5 && day <= 20)) {
            return ZodiacSings.taurus.rawValue;
        } else if((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
            return ZodiacSings.gemini.rawValue;
        } else if((month == 6 && day >= 22) || (month == 7 && day <= 22)) {
            return ZodiacSings.cancer.rawValue;
        } else if((month == 7 && day >= 23) || (month == 8 && day <= 23)) {
            return ZodiacSings.leo.rawValue;
        } else if((month == 8 && day >= 24) || (month == 9 && day <= 23)) {
            return ZodiacSings.virgo.rawValue;
        } else if((month == 9 && day >= 24) || (month == 10 && day <= 23)) {
            return ZodiacSings.libra.rawValue;
        } else if((month == 10 && day >= 24) || (month == 11 && day <= 22)) {
            return ZodiacSings.scorpio.rawValue;
        } else if((month == 11 && day >= 23) || (month == 12 && day <= 21)) {
            return ZodiacSings.sagittarius.rawValue;
        }
        return ""
    }
    
    @IBAction func addLabelButtonAction(_ sender: Any) {
        
        if self.labelInputText.text == ""{
            self.showMessageError("Erreur", "Please input the label name!")
            return
        }
        
        if selectedLabels.contains(self.labelInputText.text!){
            self.showMessageError("Erreur", "Please select another label!")
        } else {
        
            let newProfileLabel = ProfileLabel()
            
            newProfileLabel.name = self.labelInputText.text!
            newProfileLabel.property = "public"
            newProfileLabel.id = String(Int(self.labelInputText.tag))
            
            selectedLabels.append(self.labelInputText.text!)
            
            profileLabelList.append(newProfileLabel)
            currentUser.labels = profileLabelList
            
            pseudoText.text = profileLabelList[0].name + colorText.text! + zodiac
            
            self.labelInputText.text = ""
            
            tableView.reloadData()
        }
    }

    @IBAction func registerButtonAction(_ sender: Any) {
        
        currentUser.signupMode = "email"
        currentUser.name = nameText.text!
        currentUser.psuedo = pseudoText.text!
        currentUser.email = emailText.text!
        currentUser.password = passwordText.text!
        currentUser.birth = dateText.text!
        currentUser.favoritColor = colorText.text!
        
        if currentUser.name == "" {
            self.showMessageError("Erreur" ,"Please input your name.")
            return
        }
        
        if currentUser.email == "" {
            self.showMessageError("Erreur" ,"Please input your email.")
            return
        }
        
        if CommonUtils.sharedInstance.isValidEmail(testStr: currentUser.email) == false {
            self.showMessageError("Erreur", "Please correct email.")
            return
        }

        
        if currentUser.password == "" {
            self.showMessageError("Erreur" ,"Please set the password.")
            return
        }
        
        if currentUser.password != confirmPasswordText.text {
            self.showMessageError("Erreur" ,"Please check your confirm password.")
            return
        }
        
        if currentUser.birth == "" {
            self.showMessageError("Erreur" ,"Please set your birthday")
            return
        }
        
        if CommonUtils.sharedInstance.calcAge(birthday: currentUser.birth) < 18 {
            self.showMessageError("Erreur" ,"Your age should be more than 18.")
            return
        }
        
        if currentUser.favoritColor == "" {
            self.showMessageError("Erreur" ,"Please set your favorit color")
            return
        }
        
        self.showProgressHUD()
        
        WebService.userSingupWithEmail(currentUser: currentUser) { (result, error) in
            
            
            self.hideProgressHUD()
            
            if let _ = error {
                print("Error Found ---")
            }
            
            let status = result?["status"] as? Int
            
            if status == 1 {
                
                let currentUser = result?["current_user"] as? [String: AnyObject]
                UserProfile.sharedInstance.currentUser = UserModel(currentUser!)
                UserProfile.sharedInstance.currentUser?.password = self.passwordText.text!
                UserProfile.sharedInstance.saveUserInfomation()
                
                let _ = self.navigationController?.popViewController(animated: true)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserSignUpSuccess"), object: nil)
                
            } else if status == 3{
                self.showMessageError("Erruer", "This email is already registered!")
        
            }else {
                self.showMessageError("Erruer", "This signup failed!")
                
            }

            
        }
        
    }
    
    @IBAction func checkForPromotionButtonAction(_ sender: Any) {
        
        if currentUser.isAcceptable {
            currentUser.isAcceptable = false
            promotionCheckImage.image = #imageLiteral(resourceName: "uncheck")
        } else {
            currentUser.isAcceptable = true
            promotionCheckImage.image = #imageLiteral(resourceName: "check")
        }
        
    }

    @IBAction func checkForOfferButtonAction(_ sender: Any) {
        
        if currentUser.isPublish {
            currentUser.isPublish = false
            offerCheckImage.image = #imageLiteral(resourceName: "uncheck")
        } else {
            currentUser.isPublish = true
            offerCheckImage.image = #imageLiteral(resourceName: "check")
        }

        
    }

    
    // MARK - Tableview Part
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return profileLabelList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileLabelTableViewCell", for: indexPath as IndexPath) as! ProfileLabelTableViewCell
        
        cell.labelText.text = profileLabelList[indexPath.row].name
        
        if profileLabelList[indexPath.row].property == "private" {
            
            cell.propertyImage.image = #imageLiteral(resourceName: "secrect")
            
        } else {
            
            cell.propertyImage.image = #imageLiteral(resourceName: "public")
            
        }
        
        cell.propertyChangeButton.tag = indexPath.row
        
        cell.propertyChangeButton.addTarget(self, action: #selector(ProfileUpdateViewController.propertyChangeButtonAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func propertyChangeButtonAction (_ sender: UIButton){
        
        let index = sender.tag
        if profileLabelList[index].property == "private" {
            profileLabelList[index].property = "public"
        } else {
            profileLabelList[index].property = "private"
        }
        
        tableView.reloadData()
    }
    
        
  
}


