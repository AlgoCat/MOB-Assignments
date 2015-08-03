//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {

    //var photo:PFObject = PFObject(className: "Photo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        var photo = PFObject(className: "Photo")
//        photo["name"] = "test"
//        
//        
//        var comment = PFObject(className: "Comment")
//        comment["body"] = "hello!"
//        comment["photo"] = photo
//        comment.saveInBackground() // save photo as well automatically
//        
//        var comment2 = PFObject(className: "Comment")
//        comment2["body"] = "hi!"
//        comment2["photo"] = photo
//        comment2.saveInBackground()
        
        /*var query = PFQuery(className: "Photo")
        query.whereKey("name", equalTo: "test")
  
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    self.photo = objects[3] // photo 4 has comments
                    println(objects[3].objectId)
                }
                
            } else {
                println("error!")
            }
        }*/
        
        
    }

    @IBAction func showComments(sender: AnyObject) {
        /*var query = PFQuery(className: "Comment")
        query.whereKey("photo", equalTo: photo)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil) {
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        println(object.objectId)
                        println(object["body"])
                        
                    }
                    
                }
            }
            
        }*/
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

