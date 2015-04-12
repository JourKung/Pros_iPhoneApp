
//
//  UserAuthenticationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/18/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit
import ObjectMapper

enum FBImageSize: String {
    case Small = "small"
    case Normal = "normal"
    case Large = "large"
    case customHeight = "height"
    case customWidth = "width"
}

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
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var pageImages: [UIImage] = []
    var pageImageView: [UIImageView?] = []
    let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "logoutWithNotificationObserver:",
            name: LOGOUT_NOTIFICATION_KEY,
            object: nil)
        
        setupView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
//        byPassingAuthenticationViewController()
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
        self.fbLoginManager.logInWithReadPermissions(kFacebookReadPermissions, handler: { (result: FBSDKLoginManagerLoginResult!, error: NSError!) -> Void in
            if (error != nil) {
                println("[+] Process error")
            } else if (result.isCancelled) {
                println("[+] Handle cancellations")
            } else {
                // If you ask for multiple permissions at once, you
                // should check if specific permissions missing
                if (result.grantedPermissions.contains("email")) {
                    self.performWithLoggedIn()
                }
            }
        })
    }
    
    @IBAction func unwindLogoutWithFacebook(segue: UIStoryboardSegue) {
        println("[Unwind] From Setting to UserAuthentication")
//        performWithLoggedOut()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    func setupView() -> Void {
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
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        /*
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
        */
    }

    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    /*
    func byPassingAuthenticationViewController() -> Void {
        let isCached = PFUser.currentUser() // Check if user is cached
        let isLinked = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) // Check if user is linked to Facebook
        
        if (isLinked && isLinked) {
            self.loginButton.hidden = true
            self.activityIndicator.startAnimating()
            // Present the next view controller without animation
            performWithHomeViewControllerAnimated(false)
        }
    }
    */
    
    func performWithLoggedIn() -> Void {
        
        if ((FBSDKAccessToken.currentAccessToken()) != nil) {
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler({ (connection: FBSDKGraphRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
                if (error == nil) {
                    /*
                    UserDefaults.sharedInstance.setUserFbId(profile["id"] as String)
                    UserDefaults.sharedInstance.setUsername(profile["name"] as String)
                    UserDefaults.sharedInstance.setUserEmail(profile["email"] as String)
                    UserDefaults.sharedInstance.setUserBirthday(profile["birthday"] as String)
                    UserDefaults.sharedInstance.setUserGender(profile["gender"] as String)
                                        
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
                    */
                    let user = Mapper<User>().map(result)
                    self.handleUserFacebookAccessTokenAndGraphRequest(FBSDKAccessToken.currentAccessToken(), user: user)
                    
                } else {
                    // Log details of the failure
                    println("[Log] Error: \(error) \(error?.localizedDescription)")
                }
                
                self.activityIndicator.stopAnimating()
            })
            
        }
        self.activityIndicator.startAnimating()
    }
    
    func handleUserFacebookAccessTokenAndGraphRequest(currentAccessToken: FBSDKAccessToken!, user: User!) -> Void {
        
        let form = LoginWithFacebookForm()
        form.profile = Mapper().toJSON(user)
        form.fbId = currentAccessToken.userID
        form.accessToken = currentAccessToken.tokenString
        form.expirationDate = Utilities.dateFormatterWithString(currentAccessToken.expirationDate)
        
        self.handleUserFacebookRegisterResponse(form)
    }
    
    func handleUserFacebookRegisterResponse(form: LoginWithFacebookForm!) -> Void {
        
        self.prosAPIClient.postUserFacebookRegister(form).responseJSON { (request, response, results, error) -> Void in
            if let result = results as? [String: AnyObject] {
                
                let createdAt = result["createdAt"] as String
                println("[createdAt] \(createdAt)")
                
                UserDefaults.sharedInstance.setUserObjectId(result["objectId"] as String)
                UserDefaults.sharedInstance.setUserSessionToken(result["sessionToken"] as String)
                
                self.prosAPIClient.putUserFacebookProfile(form).responseJSON { (request, response, results, error) -> Void in
                    if let result: AnyObject = results {
                        
                        let updatedAt = result["updatedAt"] as String
                        println("[updatedAt] \(updatedAt) | \(result as [String: AnyObject])")
                        
                        self.performWithHomeViewControllerAnimated(true)
                    } else {
                        // Log details of the failure
                        println("[Log] Error: \(error) \(error?.localizedDescription)")
                    }
                }
            } else {
                // Log details of the failure
                println("[Log] Error: \(error) \(error?.localizedDescription)")
            }
        }
    }

    func performWithLoggedOut() -> Void {
        self.prosAPIClient.postUserFacebookLoggedOutWithRevokeSession().responseJSON { (request, response, results, error) -> Void in
            if let result = results as? [String: AnyObject] {
                println("[Log] Logout is successful \(result)")
                self.fbLoginManager.logOut()
                self.loginButton.hidden = false
                self.activityIndicator.stopAnimating()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
    func downloadingDataWithUrl(url: NSURL!) -> Void {
        let urlRequest: NSURLRequest! = NSURLRequest(URL: url)
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue(), completionHandler: {
            (response: NSURLResponse!, data: NSData!, connectionError: NSError!) -> Void in
            if (connectionError == nil && data != nil) {
                UserDefaults.sharedInstance.setUserProfileImageData(data)
            } else {
                println("[Log] Error: \(connectionError.localizedDescription)")
            }
        })
    }

    func alertController(title: String!, message: String!, preferredStyle: UIAlertControllerStyle!) {
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
    
    func performWithHomeViewControllerAnimated(animated: Bool) -> Void {
        let containerHomeVC = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UITabBarController
        presentViewController(containerHomeVC, animated: animated, completion: nil)
    }
    
    /*
    NOTE: Scroll view with Paging
    */
    
    func loadPage(page: Int) -> Void {
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
    
    func purgePage(page: Int) -> Void {
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
    
    func loadVisiblePages() -> Void {
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
    
    // ------------------------------
    // MARK: -
    // MARK Notification observer
    // ------------------------------
    
    func logoutWithNotificationObserver(notification: NSNotification) -> Void {
        performWithLoggedOut()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Memory management
    // ------------------------------
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
