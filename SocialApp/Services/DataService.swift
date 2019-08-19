//
//  DataService.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/18/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()
class DataService{
    
    static let db = DataService()
    
    //DB_references
    let _REF_BASE = DB_BASE
    let _REF_POSTS = DB_BASE.child("posts")
    let _REF_USERS = DB_BASE.child("users")
    
    //Storage_references
    let _REF_POST_IMAGES = STORAGE_BASE.child("post-pics")
    
    var REF_BASE:DatabaseReference{
        return _REF_BASE
    }
    
    var REF_POSTS:DatabaseReference{
        return _REF_POSTS
    }
    
    var REF_USERS:DatabaseReference{
        return _REF_USERS
    }
    
    var REF_POST_IMAGES:StorageReference{
        return _REF_POST_IMAGES
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String,String>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
}
