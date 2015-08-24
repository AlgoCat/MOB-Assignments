//
//  MainViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 8/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit
import GoogleMaps

// Global variable - not best practice
var userItineraries:[Itinerary] = []

class ItineraryTableViewCell : UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDestination: UILabel!
    @IBOutlet weak var lblPeriod: UILabel!
    @IBOutlet weak var itinImage: UIImageView!
    @IBOutlet weak var itinView: UIView!
    
    
    func loadItem(#title:String, destination:String, period:String, image:UIImage) {
        lblTitle.text = title
        lblDestination.text = destination
        lblPeriod.text = period
        itinImage.image = image
        
        
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.itinImage.layer.cornerRadius = 10
        self.itinImage.layer.masksToBounds = true
        
        self.itinView.layer.cornerRadius = 10
        self.itinView.layer.masksToBounds = true

    }
    
}

class MainViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblWelcome: UILabel!
    var reloadData = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var nib = UINib(nibName: "ItineraryTableViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "reuseIdentifier")
        
        // Do any additional setup after loading the view.
        
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewDidAppear(animated: Bool) {

        if let currentUser = PFUser.currentUser() {
            if let username = currentUser.username {
                lblWelcome.text = "Welcome back " + username + "!"
                loadUserItinerariesFromDB(currentUser)
                
            } else {
                performSegueWithIdentifier("GoLogin", sender: self)
            }
        }
        else {
            println("no user")
            performSegueWithIdentifier("GoLogin", sender: self)
        }
        
    }

    func loadUserItinerariesFromDB(currentUser:PFUser) {
        if (reloadData) {
            userItineraries.removeAll()
            println("Loading itineraries...")
            var query = PFQuery(className: "Itinerary")
            query.whereKey("owner", equalTo: currentUser)
            
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    if let objects = objects as? [PFObject] {
                        
                        for object in objects {
                            var itin = Itinerary()
                            
                            itin.itineraryId = object.objectId!
                            
                            if let name = object["name"] as? String {
                                itin.name = name
                            }
                            
                            if let user = object["owner"] as? PFUser {
                                itin.userId = user.objectId!
                            }
                            
                            if let origin = object["origin"] as? String {
                                itin.origin = origin
                            }
                            
                            if let dest = object["destination"] as? String {
                                itin.destination = dest
                                
                            }
                            
                            if let startDate = object["startDate"] as? String {
                                itin.startDate = startDate
                                
                            }
                            
                            if let endDate = object["endDate"] as? String {
                                itin.endDate = endDate
                                
                            }
                            
                            if let file = object["itinPicture"] as? PFFile {
                                var imageData = file.getData() // cannot data get in background
                                if let imageData = imageData {
                                    itin.image = UIImage(data: imageData)!
                                    println(file.name)
                                }
                            
                            }
                            
                            itin.dbObject = object
                            
                            userItineraries.append(itin)
                        }
                        
                        //println(self.userItineraries)
                        self.tableView.reloadData()
                        self.reloadData = false
                    }
                    
                } else {
                    println("error!")
                }
            }
        }
    }
    
    
    
    
    // Number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userItineraries.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }

    /*func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView(frame: CGRectMake(0, 0, 320, 10))
        header.backgroundColor = UIColor.clearColor()
        return header
    }*/
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("ItinMaster", sender: self)
    }
 

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.Plain, target:nil, action:nil)
        
        if segue.identifier == "ItinMaster" {
            let vc = segue.destinationViewController as! MasterViewController
            if let indexPath = tableView.indexPathForSelectedRow() {
                vc.selectedItinerary = indexPath.row
                println("Selected Itin: " + String(indexPath.row))
                reloadEvents = true
            }
        }
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:ItineraryTableViewCell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier") as! ItineraryTableViewCell
        
        var itin:Itinerary = userItineraries[indexPath.row]
        var destination:String = itin.origin + " → " + itin.destination
        var period:String = "From " + itin.startDate + " to " + itin.endDate
        
        cell.loadItem(title: itin.name, destination: destination, period: period, image: itin.image)
        
        
        return cell
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
