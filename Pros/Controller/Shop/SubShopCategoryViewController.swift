//
//  SubShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import ObjectMapper
import ImageLoader

class SubShopCategoryViewController: BaseViewController,
    UITableViewDelegate,
    UITableViewDataSource {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    let prosAPIClient = ProsAPIClient()
    var shopTypeSegue: String!
    var activities = [SubShopCategory]()
    var imageCache = [String: UIImage]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData(Utilities.percentEncodingWithUrl(self.shopTypeSegue))
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
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar(self.shopTypeSegue)
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
            self?.loadData(Utilities.percentEncodingWithUrl(self!.shopTypeSegue))
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData(parameter: String!) -> Void {
        if (parameter == "All") {
            self.prosAPIClient.getSubCategoriesWithCompletion().responseJSON { (request, response, results, error) -> Void in
                if let subShopCategory = Mapper<SubShopCategory>().mapArray(results) {
                    self.activities = subShopCategory
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
            }
        } else {
            self.prosAPIClient.getSubCategoriesByTypeWithCompletion(parameter).responseJSON { (request, response, results, error) -> Void in
                if let subShopCategory = Mapper<SubShopCategory>().mapArray(results) {
                    self.activities = subShopCategory
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
                
            }
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! SubShopCategoryTableViewCell
        
        if let title = self.activities[indexPath.row].title {
            cell.shopNameLabel.text = title
        } else {
            cell.shopNameLabel.text = "nil"
        }
        
        if let type = self.activities[indexPath.row].type {
            cell.shopTypeNameLabel.text = type
        } else {
            cell.shopTypeNameLabel.text = "nil"
        }
        
        let placeholder = UIImage(named: "00_icon_people")!
        if let activitiyShopLogoImageUrl = self.activities[indexPath.row].logoImageUrl {
            let URL: NSURL = NSURL(string: activitiyShopLogoImageUrl)!
            cell.shopLogoImageView?.load(URL, placeholder: placeholder)
        } else {
            cell.shopLogoImageView.image = placeholder
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
        
        if segue.identifier == "SegueToShop" {
            println("[Segue] Sub shop category -> Shop")
            if let indexPath = self.tableViewOutlet.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as! ShopViewController
                destinationController.subShopCategorySegue = self.activities[indexPath.row]
            }
        }
    }

}
