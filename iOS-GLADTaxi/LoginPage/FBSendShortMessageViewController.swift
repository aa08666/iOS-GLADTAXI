//
//  FBSendShortMessageViewController.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/5/13.
//  Copyright © 2019 柏呈. All rights reserved.
//

import UIKit
import SwiftyJSON


class FBSendShortMessageViewController: UIViewController {
    
    @IBOutlet weak var sendShortMessageTextField: UITextField!
    
    @IBOutlet weak var verificationNumberTextField: UITextField!

    @IBOutlet weak var teamCodeNumberTextField: UITextField!
    
    
    @IBAction func SendShortMessageButton(_ sender: UIButton) {
        
        guard let sendShortMessage = sendShortMessageTextField.text else {return}
        
        let url = "https://staging.ap.gladmobile.com/app/api/sendfbshortmessage/{?fbid}"
        
        let body = [ "phoneNumber": sendShortMessage]
        
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            
            do{
                let json = try JSON(data: data)
                guard let result = json["result"].string else {
                    print("can't receive")
                    return
                }
                print(result)
                
                
                
            }catch{
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    @IBAction func FBRegisterButton(_ sender: UIButton) {
        //TODO: call "FB-乘客註冊" api
        guard let sendShortMessage = sendShortMessageTextField.text else {return}
        guard let verificationNumber = verificationNumberTextField.text else {return}
        guard let teamCodeNumber = teamCodeNumberTextField.text else {return}
        
        let url = "https://staging.ap.gladmobile.com/app/api/fbregister/{?fbid}"
        
        let body = ["phoneNumber":sendShortMessage, "verificationNumber":verificationNumber,"teamCode":teamCodeNumber]
        Request.postRequest(urlString: url, body: body) { (data, statusCode) in
            do{
                
            }catch{
                print(error.localizedDescription)
            }
        }
        //TODO: 成功就跳到地圖頁面
        //TODO: 失敗就跳 alert 出來提醒使用者註冊程序哪邊錯誤
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    


}
