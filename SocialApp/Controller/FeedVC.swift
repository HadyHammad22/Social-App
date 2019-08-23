//
//  FeedVC.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit
import FBSDKCoreKit
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageAdd: CirecleView!
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var captionField: FancyField!
    var posts = [Post]()
    var imageSelected = false
    static var imageCash: NSCache<NSString, UIImage> = NSCache()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        DataService.db.REF_POSTS.observe(.value, with: { (snapshot) in
            print(snapshot.value!)
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                for snap in snapshot{
                    if let postDict = snap.value as? Dictionary<String,AnyObject>{
                        let key = snap.key
                        let post = Post(postKey: key, postData: postDict)
                        self.posts.append(post)
                    }
                }
            }
            self.tableView.reloadData()
        })
        
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage{
            imageAdd.image = image
            imageSelected = true
        }else{
            print("JESS: A Valid Image Wasn't Selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buSelectImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func buPosting(_ sender: Any) {
        
        guard let caption = captionField.text, caption != "" else{
            print("JESS: caption must be entered")
            return
        }
        guard let img = imageAdd.image, imageSelected == true else{
            print("JESS: image must be selected")
            return
        }
        if let imgData = img.jpegData(compressionQuality: 0.2){
            let imgUid = NSUUID().uuidString
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpeg"
            
            DataService.db.REF_POST_IMAGES.child(imgUid).putData(imgData, metadata: metaData, completion: { (metadata,error) in
                if error != nil{
                    print("JESS: unable To Upload Image To Firebase Storage")
                }else{
                    print("JESS: Upload Image To Firebase Storage Successfully")
                    DataService.db.REF_POST_IMAGES.child(imgUid).downloadURL(completion: { (url, error) in
                        self.postToFirebase(imgUrl: url!.absoluteString)
                    })
                }
            })
            
        }
        
    }
    
    func postToFirebase(imgUrl: String){
        
        let post: Dictionary<String,Any> = [
            "caption": captionField.text!,
            "imageURL": imgUrl,
            "likes": 0
        ]
        
        DataService.db.REF_POSTS.childByAutoId().setValue(post)
        captionField.text = ""
        imageSelected = false
        imageAdd.image = UIImage(named: "add-image")
        self.tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as? PostCell{
            if let image = FeedVC.imageCash.object(forKey: self.posts[indexPath.row].imageUrl as NSString){
                cell.configureCell(post: self.posts[indexPath.row], img: image)
            }else{
                cell.configureCell(post: self.posts[indexPath.row])
            }
            return cell
        }else{
            return PostCell()
        }
        
    }
    @IBAction func buSignOut(_ sender: Any) {
        if let _ = AccessToken.current{
            AccessToken.current = nil
        }
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
