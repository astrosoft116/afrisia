//
//  HomeViewController.swift
//  Afrisia
//
//  Created by mobile on 4/17/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import SWRevealViewController
import DropDown
import AlamofireImage
import GoogleMaps
import CoreLocation

class HomeViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {


    @IBOutlet weak var businessListTableView: UITableView!
    @IBOutlet weak var businessTypeView: UIView!
    @IBOutlet weak var labelListView: UIView!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet weak var labelsInputTxt: UITextField!
    @IBOutlet weak var businessTypeButton: UIButton!
    
    var placeMarker: CLPlacemark!
    var locationManager = CLLocationManager()
    var mapView = GMSMapView()
    
    var labelList: [String] = []
    var selectedLabelList: [String] = []
    
    var businessTypeList: [String] = []
    
    // MARK: Search Parameters
    var searchItem: SearchItemModel = SearchItemModel()
    
    var businessArray: [BusinessModel] = [BusinessModel]()
    var businessTypeArray: [BusinessTypeModel] = [BusinessTypeModel]()
    
    var businessTypeDropDown: DropDown!
    var labelListDropdown: DropDown!
    
    var searchDistance: Double = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getLocation()
       
        self.getBusinessTypeList()
        
        self.revealViewController().rearViewRevealWidth = UIScreen.main.bounds.size.width * 0.8
        self.revealViewController().tapGestureRecognizer()
        
        self.setupViews()
        
        labelsInputTxt.addTarget(self, action: #selector(HomeViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.loginChanged), name: NSNotification.Name(rawValue: "UserLoginChanged"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.signUpSuccess), name: NSNotification.Name(rawValue: "UserSignUpSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.profileUpdateSuccess), name: NSNotification.Name(rawValue: "UserProfileUpdateSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.forgetPasswordSuccess), name: NSNotification.Name(rawValue: "ForgetPasswordSuccess"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.sendContactSuccess(_:)), name: NSNotification.Name(rawValue: "SendContactSuccess"), object: nil)
        
        
        let userDefault = UserDefaults.standard
        if let searchDistance = userDefault.value(forKey: UserAuth.searchDistance){
            self.searchDistance = searchDistance as! Double
        }  else {
            userDefault.set(self.searchDistance,forKey: UserAuth.searchDistance)
        }
        
        
    }

    
    func getLocation() {
        guard let _ = AppDelegate.appDelegate().getLocation() else {
            self.perform(#selector(self.getLocation), with: nil, afterDelay: 1.0)
            return
        }
        
        self.checkLogin()
    }
    
    func checkLogin () {
        if UserProfile.sharedInstance.isLoggedIn() {
            
            if UserProfile.sharedInstance.getFacebookId() == "" {
                let email = UserProfile.sharedInstance.getUserEmail()
                let password = UserProfile.sharedInstance.getUserPassword()
                
                WebService.userLogin(email: email!, password: password!) { (result, error) in
                    
                    if let _ = error {
                        print("Error Found ---")
                    }
                    
                    let status = result?["status"] as? Int
                    
                    if status == 1 {
                        
                        let currentUser = result?["current_user"] as? [String: AnyObject]
                        UserProfile.sharedInstance.currentUser = UserModel(currentUser!)
                        UserProfile.sharedInstance.currentUser?.password = password!
                        UserProfile.sharedInstance.saveUserInfomation()
                        
                        self.searchItem.userID = UserProfile.sharedInstance.currentUser?.id
                        self.getBusinessList()
                        
                        
                    }
                }
            } else {
                let currentUser: UserModel = UserModel()
                
                currentUser.fbId = UserProfile.sharedInstance.getFacebookId()!
                currentUser.signupMode = "fb"
                
                WebService.userSingupWithFb(currentUser: currentUser, completionBlock: { (result, error) in
                    if let _ = error {
                        print("Error Found ---")
                    }
                    
                    let status = result?["status"] as? Int
                    
                    if status == 1 {
                        
                        let currentUser = result?["current_user"] as? [String: AnyObject]
                        UserProfile.sharedInstance.currentUser = UserModel(currentUser!)
       
                        UserProfile.sharedInstance.saveUserInfomation()
                        
                        self.searchItem.userID = UserProfile.sharedInstance.currentUser?.id
                        self.getBusinessList()
                        
                        
                    }

                })
            }
         
        } else {
            self.getBusinessList()
        }
    }
    
    func forgetPasswordSuccess() {
        self.showMessageError("Success", "Regardez votre boîte mail.")
    }
    
    func setupViews () {
        businessTypeButton.layer.borderColor = UIColor.black.cgColor
        businessTypeButton.layer.borderWidth = 1
    }
    
    func getBusinessList() {
        
        self.showProgressHUD()
        
        self.businessArray.removeAll()
        
        WebService.getBusinessList(searchItem: searchItem) { (result, error) in
            self.hideProgressHUD()
            
            if let _ = error {
                print("Error Found ---")
            }
            
            if let results = result?["result"] as? [[String: AnyObject?]] {
                for business in results {
                    self.businessArray.append(BusinessModel(business))
                    self.getBusinessArrwayWithInDistance()
                    
                    
                }
            }
            
            var userOwnLabels = [UserLabelModel]()
            self.labelList.removeAll()
            
            if let labelList = result?["label_list"] as? [[String: AnyObject?]] {
                for label in labelList {
                    userOwnLabels.append(UserLabelModel(label))
                }
                
                UserProfile.sharedInstance.userLabels = userOwnLabels
                
                for ownLabel in userOwnLabels {
                    self.labelList.append(ownLabel.name!)
                }
                
                self.setupLabelListDropdownMenu()
            }
            
            self.businessListTableView.reloadData()
        }
    }
    
    func getBusinessArrwayWithInDistance () {
        var tempArray: [BusinessModel] = [BusinessModel]()
        var currentLat: CLLocationDegrees = 0.0
        var currentLng: CLLocationDegrees = 0.0
        if let currentLocation = AppDelegate.appDelegate().getLocation(){
            currentLat = currentLocation.coordinate.latitude
            currentLng = currentLocation.coordinate.longitude
        }
        
        for business in businessArray {
            let currentLocation = CLLocation(latitude: currentLat, longitude: currentLng)
            
            let businessLat = CLLocationDegrees(business.latitude!)
            let businessLng = CLLocationDegrees(business.longitude!)
            
            let businessLocation = CLLocation(latitude: businessLat!, longitude: businessLng!)
            
            let distance = currentLocation.distance(from: businessLocation)
            
            
            
            business.distance = distance
            
            // Set Business and labels average
            var sum = business.rateScore
            for label in business.labelDetails {
                sum = sum + label.averageRate
            }
            
            let businessRateIncludingLabes = sum / Float(business.labelDetails.count + 1)
            
            business.businessRateIncludingLabes = businessRateIncludingLabes
            
            if distance < self.searchDistance * 1000 {
                tempArray.append(business)
            }
           
        }
        
        businessArray.removeAll()
        businessArray = tempArray
        
    }
    
    func getBusinessTypeList() {
        
        WebService.getBusinessTypeList { (result, error) in
            
            if let _ = error {
                print("Error Found ---")
            }
            
            if let results = result?["result"] as? [[String: AnyObject?]] {
                for businessType in results {
                    self.businessTypeArray.append(BusinessTypeModel(businessType))
                }
                
                UserProfile.sharedInstance.businessTypeArray = self.businessTypeArray
                
                self.businessTypeList.append("Type de Business")
                for businessType in self.businessTypeArray {
                    self.businessTypeList.append(businessType.name!)
                }
            }
            
            self.setupBusinessTypeDropdownMenu()
            
        }
    }
    
    func loginChanged() {
        
        if UserProfile.sharedInstance.isLoggedIn() {
            self.searchItem.userID = UserProfile.sharedInstance.currentUser?.id
        } else {
            self.searchItem.userID = ""
        }
        self.getBusinessList()
        
    }
    
    func signUpSuccess() {
        
        self.showMessageError("Thank you", "You are registered successfully.")
        
        if UserProfile.sharedInstance.isLoggedIn() {
            self.searchItem.userID = UserProfile.sharedInstance.currentUser?.id
        } else {
            self.searchItem.userID = ""
        }
        self.getBusinessList()
        
    }
    
    func profileUpdateSuccess() {
        
        self.showMessageError("Success", "Your profile was updated successfully.")
        
        if UserProfile.sharedInstance.isLoggedIn() {
            self.searchItem.userID = UserProfile.sharedInstance.currentUser?.id
        } else {
            self.searchItem.userID = ""
        }
        self.getBusinessList()
        
    }

    
    // MARK: Send Contact Notification Process
    
    func sendContactSuccess(_ notification: Notification) {
        guard let contactType = notification.object as? SubjectType else {
            return
        }
        
        switch contactType {
            
        case .general:
            
            self.showMessageError("Success", "Thank you for your message to the Afrisia Contact team!")
            break
            
        case .label:
            
            self.showMessageError("Success", "Thank you for your submission to the Afrisia Contact team!")
            break
 
        default:
            self.showMessageError("Success", "Thank you for your submission to the Afrisia Contact team!")
            break
        }
        
       
    }
    
    func textFieldDidChange (_ textField: UITextField) {
        
        let labelArray = textField.text?.components(separatedBy: ",")
        let keyString = labelArray?.last?.trimmingCharacters(in: .whitespaces).lowercased()
        let filteredLabelList = labelList.filter{($0.lowercased().range(of: keyString!) != nil)}
        self.labelListDropdown.dataSource = filteredLabelList
        self.labelListDropdown.reloadAllComponents()
        labelListDropdown.show()
       
    }
    
    @IBAction func advanceSearchButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowResearchSegue", sender: nil)
    }
    
    func setupBusinessTypeDropdownMenu() {
        self.businessTypeDropDown = DropDown(anchorView: businessTypeView)
        self.businessTypeDropDown.dataSource = self.businessTypeList
        self.businessTypeDropDown.dismissMode = .onTap
        self.businessTypeDropDown.bottomOffset = CGPoint(x: 0, y: self.businessTypeView.frame.size.height)
        self.businessTypeDropDown.backgroundColor = UIColor.white
        self.businessTypeDropDown.selectRow(at: 0)
        
        self.businessTypeDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.businessTypeDropDown.selectionAction = {(index: Int, item: String) in
            self.businessTypeLabel.text = item
            print(index)
            
            if index == 0 {
                self.searchItem.businessTypeID = ""
            } else {
                self.searchItem.businessTypeID = self.businessTypeArray[index-1].id!
                
                print(self.searchItem.businessTypeID!)
            }
            
            self.getBusinessList()
            
        }
        
    }
    
    func setupLabelListDropdownMenu () {
        self.labelListDropdown = DropDown(anchorView: labelListView)
        self.labelListDropdown.dataSource = labelList
        self.labelListDropdown.dismissMode = .onTap
        self.labelListDropdown.bottomOffset = CGPoint(x: 0, y: self.labelListView.frame.size.height)
        self.labelListDropdown.backgroundColor = UIColor.white
        self.labelListDropdown.selectRow(at: 0)
        
        self.labelListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.labelListDropdown.selectionAction = {(index: Int, item: String) in
          
            var labelArray = self.labelsInputTxt.text?.components(separatedBy: ",")
            let index = (labelArray?.count)! - 1
            labelArray?.remove(at: index)
            labelArray?.append(item)
            self.labelsInputTxt.text = labelArray?.joined(separator: ", ")
        }
    }
    
    @IBAction func searchBusinessButtonAction(_ sender: Any) {
        
        self.searchItem.labels = labelsInputTxt.text
        
        self.getBusinessList()
        
    }
    
    @IBAction func showBusinessTypeButtonAction(_ sender: Any) {
        businessTypeDropDown.show()
    }

    @IBAction func toggleMenu(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
    }
    
    @IBAction func aboutButtonAction(_ sender: Any) {
        self.performSegue(withIdentifier: "ShowAboutSegue", sender: nil)
    }

    @IBAction func showLabelListButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let labelListViewController = storyboard.instantiateViewController(withIdentifier: "LabelListViewController") as! LabelListViewController
        
        labelListViewController.delegate = self
        
        self.navigationController?.present(labelListViewController, animated: true, completion: nil)
        
    }
    
    // MARK - Tableview Part
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return businessArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath as IndexPath) as! BusinessTableViewCell
        

        cell.businessImage.af_setImage(withURL: self.businessArray[indexPath.row].photoUrl!)
        cell.businessImage.contentMode = .scaleAspectFill
        cell.businessNameLabel.text = self.businessArray[indexPath.row].name?.trimmingCharacters(in: .whitespaces)
        cell.businessTypeLabel.text = "[" + self.businessArray[indexPath.row].type! + "]"
        cell.locationLabel.text = self.businessArray[indexPath.row].city
        
        let rate = self.businessArray[indexPath.row].rateScore
        if Int(rate) > 0 {
            cell.businessRateLabel.text = String(describing: self.businessArray[indexPath.row].rateScore)
        
        } else {
            cell.businessRateLabel.text = "-"
        }
        
        if businessArray[indexPath.row].isFavorite {
            cell.favoritStatusImage.image = AfrisiaImage.favoritIcon.image
        } else {
            cell.favoritStatusImage.image = AfrisiaImage.unfavoritIcon.image
        }
        
        var count = self.businessArray[indexPath.row].labelDetails.count
        count = (count > 4) ? 4 : count
        if count > 0 {
            let labelDetails = self.businessArray[indexPath.row].labelDetails
          
            for i in  0 ... count - 1 {
                cell.labels[i].text = "[" + labelDetails[i].name! + "]"
                cell.labels[i].textColor = CommonUtils.sharedInstance.setRateColor(rate: labelDetails[i].averageRate)
                
                if i == 3 {
                    cell.labels[i].text = "[...]"
                }
            }
        }
        if count < 4 {
            for i in count ... 3 {
                cell.labels[i].text = ""
            }
        }
        cell.favoritChangeButtonAction.tag = indexPath.row
        cell.favoritChangeButtonAction.addTarget(self, action: #selector(HomeViewController.favoritChangeButtonAction(_:)), for: .touchUpInside)

     
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessDetailViewController = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        
        businessDetailViewController.business = businessArray[indexPath.row]
        self.navigationController?.pushViewController(businessDetailViewController, animated: true)
    }
    
    func favoritChangeButtonAction (_ sender: UIButton) {
        
        if UserProfile.sharedInstance.isLoggedIn() {
            let business = businessArray[sender.tag]
            
            let businessId = business.id
            let userId = UserProfile.sharedInstance.getUserId()
            var favoritStatus: String  = "0"
            if business.isFavorite {
                favoritStatus = "0"
            } else {
                favoritStatus = "1"
            }
            
            WebService.changeFavoritBusiness(businessId: businessId!, userId: userId!, status: favoritStatus) { (result, error) in
                if let _ = error {
                    print("Error Found ---")
                }
                
                let status = result?["status"] as? Int
                
                if status == 3 || status == 1 {
                    
                    self.showMessageError("Success", "Your favorite was changed successfully.")
                    
                    self.checkLogin()
                    self.businessListTableView.reloadData()
                    
                    
                    
                }
            }
            
            
            

        } else {
            self.showMessageError("Erreur", "You must login to change favorit.")
        }
    }
}


extension HomeViewController: LabelListViewControllerDelegate {
    
    func selectedLabel(_ labelName: String) {
        print("SELETED LABEL ---- %@", labelName)
        self.labelsInputTxt.text = labelName
        
        self.searchItem.labels = labelName
        self.getBusinessList()
    }
}

