//
//  PlaceSearchViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 16/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit

class PlaceSearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
 
    var recentPlaces:[GooglePlaceLocation] = []
    var recentPlacesInMemory:[String:String] = [:]
    var defaults = NSUserDefaults.standardUserDefaults()
    var selectedPlace = GooglePlaceLocation()
    var sender = ""
    
    let gpaViewController = GooglePlacesAutocomplete(
        apiKey: "AIzaSyDC-QV6MigJGHU2bxOeKoJphDaXzlCxfKo",
        placeType: .All
    )

    @IBAction func btnShowSearch(sender: AnyObject) {
        presentViewController(gpaViewController, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        gpaViewController.placeDelegate = self
        gpaViewController.navigationItem.title = "Search"
        //gpaViewController.navigationItem.leftBarButtonItem = self.navigationItem.backBarButtonItem
        //gpaViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: gpaViewController, action: "close")
        
        if let recentPlacesSaved = defaults.objectForKey("recentPlaces") as? [String:String] {
            recentPlacesInMemory = recentPlacesSaved
            for key in recentPlacesInMemory.keys {
                if let value = recentPlacesInMemory[key] {
                var oldPlace = GooglePlaceLocation()
                    oldPlace.description = value
                    oldPlace.placeId = key
                    
                    var place = Place(id: key, description: value )
                    place.apiKey = "AIzaSyDC-QV6MigJGHU2bxOeKoJphDaXzlCxfKo"
                    place.getDetails { (result) -> () in
                        oldPlace.latitude = result.latitude
                        oldPlace.longitude = result.longitude
                        println(result.description)
                    }
                    
                    recentPlaces.append(oldPlace)
                }
            }
            tableView.reloadData()
        }

        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    
    // Number of sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // Number of rows in each section
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recentPlaces.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Recent Places"
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("placeIdentifier") as! UITableViewCell
    
        cell.textLabel?.text = recentPlaces[indexPath.row].description
        
        cell.textLabel?.font = UIFont(name: "Gill Sans", size: 15.0)
        
        return cell
    }

    func tableView(tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        let header:UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        
        header.textLabel.font = UIFont(name: "Gill Sans", size: 18.0)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if segue.identifier == "backToAddEvent" {
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPathForCell(cell) {
                    selectedPlace = recentPlaces[indexPath.row]
                    println(selectedPlace.description)
                }
            }
        }
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

extension PlaceSearchViewController: GooglePlacesAutocompleteDelegate {
    func placeSelected(place: Place) {
        println(place.description)
        println(place.id)
        
        var newPlace = GooglePlaceLocation()
        newPlace.description = place.description
        newPlace.placeId = place.id

        place.getDetails { (result) -> () in
            newPlace.latitude = result.latitude
            newPlace.longitude = result.longitude
            println(result.description)
        }
        
        // Limit to 10 entries only
        if recentPlaces.count == 10 {
            recentPlaces.removeLast()
        }
        
        

        recentPlaces.insert(newPlace, atIndex: 0)
        
        if recentPlacesInMemory[place.id] == nil {
            if recentPlacesInMemory.count == 10 {
                recentPlacesInMemory.removeAtIndex(recentPlacesInMemory.startIndex)
            }
            
            recentPlacesInMemory[place.id] = place.description
        }
        
        defaults.setObject(recentPlacesInMemory, forKey: "recentPlaces")
        defaults.synchronize()
        
        placeViewClosed()
    }

    
    func placeViewClosed() {
        dismissViewControllerAnimated(true, completion: {
            self.tableView.reloadData()
            
        })
    }
}
