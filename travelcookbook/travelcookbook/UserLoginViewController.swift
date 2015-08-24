//
//  UserLoginViewController.swift
//  travelcookbook
//
//  Created by Kitty Wu on 9/8/15.
//  Copyright (c) 2015 Kitty Wu. All rights reserved.
//

import UIKit

class UserLoginViewController: UIViewController {

    @IBOutlet weak var btnLogin: UIButton!
    @IBOutlet weak var btnSignUp: UIButton!
    
    @IBOutlet weak var lblError: UILabel!
    @IBOutlet weak var txtUsername: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var username = ""
    var password = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lblError.text = ""
        lblError.textColor = UIColor.redColor()
        
        btnLogin.backgroundColor = UIColor.clearColor()
        btnLogin.layer.cornerRadius = 5
        btnLogin.layer.borderWidth = 1
        btnLogin.layer.borderColor = UIColor.whiteColor().CGColor
        
        btnSignUp.backgroundColor = UIColor.clearColor()
        btnSignUp.layer.cornerRadius = 5
        btnSignUp.layer.borderWidth = 1
        btnSignUp.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    @IBAction func btnCreateUser(sender: AnyObject) {
        if validate(true) {
            var user = PFUser()
            user["profile_pic"] = ""
            user.username = username
            user.password = password
            user.email = email
        
            user.signUpInBackgroundWithBlock { (success, error) -> Void in
                if (error == nil) {
                    println("Sign-up success")
                    self.performSegueWithIdentifier("LoggedIn", sender: self)
                } else {
                    if let error = error {
                        println("Sign-up error: " + error.description)
                        self.lblError.text = "Unable to create user due to error: " + error.description
                    }
                }
            }
        }
    }
    
    @IBAction func btnLogin(sender: AnyObject) {
        if validate(false) {
            PFUser.logInWithUsernameInBackground(username, password: password) { (user, error) -> Void in
                if (error == nil) {
                    println("Login success: " + self.username)
                    println(PFUser.currentUser())
                    self.performSegueWithIdentifier("LoggedIn", sender: self)
                } else {
                    if let error = error {
                        println("Login error: " + error.description)
                        self.lblError.text = "Login failed. Please check your username and password."
                    }
                }
            }
        }
    }

    func validate(checkEmailAddress:Bool) -> Bool {
        
        if let user = txtUsername.text {
            if !txtUsername.text.isEmpty {
                username = user
            } else {
                lblError.text = "Please enter your username."
                return false
            }
        }
        
        if let pw = txtPassword.text {
            if !txtPassword.text.isEmpty {
                password = pw
                
            } else {
                lblError.text = "Please enter your password."
                return false
            }
        }
        
        if (checkEmailAddress) {
            if let em = txtEmail.text {
                if !txtEmail.text.isEmpty {
                    email = em
                } else {
                    lblError.text = "Please enter your email address."
                    return false
                }
            }
        }

        return true
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
