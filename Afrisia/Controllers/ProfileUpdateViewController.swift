//
//  ProfileUpdateViewController.swift
//  Afrisia
//
//  Created by mobile on 5/5/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import AlamofireImage
import Social


class ProfileUpdateViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var confirmPasswordText: UITextField!
    @IBOutlet weak var passwordPartView: UIView!
    @IBOutlet weak var labelInputPartView: UIView!

    @IBOutlet weak var labelInputText: UITextField!
    @IBOutlet weak var passwordChangeButtonImage: UIImageView!
    @IBOutlet weak var promotionCheckImage: UIImageView!
    @IBOutlet weak var offerCheckImage: UIImageView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var updatedPhotoImage: UIImageView = UIImageView()
    
    var currentUser: UserModel!
    var profileLabelList: [ProfileLabel] = [ProfileLabel]()
    var willChangePassword: Bool = false
    
    var labelList: [String] = []
    var labelListDropdown: DropDown!
    var selectedLabels: [String] = []
    
    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        imagePicker.delegate = self
        
        currentUser = UserProfile.sharedInstance.currentUser
        self.getLabelList()
        
        // Edit Event
        labelInputText.addTarget(self, action: #selector(ProfileUpdateViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.setupAllViews()
        
    }
    
    func setupAllViews(){
        
        // User Photo
        
        if currentUser.photoData == "" {
            userImage.af_setImage(withURL: (currentUser?.photoURL)!)
        } else {
            userImage.image = self.updatedPhotoImage.image
        }
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.frame.size.width = userImage.frame.size.height
        userImage.layer.borderColor = UIColor.gray.cgColor
        userImage.layer.borderWidth = 2
        
        userImage.clipsToBounds = true
        
        circleImage.layer.masksToBounds = false
        circleImage.layer.cornerRadius = circleImage.frame.size.height/2
        circleImage.layer.frame.size.width = circleImage.frame.size.height
        circleImage.clipsToBounds = true
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleImage.frame.size.width/2 ,y: circleImage.frame.size.height/2 ), radius: CGFloat(circleImage.frame.size.height/2), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = UIColor.black.cgColor        //you can change the line width
        shapeLayer.lineWidth = 1.0
        
        circleImage.layer.addSublayer(shapeLayer)
        
        // User Data
        nameText.text = currentUser.name
        emailText.text = currentUser.email
        passwordText.text = currentUser.password
        confirmPasswordText.text = currentUser.password
        
        profileLabelList = currentUser.labels
        tableView.reloadData()
        
        if willChangePassword == true {
            passwordPartView.isHidden = false
            confirmPasswordText.text = ""
            passwordText.text = ""
            passwordChangeButtonImage.image = #imageLiteral(resourceName: "check")
            
        } else {
            passwordPartView.isHidden = true
            passwordChangeButtonImage.image = #imageLiteral(resourceName: "uncheck")
            let view = tableView.tableHeaderView
            view?.frame = CGRect(x: 0, y: 0, width: (view?.frame.size.width)!, height: 495 - heightConstraint.constant)
            tableView.tableHeaderView = view
        }
        
        if currentUser.isAcceptable {
            promotionCheckImage.image = #imageLiteral(resourceName: "check")
        } else {
            promotionCheckImage.image = #imageLiteral(resourceName: "uncheck")
        }
        
        if currentUser.isPublish {
            offerCheckImage.image = #imageLiteral(resourceName: "check")
        } else {
            offerCheckImage.image = #imageLiteral(resourceName: "uncheck")
        }
        

        for label in currentUser.labels {
            selectedLabels.append(label.name)
        }
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
        self.labelListDropdown.selectRow(at: 0)
        
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
    
    func textFieldDidChange (_ textField: UITextField) {
        
        let keyString: String = textField.text!
        let filteredLabelList = labelList.filter{($0.lowercased().range(of: keyString) != nil)}
        self.labelListDropdown.dataSource = filteredLabelList
        labelListDropdown.show()
        
        print(textField.text ?? String())
    }

    
    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }

    @IBAction func addLabelButtonAction(_ sender: Any) {
        
        if self.labelInputText.text == "" {
            self.showMessageError("Erreur", "Please input label name!")
            return
        }
        
        if selectedLabels.contains(self.labelInputText.text!){
            self.showMessageError("Erreur", "Please select another label!")
        } else {
            
            let newProfileLabel = ProfileLabel()
            
            newProfileLabel.name = self.labelInputText.text!
            newProfileLabel.property = "public"
            
            newProfileLabel.id = UserProfile.sharedInstance.userLabels[self.labelInputText.tag].id!
            
            currentUser.labels.append(newProfileLabel)
            profileLabelList = currentUser.labels
            
            selectedLabels.append(self.labelInputText.text!)
            
            self.labelInputText.text = ""
            
            tableView.reloadData()
        }
        
        
        
    }
    
    @IBAction func facebookShareButtonAction(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            
//            post?.setInitialText(business.name! + business.content!)
//            post?.add(businessImage.image)
//            post?.add(business.siteUrl)
            
            self.present(post!, animated: true, completion: nil)
        } else {
            self.showMessageError("Erreur", "You are not connected to Facebook")
        }

    }
    
    @IBAction func twitterShareButtonAction(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            
//            post?.setInitialText(business.name! + business.content!)
//            post?.add(businessImage.image)
//            post?.add(business.siteUrl)
            
            self.present(post!, animated: true, completion: nil)
        } else {
            self.showMessageError("Erreur", "You are not connected to Twitter.")
        }

        
    }

    @IBAction func checkForPasswordButtonAction(_ sender: Any) {
        
        if willChangePassword == true {
            willChangePassword = false
            passwordChangeButtonImage.image = #imageLiteral(resourceName: "uncheck")
            passwordText.text = currentUser.password
            confirmPasswordText.text = currentUser.password
            
            passwordPartView.isHidden = true
            
            let view = tableView.tableHeaderView
            view?.frame = CGRect(x: 0, y: 0, width: (view?.frame.size.width)!, height: 495 - heightConstraint.constant)
            tableView.tableHeaderView = view
            
            
        } else {
            
            willChangePassword = true
            passwordChangeButtonImage.image = #imageLiteral(resourceName: "check")
            passwordText.text = ""
            confirmPasswordText.text = ""
            
            passwordPartView.isHidden = false
            
            let view = tableView.tableHeaderView
            view?.frame = CGRect(x: 0, y: 0, width: (view?.frame.size.width)!, height: (view?.frame.size.height)! + heightConstraint.constant)
            tableView.tableHeaderView = view
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
    
    
    @IBAction func profileUpdateButtonAction(_ sender: Any) {
        
        if nameText.text == "" {
            self.showMessageError("Erreur", "Please input your name.")
            return
        }
        
        if emailText.text == "" {
            self.showMessageError("Erreur", "Please input your email.")
            return
        }
        
        if willChangePassword {
            if passwordText.text == "" {
                self.showMessageError("Erreur", "Please input the password.")
                return
            }
            
            if passwordText.text != confirmPasswordText.text {
                self.showMessageError("Erreur", "Please input correct confirm password.")
                
                return
            }
            
            currentUser.password = passwordText.text!
            
            
        }
        
        if CommonUtils.sharedInstance.isValidEmail(testStr: emailText.text!) == false {
            self.showMessageError("Erreur", "Please correct email.")
            return
        }

        
        
        print(currentUser)
        self.showProgressHUD()
        
        WebService.userProfileUpdate(currentUser: currentUser) { (result, error) in
            
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
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserProfileUpdateSuccess"), object: nil)
                
            } else {
                self.showMessageError("Erreur", "Your email is using by another user. Please select another one.")
            }
            
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
    
    // MARK: - Camera Function
    @IBAction func uploadPhotoButtonAction(_ sender: Any) {
        
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


extension ProfileUpdateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage //2
        self.updatedPhotoImage.contentMode = .scaleAspectFit //3
        self.updatedPhotoImage.image = chosenImage //4
        self.userImage.image = chosenImage //4
        
        
        
        let imageData:NSData = UIImagePNGRepresentation(chosenImage)! as NSData
        let imageStr = imageData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
        
        currentUser.photoData = imageStr
        
        tableView.reloadData()
        dismiss(animated:true, completion: nil) //5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
