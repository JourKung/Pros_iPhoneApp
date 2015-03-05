//
//  SubShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class SubShopCategoryViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var dummyActivities: [String]! = [String]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
        loadData()
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
    
    private func customUI() -> Void {
        customNavigationBar()
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame:CGRectZero)
        self.tableViewOutlet.backgroundColor = UIColor.groupTableViewBackgroundColor()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Shop title")
//        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.Plain, target: nil, action: nil)
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func loadData() -> Void {
        self.dummyActivities = ["Alice", "Bob", "Eve", "Carlos", "Fern", "Gun"]
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
        return self.dummyActivities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as SubShopCategoryTableViewCell
        
        cell.title.text = self.dummyActivities[indexPath.row]
        cell.type.text = "Something content ...."
        cell.logoImageView.image = UIImage(named: "00_logoDummy")
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "Segue") {
            let shopVC = segue.destinationViewController as? ShopViewController
            let indexPath = self.tableViewOutlet.indexPathForSelectedRow()
        }
    }
    

}
