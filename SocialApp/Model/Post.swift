//
//  Post.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/19/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import Foundation
import UIKit
class Post{
    private var _caption: String!
    private var _imageUrl: String!
    private var _likes: Int!
    private var _postKey: String!
    
    var caption:String{
        return _caption
    }
    var imageUrl:String{
        return _imageUrl
    }
    var likes:Int{
        return _likes
    }
    var postKey:String{
        return _postKey
    }
    
    init(caption:String, imageUrl:String, likes:Int) {
        self._caption = caption
        self._imageUrl = imageUrl
        self._likes = likes
    }
    
    init(postKey:String, postData: Dictionary<String,AnyObject>) {
        self._postKey = postKey
        
        if let caption = postData["caption"] as? String{
            self._caption = caption
        }
        
        if let imageUrl = postData["imageURL"] as? String{
            self._imageUrl = imageUrl
        }
        
        if let likes = postData["likes"] as? Int{
            self._likes = likes
        }
    }
    
    
}
