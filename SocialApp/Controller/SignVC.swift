//
//  SignVC.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/14/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
class SignVC: UIViewController {
    
    @IBOutlet weak var emailTxt: FancyField!
    @IBOutlet weak var passwordTxt: FancyField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let _ = UserDefaults.standard.string(forKey: KEY_UID){
            let feedVC = storyboard?.instantiateViewController(withIdentifier: "FeedVC") as! FeedVC
            self.present(feedVC, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindToSign(segue: UIStoryboardSegue){}
    
    @IBAction func buFBLogin(_ sender: Any) {
        if let token = AccessToken.current{
            let feedVC = self.storyboard?.instantiateViewController(withIdentifier: "FeedVC") as? FeedVC
            self.present(feedVC!, animated: true, completion: nil)
        }else{
            let loginManager = LoginManager()
            loginManager.logIn(permissions: ["email"], from: self) { (loginResult,error) in
                
                if error != nil{
                    print("JESS: Unable to auth with facebook - \(String(describing: error))")
                }else if loginResult?.isCancelled == true{
                    print("JESS: User Canceled facebook auth")
                }else{
                    print("JESS: Successfully auth with facebook",AccessToken.current!.tokenString)
                    let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                    self.firebaseAuth(credential)
                }
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
                print("JESS: Unable to auth with firebase + \(String(describing: error))")
                return
            }
            // User is signed in
            print("JESS: Successfully auth with firebase")
            if let user = authResult{
                let userData = ["Provider": credential.provider]
                self.completeSignIn(id: user.user.uid, userData: userData)
            }
        }
    }
    
    @IBAction func buSignIn(_ sender: Any) {
        if let email = emailTxt.text, let pwd = passwordTxt.text{
            Auth.auth().signIn(withEmail: email, password: pwd){ (user,error) in
                if error == nil{
                    print("JESS: Auth Successfully")
                    if let user = user{
                        let userData = ["Provider": user.user.providerID]
                        self.completeSignIn(id: user.user.uid, userData: userData)
                    }
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil{
                            print("JESS: Unable to create user")
                        }else{
                            print("JESS: User Created Successfully and Auth Successfully")
                            if let user = user{
                                let userData = ["Provider": user.user.providerID]
                                self.completeSignIn(id: user.user.uid, userData: userData)
                            }
                        }
                    })
                }
                
            }
        }
    }
    
    func completeSignIn(id: String,userData: Dictionary<String,String>){
        DataService.db.createFirebaseDBUser(uid: id, userData: userData)
        UserDefaults.standard.set(id, forKey: KEY_UID)
        emailTxt.text = ""
        passwordTxt.text = ""
        let feedVC = storyboard?.instantiateViewController(withIdentifier: "FeedVC") as! FeedVC
        self.present(feedVC, animated: true, completion: nil)
    }
    
}

