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
    @IBOutlet weak var likesImage: UIImageView!
    
    var likesRef: DatabaseReference!
    var post:Post!
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        tap.numberOfTapsRequired = 1
        likesImage.addGestureRecognizer(tap)
        likesImage.isUserInteractionEnabled = true
    }
    func configureCell(post: Post, img:UIImage? = nil){
        self.post = post
        likesRef = DataService.db.REF_CURRENT_USERS.child("likes").child(post.postKey)
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
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likesImage.image = UIImage(named: "empty-heart")
            }else{
                self.likesImage.image = UIImage(named: "filled-heart")
            }
        })
    }
    @objc func likeTapped(sender: UITapGestureRecognizer){
        likesRef.observeSingleEvent(of: .value, with: { (snapshot) in
            if let _ = snapshot.value as? NSNull{
                self.likesImage.image = UIImage(named: "filled-heart")
                self.post.adjustLikes(addLike: true)
                self.likesRef.setValue(true)
            }else{
                self.likesImage.image = UIImage(named: "empty-heart")
                self.post.adjustLikes(addLike: false)
                self.likesRef.removeValue()
            }
        })
    }
}
