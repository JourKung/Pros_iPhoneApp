//
//  NotificationViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class NotificationViewController: BaseViewController {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    // ------------------------------
    // MARK: -
    // MARK: View life cycle
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
    
    // ------------------------------
    // MARK: -
    // MARK: User interface
    // ------------------------------
    
    private func customUI() -> Void {
        customNavigationBar()
    }
    
    private func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Notifications")
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    private func loadData() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
