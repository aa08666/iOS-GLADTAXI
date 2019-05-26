//
//  LoginViewController.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 LIN,BO-CHENG on 2019/4/16.
//  Copyright © 2019 柏呈. LIN,BO-CHENG All rights reserved.
//

import UIKit
import SwiftyJSON
import FacebookCore
import FacebookLogin


/**
 點擊 一般登入按鈕：
 如果此帳號(手機號碼)還尚未註冊，就跳 alert 提醒使用者尚未註冊
 如果此帳號(手機號碼)已註冊，就登入到 mapHome page
 */
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    let pushToIdentifierFBSendShortMessageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FBSendShortMessageVC")
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
       
        
        let body = ["account": username, "password": password, "register":"1"]
        
        let pushToPageMapHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapHome")
       
        Request.postRequest(Url.url, LoginAPIs.passengerLogin, body: body) { (data, statusCode) in
            
            if statusCode == 200 {
                
                do {
                    let json = try JSON(data: data)
                    if let success = json["result"]["success"].bool {
                        if success == true {
                            self.navigationController?.pushViewController(pushToPageMapHomeVC, animated: true)
                        }else{
                            print("解析失敗")
                        }
                    }
                    
                }catch{
                    print(error.localizedDescription)
                }
            }
            
            if statusCode == 400 {
                print("400")
            }
            

            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) 
    }
    
    /**
     點擊 FB 登入按鈕：
     如果此 FB 還尚未註冊，就轉到 FBSendShortMessageViewController 裡面進行註冊
     如果此 FB 還已註冊，就 call "FB-乘客登入" api 並轉入到 mapHome
     */
    @IBAction func FBLoginButton(_ sender: UIButton) {
     
        FacebookLogin.login(self)
        
    }
    //TODO: 忘記密碼 api (以 button 實作)
    
    
}
extension LoginViewController {
    
    func alertFunc(_ controllerTitle: String, _ controllermessage: String, _ actionTitle: String) {
        let alertController = UIAlertController(title: controllerTitle, message: controllermessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
        alertController.addAction(alertAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
