//
//  ContactViewController.swift
//  Afrisia
//
//  Created by mobile on 4/20/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class ContactViewController: BaseViewController {

    @IBOutlet weak var subjectTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var generalContact: GeneralContactModel = GeneralContactModel()
    var subjectType: SubjectType = SubjectType.general
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        descriptionTextView.layer.borderWidth = 1
        
    }


    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func sendContactButtonAction(_ sender: Any) {
        
        generalContact.name = self.usernameTextField.text!
        generalContact.email = self.userEmailTextField.text!
        generalContact.messageTitle = self.subjectTextField.text!
        generalContact.messageContent = self.descriptionTextView.text
        
        if generalContact.messageTitle == "" {
            self.showMessageError("Erreur" ,"Please input subject.")
            return
        }
        
        if generalContact.name == "" {
            self.showMessageError("Erreur", "Please input your name.")
            return
        }
        
        if generalContact.email == "" {
            self.showMessageError("Erreur" ,"Please input your email.")
            return
        }
        
        if CommonUtils.sharedInstance.isValidEmail(testStr: self.generalContact.email) == false {
            self.showMessageError("Erreur", "Please input correct email.")
            return
        }

        if generalContact.messageContent == "" {
            self.showMessageError("Erreur" ,"Please input message.")
            return
        }
        
        self.showAlertWith("Confirmation", message: "Do you want to send this message?", confirmAction: { (_) in
            print("yes")
            
            WebService.sendGeneralContact(generalContact: self.generalContact, completionBlock: { (result, error) in
                
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

        
    }
}
