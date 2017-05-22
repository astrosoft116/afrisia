//
//  SideMenuTableViewController.swift
//  Afrisia
//
//  Created by mobile on 4/19/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit
import SWRevealViewController
import AlamofireImage

class SideMenuTableViewController: UITableViewController {

   
    
    @IBOutlet weak var beforeLoginView: UIView!
    @IBOutlet weak var afterLoginView: UIView!
    
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var businessCountLabel: UILabel!
    @IBOutlet weak var commentsCountLabel: UILabel!
    @IBOutlet weak var favoritCountLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var profileEditImage: UIImageView!
    
    var currentUser: UserModel = UserModel()

    
    
    var isLogin: Bool = false
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        

        
        self.setupViews()
        
    }
    
    func setupViews (){
        
        
        isLogin = UserProfile.sharedInstance.isLoggedIn()
        
        if isLogin {
            self.currentUser = UserProfile.sharedInstance.currentUser!
            
            beforeLoginView.isHidden = true
            afterLoginView.isHidden = false
            logoutButton.isHidden = false
            profileEditImage.isHidden = false
            
            userImage.af_setImage(withURL: (self.currentUser.photoURL))
            userNameLabel.text = UserProfile.sharedInstance.currentUser?.name
            businessCountLabel.text = "(" + (UserProfile.sharedInstance.currentUser?.businessCount)! + ")"
            commentsCountLabel.text = "(" + (UserProfile.sharedInstance.currentUser?.commentCount)! + ")"
            favoritCountLabel.text = "(" + (UserProfile.sharedInstance.currentUser?.favoritCount)! + ")"
            
        } else {
            
            beforeLoginView.isHidden = false
            afterLoginView.isHidden = true
            logoutButton.isHidden = true
            profileEditImage.isHidden = true
                        
            userNameLabel.text = "PSUEDO"
            userImage.image = AfrisiaImage.defaultAvatar.image
            
        }
        
        userImage.layer.masksToBounds = false
        userImage.layer.cornerRadius = userImage.frame.size.height/2
        userImage.layer.frame.size.width = userImage.frame.size.height
        userImage.clipsToBounds = true
       
        
    }
    
    @IBAction func profileEditButtonAction(_ sender: Any) {
        
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let profileUpdateViewController = storyboard.instantiateViewController(withIdentifier: "ProfileUpdateViewController")
        self.revealViewController().navigationController?.pushViewController(profileUpdateViewController, animated: true)

    }
    @IBAction func logoutButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        UserProfile.sharedInstance.removeUserInformation()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoginChanged"), object: nil)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupViews()
        
    }
    @IBAction func contactButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        if UserProfile.sharedInstance.isLoggedIn() {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contactViewController = storyboard.instantiateViewController(withIdentifier: "ContactDetailViewController")
            self.revealViewController().navigationController?.pushViewController(contactViewController, animated: true)
            
        } else {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let contactViewController = storyboard.instantiateViewController(withIdentifier: "ContactViewController")
            self.revealViewController().navigationController?.pushViewController(contactViewController, animated: true)
            
        }
        
        
    }
    @IBAction func showMyBusinessButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactViewController = storyboard.instantiateViewController(withIdentifier: "MyBusinessViewController")
        self.revealViewController().navigationController?.pushViewController(contactViewController, animated: true)
    }
    @IBAction func showMyCommentButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactViewController = storyboard.instantiateViewController(withIdentifier: "MyCommentViewController")
        self.revealViewController().navigationController?.pushViewController(contactViewController, animated: true)
    }
    @IBAction func showMyFavoritButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let contactViewController = storyboard.instantiateViewController(withIdentifier: "MyFavoritViewController")
        self.revealViewController().navigationController?.pushViewController(contactViewController, animated: true)
    }
    @IBAction func registerButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let registerViewController = storyboard.instantiateViewController(withIdentifier: "RegisterViewController")
        self.revealViewController().navigationController?.pushViewController(registerViewController, animated: true)

    }

    @IBAction func loginButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.revealViewController().navigationController?.pushViewController(loginViewController, animated: true)
    }
    
    @IBAction func faqMenuButtonAction(_ sender: Any) {
        self.revealViewController().revealToggle(animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let FaqMenuViewController = storyboard.instantiateViewController(withIdentifier: "FaqMenuViewController")
        self.revealViewController().navigationController?.pushViewController(FaqMenuViewController, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return tableView.frame.size.height / 3.0
        } else if indexPath.row == 1{
            return 184
        } else {
            return tableView.frame.size.height * 2.0 / 3.0 - 204
        }
    }
}
