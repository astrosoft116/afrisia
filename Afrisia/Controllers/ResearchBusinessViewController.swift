//
//  ResearchBusinessViewController.swift
//  Afrisia
//
//  Created by mobile on 4/20/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import AlamofireImage
import Alamofire
import CoreLocation

class ResearchBusinessViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var businessListTableView: UITableView!
    @IBOutlet weak var filterTypeView: UIView!
    @IBOutlet weak var filterTypeLabel: UILabel!
    @IBOutlet weak var businessCountLabel: UILabel!
    
    var businessArray: [BusinessModel] = [BusinessModel]()
    
    var searchItem = SearchItemModel()
    
    var filterTypeDropdown: DropDown!

    var filterTypeList: [String] = ["Note", "Proximité", "Moyenne"]
    
    var searchDistance: Double = 100
    var resultLimitedCount: Int = 50
    var displayedCount: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let userDefault = UserDefaults.standard
        if let searchDistance = userDefault.value(forKey: UserAuth.searchDistance){
            self.searchDistance = searchDistance as! Double
        }  else {
            userDefault.set(self.searchDistance,forKey: UserAuth.searchDistance)
        }
        
        if let resultCount = userDefault.value(forKey: UserAuth.resultCount) as? Int {
            self.resultLimitedCount = resultCount
        }  else {
            userDefault.set(self.resultLimitedCount,forKey: UserAuth.resultCount)
            userDefault.synchronize()
        }

        
        
        
        self.getBusinessList()
        self.setupFiterTypeDropdownMenu ()
    }
    
    func setupFiterTypeDropdownMenu () {
        self.filterTypeDropdown = DropDown(anchorView: filterTypeView)
        self.filterTypeDropdown.dataSource = filterTypeList
        self.filterTypeDropdown.dismissMode = .onTap
        self.filterTypeDropdown.bottomOffset = CGPoint(x: 0, y: self.filterTypeView.frame.size.height)
        self.filterTypeDropdown.backgroundColor = UIColor.white
        self.filterTypeDropdown.selectRow(at: 0)
        
        self.filterTypeDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.filterTypeDropdown.selectionAction = {(index: Int, item: String) in
            
           
            self.filterTypeLabel.text = item
            
            self.businessArray.sort(by: { (model1, model2) -> Bool in
                return model1.distance < model2.distance
            })


            switch item {
            case "Note":
   
                self.businessArray.sort(by: { (model1, model2) -> Bool in
                    return model1.rateScore > model2.rateScore
                })
                self.businessListTableView.reloadData()
                break
            case "Moyenne":
          
                self.businessArray.sort(by: { (model1, model2) -> Bool in
                    return model1.businessRateIncludingLabes > model2.businessRateIncludingLabes
                })
                self.businessListTableView.reloadData()
                break
            default:
         
                self.businessListTableView.reloadData()
                break
            }
            
            
        }

    }
//    
//    func sorterForFileIDASC(this:BusinessModel, that:BusinessModel) -> Bool {
//        return this.rateScore > that.rateScore
//    }
    
    // MARK: Get business with in 100km
    
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
            
            let searchLocation = CLLocation(latitude: searchItem.latitude!, longitude: searchItem.longitude!)
            let searchDistance = searchLocation.distance(from: businessLocation)
            
            
            business.distance = distance
            
            // Set Business and labels average
            var sum = business.rateScore
            for label in business.labelDetails {
                sum = sum + label.averageRate
            }
            
            let businessRateIncludingLabes = sum / Float(business.labelDetails.count + 1)
            
            business.businessRateIncludingLabes = businessRateIncludingLabes
            
            if searchDistance < self.searchDistance * 1000 {
                tempArray.append(business)
            }
            

            
        }
        
        businessArray.removeAll()
        
        businessArray = tempArray
        
    }


    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func showBusinessListMapButtonAction(_ sender: Any) {
        
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessListMapViewController = storyboard.instantiateViewController(withIdentifier: "BusinessListMapViewController") as! BusinessListMapViewController
        
        self.businessArray.sort(by: { (model1, model2) -> Bool in
            return model1.distance < model2.distance
        })
        
        businessListMapViewController.businessArray = self.businessArray
        businessListMapViewController.searchItem = self.searchItem
    
        self.navigationController?.pushViewController(businessListMapViewController, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chooseFilterButtonAction(_ sender: Any) {
        self.filterTypeDropdown.show()
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
                }
                
                self.getBusinessArrwayWithInDistance()
                
                if self.businessArray.count > self.resultLimitedCount {
                    self.displayedCount = self.resultLimitedCount
                } else {
                    self.displayedCount = self.businessArray.count
                }
                
                if self.displayedCount > 1 {
                    self.businessCountLabel.text = String(self.displayedCount) + " Résultats"
                } else {
                    self.businessCountLabel.text = String(self.displayedCount) + " Résultat"
                }
            }
            
            self.businessArray.sort(by: { (model1, model2) -> Bool in
                return model1.distance < model2.distance
            })
            
            self.businessListTableView.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return self.displayedCount
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


    

}
