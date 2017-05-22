//
//  AddBusinessViewController.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import CoreLocation

class AddBusinessViewController: BaseViewController{

    @IBOutlet weak var addPictureButtonPartView: UIView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var businessTypePartView: UIView!
    @IBOutlet weak var businessWebsiteText: UITextField!
    @IBOutlet weak var businessCityText: UITextField!
    @IBOutlet weak var businessAddressText: UITextField!
    @IBOutlet weak var decriptionTextView: UITextView!
    @IBOutlet weak var businessType: UITextField!
    @IBOutlet weak var cameraButton: UIButton!
    
    var businessTypeListDropdown: DropDown!
    var businessTypeList: [String] = []
    var businessTypeArray: [BusinessTypeModel] = [BusinessTypeModel]()
    
    var placeAutoCompleteDropdown: DropDown!
    var placeList: [String] = []
    var placeIdList: [String] = []
    var currentPlace: PlaceDetail?
    
    var businessContact: BusinessContactModel = BusinessContactModel()
    
    var imagePicker = UIImagePickerController()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        var currentLati = CLLocationDegrees()
        var currentLong = CLLocationDegrees()
        
        if let currentLocation = AppDelegate.appDelegate().getLocation(){
            currentLati = currentLocation.coordinate.latitude
            currentLong = currentLocation.coordinate.longitude
        }
        
        businessContact.latitude = Float(currentLati)
        businessContact.longitude = Float(currentLong)
        
        AppDelegate.appDelegate().getAddressFromLocation(latitude: currentLati, longitude: currentLong) { (plcemark) in
            let fullAddressArray = plcemark?.addressDictionary?["FormattedAddressLines"] as! [String]
            for address in fullAddressArray {
                self.businessAddressText.text = self.businessAddressText.text! + address + " "
                
            }
            
            self.businessCityText.text = plcemark?.locality
        }

        decriptionTextView.layer.borderWidth = 1
        decriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        imagePicker.delegate = self
        
        self.getBusinessTypeList()
        
        businessAddressText.addTarget(self, action: #selector(AddBusinessViewController.locationDidChanged(_:)), for: .editingChanged)
        businessCityText.addTarget(self, action: #selector(AddBusinessViewController.locationDidChanged(_:)), for: .editingChanged)
        
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
            self.businessType.text = item
            self.businessContact.businessTypeId = self.businessTypeArray[index].id!

            
        }
        
    }
    
    func setupPlaceAutoCompleteDropdown () {
        self.placeAutoCompleteDropdown = DropDown(anchorView: businessAddressText)
        self.placeAutoCompleteDropdown.dataSource = ["default"]
        self.placeAutoCompleteDropdown.dismissMode = .onTap
        self.placeAutoCompleteDropdown.bottomOffset = CGPoint(x: 0, y: self.businessAddressText.frame.size.height)
        
        self.placeAutoCompleteDropdown.backgroundColor = UIColor.white
        self.placeAutoCompleteDropdown.selectRow(at: 0)
        
        self.placeAutoCompleteDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.placeAutoCompleteDropdown.selectionAction = {(index: Int, item: String) in
            self.businessAddressText.text = item
            
            WebService.getPlaceDetail(placeId: self.placeIdList[index]) { (result, error) in
                
                if let _ = error {
                    print("Error Found ---")
                }
                
                if let result = result?["result"] as? [String: AnyObject?] {
                    
                    self.currentPlace = PlaceDetail(result)
                    self.businessCityText.text = self.currentPlace?.cityName
                    self.businessContact.businessCity = (self.currentPlace?.cityName)!
                    self.businessContact.businessAddress = (self.currentPlace?.fullAddress)!
                    self.businessContact.latitude = (self.currentPlace?.latitude)!
                    self.businessContact.longitude = (self.currentPlace?.longitude)!
                    
                    
                    
                }
                
            }
            
        }
    }


    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func businessAddButtonAction(_ sender: Any) {
        
        businessContact.id = UserProfile.sharedInstance.getUserId()!
        businessContact.businessName = self.businessName.text!
        businessContact.businessSite = self.businessWebsiteText.text!
        businessContact.businessDescription = self.decriptionTextView.text
  
        
        if businessContact.businessPhotoData == "" {
            self.showMessageError("Erreur" ,"Please upload business photo.")
            return
            
        }
        
        if businessContact.businessName == "" {
            self.showMessageError("Erreur" ,"Please input business name.")
            return
           
        }
        
        if businessContact.businessTypeId == "" {
            self.showMessageError("Erreur" ,"Please choose business type.")
            return
        }
        
        if businessContact.businessCity == "" {
            self.showMessageError("Erreur" ,"Please input city name.")
            return
        }
        
        if businessContact.businessAddress == "" {
            self.showMessageError("Erreur" ,"Please input correct address.")
            return
           
        }
        
        self.showAlertWith("Confirmation", message: "Do you want to submit a new business?", confirmAction: { (_) in
       
            self.showProgressHUD()
            
            WebService.addNewBusiness(businessContact: self.businessContact, completionBlock: { (result, error) in
                
                 self.hideProgressHUD()
                
                if let _ = error {
                    print("Erro Found ---")
                }
                
                if let status = result?["status"] as? Int {
                    if status == 1 {
                        
                        let _ = self.navigationController?.popViewController(animated: true)
                        
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendContactSuccess"), object: SubjectType.business)
                        
                        
                    } else {
                        
                        let msg = result?["msg"] as? String
                        self.showMessageError("Erreur", msg!)
                    }
                }
            })
        })


    }
   
    @IBAction func businessTypeSelectButtonAction(_ sender: Any) {
        businessTypeListDropdown.show()
    }
    
    // MARK: - Camera Function
    
    @IBAction func uploadBusinessPhotoButtonAction(_ sender: Any) {
        
        self.cameraButton.setTitleColor(UIColor.white, for: .normal)
        self.cameraButton.isUserInteractionEnabled = true
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        imagePicker.allowsEditing = true
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
 


}


extension AddBusinessViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        self.businessImage.contentMode = .scaleToFill //3
        self.businessImage.image = chosenImage //4
        
        
        
        
        let imageData:NSData = UIImagePNGRepresentation(chosenImage)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        
        businessContact.businessPhotoData = imageStr
        self.addPictureButtonPartView.isHidden = true
        
        
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
