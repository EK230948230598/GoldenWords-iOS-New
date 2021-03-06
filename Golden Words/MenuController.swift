//
//  MenuController.swift
//  Golden Words
//
//  Created by Léonard Bonfils on 2015-06-15.
//  Copyright © 2015 Léonard Bonfils. All rights reserved.
//


import UIKit
import Alamofire

class MenuController: UITableViewController {
    
    @IBOutlet weak var mainIconTableViewCell: UITableViewCell!
    
//    var overlayView: UIView = UIView()
//    
//    override func viewDidAppear(animated: Bool) {
//        super.viewDidAppear(animated)
//        self.revealViewController().frontViewController.view.addSubview(overlayView)
//    }
//    
//    override func viewDidDisappear(animated: Bool) {
//        super.viewDidDisappear(animated)
//        overlayView.removeFromSuperview()
//    }
//
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.revealViewController().view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.revealViewController().tapGestureRecognizer()
        self.revealViewController().frontViewController.view.userInteractionEnabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillAppear(animated)
    
        self.revealViewController().frontViewController.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.revealViewController().frontViewController.view.userInteractionEnabled = true
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
//        overlayView = UIView(frame: self.view.frame)

        // Defining the easter egg gesture
        let fiveTapGesture = UITapGestureRecognizer(target: self, action: "cellTappedFiveTimes:")
        fiveTapGesture.numberOfTapsRequired = 5
        mainIconTableViewCell.addGestureRecognizer(fiveTapGesture)
        
        // Defining a simple one-tap gesture to make sure the highlight colour is white (not gray)
        let oneTapGesture = UITapGestureRecognizer(target: self, action: "cellTappedOnce:")
        oneTapGesture.numberOfTapsRequired = 1
        mainIconTableViewCell.addGestureRecognizer(oneTapGesture)
        
        mainIconTableViewCell.userInteractionEnabled = true

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // One-tap selector
    func cellTappedOnce(gesture : UIGestureRecognizer) {
        
        if let mainIconTableViewCell = gesture.view as? UITableViewCell {
            self.mainIconTableViewCell.backgroundColor = UIColor.whiteColor()
        }
        
    }
    
    // Five-tap easter egg selector
    func cellTappedFiveTimes(gesture : UIGestureRecognizer) {
        
        if let mainIconTableViewCell = gesture.view as? UITableViewCell {
            // print("Image tapped 5 times")
            
            // Producing a JSSAlertView() to notify the user of the easter egg
            let customIcon = UIImage(named: "Demon")
            let stupidEasterEggAlertView = JSSAlertView().show(self, title: "HEY!", text: "This is iOS! Stop tapping that button like a traitor!", buttonText:  "Fine...", color: UIColor.redColor(), iconImage: customIcon)
//            stupidEasterEggAlertView.addAction(self.closeCallback)
            stupidEasterEggAlertView.setTitleFont("ClearSans-Bold")
            stupidEasterEggAlertView.setTextFont("ClearSans")
            stupidEasterEggAlertView.setButtonFont("ClearSans-Light")
            stupidEasterEggAlertView.setTextTheme(.Dark)
            
            // 
            
//            JSSAlertView().success(self, title: "Easter egg unlocked!", text: "Congratulations, you unlocked the Android 5-tap easter egg", buttonText: "My life is useless", cancelButtonText: "So useless")
//            
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
