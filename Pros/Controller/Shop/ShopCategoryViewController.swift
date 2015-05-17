//
//  ShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper

class ShopCategoryViewController: BaseViewController,
    UITableViewDelegate,
    UITableViewDataSource {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let prosAPIClient = ProsAPIClient()
    var activities = [ShopCategory]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
        customNavigationBar()
        customTableView()
        customPullToRefresh()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Categories")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 60.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        self.tableViewOutlet.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    func customPullToRefresh() -> Void {
        self.tableViewOutlet.addPullToRefresh({ [weak self] in
            self?.loadData()
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        NSOperationQueue().addOperationWithBlock({
            self.prosAPIClient.getCategoriesWithCompletion().responseJSON { (request, response, results, error) -> Void in
                if let shopCategory = Mapper<ShopCategory>().mapArray(results) {
                    self.activities = shopCategory
                    self.activities.insert(ShopCategory(shopType: "All", typeIconURL: nil), atIndex: 0)
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
            }
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopCategoryTableViewCell
        
        if let shopType = self.activities[indexPath.row].shopType {
            cell.shopTypeNameLabel.text = shopType
            cell.shopTypeImageView.image = UIImage(named: shopType)
        } else {
            cell.shopTypeNameLabel.text = "nil"
            cell.shopTypeImageView.image = UIImage(named: "00_icon_people")
        }
        
        return cell
    }
    
    // ------------------------------
    // MARK: -  
    // MARK: Table view deleagete
    // ------------------------------
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableViewOutlet.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToSubShopCategory" {
            println("[Segue] Category -> Sub shop category")
            
            if let indexPath = self.tableViewOutlet.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! SubShopCategoryViewController
                destinationController.shopTypeSegue = self.activities[indexPath.row].shopType
            }
        }
    }

}
