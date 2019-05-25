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
        
        let url = "https://staging.ap.gladmobile.com/app/api/passengerlogin"
        
        let body = ["account": username, "password": password, "register":"1"]
        
        let pushToPageMapHomeVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapHome")
       
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            
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
        let pushToMapHomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapHome")
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email,.userFriends], viewController: self) { (loginResult) in
            
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("the user cancels login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                print("user log in")
                
                let checkFBUrl = "https://staging.ap.gladmobile.com/app/api/checkfbverification/{?fbid}"
                
                let fbLoginUrl = "https://staging.ap.gladmobile.com/app/api/fblogin/{?fbid}"
                
                
                
                let body = ["fbToken": token]
                
                //FIXME: ["fbToken": token] 後面那個 token 應該改成 fb userID
                Request.postRequest(urlString: checkFBUrl, body: body, callBack: { (data, statusCode) in
                    switch statusCode {
                    // FB 已有註冊
                    case 200:
                        do{
                            let json = try JSON(data: data)
                            guard let registerSuccess = json["result"].string else {
                                print("registerSuccess 解析失敗")
                                return
                            }
                            print(registerSuccess)
                            
                            // FB 登入
                            Request.postRequest(urlString: fbLoginUrl, body: body, callBack: { (data, statusCode) in
                                do{
                                    let json = try JSON(data: data)
                                    if let success = json["result"]["success"].bool {
                                        self.navigationController?.pushViewController(pushToMapHomeViewController, animated: true)
                                        print(success)
                                    }else{
                                        print("success 解析失敗")
                                        
                                    }
                                }catch{
                                    
                                }
                            })
                            
                        }catch{
                            print(error.localizedDescription)
                        }
                    // FB 尚未註冊
                    case 400:
                        do{
                            let json = try JSON(data: data)
                            // 失敗，因為該FB帳號尚未註冊
                            if  let errResultState = json["errResult"][0]["state"].string {
                                print(errResultState)
                                self.navigationController?.pushViewController(self.pushToIdentifierFBSendShortMessageVC, animated: true)
                            } else{
                                
                                print("errResultState1 解析失敗")
                                return
                            }
                            
                        }catch{
                            
                        }
                    default:
                        print("程式怎麼會跑到這邊來!!!")
                    }
                    
                })
                
                
                
            }
        }
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
