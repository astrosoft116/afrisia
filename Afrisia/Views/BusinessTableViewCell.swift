//
//  BusinessTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 4/18/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class BusinessTableViewCell: UITableViewCell {

    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var favoritStatusImage: UIImageView!
    @IBOutlet weak var businessRateLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var favoritChangeButtonAction: UIButton!
    
 

    @IBOutlet weak var locationLabel: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
