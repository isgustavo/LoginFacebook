//
//  ViewController.swift
//  LoginFacebook
//
//  Created by Gustavo F Oliveira on 11/2/15.
//  Copyright © 2015 isgustavo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    @IBOutlet weak var mLoginButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        mLoginButton.delegate = self
        mLoginButton.readPermissions = ["public_profile", "email", "user_friends"]
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            
            print("User is not logged in")
        } else {
            print("User is logged in")
            
            self.performSegueWithIdentifier("logggedIn", sender: self)
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!){
        
        if(error != nil)
        {
            print(error.localizedDescription)
            return
        }
        
        if let _ = result.token {
            
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController") as! ProfileViewController
            
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = protectedPageNav
            
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
    }

}

