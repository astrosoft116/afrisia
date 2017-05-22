//
//  ProfileLabelTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 5/5/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class ProfileLabelTableViewCell: UITableViewCell {

    @IBOutlet weak var labelText: UITextField!
    @IBOutlet weak var propertyImage: UIImageView!
    @IBOutlet weak var propertyChangeButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
