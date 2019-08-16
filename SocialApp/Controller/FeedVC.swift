//
//  FeedVC.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func buSignOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
    }
}
