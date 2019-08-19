//
//  FeedVC.swift
//  SocialApp
//
//  Created by Hady Hammad on 8/15/19.
//  Copyright © 2019 Hady Hammad. All rights reserved.
//

import UIKit
import Firebase
class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var imageAdd: CirecleView!
    var imagePicker:UIImagePickerController!
    var posts = [Post]()
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
        }else{
            print("JESS: A Valid Image Wasn't Selected")
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func buSelectImage(_ sender: Any) {
        self.present(imagePicker, animated: true, completion: nil)
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
                return cell
            }else{
                cell.configureCell(post: self.posts[indexPath.row])
                return cell
            }
        }else{
            return PostCell()
        }
        
    }
    @IBAction func buSignOut(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: KEY_UID)
        try! Auth.auth().signOut()
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 350
    }
}
