
//
//  UserAuthenticationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/18/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

class UserAuthenticationViewController: BaseViewController,
    UIScrollViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
        
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var pageImages: [UIImage] = []
    var pageImageView: [UIImageView?] = []
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        customUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        byPassingAuthenticationViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func loginWithFacebook(sender: AnyObject) {
        performWithLoggedIn()
    }
    
    @IBAction func unwindLogoutWithFacebook(segue: UIStoryboardSegue){
        performWithLoggedOut()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        loginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
        
        pageImages = [UIImage(named: "01_tutorial")!,
            UIImage(named: "02_tutorial")!,
            UIImage(named: "03_tutorial")!,
            UIImage(named: "04_tutorial")!]
        
        let pageCount = pageImages.count
        pageControl.currentPage = 0
        pageControl.numberOfPages = pageCount
        scrollView.showsHorizontalScrollIndicator = false
        
        for index in 0..<pageCount {
            pageImageView.append(nil)
        }
        
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSizeMake(pagesScrollViewSize.width * CGFloat(pageImages.count), pagesScrollViewSize.height)

        loadVisiblePages()
    }
    
    private func updateUI() {
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func userData() -> Void {
        var query = PFUser.query()
        query.getObjectInBackgroundWithId(PFUser.currentUser().objectId, block: {
            (objects: PFObject!, error: NSError!) -> Void in
            
            // Hide loading indicator
            self.activityIndicator.stopAnimating()
            
            if (error == nil) {
                var profile = objects["profile"] as [String: AnyObject]
                
                UserDefaults.sharedInstance.userActivities = User(objectId: objects.objectId,
                    createdAt: objects.createdAt,
                    updatedAt: objects.updatedAt,
                    fbId: profile["id"] as String,
                    name: profile["name"] as String,
                    gender: profile["gender"] as String,
                    birthday: profile["birthday"] as? String,
                    email: profile["email"] as? String)
                
                UserDefaults.sharedInstance.setUserFbId(UserDefaults.sharedInstance.userActivities?.fbId)
                UserDefaults.sharedInstance.setUsername(UserDefaults.sharedInstance.userActivities?.name)
                UserDefaults.sharedInstance.setUserGender(UserDefaults.sharedInstance.userActivities?.gender)
                UserDefaults.sharedInstance.setUserBirthday(UserDefaults.sharedInstance.userActivities?.birthday)
                UserDefaults.sharedInstance.setUserEmail(UserDefaults.sharedInstance.userActivities?.email)
                
//                let fbId = profile["id"] as String
                println("[-] \(UserDefaults.sharedInstance.getUserFbId())")
                let fbPictureUrl: NSURL! = NSURL(string: "https://graph.facebook.com/\(UserDefaults.sharedInstance.getUserFbId())/picture?type=large&return_ssl_resources=1")
                let fbUrlRequest: NSURLRequest! = NSURLRequest(URL: fbPictureUrl)
                // Run network request asynchronously
                NSURLConnection.sendAsynchronousRequest(fbUrlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
                    (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
                    if (connectionError == nil && data != nil) {
                        // Set the image in the header imageView
                        UserDefaults.sharedInstance.setUserProfileImageData(data)
                    }
                })
                
                self.performHomeViewControllerAnimated(true)
                
            } else {
                // Log details of the failure
                println("[Log] Error: \(error) \(error.userInfo)")
            }
        })
    }
    
    private func loadData() -> Void {
        let request: FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler({
            (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if !(error != nil) {
                // handle successful response
                // result is a dictionary with the user's Facebook data
                let userData = result as [String: AnyObject]
                
                PFUser.currentUser().setObject(userData, forKey: "profile")
                PFUser.currentUser().saveInBackground()
                self.userData()
                
            } else if let info = error.userInfo as? [String: AnyObject] {
                if let dict1 = info["error"] as? [String: AnyObject] {
                    if let dict2 = dict1["type"] as? String {
                        if dict2 == "OAuthException" {
                            println("[Log] The facebook session was invalidated")
                            self.performWithLoggedOut()
                        }
                    }
                }
            } else {
                println("[Log] Some other error: \(error)");
            }
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private func byPassingAuthenticationViewController() -> Void {
        let isCached = PFUser.currentUser() // Check if user is cached
        let isLinked = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) // Check if user is linked to Facebook
        
        if (isLinked && isLinked) {
            self.loginButton.hidden = true
            self.activityIndicator.startAnimating()
            // Present the next view controller without animation
            performHomeViewControllerAnimated(false)
        }
    }
    
    // Show the user the logged-in UI
    private func performWithLoggedIn() -> Void {
        // Login PFUser using Facebook
        PFFacebookUtils.logInWithPermissions(kFacebookReadPermissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            
            if !(user != nil) {
                var errorMessage: String! = nil
                if !(error != nil) {
                    println("[Log] Uh oh. The user cancelled the Facebook login.")
                    errorMessage = "Uh oh. The user cancelled the Facebook login."
                } else {
                    println("[Log] Uh oh. An error occurred: \(error)")
                    errorMessage = error.localizedDescription
                }
                self.alertController("Log In Error", message: errorMessage, preferredStyle: .Alert)
            } else {
                if (user.isNew) {
                    println("[Log] User with facebook signed up and logged in!")
                } else {
                    println("[Log] User with facebook logged in!")
                }
                self.loadData()
            }
        })
        
        // Show loading indicator until login is finished
        self.activityIndicator.startAnimating()
    }

    // Show the user the logged-out UI
    private func performWithLoggedOut() -> Void {
        PFUser.logOut()
        self.loginButton.hidden = false
        self.activityIndicator.stopAnimating()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    private func alertController(title: String!, message: String!, preferredStyle: UIAlertControllerStyle!) {
        /*
        NOTE: The new way: UIAlertController (AlertView, ActionSheet)
        Default: Done action button
        */
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let defaultAction = UIAlertAction(title: "Done", style: UIAlertActionStyle.Default, handler: {
            action in
            // Handle statement
        })
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func performHomeViewControllerAnimated(animated: Bool) -> Void {
        let containerHomeVC = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UITabBarController//UINavigationController
        presentViewController(containerHomeVC, animated: animated, completion: nil)
    }
    
    /*
    NOTE: Scroll view with Paging
    */
    
    private func loadPage(page: Int) -> Void {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        // 1
        if let pageView = pageImageView[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            // 3
            let newPageView = UIImageView(image: pageImages[page])
//            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            // 4
            pageImageView[page] = newPageView
        }
    }
    
    private func purgePage(page: Int) -> Void {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageImageView[page] {
            pageView.removeFromSuperview()
            pageImageView[page] = nil
        }
    }
    
    private func loadVisiblePages() -> Void {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Update the page control
        pageControl.currentPage = page
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for var index = firstPage; index <= lastPage; ++index {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView!) -> Void {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
}
