//
//  NewItineraryTableViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 12/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit

class NewItineraryTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var txtNewItinName: UITextField!
    @IBOutlet weak var txtOrigin: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var lblSelectedStartDate: UILabel!
    @IBOutlet weak var lblSelectedEndDate: UILabel!
    @IBOutlet weak var dpFromDate: UIDatePicker!
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var btnSelectImage: UIButton!
    
    var dateFormatter = NSDateFormatter()
    var newItinName = ""
    var origin = ""
    var destination = ""
    var startDate = ""
    var endDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "dd MMM, yyyy"
        fromDateChanged()
        toDateChanged()
        
        lblError.text = ""
        lblError.textColor = UIColor.redColor()
        
    }
    
    func fromDateChanged() {
        var strDate = dateFormatter.stringFromDate(dpFromDate.date)
        startDate = strDate
        lblSelectedStartDate.text = strDate

    }
    
    @IBAction func startDateChanged(sender: AnyObject) {
        fromDateChanged()
    }
    
    func toDateChanged() {
        var strDate = dateFormatter.stringFromDate(dpEndDate.date)
        endDate = strDate
        lblSelectedEndDate.text = strDate
    }

    @IBAction func endDateChanged(sender: AnyObject) {
        toDateChanged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }*/
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 1 && indexPath.row == 0 {
            toggleStartDatepicker()
            hideEndDatepicker()
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            hideStartDatepicker()
            toggleEndDatepicker()
        }
    }
    
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if startDatePickerHidden && indexPath.section == 1 && indexPath.row == 1 {
            return 0
        }
        if endDatePickerHidden && indexPath.section == 1 && indexPath.row == 3 {
            return 0
        }
        else {
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    func hideStartDatepicker() {
        
        startDatePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleStartDatepicker() {
        
        startDatePickerHidden = !startDatePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func hideEndDatepicker() {
        
        endDatePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func toggleEndDatepicker() {
        
        endDatePickerHidden = !endDatePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @IBAction func startDateAction(sender: AnyObject) {
        fromDateChanged()
    }
    
    @IBAction func endDateAction(sender: AnyObject) {
        toDateChanged()
    }
    
    
    @IBOutlet weak var imageView: UIImageView!
    var myPickerController = UIImagePickerController()
    
    @IBAction func SelectImage(sender: AnyObject) {
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.imageView.contentMode = .ScaleAspectFit
            self.imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.myPickerController = UIImagePickerController()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    @IBAction func btnSave(sender: AnyObject) {
        if validate() {
            addSavingView()
            var itinerary = PFObject(className: "Itinerary")
            itinerary["name"] = newItinName
            itinerary["owner"] = PFUser.currentUser()
            itinerary["origin"] = origin
            itinerary["destination"] = destination
            itinerary["startDate"] = startDate
            itinerary["endDate"] = endDate
            if let image = self.imageView.image {
                let imageData = UIImagePNGRepresentation(self.imageView.image)
                let imageFile = PFFile(name:"itinPicture.png", data:imageData)
                itinerary["itinPicture"] = imageFile
            }
            
            println("Saving new itinerary: \(newItinName) From \(origin) To \(destination) Period \(startDate) - \(endDate)")
            
            
            itinerary.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    println("Saved!")
                    
                    self.boxView.removeFromSuperview()
                    
                    self.performSegueWithIdentifier("NewItinSaved", sender: self)
                    
                    
                } else {
                    self.lblError.text = "Sorry! Can't save due to error."
                    println(error)
                }
            })
            
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "NewItinSaved" {
            if let barViewControllers = segue.destinationViewController as? UITabBarController {
                if let vc = barViewControllers.viewControllers![0] as? MainViewController {
                    vc.reloadData = true
                }
            }
        }
    }
    
    var boxView = UIView()
    
    func addSavingView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY, width: 180, height: 50))
        boxView.backgroundColor = UIColor.blackColor()
        boxView.alpha = 0.8
        boxView.layer.cornerRadius = 10
        
        //Here the spinnier is initialized
        var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        activityView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityView.startAnimating()
        
        var textLabel = UILabel(frame: CGRect(x: 60, y: 0, width: 200, height: 50))
        textLabel.textColor = UIColor.grayColor()
        textLabel.text = "Saving..."
        
        boxView.addSubview(activityView)
        boxView.addSubview(textLabel)
        
        view.addSubview(boxView)
    }
    
    func validate() -> Bool {
        if let name = txtNewItinName.text {
            if !name.isEmpty {
                newItinName = name
            } else {
                lblError.text = "Please enter a name for the itinerary."
                return false
            }
        }
        
        if let fromLocation = txtOrigin.text {
            if !fromLocation.isEmpty {
                origin = fromLocation
                
            } else {
                lblError.text = "Please enter where you start your trip from."
                return false
            }
        }
        
        if let toLocation = txtDestination.text {
            if !toLocation.isEmpty {
                destination = toLocation
            } else {
                lblError.text = "Please enter your destination."
                return false
            }
        }
        
        if dpEndDate.date.compare(dpFromDate.date) == NSComparisonResult.OrderedAscending {
            lblError.text = "End date cannot be earlier than start date."
            return false
            
        }
        
        return true
    }


    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

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
