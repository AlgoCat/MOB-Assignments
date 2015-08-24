//
//  UserProfileViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 9/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit
import GoogleMaps

class UserProfileViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var lblUsername: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblTotaltin: UILabel!
    
    @IBOutlet weak var btnLogout: UIButton!
    @IBOutlet weak var btnChangePic: UIButton!
    @IBOutlet weak var profilePic: UIImageView!

    
    var user = PFUser.currentUser()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let user = user {
            lblUsername.text = user.username
            lblEmail.text = user.email
            lblTotaltin.text = "Total Itineraries: " + String(userItineraries.count)
            
            if let file = user["profilePic"] as? PFFile {
                file.getDataInBackgroundWithBlock({ (imageData, error) -> Void in
                    if let imageData = imageData {
                        self.profilePic.image = UIImage(data: imageData)
                    }
                })
            }
        }
        
        btnLogout.backgroundColor = UIColor.clearColor()
        btnLogout.layer.cornerRadius = 5
        btnLogout.layer.borderWidth = 1
        btnLogout.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnChangePic.backgroundColor = UIColor.clearColor()
        btnChangePic.layer.cornerRadius = 5
        btnChangePic.layer.borderWidth = 1
        btnChangePic.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    override func viewDidAppear(animated: Bool) {
        var camera = GMSCameraPosition.cameraWithLatitude(22.2855200, longitude: 114.1576900, zoom: 3)
        var mapView = GMSMapView.mapWithFrame(CGRectMake(0,200,CGRectGetMaxY(view.bounds)-250,380), camera: camera)
        
        addVisitedPlacesMarkers(mapView)
        
        self.view.addSubview(mapView)
    }
    
    func addVisitedPlacesMarkers(mapView:GMSMapView)
    {
        for itin in userItineraries {
            var query = PFQuery(className: "Event")
            query.whereKey("itinerary", equalTo: itin.dbObject)
            
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    if let objects = objects as? [PFObject] {
                        
                        for object in objects {
                            
                            var eventType = ""
                            var visitedPlace = ""
                            var latitude:Double = 0.0
                            var longitude:Double = 0.0
                            
                            if let type = object["eventType"] as? String {
                                eventType = type
                            }
                            
                            if let place = object["origin"] as? String {
                                visitedPlace = place
                            }
                            
                            if let lat = object["originLatitude"] as? Double {
                                latitude = lat
                            }
                            
                            if let long = object["originLongitude"] as? Double {
                                longitude = long
                            }
                            
                            if (eventType == EventType.SightSeeing.rawValue && latitude != 0 && longitude != 0) {
                                var position = CLLocationCoordinate2DMake(latitude, longitude)
                                var marker = GMSMarker(position: position)
                                marker.title = visitedPlace
                                marker.appearAnimation = kGMSMarkerAnimationPop
                                marker.map = mapView
                            }
                        }
                    }
                }
            }
        }
    }

    @IBAction func btnLogout(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error) -> Void in
            if (error == nil) {
                self.performSegueWithIdentifier("LoginAgain", sender: self)
            }
        }
    }

    var myPickerController = UIImagePickerController()

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.profilePic.contentMode = .ScaleAspectFit
            self.profilePic.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: {
            let imageData = UIImagePNGRepresentation(self.profilePic.image)
            let imageFile = PFFile(name:"profilePic.png", data:imageData)
            
            if let user = self.user {
                user["profilePic"] = imageFile
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if (success) {
                        println("User profile pic saved!")
                    } else {
                        println("Unable to save profile pic.")
                    }
                })
            } else {
                // user not logged in
            }
        })
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.myPickerController = UIImagePickerController()
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func btnChangePic(sender: AnyObject) {
        myPickerController.delegate = self;
        myPickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        self.presentViewController(myPickerController, animated: true, completion: nil)
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
