//
//  FBLoginModel.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/5/26.
//  Copyright © 2019 柏呈. All rights reserved.
//

import Foundation
import UIKit
import FacebookCore
import FacebookLogin
import SwiftyJSON

    struct FacebookLogin {
        
        static func login(_ viewController: UIViewController) {
            
            
            let loginManager = LoginManager()
            loginManager.logIn(readPermissions: [.publicProfile,.email,.userFriends], viewController: viewController) { (loginResult) in
                
                switch loginResult{
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("the user cancels login")
                case .success(grantedPermissions: _, declinedPermissions: _, token: let token):
                    print("user log in")
                    
                    let pushToMapHomeViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapHome")
                    
                    let body = ["fbToken": token.authenticationToken]
                    
                    func test() {
                        // 判斷此 FB 帳號是否註冊，200：已註冊 400：尚未註冊
                        Request.postRequest(Url.url, LoginAPIs.checkFBVerification, body: body, callBack: { (data, statusCode) in
                            
                            
                            if statusCode == 200 {
                                Request.postRequest(Url.url, LoginAPIs.fbPassengerLogin, body: body, callBack: { (data, statusCode) in
                                    if statusCode == 200 {
                                        
                                    }
                                })
                                
                            }
                            
                            if statusCode == 400 {
                                do{
                                    let json = try JSON(data: data)
                                    
                                    if  let errResultState = json["errResult"][0]["state"].string {
                                        print(errResultState)
                                        
                                    } else{
                                        
                                        print("errResultState1 解析失敗")
                                        return
                                    }
                                    
                                }catch{
                                    
                                }
                            }
                            
                        })
                    }
                    
                    
                    
                    
                }
            }
            
        }
        
    }


