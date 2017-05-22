//
//  MyCommentViewController.swift
//  Afrisia
//
//  Created by mobile on 4/24/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class MyCommentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!

    var businessArray: [BusinessModel] = [BusinessModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.getMyComments()
    }

    func getMyComments () {
        
        let userId = UserProfile.sharedInstance.getUserId()
        
        
        self.showProgressHUD()
        
        self.businessArray.removeAll()
        
        WebService.getMyComments(userId: userId!) { (result, error) in
            self.hideProgressHUD()
            
            if let _ = error {
                print("Error Found ---")
            }
            
            if let results = result?["result"] as? [[String: AnyObject?]] {
                for business in results {
                    self.businessArray.append(BusinessModel(business))
                }
                self.tableView.reloadData()

            }
            
            
        
            
            
        }
        
        
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return businessArray.count
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 320
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
        
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCommentTableViewCell", for: indexPath as IndexPath) as! MyCommentTableViewCell
        
        
        cell.businessImage.af_setImage(withURL: self.businessArray[indexPath.row].photoUrl!)
        cell.businessImage.clipsToBounds = true
        cell.businessNameLabel.text = self.businessArray[indexPath.row].name?.trimmingCharacters(in: .whitespaces)
        cell.businessTypeLabel.text = "[" + self.businessArray[indexPath.row].type! + "]"
        cell.locationLabel.text = self.businessArray[indexPath.row].city
        
       
        var count = self.businessArray[indexPath.row].labelDetails.count
        count = (count > 4) ? 4 : count
        if count > 0 {
            let labelDetails = self.businessArray[indexPath.row].labelDetails
            
            for i in  0 ... count - 1 {
                cell.labels[i].text = "[" + labelDetails[i].name! + "]"
                cell.labels[i].textColor = CommonUtils.sharedInstance.setRateColor(rate: labelDetails[i].averageRate)
                
                if i == 3 {
                    cell.labels[i].text = "[...]"
                }
            }
        }
        
        if count < 4 {
            for i in count ... 3 {
                cell.labels[i].text = ""
            }
        }

        
        // Comment part
        let businessComment = businessArray[indexPath.row].myComments[0]
        
        cell.userImage.af_setImage(withURL: businessComment.userPhotoUrl!)
        cell.userNameLabel.text = businessComment.userName
        cell.titleLabel.text = businessComment.title
        cell.contentLabel.text = businessComment.content
        
        cell.userImage.layer.masksToBounds = false
        cell.userImage.layer.cornerRadius = cell.userImage.frame.size.height/2
        cell.userImage.layer.frame.size.width = cell.userImage.frame.size.height
        cell.userImage.clipsToBounds = true
        
        let rate = businessComment.rateScore
        cell.rateLabel.text = String(describing: Float(rate!))
        cell.dateLabel.text = businessComment.date
        
        
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: cell.circleImage.frame.size.width/2 ,y: cell.circleImage.frame.size.height/2 ), radius: CGFloat((cell.circleImage.frame.size.height/2)), startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        //change the fill color
        shapeLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        shapeLayer.strokeColor = CommonUtils.sharedInstance.UIColorFromRGB(rgbValue: 0x44A654).cgColor
        //you can change the line width
        shapeLayer.lineWidth = 2.0
        
        cell.circleImage.layer.addSublayer(shapeLayer)

        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessDetailViewController = storyboard.instantiateViewController(withIdentifier: "BusinessDetailViewController") as! BusinessDetailViewController
        
        businessDetailViewController.business = businessArray[indexPath.row]
        self.navigationController?.pushViewController(businessDetailViewController, animated: true)
    }



}
