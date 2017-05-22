//
//  GeneralContactTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/7/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class GeneralContactTableViewCell: UITableViewCell {

    @IBOutlet weak var descriptionText: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        descriptionText.layer.borderColor = UIColor.black.cgColor
        descriptionText.layer.borderWidth = 1
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
