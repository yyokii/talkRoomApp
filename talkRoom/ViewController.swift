//
//  ViewController.swift
//  talkRoom
//
//  Created by 東原与生 on 2017/05/24.
//  Copyright © 2017年 yoki. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var webView: UIWebView!
    
    var name = String()
    var base64String = String()
    var uuid = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gif = NSData(contentsOfFile:Bundle.main.path(forResource: "cc", ofType: "gif")!)
        webView.load(gif as! Data, mimeType: "image/gif", textEncodingName: "utf-8", baseURL: NSURL() as URL)
        
        let fbLoginBtn = FBSDKLoginButton()
        fbLoginBtn.frame = CGRect(x: self.view.frame.size.height/10, y: self.view.frame.size.height/2, width: self.view.frame.size.width-(self.view.frame.size.height/10 + self.view.frame.size.height/10), height: 50)
        
        self.view.addSubview(fbLoginBtn)
        
        fbLoginBtn.delegate = self
        
        if UserDefaults.standard.object(forKey: "OK") != nil{
            
            print("twice")
            performSegue(withIdentifier: "next", sender: nil)
        }
        
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        
        if error != nil {
            
            print("エラー")
            
        } else if result.isCancelled {
            
        } else {
            
            getFaceBookUserInfo()
            
        }
        
    }
    
    func getFaceBookUserInfo (){
        
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,name"]).start {
            ( connectoin, result, error) in
            self.name = (result! as AnyObject).value(forKey: "name") as! String
            let id = (result! as AnyObject).value(forKey: "id") as! String
            
            let url = URL(string: "https://graph.facebook.com/\(id)/picture?type=large&return_ssl_resources=1")
            
            let dataUrl = NSData(contentsOf: url!)
            
            
            self.base64String = dataUrl!.base64EncodedString(options: NSData.Base64EncodingOptions.lineLength64Characters) as String
            
            UserDefaults.standard.set(self.name, forKey: "name")
            UserDefaults.standard.set(self.base64String, forKey: "profileImage")
            
            let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
                
                if UserDefaults.standard.object(forKey: "OK") != nil {
                    
                } else {
                    
                    self.uuid = (user?.uid)!
                    self.createNewUserDB()
                }
            })

        }
        print("segue")
        performSegue(withIdentifier: "next", sender: nil)
        
    }
    
    func createNewUserDB(){
        
        let firebase = FIRDatabase.database().reference(fromURL: "https://talkroom-76b16.firebaseio.com/")
        let user:NSDictionary = ["userName": self.name, "profileImage": self.base64String, "uuid": self.uuid]
        firebase.child("users").childByAutoId().setValue(user)
        UserDefaults.standard.set("OK", forKey: "OK")
        
    }
    
    
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("logout completed")
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}

