//
//  WelcomeViewController.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/14.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController, DataSentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var receivingLabel: UILabel!
    
    
    @IBOutlet weak var imgPhoto: UIImageView!
    
    //var storageRef: StorageReference!
    //func configureStorage() {
    //    let storageUrl = FirebaseApp.app()?.options.storageBucket
    //    storageRef = Storage.storage().reference(forURL: "gs://" + storageUrl!)
    //}
    
    
    @IBAction func btnSavePhoto_Tap(_ sender: UIButton) {
        let imageData = UIImageJPEGRepresentation(imgPhoto.image!, 0.6)
        let compressedJPEGImage = UIImage(data: imageData!)
        UIImageWriteToSavedPhotosAlbum(compressedJPEGImage!, nil, nil, nil)
        let ac = UIAlertController(title: "Photo Saved!", message: "Your photo was saved successfully", preferredStyle:  .alert)
        ac .addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
        //let guid = "test_id"
        //let imagePath = "\(guid)/\(Int(Date.timeIntervalSinceReferenceDate * 1000)).jpg"
        //let metadata = StorageMetadata()
        // metadata.contentType = "image/jpeg"
        //self.storageRef.child(imagePath)
        //    .put(imageData!, metadata: metadata) { [weak self] (metadata, error) in
        //       if let error = error {
        //            print("Error uploading: \(error)")
        //           return
        //       }
        
        //  }
    }
    
    
    @IBAction func btnTakePhoto_TouchUpInside(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .camera
            imgPicker.allowsEditing = false
            self.present(imgPicker, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func btnPickPhoto_TouchUpInside(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imgPicker = UIImagePickerController()
            imgPicker.delegate = self
            imgPicker.sourceType = .photoLibrary
            imgPicker.allowsEditing = true
            self.present(imgPicker, animated: true, completion: nil)
            
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imgPhoto.image = selectedImage
            self.updateprofileImage(profileImage: selectedImage)
            
        } else {
            print("Something went wrong")
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAndSetupUI()
        // Do any additional setup after loading the view, typically from a nib.
    }
    func fetchUserAndSetupUI() {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            print("auth not done")
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.navigationItem.title = dictionary["name"] as? String
                
                let user = User()
                user.email = dictionary["email"] as? String
                user.name = dictionary["name"] as? String
                user.profileImageURL = dictionary["profileImageURL"] as? String
                self.receivingLabel.text = user.name
                if let profileImageURL = user.profileImageURL {
                    self.imgPhoto.loadImageUsingCacheWithUrlString(urlString: profileImageURL)
                    
                }
            }
            
        }, withCancel: nil)
    }
    func userDidEnterData(Data: String) {
        self.receivingLabel.text = Data
        self.updateUserName(name: Data)
    }
    func updateUserName(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let ref = Database.database().reference()
        
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(["name" : name], withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
        })
    }
    func updateprofileImage(profileImage:UIImage) {
        
        let imageName = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName)")
        
        if let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
            
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    print(error!)
                    return
                }
                
                if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                    
                    guard let uid = Auth.auth().currentUser?.uid else {
                        return
                    }
                    
                    let ref = Database.database().reference()
                    let usersReference = ref.child("users").child(uid)
                   
                    usersReference.updateChildValues(["profileImageURL" : profileImageURL], withCompletionBlock: { (err, ref) in
                        
                        if err != nil {
                            print(err!)
                            return
                        }
                        
                    })
                }
                
                
            })
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSendingVC" {
            
            let sendingVC: NameEditViewController = segue.destination as! NameEditViewController
            sendingVC.delegate = self
            
        }
    }
    
}


