//
//  SignUpViewController.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/5/6.
//  Copyright © 2019 柏呈. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController {
    
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var verficationNumberTextField: UITextField!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func sendShortMessageButton(_ sender: UIButton) {
        guard let phoneNumber = phoneNumberTextField.text else {return}
        let url = "https://staging.ap.gladmobile.com/app/api/passengersendshortmessage"
        
        let body = ["phoneNumber":phoneNumber]
        
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            
            do {
                
                let json = try JSON(data: data)
                
                guard let result = json["result"].string else {
                    return
                }
                
                print(result)
               self.transferVerificationNumberAlert()
                
            }catch{
                
                print(error.localizedDescription)
            }
        }
    }
    
    
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        
        guard let verficationNumber = verficationNumberTextField.text else {return}
        guard let name = nameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        let url = "https://staging.ap.gladmobile.com/app/api/passengerregister"
        let body = [
            "verificationNumber":verficationNumber,
            "name":name,
            "name":password,
            "email":email
        ]
        
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            do {
                let json = try JSON(data: data)
                
                guard let result = json["result"].string else {
                    print("註冊失敗")
                    return
                }
                print(result)
                self.passengerRegisterAlert()
                
                
            }catch{
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}

extension SignUpViewController {
    
    func transferVerificationNumberAlert() {
        let alertController = UIAlertController(title: "成功", message: "傳送電話號碼成功", preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alerAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func passengerRegisterAlert() {
        let alertController = UIAlertController(title: "成功", message: "註冊成功", preferredStyle: .alert)
        let alerAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(alerAction)
        present(alertController, animated: true, completion: nil)
    }
}
