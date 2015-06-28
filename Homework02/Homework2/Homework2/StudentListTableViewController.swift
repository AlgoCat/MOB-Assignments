//
//  StudentListTableViewController.swift
//  Homework2
//
//  Created by Kannan Chandrasegaran on 25/6/15.
//  Copyright (c) 2015 Kannan Chandrasegaran. All rights reserved.
//

import UIKit

class StudentListTableViewController: UITableViewController {

    var studentList: [Student] = []
  
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
      
        setupStudents()

    }
  
    func setupStudents() {
        var student1:Student = Student()
        
        student1.age = 18
        student1.firstName = "robert"
        student1.lastName = "swift"
        student1.scores = [53,47,58,64]
        student1.phoneNumber = 63938208
        student1.profilePicURL = "http://fc02.deviantart.net/fs71/f/2012/067/2/4/profile_picture_by_durenatu-d4s6icn.jpg"
      
        var student2:Student = Student()
        
        student2.age = 17
        student2.firstName = "susan"
        student2.lastName = "table"
        student2.scores = [73,81,78,84]
        student2.profilePicURL = "http://www.karenmok.com/wp-content/uploads/2014/06/unnamed.jpg"

      
        var student3:Student = Student()
        
        student3.age = 19
        student3.firstName = "jake"
        student3.lastName = "viewcontroller"
        student3.scores = [62,71,78,64]
        student3.phoneNumber = 64848048
        student3.profilePicURL = "https://cdnil0.fiverrcdn.com/deliveries/626834/large/create-cartoon-caricatures_ws_1369443506.jpg"
        
        studentList.append(student1)
        studentList.append(student2)
        studentList.append(student3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return studentList.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        var studentNumber = indexPath.row
        cell.textLabel?.text = studentList[studentNumber].firstName + " " + studentList[studentNumber].lastName

        return cell
    }

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        var destinationVC = segue.destinationViewController as! StudentProfileViewController
        
        if let indexPath = self.tableView.indexPathForSelectedRow() {
            destinationVC.student = studentList[indexPath.row]
        }
    }


}
