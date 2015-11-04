//
//  ProfileViewController.swift
//  LoginFacebook
//
//  Created by Gustavo F Oliveira on 11/2/15.
//  Copyright © 2015 isgustavo. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    struct FacebookUser {
        
        var id: String?
        var name: String?
        var firstName: String?
        var lastName: String?
        var email: String?
        var photo: UIImage?
        
        
        init(id: String, name: String, firstName: String, lastName: String, email: String, photo: UIImage!){
            self.id = id
            self.name = name
            self.firstName = firstName
            self.lastName = lastName
            self.email = email
            self.photo = photo
            
        }
        
    }
    
    private var mFacebookUser: FacebookUser?
    
    @IBOutlet weak var mProfileImageView: UIImageView!
    
    @IBOutlet weak var mNameLabel: UILabel!
    
    @IBOutlet weak var mEmailLabel: UILabel!
    
    @IBOutlet weak var mFacebookButton: FBSDKLoginButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if FBSDKAccessToken.currentAccessToken() == nil {
            print("User is not logged in")
        } else {
            print("User is logged in")
            
            returnCurrentFacebookUser()
        }
        
        mFacebookButton.delegate = self
        
        
        
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
            
            let protectedPage = self.storyboard?.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
            
            let protectedPageNav = UINavigationController(rootViewController: protectedPage)
            
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            appDelegate.window?.rootViewController = protectedPageNav
            
        }
        
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        let vc = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as! ViewController
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    func returnCurrentFacebookUser() -> FacebookUser? {
        
        var photoRequest: UIImage?
        let userID: String = FBSDKAccessToken.currentAccessToken().userID
        
        if FBSDKAccessToken.currentAccessToken() != nil {
            
            let facebookProfileUrl = NSURL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
            
            if let data = NSData(contentsOfURL: facebookProfileUrl!) {
                photoRequest = UIImage(data: data)!
            }

            
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if error == nil {
                    let userRequest = result as! NSDictionary
                    
                    self.mFacebookUser = FacebookUser(id: userRequest.valueForKey("id")! as! String,
                        name: userRequest.valueForKey("name") as! String,
                        firstName: userRequest.valueForKey("first_name") as! String,
                        lastName: userRequest.valueForKey("last_name") as! String,
                        email: userRequest.valueForKey("email") as! String,
                        photo: photoRequest)
                    
                    self.mProfileImageView.image = self.mFacebookUser?.photo
                    self.mNameLabel.text = self.mFacebookUser?.name
                    self.mEmailLabel.text = self.mFacebookUser?.email
                }
            })
        }
        
        return nil

    }

}
