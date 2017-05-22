//
//  FaqDetailViewController.swift
//  Afrisia
//
//  Created by mobile on 5/6/17.
//  Copyright © 2017 Mobile Star. All rights reserved.
//

import UIKit

class FaqDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var faqTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var faqType: Int!
    var filename: String = String()
    
    
    fileprivate lazy var sizingCell : ExpandableTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier:"CellID") as? ExpandableTableViewCell else{
            preconditionFailure("reusable cell not found")
        }
        return cell
    } ()
    
    open var dataSourceArray = [ItemModel]()
    
    var expandedIndexPaths : [IndexPath] = [IndexPath]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        tableView.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "CellID")
        
        if faqType == 0 {
            filename = "start"
            faqTitleLabel.text = "Pour commencer..."
            
        }
        if faqType == 1 {
            filename = "research"
            faqTitleLabel.text = "Les recherches..."
            
        }
        if faqType == 2 {
            filename = "account"
            faqTitleLabel.text = "Mon compte..."
            
        }
        
        let path = NSURL.fileURL(withPath: Bundle.main.path(forResource: filename, ofType: "json")!)
        let data = try! Data(contentsOf: path, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String:String]]
        let dataSource = json.map({return ItemModel(question: $0["Question"]!, answer: $0["Answer"]!)})
       
        
        dataSourceArray = dataSource
    }

    @IBAction func dismissButtonAction(_ sender: Any) {
        
        let _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    //MARK: table view datasource
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : ExpandableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? ExpandableTableViewCell else {
            preconditionFailure("reusable cell not found")
        }
        let item = self.dataSourceArray[(indexPath as NSIndexPath).row]
        cell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension
        } else {
            return self.dynamicCellHeight(indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dynamicCellHeight(indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        
    }
    
    //MARK: table view delegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.expandedIndexPaths.contains(indexPath)) {
            let idx = self.expandedIndexPaths.index(of: indexPath)
            self.expandedIndexPaths.remove(at: idx!)
        } else {
            self.expandedIndexPaths.append(indexPath)
        }
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    
    //MARK: compute cell height
    
    fileprivate func dynamicCellHeight(_ indexPath:IndexPath)->CGFloat {
        
        let item = self.dataSourceArray[(indexPath as NSIndexPath).row]
        sizingCell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        sizingCell.setNeedsUpdateConstraints()
        sizingCell.updateConstraintsIfNeeded()
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        return sizingCell.cellContentHeight()
    }


}
