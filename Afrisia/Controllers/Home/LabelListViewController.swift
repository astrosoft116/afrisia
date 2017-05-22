//
//  LabelListViewController.swift
//  Afrisia
//
//  Created by mobile on 4/26/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit


protocol LabelListViewControllerDelegate {
    func selectedLabel(_ labelName: String)
}


class LabelListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var labelList: [String] = []
    var choosedLabels: [String]!
    
    @IBOutlet weak var labelInputTxt: UITextField!
    @IBOutlet weak var tableview: UITableView!
    
    var delegate: LabelListViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.setupVariables()
        
        labelInputTxt.addTarget(self, action: #selector(LabelListViewController.textFieldDidChange(_:)), for: .editingChanged)
        
    }
    
    func setupVariables () {
        if let userLabels = UserProfile.sharedInstance.userLabels {
            for userLabel in userLabels {
                self.labelList.append(userLabel.name!)
            }

        }
        
        choosedLabels = labelList
    }
    
    func textFieldDidChange (_ textField: UITextField) {
        
        if textField.text == ""{
            
            self.choosedLabels = self.labelList
            
        } else if let keyString = textField.text?.lowercased(){
            
            let filteredLabels = labelList.filter{($0.lowercased().range(of: keyString) != nil)}
            self.choosedLabels = filteredLabels
        }
        
        tableview.reloadData()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
        
    }
    
    @IBAction func searchButtonAction(_ sender: Any) {
        
        // dismiss current view controller
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismiss(animated: false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismiss(animated: true, completion: nil)
            
            if let label = self.labelInputTxt.text {
                self.delegate?.selectedLabel(label)
            } else {
                self.delegate?.selectedLabel("")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let presentingViewController: UIViewController! = self.presentingViewController
        
        self.dismiss(animated: false) {
            // go back to MainMenuView as the eyes of the user
            presentingViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return choosedLabels.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelTableViewCell", for: indexPath as IndexPath) as! LabelTableViewCell
        
        cell.label.text = choosedLabels[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.labelInputTxt.text = choosedLabels[indexPath.row]
    }
}
