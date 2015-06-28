//
//  StudentProfileViewController.swift
//  Homework2
//
//  Created by Kannan Chandrasegaran on 25/6/15.
//  Copyright (c) 2015 Kannan Chandrasegaran. All rights reserved.
//

import UIKit

class StudentProfileViewController: UIViewController {

  var student:Student = Student()
  
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var averageScoreLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var studentImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        firstNameLabel.text = student.firstName
        lastNameLabel.text = student.lastName
        ageLabel.text = String(student.age)
        averageScoreLabel.text = String(format: "%.2f", averageScore(student.scores))
        
        // optional student phone number
        if let phone = student.phoneNumber {
            phoneLabel.text = String(phone)
        }
        else {
            phoneLabel.text = ""
        }
        
        
        // student's profile pic
        if let url = NSURL(string: student.profilePicURL) {
            if let data = NSData(contentsOfURL: url){
                studentImage.contentMode = UIViewContentMode.ScaleAspectFit
                studentImage.image = UIImage(data: data)
            }
        }
    }
    
    func averageScore(scores:[Int]) -> Double {
        var sum:Double = 0
        for score in scores {
            sum = sum + Double(score)
        }
        
        return sum/Double(scores.count)
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
