//
//  OfficialBusinessContactTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown

protocol OfficialBusinessContactTableViewCellDelegate {
    func updateOfficialBusinessContact(_ officialBusinessContact: OfficialBusinessContactModel)
}

class OfficialBusinessContactTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var genderText: UITextField!
    @IBOutlet weak var businessTypeText: UITextField!
    @IBOutlet weak var businessTypePartView: UIView!
    @IBOutlet weak var genderPartView: UIView!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var phonenumberAfrisiaText: UITextField!
    @IBOutlet weak var phonenumberUserText: UITextField!
    @IBOutlet weak var roleText: UITextField!
    @IBOutlet weak var businessWebsite: UITextField!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var businessPicture: UIImageView!
    @IBOutlet weak var cameraPartView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var businessTypeListDropdown: DropDown!
    var businessTypeList: [String] = []
    var businessTypeArray: [BusinessTypeModel] = [BusinessTypeModel]()
    
    var placeAutoCompleteDropdown: DropDown!
    var placeList: [String] = []
    var placeIdList: [String] = []
    var currentPlace: PlaceDetail?
    
    var genderDropdown: DropDown!
    var genderList: [String] = ["Male","Female"]
    
    var officialBusinessContact: OfficialBusinessContactModel = OfficialBusinessContactModel()
    
    var delegate: OfficialBusinessContactTableViewCellDelegate!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionText.layer.borderWidth = 1
        descriptionText.layer.borderColor = UIColor.black.cgColor
        
        self.getBusinessTypeList()
        self.setupGenderDropdown()
        
        addressText.addTarget(self, action: #selector(BusinessContactTableViewCell.locationDidChanged(_:)), for: .editingChanged)
        cityText.addTarget(self, action: #selector(BusinessContactTableViewCell.locationDidChanged(_:)), for: .editingChanged)
        
        // AutoComplete
        self.setupPlaceAutoCompleteDropdown()
        
        descriptionText.delegate = self
        businessName.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        businessWebsite.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        roleText.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        phonenumberAfrisiaText.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        phonenumberUserText.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        

    }
    
    func locationDidChanged(_ textField: UITextField){
        
        if ((textField.text?.characters.count)! > 0){
            
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
                    self.placeAutoCompleteDropdown.anchorView = textField
                    self.placeAutoCompleteDropdown.dataSource = self.placeList
                    self.placeAutoCompleteDropdown.show()
                }
                
            }
        } else {
            self.placeAutoCompleteDropdown.hide()
        }
        
    }
    
    func setupPlaceAutoCompleteDropdown () {
        self.placeAutoCompleteDropdown = DropDown(anchorView: addressText)
        self.placeAutoCompleteDropdown.dataSource = ["default"]
        self.placeAutoCompleteDropdown.dismissMode = .onTap
        self.placeAutoCompleteDropdown.bottomOffset = CGPoint(x: 0, y: self.addressText.frame.size.height)
        
        self.placeAutoCompleteDropdown.backgroundColor = UIColor.white
        self.placeAutoCompleteDropdown.selectRow(at: 0)
        
        self.placeAutoCompleteDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.placeAutoCompleteDropdown.selectionAction = {(index: Int, item: String) in
            self.addressText.text = item
            
            WebService.getPlaceDetail(placeId: self.placeIdList[index]) { (result, error) in
                
                if let _ = error {
                    print("Error Found ---")
                }
                
                if let result = result?["result"] as? [String: AnyObject?] {
                    
                    self.currentPlace = PlaceDetail(result)
                    self.cityText.text = self.currentPlace?.cityName
                    
                    self.officialBusinessContact.businessCity = (self.currentPlace?.cityName)!
                    self.officialBusinessContact.businessAddress = (self.currentPlace?.fullAddress)!
                    self.officialBusinessContact.latitude = (self.currentPlace?.latitude)!
                    self.officialBusinessContact.longitude = (self.currentPlace?.longitude)!
                    
                    self.delegate.updateOfficialBusinessContact(self.officialBusinessContact)

                    
                    
                    
                }
                
            }
            
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        officialBusinessContact.businessDescription = descriptionText.text
        
        self.delegate.updateOfficialBusinessContact(self.officialBusinessContact)
    }
    
    func textFieldDidChanged (_ textField: UITextField) {
        
        officialBusinessContact.businessName = businessName.text!
        officialBusinessContact.businessSite = businessWebsite.text!
        officialBusinessContact.role = roleText.text!
        officialBusinessContact.phoneNumber = phonenumberAfrisiaText.text!
        officialBusinessContact.businessNumber = phonenumberUserText.text!
        
        self.delegate.updateOfficialBusinessContact(self.officialBusinessContact)

  
    }

    
    func getBusinessTypeList() {
        
        if let businessTypeArray = UserProfile.sharedInstance.businessTypeArray {
            self.businessTypeArray = businessTypeArray
            self.businessTypeList.append("Type de Business")
            
            for businessType in businessTypeArray {
                self.businessTypeList.append(businessType.name!)
            }
        }
        
        self.setupBusinessTypeDropdown()
        
    }
    
    func setupBusinessTypeDropdown() {
        self.businessTypeListDropdown = DropDown(anchorView: businessTypePartView)
        self.businessTypeListDropdown.dataSource = businessTypeList
        self.businessTypeListDropdown.dismissMode = .onTap
        self.businessTypeListDropdown.bottomOffset = CGPoint(x: 0, y: self.businessTypePartView.frame.size.height)
        self.businessTypeListDropdown.backgroundColor = UIColor.white
        self.businessTypeListDropdown.selectRow(at: 0)
        
        self.businessTypeListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.businessTypeListDropdown.selectionAction = {(index: Int, item: String) in
            self.businessTypeText.text = item
            self.officialBusinessContact.businessTypeId = self.businessTypeArray[index].id!
            
            self.delegate.updateOfficialBusinessContact(self.officialBusinessContact)
            

        }
    }
    
    func setupGenderDropdown() {
        self.genderDropdown = DropDown(anchorView: genderPartView)
        self.genderDropdown.dataSource = genderList
        self.genderDropdown.dismissMode = .onTap
        self.genderDropdown.bottomOffset = CGPoint(x: 0, y: self.genderPartView.frame.size.height)
        self.genderDropdown.backgroundColor = UIColor.white
        self.genderDropdown.selectRow(at: 0)
        
        self.genderDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.genderDropdown.selectionAction = {(index: Int, item: String) in
            self.genderText.text = item
            
            self.officialBusinessContact.gender = item
            
            self.delegate.updateOfficialBusinessContact(self.officialBusinessContact)
        }
    }



    @IBAction func genderSelectButtonAction(_ sender: Any) {
        genderDropdown.show()
    }
    @IBAction func businessTypeSelectButtonAction(_ sender: Any) {
        businessTypeListDropdown.show()

    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
