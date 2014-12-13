//
//  SidePanelViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 11/25/14.
//  Copyright (c) 2014 com.cpekmutt.project. All rights reserved.
//

import UIKit

@objc
protocol SidePanelViewControllerDelegate {
    func menuSelected(menu: Menu)
}

class SidePanelViewController: BaseViewController,
UITableViewDataSource,
UITableViewDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userProfilePictureView: FBProfilePictureView!
    
    var delegate: SidePanelViewControllerDelegate?
    var menu: Array<Menu>!
    
    struct TableView {
        struct CellIdentifiers {
            static let MenuCell = "MenuCell"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        userProfilePictureView.profileID = UserDefaults.sharedInstance.userObjectID
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table View Data Source
    // ------------------------------
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TableView.CellIdentifiers.MenuCell, forIndexPath: indexPath) as MenuCell
        cell.configureForAnimal(menu[indexPath.row])
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // Mark: Table View Delegate
    // ------------------------------
    
    func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        let selectedMenu = menu[indexPath.row]
        delegate?.menuSelected(selectedMenu)
    }
}

// ------------------------------
// MARK: -
// MARK: Table View Cell
// ------------------------------

class MenuCell: UITableViewCell {
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuTitleLabel: UILabel!
    @IBOutlet weak var menuDescriptionLabel: UILabel!
    
    func configureForAnimal(menu: Menu) {
        menuImageView.image = menu.image
        menuTitleLabel.text = menu.title
        menuDescriptionLabel.text = menu.description
    }
}
