//
//  sendingVC.swift
//  Bear
//
//  Created by chengen Zheng on 2017/10/17.
//  Copyright © 2017年 chengen Zheng. All rights reserved.
//

import UIKit
protocol DataSentDelegate {
    
    func userDidEnterData(Data: String)
}

class SendingVC: UIViewController {
    
    @IBOutlet weak var dataEntryTextField: UITextField!
    
    
    
    var delegate: DataSentDelegate? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func sendBtnwasPressed(_ sender: UIButton) {
    if delegate != nil {
            if dataEntryTextField.text != nil {
                let data = dataEntryTextField.text
                delegate?.userDidEnterData(Data: data!)
                dismiss(animated: true, completion: nil)
            }
            
            
        }
        
        
    }
    
    
    
}
