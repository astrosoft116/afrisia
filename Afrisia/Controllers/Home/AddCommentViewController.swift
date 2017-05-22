//
//  AddCommentViewController.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown
import Social

class AddCommentViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var contentText: UITextView!
    @IBOutlet weak var totalRateLabel: UILabel!
    @IBOutlet weak var totalRateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var labelInputText: UITextField!
    @IBOutlet weak var labelAddPartView: UIView!


    
    var additionalComment: AdditionalComment!
    
    var rateDropDown: DropDown!
    var rateList: [String] = ["5", "4", "3", "2", "1"]
    
    var labelListDropdown: DropDown!    
    var labelList: [String] = []
    var selectedLabelList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        
        // Edit Event
        labelInputText.addTarget(self, action: #selector(ResearchViewController.textFieldDidChange(_:)), for: .editingChanged)
        
        self.getLabelList()
        self.setupAllViews()
        self.setupRateListDropdown()

    }
    
    //MARK: - Setup All Views
    
    func setupAllViews () {
        
        self.titleText.text = ""
        self.contentText.text = ""
        self.businessNameLabel.text = additionalComment.businessName
        
        self.contentText.layer.borderWidth = 1
        self.contentText.layer.borderColor = UIColor.black.cgColor
        self.contentText.text = ""
        
        self.titleText.text = ""
    }
    
    func getLabelList() {
        
        if let userLabels = UserProfile.sharedInstance.userLabels {
            
            for userLabel in userLabels {
                self.labelList.append(userLabel.name!)
            }
        }
        
        self.setupLabelListDropdownMenu()
        
    }
    
    @IBAction func totalRateButtonAction(_ sender: Any) {
        self.rateDropDown.anchorView = self.totalRateLabel
        self.rateDropDown.selectionAction = {(index: Int, item: String) in
            
            self.additionalComment.rate = Int(item)
            self.totalRateLabel.text = item
            
        }
        rateDropDown.show()
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupRateListDropdown () {
        self.rateDropDown = DropDown(anchorView: totalRateButton)
        self.rateDropDown.dataSource = rateList
        self.rateDropDown.dismissMode = .onTap
        self.rateDropDown.bottomOffset = CGPoint(x: 0, y: totalRateButton.frame.size.height)
        self.rateDropDown.backgroundColor = UIColor.white
        self.rateDropDown.selectRow(at: 0)
        
        self.rateDropDown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
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
    
    @IBAction func facebookShareButtonAction(_ sender: Any) {

        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
//            
//            post?.setInitialText(business.name! + business.content!)
//            post?.add(businessImage.image)
//            post?.add(business.siteUrl)
            
            self.present(post!, animated: true, completion: nil)
        } else {
            self.showMessageError("Erreur", "You are not connected to Facebook")
        }

    }
    
    // MARK: - Label Add Part
    
    @IBAction func addLabelButtonAction(_ sender: Any) {
        
        if (self.labelInputText.text == ""){
            self.showMessageError("Erreur", "Please input label name.")
            return
        }

        
        if selectedLabelList.contains(self.labelInputText.text!){
            self.showMessageError("Erreur", "Please choose another label.")
            return
        }
        
        if !labelList.contains(self.labelInputText.text!){
            self.showMessageError("Erreur", "Please input correct label name.")
            return
        }
        
        let addtionanlLabel = AdditionalLabel()
        addtionanlLabel.name = self.labelInputText.text
        
        if let userLabels = UserProfile.sharedInstance.userLabels {
            
            for userLabel in userLabels {
                if userLabel.name == self.labelInputText.text{
                    addtionanlLabel.property = userLabel.property
                }
            }
        }
        self.selectedLabelList.append(self.labelInputText.text!)
        self.additionalComment.labels?.append(addtionanlLabel)
        self.labelInputText.text = ""
        
        tableView.reloadData()
        
    }
    
    func textFieldDidChange (_ textField: UITextField) {
        
        let keyString: String = textField.text!
        let filteredLabelList = labelList.filter{($0.lowercased().range(of: keyString) != nil)}
        self.labelListDropdown.dataSource = filteredLabelList
        labelListDropdown.show()
        
    }
    
    func setupLabelListDropdownMenu () {
        self.labelListDropdown = DropDown(anchorView: labelAddPartView)
        self.labelListDropdown.dataSource = self.labelList
        self.labelListDropdown.dismissMode = .onTap
        self.labelListDropdown.topOffset = CGPoint(x: 0, y: -self.labelAddPartView.frame.size.height)
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
            //            self.filterTransactionsWith(index)
        }
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           
        return (self.additionalComment.labels?.count)!
     
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let label = additionalComment.labels?[indexPath.row]
        var height: CGFloat!
        
        if label?.rate == 1 {
            height = 250
        } else {
            height = 70
        }
        
        return height
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentTableViewCell", for: indexPath as IndexPath) as! AddCommentTableViewCell
        
        let label = additionalComment.labels?[indexPath.row]
        
        cell.labelName.text = "[" + (label?.name!)! + "]"
        
        if label?.rate == 0 {
            cell.rateLabel.text = "-"
            cell.contentPartView.isHidden = true
        } else if (label?.rate)! > 1 {
            cell.rateLabel.text = String(describing: Int((label?.rate!)!))
            cell.contentPartView.isHidden = true
        }else {
            cell.rateLabel.text = "1"
            cell.contentPartView.isHidden = false
            cell.contentText.text = ""
            cell.titleText.text = ""
            cell.contentText.layer.borderColor = UIColor.black.cgColor
            cell.contentText.layer.borderWidth = 1
   
        }
        
        cell.rateButton.tag = indexPath.row
        cell.rateButton.addTarget(self, action: #selector(AddCommentViewController.ratingButtonTapped(_:)), for: .touchUpInside)
        
        cell.titleText.addTarget(self, action: #selector(AddCommentViewController.titleTextDidChanged(_:)), for: .editingChanged)
        cell.titleText.tag = indexPath.row
        
        cell.contentText.delegate = self
        cell.contentText.tag = indexPath.row
        
        
        
        return cell
    }
    
    // MARK: Button Action
    func ratingButtonTapped(_ button: UIButton) {
        
        let i = button.tag
        
        self.rateDropDown.anchorView = button
        
        self.rateDropDown.selectionAction = {(index: Int, item: String) in
            self.additionalComment.labels?[i].rate = Int(item)
            
            if let userLabels = UserProfile.sharedInstance.userLabels {
                
                for userLabel in userLabels {
                    if userLabel.name == self.additionalComment.labels?[i].name{
                        self.additionalComment.labels?[i].property = userLabel.property
                    }
                }
            }

            
            self.additionalComment.labels?[i].commentContent = ""
            self.additionalComment.labels?[i].commentTitle = ""
            self.tableView.reloadData()
            
        }
        
        self.rateDropDown.show()

    }
    
    func titleTextDidChanged(_ textField: UITextField){
        
        let index = textField.tag
        self.additionalComment.labels?[index].commentTitle = textField.text
    
        
    }
    
    func contentTextDidChanged(_ textField: UITextField){
        
        let index = textField.tag
        self.additionalComment.labels?[index].commentContent = textField.text
        
    }
    @IBAction func addCommentButtonAction(_ sender: Any) {
        
        print(self.additionalComment)
        
        additionalComment.commentTitle = titleText.text
        additionalComment.commentContent = contentText.text
        
        if additionalComment.commentTitle == "" {
            self.showMessageError("Erruer", "Please input the comment title.")
            return
        }
        
        if additionalComment.commentContent == "" {
            self.showMessageError("Erruer", "Please input the comment content.")
            return
        }
        
        if totalRateLabel.text == "-" {
            self.showMessageError("Erruer", "Please input the comment title.")
            return
        }
        
        additionalComment.rate = Int(totalRateLabel.text!)
        
        for label in additionalComment.labels! {
            if label.rate == 0{
                self.showMessageError("Erreur", "Please input labelrate")
                return
            } else if (label.rate == 1) && (label.commentTitle == "" || label.commentContent == ""){
                self.showMessageError("Erreur", "Please fill the blank text")
                return
            }
        }
        
        WebService.addComment(newComment: additionalComment) { (result, error) in
            
            if let _ = error {
                print("Error Found ---")
            }
            
            let status = result?["status"] as? Int
            
            if status == 1 {
                
              
                
                let _ = self.navigationController?.popViewController(animated: true)
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AddCommentSuccess"), object: nil)
                
            } else {
                self.showMessageError("Erreur", "Unfortunately your commment can't be updated.")
            }
            
        }
        
    }

}

extension AddCommentViewController: UITextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        let index = textView.tag
        self.additionalComment.labels?[index].commentContent = textView.text
    }
}
