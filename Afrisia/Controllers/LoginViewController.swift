//
//  LoginViewController.swift
//  Afrisia
//
//  Created by mobile on 4/19/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))
        
        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tap)

    }
    
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passLabel: UITextField!

    
    // MARK: - Button Actions
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonAction(_ sender: Any) {
        
        let email = emailLabel.text
        let password = passLabel.text
        
        if email == "" {
            self.showMessageError("Erreur", "Please input your email.")
            return
        }
        
        if password == "" {
            self.showMessageError("Erreur", "Please input password.")
            return
        }
        
        if CommonUtils.sharedInstance.isValidEmail(testStr: email!) == false {
            self.showMessageError("Erreur", "Please input correct email.")
            return
        }
    
        self.showProgressHUD()
        
        WebService.userLogin(email: email!, password: password!) { (result, error) in
            
            self.hideProgressHUD()
            
            if let _ = error {
                print("Error Found ---")
            }
            
            let status = result?["status"] as? Int
            
            if status == 1 {
                
                let currentUser = result?["current_user"] as? [String: AnyObject]
                UserProfile.sharedInstance.currentUser = UserModel(currentUser!)
                UserProfile.sharedInstance.currentUser?.password = self.passLabel.text!
                UserProfile.sharedInstance.saveUserInfomation()
                

                print((UserProfile.sharedInstance.currentUser?.id)!)

                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoginChanged"), object: nil)
                
                let _ = self.navigationController?.popViewController(animated: true)
                
            } else {
                
                self.showMessageError("Erreur", "Email and password do not match.")
            }

        }

    }
    
    
    
    
    @IBAction func forgetPasswordButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let forgetPasswordViewController = storyboard.instantiateViewController(withIdentifier: "ForgetPasswordViewController") as! ForgetPasswordViewController
        
      
        self.navigationController?.pushViewController(forgetPasswordViewController, animated: true)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
   
}
