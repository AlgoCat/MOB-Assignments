//
//  DetailViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 8/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit
import GoogleMaps

class DetailViewController: UIViewController {

    
    var selectedEvent:Int = 0
    var event:Event = Event(type:"None")
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var lblEndDate: UILabel!
    @IBOutlet weak var btnOrigin: UIButton!
    @IBOutlet weak var btnDestination: UIButton!
    @IBOutlet weak var lblTo: UILabel!
    
    var mapView = GMSMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        event = events[selectedEvent]
        self.configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        self.navigationItem.title = event.eventName
        eventImageView.contentMode = .ScaleAspectFit
        eventImageView.image = event.image
        lblStartDate.text = event.startDate
        lblEndDate.text = event.endDate
        
        btnOrigin.setTitle(event.origin, forState: UIControlState.Normal)
        
        if (!event.destination.isEmpty) {
            btnDestination.setTitle(event.destination, forState: UIControlState.Normal)
            btnDestination.enabled = true
            lblTo.text = "to"
        } else {
            btnDestination.setTitle("", forState: UIControlState.Normal)
            btnDestination.enabled = false
            lblTo.text = ""
        }
        
        showMap(true)
    }

    func isValidOriginCoordinates() -> Bool {
        return event.originLatitude != 0 && event.originLongitude != 0
    }
    
    func isValidDestinationCoordinates() -> Bool {
        return event.destinationLatitude != 0 && event.destinationLongitude != 0
    }
    
    func showMap(showOrigin:Bool) {
        var camera = GMSCameraPosition.cameraWithLatitude(event.originLatitude, longitude: event.originLongitude, zoom: 15)
        mapView = GMSMapView.mapWithFrame(CGRectMake(0,250,CGRectGetMaxY(view.bounds)-250,CGRectGetMaxX(view.bounds)), camera: camera)
        self.view.addSubview(mapView)

        // Show flight path
        if (event.eventType == EventType.Flight.rawValue) {
            if (isValidOriginCoordinates() && isValidDestinationCoordinates()) {
                var camera3 = GMSCameraPosition.cameraWithLatitude(event.originLatitude, longitude: event.originLongitude, zoom: 2)
                
                var path = GMSMutablePath()
                path.addLatitude(event.originLatitude, longitude:event.originLongitude) // flight origin
                path.addLatitude(event.destinationLatitude, longitude:event.destinationLongitude) // flight destination
                
                var polyline = GMSPolyline(path: path)
                polyline.strokeColor = UIColor.blueColor()
                polyline.strokeWidth = 3.0
                polyline.map = mapView
                
                mapView.animateToCameraPosition(camera3)
                return
            }
        }

        if showOrigin {
            if (isValidOriginCoordinates()) {
                var camera = GMSCameraPosition.cameraWithLatitude(event.originLatitude, longitude: event.originLongitude, zoom: 15)

                var marker = GMSMarker(position: camera.target)
                marker.title = event.origin
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = mapView
                
                mapView.animateToCameraPosition(camera)
            }
        } else {
            if (isValidDestinationCoordinates()) {
                var camera2 = GMSCameraPosition.cameraWithLatitude(event.destinationLatitude, longitude: event.destinationLongitude, zoom: 15)

                var marker = GMSMarker(position: camera2.target)
                marker.title = event.destination
                marker.appearAnimation = kGMSMarkerAnimationPop
                marker.map = mapView

                mapView.animateToCameraPosition(camera2)
            }
        }
    }
    
    @IBAction func btnShowOriginInfo(sender: AnyObject) {
        showMap(true)
    }
    
    @IBAction func btnShowDestinationInfo(sender: AnyObject) {
        showMap(false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

