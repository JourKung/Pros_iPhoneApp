//
//  CardViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class CardViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    
    var cardView: RKCardView!
    
    // ------------------------------
    // MARK: -
    // MARK: View Life Cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    @IBAction func unwindCloseWithCardViewController(segue: UIStoryboardSegue) {
//        dismissViewControllerAnimated(true, completion: {
//            println("[+] Set/Reload card")
//        })
        println("[+] Set/Reload card")
        navigationController?.popViewControllerAnimated(true)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User Interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Cards")
    }
    
    private func updateUI() {
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func loadData() -> Void {
//        activities = ["cover": ["00_coverDummy", "01_coverDummy", "02_coverDummy", "03_coverDummy"],
//            "logo": ["00_logoDummy", "01_logoDummy", "02_logoDummy", "03_logoDummy"],
//            "title": ["StarBucks", "Black Canyon", "Coffee World", "Cafe Amazon"],
//            "description": ["Coffee shop", "Coffee shop", "Coffee shop", "Coffee shop"],
//            "point": ["99", "100", "7", "55"],
//            "expirationDate": ["04/12/2014", "12/11/2014", "26/06/2015", "01/01/2015"]];
        
        // ----
        
//        userActivities = [User(objectId: userData["objectId"] as? String
//            , createdAt: userData["createdAt"] as? String
//            , updatedAt: userData["updatedAt"] as? String
//            , fbId: userData["id"] as? String
//            , name: userData["name"] as? String
//            , gender: userData["gender"] as? String
//            , birthday: userData["birthday"] as? String
//            , email: userData["email"] as? String
//            , profileImage: nil)]
        
//        userActivities = [User(objectId: "",
//            createdAt: NSDate(),
//            updatedAt: NSDate(),
//            fbId: "",
//            name: "",
//            gender: "",
//            birthday: "",
//            email: "",
//            profileImage: UIImage())]
        
        /*
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
        */
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
//        let titleCount = activities["title"]!
//        return titleCount.count
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        cardView = RKCardView(frame: CGRectMake(BUFFERX, BUFFERY-15,
            view.frame.size.width-2*BUFFERX,
            view.frame.size.height-11*BUFFERY))
        
        cardView.coverImageView.image = UIImage(named: "00_coverDummy")//UIImage(named: (initDictionaryWithArray("cover")[indexPath.row]))
        cardView.logoImageView.image = UIImage(named: "00_logoDummy")//UIImage(named: (initDictionaryWithArray("logo")[indexPath.row]))
        cardView.titleLabel.text = "StackBucks Coffee"//initDictionaryWithArray("title")[indexPath.row]
        cardView.typeLabel.text = "@Cafe"//initDictionaryWithArray("description")[indexPath.row];
        cardView.pointLabel.text = "99"//initDictionaryWithArray("point")[indexPath.row];
        
        cardView.expirationDateLabel.text = Utilities.dateWithString(NSDate(), dateStype: .ShortStyle, timeStyle: .NoStyle)//initDictionaryWithArray("expirationDate")[indexPath.row];
        
        cell.contentView.addSubview(cardView)
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.size.height-10*BUFFERY
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
