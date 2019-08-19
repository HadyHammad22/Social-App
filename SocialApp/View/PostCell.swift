//
//  PostCell.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/17/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class PostCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var likesLbl: UILabel!
    @IBOutlet weak var caption: UITextView!
    
    func configureCell(post: Post, img:UIImage? = nil){
        self.caption.text = post.caption
        self.likesLbl.text = "\(post.likes)"
        
        if img != nil{
            self.postImage.image = img
        }else{
            let ref = Storage.storage().reference(forURL: post.imageUrl)
            ref.getData(maxSize: 2 * 1024 * 1024, completion: { (data,error) in
                if error != nil{
                    print("JESS: Unable To Download Image From Firebase Storage")
                }else{
                    print("JESS: Image Downloaded Successfully From Firebase Storage")
                    if let imgData = data{
                        if let img = UIImage(data: imgData){
                            self.postImage.image = img
                            FeedVC.imageCash.setObject(img, forKey: post.imageUrl as NSString)
                        }
                        
                    }
                }
            })
        }
    }
}
