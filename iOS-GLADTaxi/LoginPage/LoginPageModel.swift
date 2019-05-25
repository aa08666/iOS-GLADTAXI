//
//  LoginPageModel.swift
//  iOS-GLADTaxi
//
//  Created by 柏呈 on 2019/5/22.
//  Copyright © 2019 柏呈. All rights reserved.
//

import Foundation

struct Login: Codable {
    let result: Result
}


struct Result: Codable {
    let success: Bool
    let teamCode, message, token: String
}
