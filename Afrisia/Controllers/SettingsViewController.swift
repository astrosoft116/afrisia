//
//  SettingsViewController.swift
//  Afrisia
//
//  Created by mobile on 5/11/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import DropDown

class SettingsViewController: UIViewController {

    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var startValueLabel: UILabel!
    @IBOutlet weak var endValueLabel: UILabel!
    @IBOutlet weak var currentValueLabel: UILabel!
    @IBOutlet weak var currentResultNumLabel: UILabel!
    @IBOutlet weak var numberPartView: UIView!
    
    var numberDropdown: DropDown!
    var numberArray: [String] = [
        "5",
        "10",
        "15",
        "20",
        "25",
        "30",
        "35",
        "40",
        "45",
        "50"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let userDefault = UserDefaults.standard
        let currendDistance = userDefault.value(forKey: UserAuth.searchDistance) as? Float
        
        distanceSlider.value = currendDistance!
        currentValueLabel.text = String(Int(currendDistance!)) + "km"
        
        
        if let currentResultCount = userDefault.value(forKey: UserAuth.resultCount)  {
            currentResultNumLabel.text = String(describing: currentResultCount)
        }

        
        self.setupNubmerDropdown()
    }
    
    func setupNubmerDropdown() {
        self.numberDropdown = DropDown(anchorView: numberPartView)
        self.numberDropdown.dataSource = numberArray
        self.numberDropdown.dismissMode = .onTap
        self.numberDropdown.bottomOffset = CGPoint(x: 0, y: self.numberPartView.frame.size.height)
        self.numberDropdown.backgroundColor = UIColor.white
        self.numberDropdown.selectRow(at: 0)
        
        self.numberDropdown.customCellConfiguration = { (index: Index, item: String, cell: DropDownCell) -> Void in
            
            cell.optionLabel.textColor = UIColor.black
            cell.optionLabel.font = UIFont(name: "Arial-BoldMT", size: 17)
            cell.optionLabel.contentMode = .center
        }
        
        self.numberDropdown.selectionAction = {(index: Int, item: String) in
            self.currentResultNumLabel.text = item

            
            
        }
        
    }
    
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func distanceValueChaged(_ sender: Any) {
        
        currentValueLabel.text = String(Int(distanceSlider.value)) + "km"
        
    }
    @IBAction func setResultNumberButtonAction(_ sender: Any) {
        
        numberDropdown.show()
    }
    @IBAction func updateValueButtonAction(_ sender: Any) {
        
        let userDefault = UserDefaults.standard
        userDefault.set(Int(self.currentResultNumLabel.text!),forKey: UserAuth.resultCount)
        userDefault.set(Int(distanceSlider.value), forKey: UserAuth.searchDistance)
        userDefault.synchronize()
        
        let _ = self.navigationController?.popViewController(animated: true)
    }
    
}
