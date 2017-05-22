//
//  SocialButtonTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class SocialButtonTableViewCell: UITableViewCell {

    @IBOutlet weak var facebookShareButtonAction: UIButton!
    @IBOutlet weak var twitterShareButtonAction: UIButton!
    @IBOutlet weak var linkedInShareButtonAction: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
