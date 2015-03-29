//
//  SubShopCategoryViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class SubShopCategoryViewController: BaseTableViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var shopCategorySegue: ShopCategory!
    var activities: [SubShopCategory]! = [SubShopCategory]()
    var imageCache = [String: UIImage]()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        loadData(self.shopCategorySegue?.type)
        customUI()
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
    
    func customUI() -> Void {
        customNavigationBar()
        customTableView()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar(self.shopCategorySegue?.type)
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
    
    func loadData(parameter: String!) -> Void {
        if (parameter == "All") {
            if self.prosAPIClient?.getSubCategoriesWithCompletion() == nil {
                return
            }
            
            refreshControl?.beginRefreshing()
            
            self.prosAPIClient?.getSubCategoriesWithCompletion().responseJSON { (request, reponse, results, error) -> Void in
                
                if let subShopCategories: AnyObject = results {
                    self.activities = [SubShopCategory]()
                    
                    for subShopCategory in subShopCategories as [AnyObject] {
                        let tmpURL = subShopCategory.objectForKey("UserLogoImageUrl") as String
                        self.activities.append(SubShopCategory(type: subShopCategory.objectForKey("shopType") as String
                            , shopId: subShopCategory.objectForKey("id") as String
                            , title: subShopCategory.objectForKey("name") as String
                            , logoImageUrl: tmpURL))
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        } else {
            if self.prosAPIClient?.getSubCategoriesByTypeWithCompletion(parameter) == nil {
                return
            }
            
            refreshControl?.beginRefreshing()
            
            self.prosAPIClient?.getSubCategoriesByTypeWithCompletion(parameter).responseJSON { (request, reponse, results, error) -> Void in
                
                if let subShopCategories: AnyObject = results {
                    self.activities = [SubShopCategory]()
                    
                    for subShopCategory in subShopCategories as [AnyObject] {
                        let tmpURL = subShopCategory.objectForKey("UserLogoImageUrl") as String
                        self.activities.append(SubShopCategory(type: subShopCategory.objectForKey("shopType") as String
                            , shopId: subShopCategory.objectForKey("id") as String
                            , title: subShopCategory.objectForKey("name") as String
                            , logoImageUrl: tmpURL))
                    }
                }
                
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
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
    
    private let cellIdentifier       = "Cell"
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as SubShopCategoryTableViewCell
        
        cell.titleLabel.text = self.activities[indexPath.row].title
        cell.typeLabel.text = self.activities[indexPath.row].type
        
        let tmpURL = Utilities.cleanUrl(self.activities[indexPath.row].logoImageUrl)
        let image = self.imageCache[tmpURL]
        
        if (image == nil) {
            // Download an NSData representation of the image at the URL
            let urlRequest: NSURLRequest! = NSURLRequest(URL: NSURL(string: tmpURL)!)
            NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                
                if (connectionError == nil && data != nil) {
                    self.imageCache[tmpURL] = UIImage(data: data)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? SubShopCategoryTableViewCell {
                            cellToUpdate.logoImageView.image = self.imageCache[tmpURL]
                        }
                    })
                }
                else {
                    println("Error: \(connectionError.localizedDescription)")
                }
            })
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                if let cellToUpdate = tableView.cellForRowAtIndexPath(indexPath) as? SubShopCategoryTableViewCell {
                    cellToUpdate.logoImageView.image = image
                }
            })
        }
        
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
        
        if segue.identifier == "SegueToShop" {
            println("[Segue] Sub shop category -> Shop")
            
            if let indexPath = tableView.indexPathForSelectedRow() {
                let destinationController = segue.destinationViewController as ShopViewController
                destinationController.subShopCategorySegue = self.activities[indexPath.row]
            }
        }
    }
    

}
