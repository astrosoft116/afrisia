//
//  BusinessContactTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown

protocol BusinessContactTableViewCellDelegate {
    func updateBusinessContact(_ businessContact: BusinessContactModel)
}

class BusinessContactTableViewCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var businessTypePartView: UIView!
    @IBOutlet weak var businessTypeText: UITextField!
    @IBOutlet weak var cityText: UITextField!
    @IBOutlet weak var addressText: UITextField!
    @IBOutlet weak var businessNameText: UITextField!
    @IBOutlet weak var businessWebsiteText: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cameraPartView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var businessPicture: UIImageView!
    
    var businessTypeListDropdown: DropDown!
    var businessTypeList: [String] = []
    var businessTypeArray: [BusinessTypeModel] = [BusinessTypeModel]()
    
    var placeAutoCompleteDropdown: DropDown!
    var placeList: [String] = []
    var placeIdList: [String] = []
    var currentPlace: PlaceDetail?

    var businessContact: BusinessContactModel = BusinessContactModel()
    
    var delegate: BusinessContactTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        self.getBusinessTypeList()
        
        addressText.addTarget(self, action: #selector(BusinessContactTableViewCell.locationDidChanged(_:)), for: .editingChanged)
        cityText.addTarget(self, action: #selector(BusinessContactTableViewCell.locationDidChanged(_:)), for: .editingChanged)
        
        businessNameText.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        businessWebsiteText.addTarget(self, action: #selector(BusinessContactTableViewCell.textFieldDidChanged(_:)), for: .editingChanged)
        
        descriptionTextView.delegate = self
        
        // AutoComplete
        self.setupPlaceAutoCompleteDropdown()


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
    
    func textViewDidChange(_ textView: UITextView) {
        businessContact.businessDescription = descriptionTextView.text
        self.delegate.updateBusinessContact(businessContact)
    }
    
    func textFieldDidChanged (_ textField: UITextField) {

        businessContact.businessName = businessNameText.text!
        businessContact.businessSite = businessWebsiteText.text!
        
        self.delegate.updateBusinessContact(businessContact)
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
                    self.businessContact.businessCity = (self.currentPlace?.cityName)!
                    self.businessContact.businessAddress = (self.currentPlace?.fullAddress)!
                    self.businessContact.latitude = (self.currentPlace?.latitude)!
                    self.businessContact.longitude = (self.currentPlace?.longitude)!
                    
                    self.delegate.updateBusinessContact(self.businessContact)
                    
                
                    
                }
                
            }
            
        }
    }



    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
    }
    
    func getBusinessTypeList() {
        
        if let businessTypeArray = UserProfile.sharedInstance.businessTypeArray {
            self.businessTypeArray = businessTypeArray
            
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
            self.businessContact.businessTypeId = self.businessTypeArray[index].id!
            
            self.delegate.updateBusinessContact(self.businessContact)

        }

    }
    

    @IBAction func businessTypeSelectButtonActioin(_ sender: Any) {
        
        businessTypeListDropdown.show()
    }
    

}
