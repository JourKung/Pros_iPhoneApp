//
//  CardViewController.swift
//  Pros
//
//  Created by Suwat Saegauy on 2/21/15.
//  Copyright (c) 2015 com.cpekmutt.project. All rights reserved.
//

import UIKit
import AVFoundation
import ObjectMapper
import ImageLoader

class CardViewController: BaseViewController,
    UITableViewDataSource,
    UITableViewDelegate,
    QRCodeReaderViewControllerDelegate,
    CNPPopupControllerDelegate {

    // ------------------------------
    // MARK: -
    // MARK: Properties
    // ------------------------------
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var insertCardBarButtonItem: UIBarButtonItem!
    
    let prosAPIClient: ProsAPIClient! = ProsAPIClient()
    var activities = [Card]()
    
    var cardView: RKCardView!
    var popupController: CNPPopupController!
    
    lazy var reader = QRCodeReaderViewController(metadataObjectTypes: [AVMetadataObjectTypeQRCode, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeUPCECode, AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeAztecCode])
    
    // ------------------------------
    // MARK: -
    // MARK: View Life Cycle
    // ------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        loadData()
        setupView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Action
    // ------------------------------
    
    @IBAction func scanAction(sender: AnyObject) {        
        let alertController = UIAlertController(title: "Select input form...", message: "", preferredStyle: .ActionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[CancelAction] ActionSheet")
        }
        alertController.addAction(cancelAction)
        
        let scanQRCodeAction = UIAlertAction(title: "Scan QRCode", style: .Default) { (action) in
            self.performQRCodeReaderViewControllerWithAnimated(true)
        }
        alertController.addAction(scanQRCodeAction)
        
        
        let serialNumberAction = UIAlertAction(title: "Serial number", style: .Default) { (action) in
            self.performSerialNumberAlertACtionWithAnimated(true)
        }
        alertController.addAction(serialNumberAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: User Interface
    // ------------------------------
    
    func setupView() -> Void {
        customNavigationBar()
        customTableView()
        customPullToRefresh()
    }
    
    func customNavigationBar() -> Void {
        navigationItem.titleView = Utilities.titleLabelOnNavigationBar("Cards")
    }
    
    func customTableView() -> Void {
        self.tableViewOutlet.estimatedRowHeight = 80.0
        self.tableViewOutlet.rowHeight = UITableViewAutomaticDimension
        
        // This will remove extra separators from tableview
        self.tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        self.tableViewOutlet.separatorColor = UIColor.clearColor()
        self.tableViewOutlet.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    }
    
    func customPullToRefresh() -> Void {
        self.tableViewOutlet.addPullToRefresh({ [weak self] in
            self?.loadData()
        })
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Data
    // ------------------------------
    
    func loadData() -> Void {
        NSOperationQueue().addOperationWithBlock({
            let form = MembershipCardForm()
            form.fbId = UserDefaults.sharedInstance.getUserFbId()
            self.prosAPIClient.getMembershipCardWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                if let card = Mapper<Card>().mapArray(results) {
                    self.activities = card
                }
                
                NSOperationQueue.mainQueue().addOperationWithBlock({
                    self.tableViewOutlet.reloadData()
                    self.tableViewOutlet.stopPullToRefresh()
                })
            }
        })
}
    
    // ------------------------------
    // MARK: -
    // MARK: Configuration
    // ------------------------------
    
    func performQRCodeReaderViewControllerWithAnimated(animted: Bool!) {
        if QRCodeReader.supportsMetadataObjectTypes() {
            self.reader.modalPresentationStyle = .FormSheet
            self.reader.delegate = self
            self.reader.completionBlock = { (result: String?) in
                if let result = result {
                    println("[Log] QR enter: \(result)")
                    // Fn: Send to service API and Check
                    NSOperationQueue().addOperationWithBlock({
                        let form = InsertMembershipCardForm()
                        form.fbId = UserDefaults.sharedInstance.getUserFbId()
                        form.qrId = result
                        self.prosAPIClient.getInsertMembershipCardWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                            if let result = results as? Bool {
                                println("[Log] qr enter response \(result)")
                            }
                            
                            NSOperationQueue.mainQueue().addOperationWithBlock({
                                self.tableViewOutlet.reloadData()
                                self.tableViewOutlet.stopPullToRefresh()
                            })
                        }
                    })
                } else {
                    println("[Log] Completion with result is nil")
                }
            }
            
            presentViewController(self.reader, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Error", message: "Reader not supported by the current device", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            
            presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func performSerialNumberAlertACtionWithAnimated(animated: Bool!) {
        let alertController = UIAlertController(title: "Serial number", message: "Please enter your serial number", preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            println("[CancelAction] Alert")
        }
        alertController.addAction(cancelAction)
        
        let enterAction = UIAlertAction(title: "Enter", style: .Default) { (action) in
            let serialNumberTextField = alertController.textFields![0] as! UITextField
            println("[Log] serial enter: \(serialNumberTextField.text)")
            // Fn: Send to service API and Check
            NSOperationQueue().addOperationWithBlock({
                let form = InsertMembershipCardForm()
                form.fbId = UserDefaults.sharedInstance.getUserFbId()
                form.qrId = serialNumberTextField.text
                self.prosAPIClient.getInsertMembershipCardWithCompletion(form).responseJSON { (request, response, results, error) -> Void in
                    if let result = results as? Bool {
                        println("[Log] serial enter response \(result)")
                        
                        let alert = UIAlertController(title: "Code reader", message: serialNumberTextField.text, preferredStyle: .Alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                        self.presentViewController(alert, animated: true, completion: nil)
                    }
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock({
                        self.tableViewOutlet.reloadData()
                        self.tableViewOutlet.stopPullToRefresh()
                    })
                }
            })
        }
        enterAction.enabled = false
        alertController.addAction(enterAction)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Serial number"
            textField.secureTextEntry = true
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                enterAction.enabled = textField.text != ""
            }
        }
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func performWithSerialNumberViewControllerAnimated(animated: Bool) -> Void {
        showPopupWithStyle(CNPPopupStyle.Fullscreen)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view data source
    // ------------------------------
    
    let BUFFERX: CGFloat = 12 //distance from side to the card (higher makes thinner card)
    let BUFFERY: CGFloat = 35 //distance from top to the card (higher makes shorter card)
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.activities.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = self.tableViewOutlet.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        cell.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
        
        cardView = RKCardView(frame: CGRectMake(BUFFERX, BUFFERY-15,
            view.frame.size.width-2*BUFFERX,
            view.frame.size.height-11*BUFFERY))
        
        if let shopCoverURL = self.activities[indexPath.row].shopCoverURL {
            let URL: NSURL = NSURL(string: shopCoverURL)!
            cardView.coverImageView?.load(URL)
        }
        
        let placeholder = UIImage(named: "00_icon_people")!
        if let activityShopLogoURL = self.activities[indexPath.row].shopLogoURL {
            let URL: NSURL = NSURL(string: activityShopLogoURL)!
            cardView.logoImageView?.load(URL, placeholder: placeholder)
        } else {
            cardView.logoImageView.image = placeholder
        }
        
        if let activityShopName = self.activities[indexPath.row].shopName {
            cardView.titleLabel.text = activityShopName
        } else {
            cardView.titleLabel.text = "nil"
        }
        
        if let activityShopType = self.activities[indexPath.row].shopType {
            cardView.typeLabel.text = activityShopType
        } else {
            cardView.typeLabel.text = "nil"
        }
        
        if let activityPoint = self.activities[indexPath.row].point {
            cardView.pointLabel.text = activityPoint
        } else {
            cardView.pointLabel.text = "nil"
        }
        
        if let activityExpireAt = self.activities[indexPath.row].expireAt {
            cardView.expirationDateLabel.text = Utilities.dateWithString(ISO8601DateFormatter().dateFromString(activityExpireAt), dateStype: NSDateFormatterStyle.ShortStyle, timeStyle: NSDateFormatterStyle.NoStyle)
        } else {
            cardView.expirationDateLabel.text = "nil"
        }
        
        cell.contentView.addSubview(cardView)
        
        return cell
    }
    
    // ------------------------------
    // MARK: -
    // MARK: Table view deleagete
    // ------------------------------
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.size.height-10*BUFFERY
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performWithSerialNumberViewControllerAnimated(true)
    }
    
    // ------------------------------
    // MARK: -
    // MARK: - QRCodeReader Delegate Methods
    // ------------------------------
    
    func reader(reader: QRCodeReaderViewController, didScanResult result: String) {
        self.dismissViewControllerAnimated(true, completion: { [unowned self] () -> Void in
            let alert = UIAlertController(title: "Code reader", message: result, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        })
    }
    
    func readerDidCancel(reader: QRCodeReaderViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "segueToQRCodeReader" {
            println("[Segue] Card -> QRCode reader")
        }
    }

    // ------------------------------
    // MARK: -
    // MARK: CNPPopupController delegate
    // ------------------------------
    
    func popupController(controller: CNPPopupController!, didDismissWithButtonTitle title: String!) {
        println("[Log] Dismissed with button title: \(title)")
    }
    
    func popupControllerDidPresent(controller: CNPPopupController!) {
        println("[Log] Popup controller presented.")
    }
    
    func showPopupWithStyle(popupStyle: CNPPopupStyle!) {
        var paragraphStyle: NSMutableParagraphStyle! = NSMutableParagraphStyle.new()
        paragraphStyle.lineBreakMode = NSLineBreakMode.ByCharWrapping
        paragraphStyle.alignment = NSTextAlignment.Center
        
        var paragraphStyleWithLineOne: NSMutableParagraphStyle! = NSMutableParagraphStyle.new()
        paragraphStyleWithLineOne.lineBreakMode = NSLineBreakMode.ByWordWrapping
        paragraphStyleWithLineOne.alignment = NSTextAlignment.Left
        
        let icon: UIImage! = UIImage(named: "00_qrDummy")
        let title: NSAttributedString! = NSAttributedString(string: "Terms & Conditions",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(24),
                NSParagraphStyleAttributeName: paragraphStyle])
        let lineOne: NSAttributedString! = NSAttributedString(string: "Membership in the programme is available to individuals (you) as stated in these Terms and Conditions. You may maintain only one account. Companies and/or other entities cannot enrol. There is no enrollment fee for this programme.",
            attributes: [NSFontAttributeName: UIFont.systemFontOfSize(18),
                NSForegroundColorAttributeName: UIColor.blackColor(),
                NSParagraphStyleAttributeName: paragraphStyleWithLineOne])
        
        let buttonTitle: NSAttributedString! = NSAttributedString(string: "Close me",
            attributes: [NSFontAttributeName: UIFont.boldSystemFontOfSize(18),
                NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSParagraphStyleAttributeName: paragraphStyle])
        
        let buttonItem: CNPPopupButtonItem! = CNPPopupButtonItem.defaultButtonItemWithTitle(buttonTitle, backgroundColor: UIColor(red: 0.46, green: 0.8, blue: 1.0, alpha: 1.0))
        buttonItem.selectionHandler = { (item: CNPPopupButtonItem!) -> Void in
            println("[Log] Block for button: \(item.buttonTitle.string)")
        }
        
        self.popupController = CNPPopupController(title: title, contents: [lineOne], buttonItems: [buttonItem], destructiveButtonItem: nil)
        self.popupController.theme = CNPPopupTheme.defaultTheme()
        self.popupController.theme.popupStyle = popupStyle
        self.popupController.delegate = self
        self.popupController.theme.presentationStyle = CNPPopupPresentationStyle.SlideInFromBottom
        self.popupController.presentPopupControllerAnimated(true)
    }
}
