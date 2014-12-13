//
//  UserAuthenticationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 8/18/14.
//  Copyright (c) 2014 Posa. All rights reserved.
//

import UIKit

class UserAuthenticationViewController: BaseViewController,
FBLoginViewDelegate,
UIScrollViewDelegate {
    
    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: UIPageControl!
    
    var loginView: FBLoginView!
    var pageImages: [UIImage] = []
    var pageImageView: [UIImageView?] = []
    
    // ------------------------------
    // MARK: -
    // MARK: View Life Cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        /*
        NOTE: Initialize FBLoginView & permission
        */
        loginView = FBLoginView()
        loginView.delegate = self
        loginView.readPermissions = kFacebookReadPermissions
        
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

    // ------------------------------
    // MARK: -
    // MARK: User Interface
    // ------------------------------
    
    func updateUI() {
        customUI()
//        customNavigationBar()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
//    func customNavigationBar() {
//        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Log In")
//    }
    
    func customUI() {
//        view.backgroundColor = UIColor(red: 28.0/255.0, green: 119.0/255.0, blue: 201.0/255.0, alpha: 1)
        loginView.frame = CGRectOffset(loginView.frame, (self.view.center.x - (loginView.frame.size.width / 2)), 492)
        view.addSubview(loginView)
        
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
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    // Logged-in user experience
    func loginViewShowingLoggedInUser(loginView: FBLoginView!) {
        println("[+] View Logged In")
        performHomeViewControllerAnimated(true)
    }
    
    // Logged-out user experience
    func loginViewShowingLoggedOutUser(loginView: FBLoginView!) {
        println("[+] View Logged Out")
        PFUser.logOut()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func performHomeViewControllerAnimated(animated: Bool) {
        let homeVC = storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as UINavigationController
//        navigationController?.presentViewController(homeVC, animated: !animated, completion: nil)
        presentViewController(homeVC, animated: !animated, completion: nil)
//        performSegueWithIdentifier("HomeViewController", sender: nil)
    }
    
    /*
    NOTE: Scroll view with Paging
    */
    
    func loadPage(page: Int) {
        
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
    
    func purgePage(page: Int) {
        
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
    
    func loadVisiblePages() {
        
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
    
    func scrollViewDidScroll(scrollView: UIScrollView!) {
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
