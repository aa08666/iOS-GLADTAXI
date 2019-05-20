//
//  URLRequest.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/4/16.
//  Copyright © 2019 柏呈. All rights reserved.
//

import Foundation

struct Request {
   
    // GET
    static func getRequest(api:String, callBack: @escaping (_ data: Data, _ statusCode: Int) -> Void){
        
        guard let url = URL(string:  api) else {
            print("Error: cannot create URL")
            return
        }
        
        var urlRequest = URLRequest(url: url)
        
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                print("error calling GET")
                print(error!)
                return
            }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else { return }
            
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            
            callBack(data, httpUrlResponse.statusCode)
        }
        task.resume()
    }
    
    // POST
    static func postRequest(urlString: String, body: [String:Any], callBack: @escaping (_ data: Data, _ statusCode: Int) -> Void){
        
        guard let url = URL(string: urlString) else {return}
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
        }catch{
            print(error)
        }
        
        urlRequest.httpMethod = "POST"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, respose, error) in
            guard  error == nil else {
                //TODO: 判斷 statusCode 處理錯誤
                print("error calling POST")
                print(error!)
                return
            }
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            guard let httpUrlResponse = respose as? HTTPURLResponse else {return}
            
            callBack(data, httpUrlResponse.statusCode )
        }
        task.resume()
    }
    
    // DELETE
    static func deleteRequest(api:String, header:[String:String], body: [String: Any], callBack: @escaping (_ data: Data, _ statusCode: Int) -> Void){
        
        guard let url = URL(string:  api) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {

            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions())
            
            urlRequest.httpMethod = "DELETE"
            
            let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
                
            guard error == nil else { return }
                
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
                
            guard let httpUrlResponse = response as? HTTPURLResponse else { return }
                
                callBack(data, httpUrlResponse.statusCode)
            }
            task.resume()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    //PUT
    static func putRequest(api:String, header:[String:String], callBack: @escaping (_ data: Data, _ statusCode: Int) -> Void){
        
        guard let url = URL(string:  api) else { return }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        urlRequest.httpMethod = "PUT"
        
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else { return }
            
            guard let httpUrlResponse = response as? HTTPURLResponse else { return }
            
            guard let data = data else {
                print("Error: did not receive data")
                return
            }
            
            
            callBack(data, httpUrlResponse.statusCode)
        }
        task.resume()
    }

}
//struct Request {
//    static func a(callback:(Result<(Data,Int),Error>)->Void){
//        enum E:Error{case A,B}
//        callback(.failure(E.A))
//    }
//class aasd  {
//    func sad() {
//        Request.a { (<#Result<(Data, Int), Error>#>) in
//            <#code#>
//        }
//        Request.a(anyRequest: .init(url: <#T##URL#>))
//            { (result) in
//            switch result{
//
//            case .success( let d):
//                d
//            case .failure(let e):
//                e.
//            }
//        }
//    }
//}

