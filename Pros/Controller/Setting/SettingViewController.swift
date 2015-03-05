//
//  SettingViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit

class SettingViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var logoutButton: UIButton!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userGenderLabel: UILabel!
    @IBOutlet weak var userBirthdayLabel: UILabel!
    @IBOutlet weak var userEmailLabel: UILabel!
    
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
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Settings")
    }
    
    private func updateUI() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    private let headerCellIdentifier    = "HeaderCell"
    private let bodyCellIdentifier      = "BodyCell"
    private let footerCellIdentifier    = "FooterCell"
    
    private func headerTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(headerCellIdentifier, forIndexPath: indexPath) as SettingHeaderTableViewCell
        cell.textLabel?.text = "Section 01"
        return cell
    }
    
    private func bodyTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(bodyCellIdentifier, forIndexPath: indexPath) as SettingBodyTableViewCell
        cell.textLabel?.text = "Section 02"
        return cell
    }
    
    private func footerTableViewCell(indexPath: NSIndexPath!) -> UITableViewCell {
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(footerCellIdentifier, forIndexPath: indexPath) as SettingFooterTableViewCell
        cell.textLabel?.text = "Section 03"
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableViewOutlet.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
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
