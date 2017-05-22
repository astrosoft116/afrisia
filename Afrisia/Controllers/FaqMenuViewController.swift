//
//  FaqMenuViewController.swift
//  Afrisia
//
//  Created by mobile on 4/20/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class FaqMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func startFaqButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let startFaqViewController = storyboard.instantiateViewController(withIdentifier: "FaqDetailViewController") as? FaqDetailViewController
        startFaqViewController?.faqType = 0
        self.navigationController?.pushViewController(startFaqViewController!, animated: true)

    }

    @IBAction func researchFaqButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let researchFaqViewController = storyboard.instantiateViewController(withIdentifier: "FaqDetailViewController") as? FaqDetailViewController
        researchFaqViewController?.faqType = 1
        self.navigationController?.pushViewController(researchFaqViewController!, animated: true)
        
    }
   
    @IBAction func accountFaqButtonAction(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let accountFaqViewController = storyboard.instantiateViewController(withIdentifier: "FaqDetailViewController") as? FaqDetailViewController
        accountFaqViewController?.faqType = 2
        self.navigationController?.pushViewController(accountFaqViewController!, animated: true)

    }
}
