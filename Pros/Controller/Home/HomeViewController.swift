//
//  HomeViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/31/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

@objc
protocol HomeViewControllerDelegate {
    optional func toggleLeftPanel()
//    optional func toggleRightPanel()
//    optional func collapseSidePanels()
}

class HomeViewController: BaseViewController,
    UITableViewDelegate,
    UITableViewDataSource,
    SidePanelViewControllerDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    var delegate: HomeViewControllerDelegate?
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userBirthdayLabel: UILabel!
    @IBOutlet weak var sidebarButon: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    let UserClass = User()
    var cardView: RKCardView!
    var activities = [String: Array<String>]()
    
    // ------------------------------
    // MARK: -
    // MARK: View Life Cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func performLogout(sender: AnyObject) {
//        FBSession.activeSession().closeAndClearTokenInformation()
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func toggleLeftPanel(sender: AnyObject) {
        delegate?.toggleLeftPanel?()
    }
    
    func menuSelected(menu: Menu) {
        delegate?.toggleLeftPanel?()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User Interface
    // ------------------------------
    
    func updateUI() {
        customUI()
        customNavigationBar()
        loadData()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.title = "My Cards"
    }
    func customUI() -> Void {
        logoutButton.setTitle("Log out", forState: UIControlState.Normal)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        activities = ["cover": ["00_coverDummy", "01_coverDummy", "02_coverDummy", "03_coverDummy"],
            "logo": ["00_logoDummy", "01_logoDummy", "02_logoDummy", "03_logoDummy"],
            "title": ["StarBucks", "Black Canyon", "Coffee World", "Cafe Amazon"],
            "description": ["Coffee shop", "Coffee shop", "Coffee shop", "Coffee shop"],
            "point": ["99", "100", "7", "55"],
            "expirationDate": ["04/12/2014", "12/11/2014", "26/06/2015", "01/01/2015"]];
        
        
        
        
        // ----
        let userData = UserDefaults.sharedInstance.userActivities
        
        UserClass.id = userData["id"] as? String
        UserClass.name = userData["name"] as? String
        UserClass.gender = userData["gender"] as? String
        UserClass.birthday = userData["birthday"] as? String
        UserClass.email = userData["email"] as? String
        
        let fbPictureUrl: NSURL! = NSURL(string: "https://graph.facebook.com/\(self.UserClass.id)/picture?type=large&return_ssl_resources=1")
        let fbUrlRequest: NSURLRequest! = NSURLRequest(URL: fbPictureUrl)
        // Run network request asynchronously
        NSURLConnection.sendAsynchronousRequest(fbUrlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
            if (connectionError == nil && data != nil) {
                // Set the image in the header imageView
                self.UserClass.picture = UIImage(data: data)
            }
        })
        
        
        println("[HomeVC] \(UserClass.id) \(UserClass.email)")
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    
    
    // ------------------------------
    // MARK: - 
    // MARK: Table view data source
    // ------------------------------
    
    let BUFFERX: CGFloat = 15 //distance from side to the card (higher makes thinner card)
    let BUFFERY: CGFloat = 35 //distance from top to the card (higher makes shorter card)
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let titleCount: Array = activities["title"]!
        return titleCount.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        
        cardView = RKCardView(frame: CGRectMake(BUFFERX, BUFFERY-15,
            view.frame.size.width-2*BUFFERX,
            view.frame.size.height-11*BUFFERY))
        
//        var cover: Array = activities["cover"]!
//        var logo: Array = activities["logo"]!
//        var title: Array = activities["title"]!
//        var description: Array = activities["description"]!
//        var point: Array = activities["point"]!
//        var expirationDate: Array = activities["expirationDate"]!
        
        
        cardView.coverImageView.image = UIImage(named: (initDictionaryWithArray("cover")[indexPath.row]))
        cardView.profileImageView.image = UIImage(named: (initDictionaryWithArray("logo")[indexPath.row]))
        cardView.titleLabel.text = initDictionaryWithArray("title")[indexPath.row]
        cardView.descriptionLabel.text = initDictionaryWithArray("description")[indexPath.row];
        cardView.pointLabel.text = initDictionaryWithArray("point")[indexPath.row];
        cardView.expirationDateLabel.text = initDictionaryWithArray("expirationDate")[indexPath.row];
        
        cell.contentView.addSubview(cardView)
        return cell
    }
    
    func initDictionaryWithArray(key: String) -> Array<String>! {
        return activities[key]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.size.height-10*BUFFERY
    }
}
