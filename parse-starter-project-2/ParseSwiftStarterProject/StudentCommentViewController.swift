//
//  StudentCommentViewController.swift
//  ParseStarterProject
//
//  Created by Kitty Wu on 29/7/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit
import Parse

class StudentCommentViewController: UIViewController {

    var student:Student = Student()

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtComment: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        lblTitle.text = "Comments for: \(student.name)"
    }

    @IBAction func btnAddComment(sender: AnyObject) {
        if let usercomment = txtComment.text {
            var query = PFQuery(className: "Student")
            query.whereKey("objectId", equalTo: student.objectId)
            
            query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                if (error == nil) {
                    if let objects = objects as? [PFObject] {
                        
                        var student = objects[0]
                        
                        var comment = PFObject(className: "StudentComment")
                        comment["text"] = usercomment
                        comment["page_owner"] = student
                        comment.saveInBackground()
                        self.txtComment.text = ""
                        
                        
                        // alert message
                        var alert = UIAlertController(title: "Success!", message: "Comment saved successfully!", preferredStyle: .Alert)
                        
                        // add button on the alert
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                        
                        // show the alert :)
                        self.presentViewController(alert, animated: true, completion: nil)

                        
                    }
                    
                } else {
                    println("error!")
                }
            }

            
            
        }
        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destinationVC = segue.destinationViewController as! ViewCommentsTableViewController
        
       
        destinationVC.student = student
        
        
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
