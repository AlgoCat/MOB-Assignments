//
//  AddEventTableViewController.swift
//  Pods
//
//  Created by Kitty Wu on 16/8/15.
//
//

import UIKit


class AddEventTableViewController: UITableViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var eventType: UIPickerView!
    @IBOutlet weak var lblSelectedStartDate: UILabel!
    @IBOutlet weak var lblSelectedEndDate: UILabel!
    @IBOutlet weak var dpFromDate: UIDatePicker!
    @IBOutlet weak var dpEndDate: UIDatePicker!
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtEventName: UITextField!
    @IBOutlet weak var txtFreeText: UITextView!
    @IBOutlet weak var txtLocation: UITextField!
    @IBOutlet weak var txtDestination: UITextField!
    @IBOutlet weak var lblEventType: UILabel!

    var selectedItinerary:Int = 0
    var newEventIndex:Int = 0
    var dateFormatter = NSDateFormatter()
    var newEventName = ""
    var selectedEventType = EventType.SightSeeing.rawValue
    var eventTypes:[String] = EventType.allTypes
    
    var origin = ""
    var originGooglePlaceId = ""
    var originLatitude:Double = 0.0
    var originLongitude:Double = 0.0
    var selectedOrigin = GooglePlaceLocation()
    var destination = ""
    var destinationGooglePlaceId = ""
    var destinationLatitude:Double = 0.0
    var destinationLongitude:Double = 0.0
    var selectedDestination = GooglePlaceLocation()
    
    var startDate = ""
    var endDate = ""
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        dateFormatter.dateFormat = "dd MMM, yyyy HH:mm aa"
        fromDateChanged()
        toDateChanged()
        
        lblError.text = ""
        lblError.textColor = UIColor.redColor()

        lblEventType.text = EventType.SightSeeing.rawValue
        eventType.hidden = true
        txtLocation.placeholder = "Location"
        txtDestination.placeholder = ""
        txtDestination.enabled = false
    
        eventType.dataSource = self
        eventType.delegate = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "goToPlaceSearch") {
            if let vc = segue.destinationViewController as? PlaceSearchViewController {
                vc.sender = "origin"
            }
        } else if (segue.identifier == "placeSearchForDest") {
            if let vc = segue.destinationViewController as? PlaceSearchViewController {
                vc.sender = "destination"
            }
        }
    }

    // Unwind from Google Place Search ViewController
    @IBAction func unwindFromPlaceSearchViewController(segue:UIStoryboardSegue)
    {
        let sourceVC = segue.sourceViewController as! PlaceSearchViewController
        
        if sourceVC.sender == "origin" {
            selectedOrigin = sourceVC.selectedPlace
            txtLocation.text = sourceVC.selectedPlace.description
        } else {
            selectedDestination = sourceVC.selectedPlace
            txtDestination.text = sourceVC.selectedPlace.description
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return eventTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return eventTypes[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedEventType = eventTypes[row]
        lblEventType.text = selectedEventType
        
        let indexPath = NSIndexPath(forRow: 4, inSection: 0)
        let cell = tableView.cellForRowAtIndexPath(indexPath)

        if (selectedEventType == EventType.SightSeeing.rawValue || selectedEventType == EventType.Other.rawValue) {
            txtLocation.placeholder = "Location"
            txtDestination.placeholder = ""
            txtDestination.enabled = false
            cell?.accessoryType = UITableViewCellAccessoryType.None
            cell?.userInteractionEnabled = false
        }
        else {
            txtLocation.placeholder = "Origin"
            txtDestination.placeholder = "Destination"
            txtDestination.enabled = true
            cell?.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            cell?.userInteractionEnabled = true
        }
        hideEventTypePicker()
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            toggleEventTypePicker()
        }
        if indexPath.section == 1 && indexPath.row == 0 {
            toggleStartDatePicker()
            hideEndDatePicker()
        }
        else if indexPath.section == 1 && indexPath.row == 2 {
            hideStartDatePicker()
            toggleEndDatePicker()
        }
    }
    
    var startDatePickerHidden = true
    var endDatePickerHidden = true
    var eventTypePickerHidden = true

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if eventTypePickerHidden && indexPath.section == 0 && indexPath.row == 2 {
            return 0
        }
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
    
    func hideStartDatePicker() {
        
        startDatePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleStartDatePicker() {
        
        startDatePickerHidden = !startDatePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideEndDatePicker() {
        
        endDatePickerHidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleEndDatePicker() {
        
        endDatePickerHidden = !endDatePickerHidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func hideEventTypePicker() {
        
        eventTypePickerHidden = true
        eventType.hidden = true
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleEventTypePicker() {
        
        eventTypePickerHidden = !eventTypePickerHidden
        eventType.hidden = !eventType.hidden
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    override func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel.font = UIFont(name: "Gill Sans", size: 18.0)
    }
    
    
    @IBAction func btnSave(sender: AnyObject) {
        var itinerary = userItineraries[selectedItinerary].dbObject
        
        if validate() {
            addSavingView()
            var event = PFObject(className: "Event")
            event["eventIndex"] = newEventIndex
            event["eventName"] = newEventName
            event["eventType"] = selectedEventType
            event["origin"] = origin
            event["originGooglePlaceId"] = originGooglePlaceId
            event["originLatitude"] = originLatitude
            event["originLongitude"] = originLongitude
            event["destination"] = destination
            event["destinationGooglePlaceId"] = destinationGooglePlaceId
            event["destinationLatitude"] = destinationLatitude
            event["destinationLongitude"] = destinationLongitude
            event["startDate"] = startDate
            event["endDate"] = endDate
            event["itinerary"] = itinerary
            
            println("Saving new event: \(newEventName) of type \(eventType) From \(origin) To \(destination) Period \(startDate) - \(endDate)")
            
            event.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    println("Event Saved!")
                    
                    self.boxView.removeFromSuperview()
                    
                    reloadEvents = true
                    self.navigationController?.popViewControllerAnimated(true)
                    
                } else {
                    self.lblError.text = "Sorry! Can't save event due to error."
                    println(error)
                }
            })
            
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
        if let name = txtEventName.text {
            if !name.isEmpty {
                newEventName = name
            } else {
                lblError.text = "Please enter a name for the event."
                return false
            }
        }
        
        if let fromLocation = txtLocation.text {
            if !fromLocation.isEmpty {
                origin = fromLocation
                
                if (origin == selectedOrigin.description) {
                    originGooglePlaceId = selectedOrigin.placeId
                    originLatitude = selectedOrigin.latitude
                    originLongitude = selectedOrigin.longitude
                } else {
                    originGooglePlaceId = ""
                    originLatitude = 0.0
                    originLongitude = 0.0
                }
            } else {
                lblError.text = "Please enter where you start from."
                return false
            }
        }
        
        if let toLocation = txtDestination.text {
            if !toLocation.isEmpty {
                destination = toLocation
                
                if (destination == selectedDestination.description) {
                    destinationGooglePlaceId = selectedDestination.placeId
                    destinationLatitude = selectedDestination.latitude
                    destinationLongitude = selectedDestination.longitude
                } else {
                    destinationGooglePlaceId = ""
                    destinationLatitude = 0.0
                    destinationLongitude = 0.0
                }
            }
        }
        
        if dpEndDate.date.compare(dpFromDate.date) == NSComparisonResult.OrderedAscending {
            lblError.text = "End datetime cannot be earlier than start datetime."
            return false
        }
        
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 0
    }*/

    /*override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 0
    }*/

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


