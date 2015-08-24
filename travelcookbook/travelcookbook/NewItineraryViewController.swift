//
//  NewItineraryViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 9/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit


class NewItineraryViewController: UIViewController, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var txtNewItin: UITextField!
    @IBOutlet weak var txtFromLoc: UITextField!
    @IBOutlet weak var txtToLoc: UITextField!
    
    @IBOutlet weak var dpFromDate: UIDatePicker!
    @IBOutlet weak var dpToDate: UIDatePicker!
    @IBOutlet weak var selectedStartDate: UILabel!
    @IBOutlet weak var selectedEndDate: UILabel!
    
    @IBOutlet weak var lblError: UILabel!
    
    var dateFormatter = NSDateFormatter()
    var newItinName = ""
    var origin = ""
    var destination = ""
    var startDate = ""
    var endDate = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        dateFormatter.dateFormat = "dd MMM, yyyy"
        fromDateChanged()
        toDateChanged()
        
        lblError.text = ""
        lblError.textColor = UIColor.redColor()
    }
    
    func fromDateChanged() {
        var strDate = dateFormatter.stringFromDate(dpFromDate.date)
        startDate = strDate
        selectedStartDate.text = strDate
    }
    
    func toDateChanged() {
        var strDate = dateFormatter.stringFromDate(dpToDate.date)
        endDate = strDate
        selectedEndDate.text = strDate
    }
    
    // Number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    // Number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as! UITableViewCell
        
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 4 {
            toggleDatepicker()
        }
    }
    
    var datePickerHidden = false
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if datePickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        }
        else {
           // return tableView(tableView, heightForRowAtIndexPath: indexPath)
            return 100
        }
    }
    
    func toggleDatepicker() {
        
        datePickerHidden = !datePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
        
    }

    
    @IBAction func startDateAction(sender: AnyObject) {
        fromDateChanged()
    }
    
    @IBAction func endDateAction(sender: AnyObject) {
        toDateChanged()
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
    
    var boxView = UIView()
    
    func addSavingView() {
        // You only need to adjust this frame to move it anywhere you want
        boxView = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 25, width: 180, height: 50))
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
    
        
        if let name = txtNewItin.text {
            if !txtNewItin.text.isEmpty {
                newItinName = name
            } else {
                lblError.text = "Please enter a name for the itinerary."
                return false
            }
        }
        
        if let fromLocation = txtFromLoc.text {
            if !txtFromLoc.text.isEmpty {
                origin = fromLocation
                
            } else {
                lblError.text = "Please enter where you start your trip from."
                return false
            }
        }
        
        if let toLocation = txtToLoc.text {
            if !txtToLoc.text.isEmpty {
                destination = toLocation
            } else {
                lblError.text = "Please enter your destination."
                return false
            }
        }
        
        if dpToDate.date.compare(dpFromDate.date) == NSComparisonResult.OrderedAscending {
            lblError.text = "End date cannot be earlier than start date."
            return false

        }

        return true
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
