//
//  BusinessCommentTableViewCell.swift
//  Afrisia
//
//  Created by mobile on 4/25/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class BusinessCommentTableViewCell: UITableViewCell {
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var commentTitleLabel: UILabel!
    @IBOutlet weak var commentContentLabel: UILabel!
    @IBOutlet weak var commentRateLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var userImage: UIImageView!

    @IBOutlet weak var comentContainerView: UIView!
    @IBOutlet weak var circleImage: UIImageView!
    
    let shapeLayer = CAShapeLayer()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: circleImage.frame.size.width/2 ,y: circleImage.frame.size.height/2 ), radius: CGFloat((circleImage.frame.size.height/2)), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = CommonUtils.sharedInstance.UIColorFromRGB(rgbValue: 0x44A654).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 2.0
        
        circleImage.layer.addSublayer(shapeLayer)
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        
        userImage.clipsToBounds = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
