//
//  AboutViewController.swift
//  Afrisia
//
//  Created by mobile on 4/19/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}
