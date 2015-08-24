//
//  MasterViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 8/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit

// Global variable - not best practice
var events:[Event] = []
var reloadEvents = true // hack


class EventCell: UITableViewCell {
    
    @IBOutlet weak var lblEventName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var eventImageView: UIImageView!
}



class MasterViewController: UITableViewController {

    var selectedItinerary:Int = 0
    var reloadData = true

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewEvent:")

        self.navigationItem.rightBarButtonItems?.append(addButton)
        self.navigationItem.title = userItineraries[selectedItinerary].name
    }
    
    override func viewDidAppear(animated: Bool) {
        loadItineraryEventsFromDB()
    }
    
    func loadItineraryEventsFromDB() {
        if (reloadEvents) {
            events.removeAll()
            println("Loading events...")
            var query = PFQuery(className: "Event")
            query.whereKey("itinerary", equalTo: userItineraries[selectedItinerary].dbObject)
            query.orderByAscending("eventIndex")
            
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    if let objects = objects as? [PFObject] {
                        userItineraries[self.selectedItinerary].eventIndex = objects.count
                        
                        for object in objects {
                            
                            var eventType = EventType.SightSeeing.rawValue
                            
                            if let type = object["eventType"] as? String {
                                eventType = type
                            }
                            
                            var event = Event(type: eventType)
                            
                            event.eventId = object.objectId!
                            
                            if let name = object["eventName"] as? String {
                                event.eventName = name
                            }
                            
                            if let origin = object["origin"] as? String {
                                event.origin = origin
                            }
                            
                            if let originGooglePlaceId = object["originGooglePlaceId"] as? String {
                                event.originGooglePlaceId = originGooglePlaceId
                            }
                            
                            if let originLatitude = object["originLatitude"] as? Double {
                                event.originLatitude = originLatitude
                            }
                            
                            if let originLongitude = object["originLongitude"] as? Double {
                                event.originLongitude = originLongitude
                            }
                            
                            if let dest = object["destination"] as? String {
                                event.destination = dest
                            }
                            
                            if let destGooglePlaceId = object["destinationGooglePlaceId"] as? String {
                                event.destinationGooglePlace = destGooglePlaceId
                            }
                            
                            if let destLatitude = object["destinationLatitude"] as? Double {
                                event.destinationLatitude = destLatitude
                            }
                            
                            if let destLongitude = object["destinationLongitude"] as? Double {
                                event.destinationLongitude = destLongitude
                            }
                            
                            if let startDate = object["startDate"] as? String {
                                event.startDate = startDate
                            }
                            
                            if let endDate = object["endDate"] as? String {
                                event.endDate = endDate
                            }
                            
                            event.dbObject = object
                            
                            events.append(event)
                        }
                        //println(events)
                        
                        self.tableView.reloadData()
                        reloadEvents = false
                    }
                    
                } else {
                    println("error!")
                }
            }
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func insertNewEvent(sender: AnyObject) {
        performSegueWithIdentifier("AddEvent", sender: self)
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let vc = segue.destinationViewController as! DetailViewController
                vc.selectedEvent = indexPath.row
            }
        }
        else if segue.identifier == "AddEvent" {
            let vc = segue.destinationViewController as! AddEventTableViewController
            vc.selectedItinerary = selectedItinerary
            vc.newEventIndex = events.count
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! EventCell
        println(events[indexPath.row].eventName)
        
        cell.lblEventName.text = events[indexPath.row].eventName
        var location = events[indexPath.row].origin
        var destination = events[indexPath.row].destination
        if !destination.isEmpty {
            location = location + " → " + destination
        }
        cell.lblLocation.text = location
        cell.lblPeriod.text = events[indexPath.row].startDate + " - " + events[indexPath.row].endDate
        cell.eventImageView.image = events[indexPath.row].image
        
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            events.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }


}

