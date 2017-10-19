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
     
        if let email = txtEmail.text, let password = txtPassword.text {
            
            self.indicator.isHidden = false
            self.indicator.startAnimating()
            
            Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                // ...
                if user != nil{
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
