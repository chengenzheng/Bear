//
//  PostViewController.swift
//  Bear
//
//  Created by 薛永伟 on 2017/11/15.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var imageBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostClick(_ sender: UIButton) {
        
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("post_images").child("\(imageName)")
        
        if let profileImage = self.imageBtn.imageView?.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let imageURL = metadata?.downloadURL()?.absoluteString {
                    
                    self.postWithImg(url: imageURL)
//                    let values = ["name": name, "email": email, "profileImageURL" : profileImageURL]
//
//                    self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                }
                
                
            })
        }
        
        
    }
    func postWithImg(url:String) {
        
        let uid = Auth.auth().currentUser?.uid
        
        
        let reference = Database.database().reference().child("posts")
        let childReference = reference.childByAutoId()
        
        
        let timestamp = NSDate().timeIntervalSince1970 as NSNumber
        
        
        let values = ["createBy": uid!,"caption":self.textView.text!,"timestamp":timestamp,"image":url,"numberOfComments":5,"numberOfLikes":10,"numberOfShares":15] as [String : Any]
        //        childReference.updateChildValues(values)
        
        childReference.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
            
            self.textView.text = nil
            self.navigationController?.popViewController(animated: true)
            
        }
    }
    @IBAction func onImgBtnClick(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imgPiker = UIImagePickerController()
            imgPiker.delegate = self
            imgPiker.allowsEditing = true
            imgPiker.sourceType = .photoLibrary
            self.present(imgPiker, animated: true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker .dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImg = info[UIImagePickerControllerOriginalImage] {
            self.imageBtn.setImage(selectedImg as? UIImage, for: UIControlState.normal)
        }else{
            print("img error ")
        }
        dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
