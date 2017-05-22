//
//  BusinessTypeTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

protocol BusinessTypeTableViewCellDelegate {
    func updateBusinessType(_ businessTypeContact: BusinessTypeContactModel)
}

class BusinessTypeTableViewCell: UITableViewCell, UITextViewDelegate {

    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var businessTypeText: UITextField!
    @IBOutlet weak var businessTypePicture: UIImageView!
    @IBOutlet weak var cameraPartView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    
    var businessTypeContact: BusinessTypeContactModel = BusinessTypeContactModel()
    
    var delegate: BusinessTypeTableViewCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionTextView.layer.borderWidth = 1
        descriptionTextView.layer.borderColor = UIColor.black.cgColor
        
        businessTypeText.addTarget(self, action: #selector(BusinessTypeTableViewCell.textDidChanged(_:)), for: .editingChanged)
        
        descriptionTextView.delegate = self
        
        
       
        
    }
    
    func textDidChanged(_ textField: AnyObject){
        businessTypeContact.typeName = businessTypeText.text!
        self.delegate.updateBusinessType(businessTypeContact)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        //do continue your work
        businessTypeContact.typeDescription = descriptionTextView.text
        self.delegate.updateBusinessType(businessTypeContact)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
