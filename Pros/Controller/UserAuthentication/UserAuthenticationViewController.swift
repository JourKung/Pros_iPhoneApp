
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
    let UserClass = User()
    
    // ------------------------------
    // MARK: -
    // MARK: View Life Cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        updateUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        byPassingAuthenticationViewController()
    }

    func byPassingAuthenticationViewController() -> Void {
        let isCached = PFUser.currentUser() // Check if user is cached
        let isLinked = PFFacebookUtils.isLinkedWithUser(PFUser.currentUser()) // Check if user is linked to Facebook
        
        if (isLinked && isLinked) {
            // Present the next view controller without animation
            performHomeViewControllerAnimated(false)
        }
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
        /*
        // If the session state is any of the two "open" states when the button is clicked
        if (FBSession.activeSession().state == FBSessionState.Open ||
            FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {
                
                // Close the session and remove the access token from the cache
                // The session state handler (in the app delegate) will be called automatically
                FBSession.activeSession().closeAndClearTokenInformation()
                
                // If the session state is not any of the two "open" states when the button is clicked
        } else {
            // Open a session showing the user the login UI
            // You must ALWAYS ask for public_profile permissions when opening a session
            FBSession.openActiveSessionWithReadPermissions(kFacebookReadPermissions, allowLoginUI: true, completionHandler: {
                (session, state, error) -> Void in
                // Retrieve the app delegate
                self.sessionStateChanged(session, state: state, error: error)
            })
        }
        */
        
        userLoggedIn()
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User Interface
    // ------------------------------
    
    func updateUI() {
        customUI()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func customUI() -> Void {
        loginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
        
        pageImages = [UIImage(named: "image1")!,
            UIImage(named: "image2")!,
            UIImage(named: "image3")!,
            UIImage(named: "image4")!,
            UIImage(named: "image5")!,
            UIImage(named: "image6")!]
        
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
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        let request: FBRequest = FBRequest.requestForMe()
        request.startWithCompletionHandler({
            (connection: FBRequestConnection!, result: AnyObject!, error: NSError!) -> Void in
            
            if !(error != nil) {
                // handle successful response
                // result is a dictionary with the user's Facebook data
                let userData = result as [String: AnyObject]
                UserDefaults.sharedInstance.userActivities = userData
                
                PFUser.currentUser().setObject(userData, forKey: "profile")
                PFUser.currentUser().saveInBackground()
//                [self _updateProfileData];
                self.performHomeViewControllerAnimated(true)
                
            } else if let info = error.userInfo as? [String: AnyObject] {
                if let dict1 = info["error"] as? [String: AnyObject] {
                    if let dict2 = dict1["type"] as? String {
                        if dict2 == "OAuthException" {
                            println("[Log] The facebook session was invalidated")
                            self.userLoggedOut()
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
    /*
    func sessionStateChanged(session: FBSession!, state: FBSessionState!, error: NSError!) -> Void {
        
        // If the session was opened successfully
        if (!(error != nil) && state == FBSessionState.Open) {
            println("[Log] Session opened")
            // Show the user the logged-in UI
            userLoggedIn()
            return
        }
        
        if (state == FBSessionState.Closed ||
            state == FBSessionState.ClosedLoginFailed) {
                // If the session is closed
                println("[Log] Session closed")
                // Show the user the logged-out UI
//                userLoggedOut()
        }
        
        // Handle errors
        if (error != nil) {
            println("[Log] Error")
            var alertText, alertTitle: String!
            // If the error requires people using an app to make an action outside of the app in order to recover
            if (FBErrorUtility.shouldNotifyUserForError(error) == true) {
                alertTitle = "Something went wrong"
                alertText = FBErrorUtility.userMessageForError(error)
                alertController(alertTitle, message: alertText, preferredStyle: .Alert)
            } else {
                // If the user cancelled login, do nothing
                if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.UserCancelled) {
                    println("[Log] User cancelled login")
                    // Handle session closures that happen outside of the app
                } else if (FBErrorUtility.errorCategoryForError(error) == FBErrorCategory.AuthenticationReopenSession) {
                    alertTitle = "Session Error"
                    alertText = "Your current session is no longer valid. Please login again."
                    alertController(alertTitle, message: alertText, preferredStyle: .Alert)
                    
                    // Here we will handle all other errors with a generic error message.
                    // We recommend you check our Handling Errors guide for more information
                    // https://developers.facebook.com/docs/ios/errors/
                } else {
                    // Get more error information from the error
                    if let info = error.userInfo {
                        if let dict1 = info["com.facebook.sdk:ParsedJSONResponseKey"] as? NSDictionary {
                            if let dict2 = dict1["body"] as? NSDictionary {
                                if let errorInformation = dict2["error"] as? NSDictionary {
                                    if let msg: AnyObject = errorInformation["message"] {
                                        // Show the user an error message
                                        alertTitle = "Something went wrong"
                                        alertText = ("Please retry. \n\n If the problem persists contact us and mention this error code: \(msg)")
                                        alertController(alertTitle, message: alertText, preferredStyle: .Alert)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Clear this token
        FBSession.activeSession().closeAndClearTokenInformation()
        // Show the user the logged-out UI
        userLoggedOut()
    }
    */
    
    // Show the user the logged-in UI
    func userLoggedIn() -> Void {
        
        // Login PFUser using Facebook
        PFFacebookUtils.logInWithPermissions(kFacebookReadPermissions, block: {
            (user: PFUser!, error: NSError!) -> Void in
            // Hide loading indicator
            self.activityIndicator.stopAnimating()
            
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
//                self.performHomeViewControllerAnimated(true)
                self.loadData()
            }
        })
        
        // Show loading indicator until login is finished
        self.activityIndicator.startAnimating()
    }

    // Show the user the logged-out UI
    func userLoggedOut() -> Void {        
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
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
    
    func performHomeViewControllerAnimated(animated: Bool) -> Void {
        let containerHomeVC = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UINavigationController
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
    
    // MARK: - Navigation
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        
        if segue.identifier == "HomeViewController" {
            let destinationVC = segue.destinationViewController as HomeViewController
//            destinationVC.nameFB = userClass.name
//            destinationVC.userPictureView.profileID = userID
        }
    }
    */

}
