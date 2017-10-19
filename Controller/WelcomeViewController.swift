//
//  WelcomeViewController.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/14.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController, DataSentDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func userDidEnterData(Data: String) {
        receivingLabel.text = Data
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSendingVC" {
            
            let sendingVC: SendingVC = segue.destination as! SendingVC
            sendingVC.delegate = self
            
        }
    }
    
}


