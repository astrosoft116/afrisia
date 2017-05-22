//
//  BaseViewController.swift
//  Afrisia
//
//  Created by mobile on 4/29/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import MBProgressHUD

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    func showProgressHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideProgressHUD() {
        
        DispatchQueue.main.async { 
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    func showMessageError(_ title: String? = "Error", _ errorMessage: String) {
        let alertController = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    func showAlertWith(_  title: String? = nil, message: String, confirmAction:@escaping ((UIAlertAction) -> Void)) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "OK", style: .default, handler: confirmAction)
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    
}
