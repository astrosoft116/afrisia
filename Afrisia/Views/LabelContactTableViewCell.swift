//
//  LabelContactTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

protocol LabelContactTableViewCellDelegate {
    func updateLabel(_ labelContact: LabelContactModel)
}

class LabelContactTableViewCell: UITableViewCell {
    
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var labelInputText: UITextField!
    
    var delegate: LabelContactTableViewCellDelegate?
    
    var label: LabelContactModel = LabelContactModel()
    var isPrivate: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        labelInputText.addTarget(self, action: #selector(LabelContactTableViewCell.textDidChanged(_:)), for: .editingChanged)
        
    }
    
    func textDidChanged(_ textField: UITextField){
        self.updateLabelModel()
    }
    
    func updateLabelModel(){
        label.labelName = labelInputText.text!
        label.labelProperty = isPrivate
        
        self.delegate?.updateLabel(label)
    }

    @IBAction func changeLabelPropertyButtonAction(_ sender: Any) {
        
        if isPrivate {
            propertyImage.image = #imageLiteral(resourceName: "public")
            isPrivate = false
        } else {
            propertyImage.image = #imageLiteral(resourceName: "secrect")
            isPrivate = true
        }
        
        self.updateLabelModel()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
