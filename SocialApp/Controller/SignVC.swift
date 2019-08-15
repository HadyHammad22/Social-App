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
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func buFBLogin(_ sender: Any) {
        let facebookLogin = LoginManager()
        facebookLogin.logIn(permissions: ["email"], from: self) { (result,error) in
            if error != nil{
                print("JESS: Unable to auth with facebook - \(String(describing: error))")
            }else if result?.isCancelled == true{
                print("JESS: User Canceled facebook auth")
            }else{
                print("JESS: Successfully auth with facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: AccessToken.current!.tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential){
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil{
                print("JESS: Unable to auth with firebase - \(String(describing: error))")
            }else{
                print("JESS: Successfully auth with firebase")
            }
        })
    }
    
    @IBAction func buSignIn(_ sender: Any) {
        if let email = emailTxt.text, let pwd = passwordTxt.text{
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error == nil{
                    print("JESS: Auth Successfully")
                }else{
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil{
                            print("JESS: Unable to create user")
                        }else{
                            print("JESS: User Created Successfully and Auth Successfully")
                        }
                    })
                }
                
            })
        }
    }
    
    
}

