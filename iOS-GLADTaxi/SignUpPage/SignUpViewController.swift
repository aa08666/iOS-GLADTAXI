//
//  SignUpViewController.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/5/6.
//  Copyright © 2019 柏呈. All rights reserved.
//

import UIKit
import SwiftyJSON

class SignUpViewController: UIViewController, UITextFieldDelegate {
    
    
    
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var verficationNumberTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var teamCodeTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        verficationNumberTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        teamCodeTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func sendShortMessageButton(_ sender: UIButton) {
        
        guard let phoneNumber = phoneNumberTextField.text else {return}
        
        
        let body = ["phoneNumber":phoneNumber]
        
        Request.postRequest(Url.url, SignAPIs.passengerSendShortMessage, body: body) { (data, statusCode) in
            
            do {
                
                let json = try JSON(data: data)
                
                guard let result = json["result"].string else {
                    return
                }
                
                print(result)
                
                
            }catch{
                
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        phoneNumberTextField.becomeFirstResponder()
        verficationNumberTextField.becomeFirstResponder()
        
    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        
        
        guard let verficationNumber = verficationNumberTextField.text else {return}
        guard let name = nameTextField.text else {return}
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let teamCode = teamCodeTextField.text else {return}
        guard let phoneNumber = phoneNumberTextField.text else {return}
        
        let pushToPageMapHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapHome")
        
        
      
        
        let body:[String:Any] = [
            "phoneNumber":phoneNumber,
            "verificationNumber":verficationNumber,
            "teamCode":teamCode,
            "name":name,
            "email":email,
            "gender":genderSegment.selectedSegmentIndex,
            "password":password
        ]
        
        Request.postRequest(Url.url, SignAPIs.passengerRegister, body: body) { (data, statusCode) in
            if statusCode == 200 {
                self.navigationController?.pushViewController(pushToPageMapHomeVC, animated: true)
            }
            
            if statusCode == 400 {
                print("YAYAY")
            }
            
        }
        
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

