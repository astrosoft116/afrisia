//
//  ResearchViewController.swift
//  Afrisia
//
//  Created by mobile on 4/20/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import Alamofire
import CoreLocation

class ResearchViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    var showMyLabelCheck: Bool = true
    var searchTagsEnable: Bool = false
    
    var businessTypeDropDown: DropDown!
    var labelListDropdown: DropDown!
    var placeAutoCompleteDropdown: DropDown!
    
    var labelList: [String] = []
    var selectedLabelList: [String] = []
    var businessTypeList: [String] = []
    var placeList: [String] = []
    var placeIdList: [String] = []
    var businessTypeArray: [BusinessTypeModel] = [BusinessTypeModel]()
    
    var currentPlace: PlaceDetail?
    var searchItem: SearchItemModel = SearchItemModel()
    
    var textField = UITextField()

    
    let textFieldContentsKey = "textFieldContents"
    
    @IBOutlet weak var andOperationButtonImage: UIImageView!
    @IBOutlet weak var orOperationButtonImage: UIImageView!
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var tagsTextField: UITextField!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet weak var businessTypeView: UIView!
    @IBOutlet weak var labelInputTextField: UITextField!
    @IBOutlet weak var labelListView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var businessNameLabel: UITextField!
    @IBOutlet weak var checkFieldView: UIView!
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        self.getBusinessTypeList()
        self.getLabelList()
        
        // Edit Event
        labelInputTextField.addTarget(self, action: #selector(ResearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        locationTextField.addTarget(self, action: #selector(ResearchViewController.locationDidChanged(_:)), for: .editingChanged)
        
        // Setup All Views
        self.setupAllViews()
        
        // AutoComplete
        self.setupPlaceAutoCompleteDropdown()
        
        if let currentLocation = AppDelegate.appDelegate().getLocation(){
            self.searchItem.latitude = currentLocation.coordinate.latitude
            self.searchItem.longitude = currentLocation.coordinate.longitude
        }
        
        AppDelegate.appDelegate().getAddressFromLocation(latitude: searchItem.latitude!, longitude: searchItem.longitude!) { (plcemark) in
            let fullAddressArray = plcemark?.addressDictionary?["FormattedAddressLines"] as! [String]
            for address in fullAddressArray {
                self.locationTextField.text = self.locationTextField.text! + address + " "
            }
        }

        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
    }
    
    func setupAllViews () {
        businessTypeView.layer.borderColor = UIColor.black.cgColor
        businessTypeView.layer.borderWidth = 1
        
        if !searchTagsEnable {
            tagsTextField.text = ""
            tagsTextField.isHidden = true
        }
        
        if UserProfile.sharedInstance.isLoggedIn() {
            checkFieldView.isHidden = false
            
            
            // Label Table View
            self.selectedLabelList.removeAll()
            
            let profileLabels = UserProfile.sharedInstance.currentUser?.labels
            
            for label in profileLabels! {
                self.selectedLabelList.append(label.name)
            }
            
            tableView.reloadData()
            
            searchItem.userID = UserProfile.sharedInstance.getUserId()
            
            
            
        } else {
            checkFieldView.isHidden = true
        }
        

        if let currentLocation = AppDelegate.appDelegate().getLocation(){
            searchItem.latitude = currentLocation.coordinate.latitude
            searchItem.longitude = currentLocation.coordinate.longitude
        }

    }
    
    func locationDidChanged(_ textField: UITextField){
        
        if (textField == locationTextField) && ((textField.text?.characters.count)! > 0){
            
            placeList = []
            placeIdList = []
            
            CommonUtils.sharedInstance.request?.cancel()
            
            WebService.getPlaceAutoComplete(input: textField.text!) { (result, error) in
                
                if let _ = error {
                    print("Error Found ---")
                }
                
                if let results = result?["predictions"] as? [[String: AnyObject?]] {
                    for result in results {
                        self.placeList.append(result["description"] as! String)
                        self.placeIdList.append(result["place_id"] as! String)
                        
                    }
                    
                    self.placeAutoCompleteDropdown.dataSource = self.placeList
                    self.placeAutoCompleteDropdown.show()
                }
                
            }
        } else {
            self.placeAutoCompleteDropdown.hide()
        }

    }
    
    func getBusinessTypeList() {
        
        if let businessTypeArray = UserProfile.sharedInstance.businessTypeArray {
            self.businessTypeArray = businessTypeArray
            self.businessTypeList.append("Type de Business")
            
            for businessType in businessTypeArray {
                self.businessTypeList.append(businessType.name!)
            }
        }
        
        self.setupBusinessTypeDropdownMenu()

    }
    
    func getLabelList() {
        
        if let userLabels = UserProfile.sharedInstance.userLabels {
            
            for userLabel in userLabels {
                self.labelList.append(userLabel.name!)
            }
        }
        
        self.setupLabelListDropdownMenu()
        
    }
    
    @IBAction func changeLabelAction(_ sender: Any) {
        print("clicked")
        
        
    }
    
    func textFieldDidChange (_ textField: UITextField) {
        
        let keyString: String = textField.text!
        let filteredLabelList = labelList.filter{($0.lowercased().range(of: keyString) != nil)}
        self.labelListDropdown.dataSource = filteredLabelList
        labelListDropdown.show()
        
            print(textField.text ?? String())
    }
    
    // MARK: - BusinessType Dropdown
    
    func setupBusinessTypeDropdownMenu () {
        
        self.businessTypeDropDown = DropDown(anchorView: businessTypeView)
        self.businessTypeDropDown.dataSource = businessTypeList
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
            
            if index == 0 {
                self.searchItem.businessTypeID = ""
            } else {
                self.searchItem.businessTypeID = self.businessTypeArray[index-1].id!
                
                print(self.searchItem.businessTypeID!)
            }
        }
    }
    
    // MARK: - LabelList Dropdown
    func setupLabelListDropdownMenu () {
        self.labelListDropdown = DropDown(anchorView: labelListView)
        self.labelListDropdown.dataSource = self.labelList
        self.labelListDropdown.dismissMode = .onTap
        self.labelListDropdown.topOffset = CGPoint(x: 0, y: -self.labelListView.frame.size.height)
        self.labelListDropdown.direction = .top
        
        self.labelListDropdown.backgroundColor = UIColor.white
        self.labelListDropdown.selectRow(at: 0)
        
        self.labelListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.labelListDropdown.selectionAction = {(index: Int, item: String) in
            self.labelInputTextField.text = item
            //            self.filterTransactionsWith(index)
        }
    }
    
    func setupPlaceAutoCompleteDropdown () {
        self.placeAutoCompleteDropdown = DropDown(anchorView: locationTextField)
        self.placeAutoCompleteDropdown.dataSource = ["default"]
        self.placeAutoCompleteDropdown.dismissMode = .onTap
        self.placeAutoCompleteDropdown.bottomOffset = CGPoint(x: 0, y: self.locationTextField.frame.size.height)
        
        self.placeAutoCompleteDropdown.backgroundColor = UIColor.white
        self.placeAutoCompleteDropdown.selectRow(at: 0)
        
        self.placeAutoCompleteDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.placeAutoCompleteDropdown.selectionAction = {(index: Int, item: String) in
            self.locationTextField.text = item
            
            WebService.getPlaceDetail(placeId: self.placeIdList[index]) { (result, error) in
                
                if let _ = error {
                    print("Error Found ---")
                }
                
                if let result = result?["result"] as? [String: AnyObject?] {
                    
                    self.currentPlace = PlaceDetail(result)
                    
                    let lat = self.currentPlace?.latitude
                    let lng = self.currentPlace?.longitude

                    self.searchItem.latitude = CLLocationDegrees(lat!)
                    self.searchItem.longitude = CLLocationDegrees(lng!)
                }
                
            }

        }
    }
    
    @IBAction func addLabelButtonAction(_ sender: Any) {
        
        if self.labelInputTextField.text == "" {
            self.showMessageError("Erreur", "Please input the label.")
            return
        }
        
        if selectedLabelList.contains(self.labelInputTextField.text!){
            self.showMessageError("Erreur", "Please choose another label.")
            return
        }
        
        if !labelList.contains(self.labelInputTextField.text!){
            self.showMessageError("Erreur", "Please input correct label name.")
            return
        }
            
        let newLabel = self.labelInputTextField.text
        selectedLabelList.append(newLabel!)
        tableView.reloadData()
        self.labelInputTextField.text = ""
        
        
    }
    
    @IBAction func businessTypeShowButton(_ sender: Any) {
        businessTypeDropDown.show()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func showTagsTextFieldButtonAction(_ sender: Any) {
        searchTagsEnable = true
        tagsTextField.isHidden = false
    }
    
    @IBAction func showSearchBusinessButtonAction(_ sender: Any) {
        
        self.searchItem.businessName = self.businessNameLabel.text
        self.searchItem.tags = self.tagsTextField.text
        
        let joiner = ","
        self.searchItem.labels = self.selectedLabelList.joined(separator: joiner)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let researchBusinessViewController = storyboard.instantiateViewController(withIdentifier: "ResearchBusinessViewController") as! ResearchBusinessViewController
        
        researchBusinessViewController.searchItem = self.searchItem
        
        self.navigationController?.pushViewController(researchBusinessViewController, animated: true)
    }
   
    @IBAction func andOperationAction(_ sender: Any) {
        self.searchItem.logicOperation = "AND"
//        andOperationButtonImage.image = UIImage(named: "green_circle")
        
        andOperationButtonImage.image = AfrisiaImage.greenButtonIcon.image
        orOperationButtonImage.image = AfrisiaImage.blackButtonIcon.image
    }

    @IBAction func orOperationAction(_ sender: Any) {
        self.searchItem.logicOperation = "OR"
        orOperationButtonImage.image = AfrisiaImage.greenButtonIcon.image
        andOperationButtonImage.image = AfrisiaImage.blackButtonIcon.image
    }
    
    @IBAction func checkButtonAction(_ sender: Any) {
        
        showMyLabelCheck = !showMyLabelCheck
        
        if showMyLabelCheck {
            let profileLabels = UserProfile.sharedInstance.currentUser?.labels
            
            for label in profileLabels! {
                self.selectedLabelList.append(label.name)
            }

            checkImage.image = AfrisiaImage.checkButtonIcon.image
            
            tableView.reloadData()
        } else {
            checkImage.image = AfrisiaImage.uncheckButtonIcon.image
            self.selectedLabelList.removeAll()
            tableView.reloadData()
        }
    }
    
    func deleteLabelAction(_ sender: UIButton) {
        let index = sender.tag
        selectedLabelList.remove(at: index)
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return selectedLabelList.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResearchLabelTableViewCell", for: indexPath as IndexPath) as! ResearchLabelTableViewCell
        cell.txtLabelField.text = selectedLabelList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(ResearchViewController.deleteLabelAction(_:)), for: .touchUpInside)
        
        /*
         if let desc = self.items[indexPath.row]["description"] as? NSString   {
         cell.detailTextLabel.text = desc
         }*/
        
        return cell
    }

}
