//
//  Constants.swift
//  TestApp
//
//  Created by Ethan's MacBook on 2020/11/09.
//

import Foundation

struct Constants {
    
    static let debug = true
    static var serverCommPrefix: String {
        
        if Constants.debug {
            return "https://appapi-dev.kakao.golf"
        } else {
            return "https://appapi.kakao.golf"
        }
    }
    
    
}
