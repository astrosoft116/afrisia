//
//  MyCommentTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class MyCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var circleImage: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
