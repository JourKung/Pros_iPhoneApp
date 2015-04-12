//
//  ShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class ShopCategoryViewController: BaseTableViewController {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var activities: [ShopCategory]! = [ShopCategory]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
        customUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refreshControl?.addTarget(self, action: "loadData", forControlEvents: .ValueChanged)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Categories")
        navigationItem.backBarButtonItem = Utilities.previousBackBarButtonItemOnNavigationBar()
    }
    
    private func customTableView() -> Void {
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        tableView.separatorColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        tableView.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        if self.prosAPIClient?.getCategoriesWithCompletion() == nil {
            return
        }
        
        refreshControl?.beginRefreshing()
//        let start = CACurrentMediaTime()
        
        self.prosAPIClient?.getCategoriesWithCompletion().responseJSON { (request, reponse, results, error) -> Void in
//            let end = CACurrentMediaTime()
            
            if let categories = results?.objectForKey("shopType") as? [String] {
                self.activities = [ShopCategory]()
                for type in categories {
                    self.activities.append(ShopCategory(objectId: nil, createdAt: nil, updatedAt: nil, type: type))
                }
                self.activities.insert(ShopCategory(objectId: nil, createdAt: nil, updatedAt: nil, type: "All"), atIndex: 0)
            }
            
            self.tableView.reloadData()
            self.refreshControl?.endRefreshing()
        }
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    private let cellIdentifier = "Cell"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! ShopCategoryTableViewCell
        
        let activity = self.activities[indexPath.row]
        cell.typeLabel.text = activity.type
        cell.typeImageView.image = UIImage(named: activity.type)
        
        return cell
    }
    
    // ------------------------------
    // MARK: -  
    // MARK: Table view deleagete
    // ------------------------------
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "SegueToSubShopCategory" {
            println("[Segue] Category -> Sub shop category")
            
            if let indexPath = tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! SubShopCategoryViewController
                destinationController.shopCategorySegue = self.activities[indexPath.row]
            }
        }
    }

}
