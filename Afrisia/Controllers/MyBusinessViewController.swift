//
//  MyBusinessViewController.swift
//  Afrisia
//
//  Created by mobile on 4/24/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class MyBusinessViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var businessArray: [BusinessModel] = [BusinessModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.getMyBusinessList()
    }
    
    func getMyBusinessList () {
        
        let userId = UserProfile.sharedInstance.getUserId()
        
        
        self.showProgressHUD()
        
        self.businessArray.removeAll()
        
        WebService.getMyBusinessList(userId: userId!) { (result, error) in
            self.hideProgressHUD()
            
            if let _ = error {
                print("Error Found ---")
            }
            
            if let results = result?["result"] as? [[String: AnyObject?]] {
                for business in results {
                    self.businessArray.append(BusinessModel(business))
                }
            }
            
            self.tableView.reloadData()
            

        }

        
    }


    
    @IBAction func dismissButtonAction(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }

    @IBAction func showMyBusinessButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addBusinessViewController = storyboard.instantiateViewController(withIdentifier: "AddBusinessViewController")
        self.navigationController?.pushViewController(addBusinessViewController, animated: true)
    }

    // MARK - Tableview Part
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return businessArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath as IndexPath) as! BusinessTableViewCell
        
        
        cell.businessImage.af_setImage(withURL: self.businessArray[indexPath.row].photoUrl!)
        cell.businessImage.contentMode = .scaleAspectFill
        cell.businessImage.clipsToBounds = true
        cell.businessNameLabel.text = self.businessArray[indexPath.row].name?.trimmingCharacters(in: .whitespaces)
        cell.businessTypeLabel.text = "[" + self.businessArray[indexPath.row].type! + "]"
        cell.locationLabel.text = self.businessArray[indexPath.row].city
        
        let rate = self.businessArray[indexPath.row].rateScore
        if Int(rate) > 0 {
            cell.businessRateLabel.text = String(describing: self.businessArray[indexPath.row].rateScore)
            
        } else {
            cell.businessRateLabel.text = "-"
        }
        
        if businessArray[indexPath.row].isFavorite {
            cell.favoritStatusImage.image = AfrisiaImage.favoritIcon.image
        } else {
            cell.favoritStatusImage.image = AfrisiaImage.unfavoritIcon.image
        }
        
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
