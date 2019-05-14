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



class LoginViewController: UIViewController {
    
    let pushToIdentifierFBSendShortMessageVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FBSendShortMessageVC")
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginAction(_ sender: UIButton) {
        
        guard let username = usernameTextField.text else {return}
        
        guard let password = passwordTextField.text else {return}
        
        let url = "https://staging.ap.gladmobile.com/app/api/passengerlogin"
        
        let body = ["account": username, "password": password]
        
        let pushToPageTwoVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "page2")
        
        //TODO: 忘記密碼 api (以 button 實作)
        
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            
            do {
                let json = try JSON(data: data)
                //TODO: 如果有 Responses 400 裡面的情形，就跳出相對的 alert 提醒使用者
                switch statusCode {
                case 200:
                    
                    guard let success = json["result"]["success"].bool else {
                        print("no success bool")
                        self.alertFunc("錯誤", "請輸入正確帳號密碼", "Ok")
                        return
                    }
                    print(success)
                    self.navigationController?.pushViewController(pushToPageTwoVC, animated: true)
                    
                case 400:
                    if let errResultState1 = json["errResult"][0]["state"].string {

                    }else{
                        print("等等處理")
                    }
                default:
                    print("黑人問號")
                }
                
                
   
                
            }catch{
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func FBLoginButton(_ sender: UIButton) {
        
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [.publicProfile,.email,.userFriends], viewController: self) { (loginResult) in
//            guard let accessToken = AccessToken.current else {return}
            switch loginResult{
            case .failed(let error):
                print(error)
            case .cancelled:
                print("the user cancels login")
            case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                print("user log in")
                
        let url = "https://staging.ap.gladmobile.com/app/api/checkfbverification/{?fbid}"
                
        let body = ["fbToken": token]
                
                Request.postRequest(urlString: url, body: body, callBack: { (data, statusCode) in
                    do{
                        let json = try JSON(data: data)
                        guard let result = json["result"].string else {
                            return
                        }
                        
                    }catch{
                        print(error.localizedDescription)
                    }
                })
//TOOD: 登入成功後，如果此 FB 還尚未註冊，就轉到 FBSendShortMessageViewController 裡面進行註冊
//TODO: 登入成功後，如果此 FB 還尚已註冊，就 call "FB-乘客登入" 這隻 api
                self.navigationController?.pushViewController(self.pushToIdentifierFBSendShortMessageVC, animated: true)
                
            }
        }
    }
    
    
    
}
extension LoginViewController {
    
    func alertFunc(_ controllerTitle: String, _ controllermessage: String, _ actionTitle: String) {
        let alertController = UIAlertController(title: controllerTitle, message: controllermessage, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: actionTitle, style: .default, handler: nil)
            alertController.addAction(alertAction)
       
        present(alertController, animated: true, completion: nil)
    }
}
