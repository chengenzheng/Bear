//
//  RegisterViewController.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/14.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var btnRegister: UIButton!
    
   
    @IBOutlet weak var txtPassword: UITextField!
    
    
    @IBOutlet weak var txtEmail: UITextField!
    
    
    @IBOutlet weak var txtUsername: UITextField!
    
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    
    
    @IBAction func btnRegister_TouchUpInside(_ sender: UIButton) {
     
        if let email = txtEmail.text, let username = txtUsername.text,let password = txtPassword.text {
            
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                // ...
                guard let uid = user?.uid else {
                    return
                }
                if user != nil{
                    
                    let imageName = NSUUID().uuidString
                    let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName)")
                    
                    if let profileImage = UIImage.init(named: "defaultUserImg"), let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                        
                        storageRef.putData(uploadData, metadata: nil, completion: { (metadata, error) in
                            if error != nil {
                                print(error!)
                                return
                            }
                            if let profileImageURL = metadata?.downloadURL()?.absoluteString {
                                let values = ["name": username, "email": email, "profileImageURL" : profileImageURL]
                                
                                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
                            }
//                            if (metadata?.downloadURL()?.absoluteString) != nil {
//                                let values = ["name": username, "email": email, "profileImageURL" : "null"]
//                                 self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
//                            }
                        })
                    }
                    
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "navigation")
                    self.present(vc!, animated: true, completion: nil)
                    
                    
                }
                else{
                    let alertController = UIAlertController(title: "Registration Failed!", message: (error?.localizedDescription)!, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default){
                        (result : UIAlertAction) -> Void in
                        print("OK")
                    }
                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion:  nil)
                }
                self.indicator.stopAnimating()
            }
        }
    }
    override func touchesBegan(_ _touches: Set<UITouch>, with event: UIEvent?){
        txtEmail.resignFirstResponder()
        txtUsername.resignFirstResponder()
        txtPassword.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err!)
                return
            }
            
        })
        
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
