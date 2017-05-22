//
//  BusinessDetailViewController.swift
//  Afrisia
//
//  Created by mobile on 4/21/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import Social

class BusinessDetailViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var detailHeaderView: UIView!
    @IBOutlet weak var businessImage: UIImageView!
    @IBOutlet weak var businessTypeLabel: UILabel!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var favoritStatusIcon: UIImageView!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var commentNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var contactButtonPartView: UIView!
    @IBOutlet weak var websiteButtonView: UIView!

    
    var additionalComment: AdditionalComment = AdditionalComment()

    
    var business: BusinessModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableHeaderView = detailHeaderView
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addCommentSuccess), name: NSNotification.Name(rawValue: "AddCommentSuccess"), object: nil)
        
        self.setupAllViews()
        
    }
    
    func addCommentSuccess (){
        self.showMessageError("Success", "Your comment was updated successfully.")
    }
    
    func setupAllViews() {
        businessNameLabel.text = business.name
        businessImage.af_setImage(withURL: business.photoUrl!)
        businessTypeLabel.text = "[" + business.type! + "]"
        
        if business.phoneNumber == "" {
            contactButtonPartView.isHidden = true
        }
        
        if business.siteUrl == URL(string: ""){
            websiteButtonView.isHidden = true
        }

        
        var count = business.labelDetails.count
        count = (count > 4) ? 4 : count
        if count > 0 {
            let labelDetails = business.labelDetails
            
            for i in  0 ... count - 1 {
                labels[i].text = "[" + labelDetails[i].name! + "]"
                labels[i].textColor = CommonUtils.sharedInstance.setRateColor(rate: labelDetails[i].averageRate)
                
                if i == 3 {
                    labels[i].text = "[...]"
                }
            }
        }
        
        if count < 4 {
            for i in count ... 3 {
                labels[i].text = ""
            }
        }       
        
        if business.isFavorite {
            favoritStatusIcon.image = AfrisiaImage.favoritIcon.image
        }
        
        commentCountLabel.text = String(business.comments.count)
        
        if business.comments.count > 1 {
            commentNameLabel.text = "comments"
        } else {
            commentNameLabel.text = "comment"
        }
        
        rateLabel.text = String(business.rateScore as Float)
    
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        
        return label.frame.height
    }
    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    @IBAction func visitSiteButtonAction(_ sender: Any) {
        
         UIApplication.shared.openURL(business.siteUrl!)
    }

    @IBAction func callBusinessButtonAction(_ sender: Any) {
        if  let url = NSURL(string: "tel://\(business.phoneNumber)"), UIApplication.shared.canOpenURL(url as URL) {
            
        }
    }
    
    
    @IBAction func showCommentViewButtonAction(_ sender: Any) {
        
        if UserProfile.sharedInstance.isLoggedIn() {
            self.additionalComment.businessId = business.id
            self.additionalComment.businessName = business.name
            self.additionalComment.userId = UserProfile.sharedInstance.getUserId()
            
            self.additionalComment.labels?.removeAll()
            
            for label in business.labelDetails {
                let addtionanlLabel = AdditionalLabel()
                addtionanlLabel.name = label.name
                
                self.additionalComment.labels?.append(addtionanlLabel)
            }
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let showAddCommentViewController = storyboard.instantiateViewController(withIdentifier: "AddCommentViewController") as! AddCommentViewController
            
            showAddCommentViewController.additionalComment = self.additionalComment
            
            self.navigationController?.pushViewController(showAddCommentViewController, animated: true)
            
        }
        
    }
    
    @IBAction func facebookShareButtonAction(_ sender: Any) {
        
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook){
            let post = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            

            post?.setInitialText(business.name! + business.content!)
            post?.add(businessImage.image)
            post?.add(business.siteUrl)
            
            self.present(post!, animated: true, completion: nil)
        } else {
            self.showMessageError("Erreur", "You are not connected to Facebook")
        }
    }
    @IBAction func twitterShareButtonAction(_ sender: Any) {
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter){
            let post = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            
            post?.setInitialText(business.name! + business.content!)
            post?.add(businessImage.image)
            post?.add(business.siteUrl)
            
            self.present(post!, animated: true, completion: nil)
        } else {
            self.showMessageError("Erreur", "You are not connected to Twitter.")
        }
    }
    @IBAction func showMapViewButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let businessDetailMapViewController = storyboard.instantiateViewController(withIdentifier: "BusinessDetailMapViewController") as! BusinessDetailMapViewController
        
        businessDetailMapViewController.business = self.business
        
        self.navigationController?.pushViewController(businessDetailMapViewController, animated: true)
    }
    
    //MARK: - TableView Part
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 1
        case 1:
            
            let count = business.labelDetails.count
            
            return count
        case 2:
            return 1
        case 3:
            
            let count = business.comments.count
            return count
        default:
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            let bounds = UIScreen.main.bounds
            let widthOfScreen = bounds.size.width * 0.8
            
            let font = UIFont(name: "Helvetica", size: 14.0)
            
            let height = heightForView(text: business.content!, font: font!, width: widthOfScreen) + 40

            return height
        case 1:
            return 30
        case 2:
            return 225
        case 3:
            return 250
            
        default:
            return 0
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDescriptionTableViewCell", for: indexPath as IndexPath) as! BusinessDescriptionTableViewCell
            
            cell.businessDescriptionNameLabel.text = business.name
            cell.businessDescriptionLabel.text = business.content
            
            let font = UIFont(name: "Helvetica", size: 14.0)

            cell.businessDescriptionLabel.font = font
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "LabelVoteNumberTableViewCell", for: indexPath as IndexPath) as! LabelVoteNumberTableViewCell
            
            cell.labelName.text = "[" + business.labelDetails[indexPath.row].name! + "]"
            
            cell.labelName.textColor = CommonUtils.sharedInstance.setRateColor(rate: business.labelDetails[indexPath.row].averageRate)
            
            if business.labelDetails[indexPath.row].numVote > 1 {
                cell.voteCount.text = "- " + String(business.labelDetails[indexPath.row].numVote) + "  votes"
            } else {
                cell.voteCount.text = "- " + String(business.labelDetails[indexPath.row].numVote) + "  vote"
            }
            
            let average = business.labelDetails[indexPath.row].averageRate
            let roundedAverage = (average * 10).rounded(.toNearestOrAwayFromZero)/10
            
            cell.rateScore.text = String(roundedAverage)
            cell.rateScore.textColor = CommonUtils.sharedInstance.setRateColor(rate: business.labelDetails[indexPath.row].averageRate)
            
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "SocialButtonTableViewCell", for: indexPath as IndexPath) as! SocialButtonTableViewCell
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessCommentTableViewCell", for: indexPath as IndexPath) as! BusinessCommentTableViewCell
            
            cell.userNameLabel.text = business.comments[indexPath.row].userName
            cell.dateLabel.text = business.comments[indexPath.row].date
            cell.commentTitleLabel.text = business.comments[indexPath.row].title
            cell.commentContentLabel.text = business.comments[indexPath.row].content
            cell.commentRateLabel.text = String(business.comments[indexPath.row].rateScore!)
            
            cell.comentContainerView.layer.borderColor = UIColor.lightGray.cgColor
            cell.comentContainerView.layer.borderWidth = 1
            
            for label in cell.labels {
                label.text = ""
            }
            
            for i in 0...business.comments[indexPath.row].labels.count - 1 {
                cell.labels[i].text = "[" + business.comments[indexPath.row].labels[i].name! + "]"
            }
            
            cell.userImage.af_setImage(withURL: business.comments[indexPath.row].userPhotoUrl!)
            
            
            
            
            
        
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessDescriptionTableViewCell", for: indexPath as IndexPath) as! BusinessDescriptionTableViewCell
            return cell
        }
        
    }


}
