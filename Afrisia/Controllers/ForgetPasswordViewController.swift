//
//  ForgetPasswordViewController.swift
//  Afrisia
//
//  Created by mobile on 5/9/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: BaseViewController {

    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

        // Do any additional setup after loading the view.
    }

    
    @IBAction func forgetButtonAction(_ sender: Any) {
        
        if emailTextField.text == "" {
            self.showMessageError("Erreur", "Please input your email.")
            return
        }
        
        if CommonUtils.sharedInstance.isValidEmail(testStr: emailTextField.text!) == false {
            self.showMessageError("Erreur", "Please correct email.")
            return
        }
        
        WebService.forgetPassword(email: emailTextField.text!) {(result, error) in
            
            if let _ = error {
                print("Error Found ---")
            }
            
            let status = result?["status"] as? Int
            
            if status == 1 {
                let _ = self.navigationController?.popViewController(animated: true)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ForgetPasswordSuccess"), object: nil)
                
            } else {
                self.showMessageError("Erreur", "Your eamil is not registered.")
            }
            
        }
        
        
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    



   

}
