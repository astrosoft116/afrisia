//
//  ContactDetailViewController.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.

enum SubjectType {
    
    case general
    case label
    case businessType
    case business
    case officialBusiness
    
}

import UIKit
import DropDown

class ContactDetailViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var subjectPartView: UIView!
    @IBOutlet weak var subjectText: UITextField!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    var imagePicker = UIImagePickerController()
    
    var subjectListDropdown: DropDown!
    var subjectList: [String] = ["Sujet", "Label", "Type de Business", "Business", "Officiel Business"]
    var subjectType: SubjectType!
    
    var labelContact: LabelContactModel = LabelContactModel()
    var businessTypeContact: BusinessTypeContactModel = BusinessTypeContactModel()
    var businessContact: BusinessContactModel = BusinessContactModel()
    var officialBusinessContact: OfficialBusinessContactModel = OfficialBusinessContactModel()
    

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        self.setupAllViews()
    }
    
    func setupAllViews () {
        
        self.subjectType = SubjectType.general
        self.subjectText.text = "Sujet"
        self.nameText.text = UserProfile.sharedInstance.currentUser?.name
        self.emailText.text = UserProfile.sharedInstance.currentUser?.email
        self.setupSubjectListDropdown ()
        
    }
    
    func setupSubjectListDropdown (){
        self.subjectListDropdown = DropDown(anchorView: subjectPartView)
        self.subjectListDropdown.dataSource = subjectList
        self.subjectListDropdown.dismissMode = .onTap
        self.subjectListDropdown.bottomOffset = CGPoint(x: 0, y: self.subjectPartView.frame.size.height)
        self.subjectListDropdown.backgroundColor = UIColor.white
        self.subjectListDropdown.selectRow(at: 0)
        
        self.subjectListDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.subjectListDropdown.selectionAction = {(index: Int, item: String) in
            self.subjectText.text = item
            
            switch index {
            case 0:
                self.subjectType = .general
            case 1:
                self.subjectType = .label
            case 2:
                self.subjectType = .businessType
            case 3:
                self.subjectType = .business
            case 4:
                self.subjectType = .officialBusiness
            default:
                self.subjectType = .general
            }
            
            print(self.subjectType)
            
            self.tableView.reloadData()
            
        }
    }

    @IBAction func subjectSelectButtonAction(_ sender: Any) {
        subjectListDropdown.show()
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Send Contact
    @IBAction func sendContactButtonAction(_ sender: Any) {
        
        switch subjectType! {
            
        case .label:
            
            labelContact.id = UserProfile.sharedInstance.getUserId()!
            labelContact.name = self.nameText.text!
            labelContact.email = self.emailText.text!
            
            if labelContact.name == "" {
                self.showMessageError("Erreur", "Please input your name.")
                break
            }
            
            if labelContact.email == "" {
                self.showMessageError("Erreur" ,"Please input your email.")
                break
            }
            
            if labelContact.labelName == "" {
                self.showMessageError("Erreur" ,"Please input label name.")
                break
            }
            
            self.showAlertWith("Confirmation", message: "Do you want to submit a new label?", confirmAction: { (_) in
                print("yes")
                
                WebService.sendLabelContact(labelContact: self.labelContact, completionBlock: { (result, error) in
                    
                    if let _ = error {
                        print("Erro Found ---")
                    }
                    
                    if let status = result?["status"] as? Int {
                        if status == 1 {
                       
                            let _ = self.navigationController?.popViewController(animated: true)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendContactSuccess"), object: self.subjectType)
                            
                            
                        } else {
                            
                            let msg = result?["msg"] as? String
                            self.showMessageError("Erreur", msg!)
                        }
                    }
                })
            })
            
            
        
            break
            
        case .businessType:
            
            businessTypeContact.id = UserProfile.sharedInstance.getUserId()!
            businessTypeContact.name = self.nameText.text!
            businessTypeContact.email = self.emailText.text!
            
            if businessTypeContact.name == "" {
                self.showMessageError("Erreur", "Please input your name.")
                break
            }
            
            if businessTypeContact.email == "" {
                self.showMessageError("Erreur" ,"Please input your email.")
                break
            }
            
            if businessTypeContact.typeName == "" {
                self.showMessageError("Erreur" ,"Please input new Le Type d’Établissement nom!")
                break
            }
            
            self.showAlertWith("Confirmation", message: "Do you want to submit a new Le Type d’Établissement?", confirmAction: { (_) in
                print("yes")
                
                WebService.sendBusinessTypeContact(businessTypeContact: self.businessTypeContact, completionBlock: { (result, error) in
                    
                    if let _ = error {
                        print("Erro Found ---")
                    }
                    
                    if let status = result?["status"] as? Int {
                        if status == 1 {
                            
                            let _ = self.navigationController?.popViewController(animated: true)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendContactSuccess"), object: self.subjectType)
                            
                            
                        } else {
                            
                            let msg = result?["msg"] as? String
                            self.showMessageError("Erreur", msg!)
                        }
                    }
                })
            })
            
            
            
            break
            
        case .business:
            
            businessContact.id = UserProfile.sharedInstance.getUserId()!
            businessContact.name = self.nameText.text!
            businessContact.email = self.emailText.text!
            
            if businessContact.name == "" {
                self.showMessageError("Erreur", "Please input your name.")
                break
            }
            
            if businessContact.email == "" {
                self.showMessageError("Erreur" ,"Please input your email.")
                break
            }
            
            if businessContact.businessName == "" {
                self.showMessageError("Erreur" ,"Please input business name.")
                break
            }
            
            if businessContact.businessTypeId == "" {
                self.showMessageError("Erreur" ,"Please choose business type.")
                break
            }
            
            if businessContact.businessPhotoData == "" {
                self.showMessageError("Erreur" ,"Please upload business photo.")
                break
            }
            
            
            if businessContact.businessCity == "" {
                self.showMessageError("Erreur" ,"Please input city name.")
                break
            }
            
            if businessContact.businessAddress == "" {
                self.showMessageError("Erreur" ,"Please input correct address.")
                break
            }
            
            
            
            self.showAlertWith("Confirmation", message: "Do you want to submit a new business?", confirmAction: { (_) in
                print("yes")
                
                WebService.sendBusinessContact(businessContact: self.businessContact, completionBlock: { (result, error) in
                    
                    if let _ = error {
                        print("Erro Found ---")
                    }
                    
                    if let status = result?["status"] as? Int {
                        if status == 1 {
                            
                            let _ = self.navigationController?.popViewController(animated: true)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendContactSuccess"), object: self.subjectType)
                            
                            
                        } else {
                            
                            let msg = result?["msg"] as? String
                            self.showMessageError("Erreur", msg!)
                        }
                    }
                })
            })
            
            
            
            break
            
        case .officialBusiness:
            
            officialBusinessContact.id = UserProfile.sharedInstance.getUserId()!
            officialBusinessContact.name = self.nameText.text!
            officialBusinessContact.email = self.emailText.text!
            
            if officialBusinessContact.name == "" {
                self.showMessageError("Erreur", "Please input your name.")
                break
            }
            
            if officialBusinessContact.email == "" {
                self.showMessageError("Erreur" ,"Please input your email.")
                break
            }
            
            if officialBusinessContact.gender == "" {
                self.showMessageError("Erreur", "Please choose your gender.")
                break
            }
            
            if officialBusinessContact.phoneNumber == "" {
                self.showMessageError("Erreur", "Please input your phonenumber")
                break
            }
            
            if officialBusinessContact.role == "" {
                self.showMessageError("Erreur" ,"Please input role in your business.")
                break
            }


            
            if officialBusinessContact.businessName == "" {
                self.showMessageError("Erreur" ,"Please input business name.")
                break
            }
            
            if officialBusinessContact.businessTypeId == "" {
                self.showMessageError("Erreur" ,"Please choose business type.")
                break
            }
            if officialBusinessContact.businessPhotoData == "" {
                self.showMessageError("Erreur" ,"Please upload business photo.")
                break
            }

            
            if officialBusinessContact.businessCity == "" {
                self.showMessageError("Erreur" ,"Please input city name.")
                break
            }
            
            if officialBusinessContact.businessAddress == "" {
                self.showMessageError("Erreur" ,"Please input correct address.")
                break
            }
            
            
            
            self.showAlertWith("Confirmation", message: "Do you want to submit a new official business?", confirmAction: { (_) in
                print("yes")
                
                WebService.sendOfficialBusinessContact(officialBusinessContact: self.officialBusinessContact, completionBlock: { (result, error) in
                    
                    if let _ = error {
                        print("Erro Found ---")
                    }
                    
                    if let status = result?["status"] as? Int {
                        if status == 1 {
                            
                            let _ = self.navigationController?.popViewController(animated: true)
                            
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SendContactSuccess"), object: self.subjectType)
                            
                            
                        } else {
                            
                            let msg = result?["msg"] as? String
                            self.showMessageError("Erreur", msg!)
                        }
                    }
                })
            })
            
            
            
            break


            
        default:
            
            self.showMessageError("Erreur", "Please choose the subject!")
            break
      
        }
    }
    
    
    // MARK: - Table View Part
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        switch self.subjectType! {
            
        case .label:
            return 60
        case .businessType:
            return 400
        case .business:
            return 650
        case .officialBusiness:
            return 900
        default:
            return 140
            
            
            
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

            switch self.subjectType! {
                
            case .label:
                let cell = tableView.dequeueReusableCell(withIdentifier: "LabelContactTableViewCell", for: indexPath as IndexPath) as! LabelContactTableViewCell
                
                cell.delegate = self
                
                
                return cell
                
            case .businessType:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTypeTableViewCell", for: indexPath as IndexPath) as! BusinessTypeTableViewCell
                
                cell.delegate = self
                
                if self.businessTypeContact.typePhotoData != "" {
                    cell.cameraPartView.isHidden = true
                     cell.businessTypePicture?.contentMode = .scaleAspectFit
                    cell.businessTypePicture?.image = self.businessTypeContact.cameraImage
           
                }
                
                cell.cameraButton.addTarget(self, action: #selector(ContactDetailViewController.cameraButtonAction(_:)), for: .touchUpInside)
            
                return cell
                
            case .business:
                let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessContactTableViewCell", for: indexPath as IndexPath) as! BusinessContactTableViewCell
                
                cell.delegate = self
                
                if self.businessContact.businessPhotoData != "" {
                    cell.cameraPartView.isHidden = true
                    cell.businessPicture?.image = self.businessContact.cameraImage
               
                }
                
                cell.cameraButton.addTarget(self, action: #selector(ContactDetailViewController.cameraButtonAction(_:)), for: .touchUpInside)
                
                return cell
                
            case .officialBusiness:
                let cell = tableView.dequeueReusableCell(withIdentifier: "OfficialBusinessContactTableViewCell", for: indexPath as IndexPath) as! OfficialBusinessContactTableViewCell
                
                cell.delegate = self
                
                if self.officialBusinessContact.businessPhotoData != "" {
                    cell.cameraPartView.isHidden = true
                    cell.businessPicture?.image = self.officialBusinessContact.cameraImage
          
                }
                
                cell.cameraButton.addTarget(self, action: #selector(ContactDetailViewController.cameraButtonAction(_:)), for: .touchUpInside)
                
                return cell
                
            default:
                let cell = tableView.dequeueReusableCell(withIdentifier: "GeneralContactTableViewCell", for: indexPath as IndexPath) as! GeneralContactTableViewCell
            
                return cell
            
            
            }


    }
    
    func cameraButtonAction (_ sender: UIButton){
        
        sender.setTitleColor(UIColor.white, for: .normal)
        sender.isUserInteractionEnabled = true
        
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

extension ContactDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        
        let imageData:NSData = UIImagePNGRepresentation(chosenImage)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        
        switch self.subjectType! {
            
            
        case .businessType:
            self.businessTypeContact.cameraImage = chosenImage
            self.businessTypeContact.typePhotoData = imageStr
            break
        case .business:
            self.businessContact.cameraImage = chosenImage
            self.businessContact.businessPhotoData = imageStr
            break
        case .officialBusiness:
            self.officialBusinessContact.cameraImage = chosenImage
            self.officialBusinessContact.businessPhotoData = imageStr
            break
        default:
            break
            
            
            
        }
        tableView.reloadData()
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}


extension ContactDetailViewController: LabelContactTableViewCellDelegate {
    func updateLabel(_ labelContact: LabelContactModel) {
        print(labelContact)
        self.labelContact = labelContact
    }
}

extension ContactDetailViewController: BusinessTypeTableViewCellDelegate {
    func updateBusinessType(_ businessTypeContact: BusinessTypeContactModel) {
        print(labelContact)
        self.businessTypeContact = businessTypeContact
    }
}

extension ContactDetailViewController: BusinessContactTableViewCellDelegate{
    func updateBusinessContact(_ businessContact: BusinessContactModel){
        print(businessContact)
        
        self.businessContact = businessContact
    }
}

extension ContactDetailViewController: OfficialBusinessContactTableViewCellDelegate{
    func updateOfficialBusinessContact(_ officialBusinessContact: OfficialBusinessContactModel) {
        self.officialBusinessContact = officialBusinessContact
        print(officialBusinessContact)
    }
}

