//
//  UserDefaults.swift
//  Cafe24PlusApp
//
//  Created by 최주영 on 2017. 9. 25..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import Foundation

struct UserDefaultKeys {
    
    /// 간편 검색 툴팁
    static let simpleSearchTooltip = "simpleSearchTooltip"
}


public extension UserDefaults {
    subscript(key: String) -> Any? {
        
        get {
            
            return object(forKey: key) as Any?
        }
        set {
            
            set(newValue, forKey: key)
        }
    }
    
    func date(forKey key: String) -> Date? {
        
        return object(forKey: key) as? Date
    }
    
    func removeObjWithDynamicKey(forKey key: String) {
        
        if let keys = UserDefaults.standard.object(forKey: "dynamicKey") as? [String] {
            
            let saveKeys = keys.filter({ key in
                return key != key
            })
            
            UserDefaults.standard.set(saveKeys, forKey: "dynamicKey")
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        } else {
            UserDefaults.standard.removeObject(forKey: key)
            UserDefaults.standard.synchronize()
        }
    }
    
    /// 동적 키를 갖는 프로퍼티 저장
    ///
    /// - Parameters:
    ///   - data: 저장할 데이터
    ///   - key: 키 값
    func setDataWithDynamicKey(_ data: Any?, forKey key: String) {
        
        if let data = data {
            UserDefaults.standard.set(data, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
        
        UserDefaults.standard.synchronize()
        
        if let keys = UserDefaults.standard.object(forKey: "dynamicKey") as? [String] {
            var keys = keys
            var isExistKey = false
            for tmpKey in keys {
                if key == tmpKey {
                    isExistKey = true
                    break
                }
            }
            
            if isExistKey == false {
                keys.append(key)
            } else {
                keys = keys.filter({ tmpKey in
                    tmpKey == key
                })
            }
            
            UserDefaults.standard.set(keys, forKey: "dynamicKey")
            UserDefaults.standard.synchronize()
        } else {
            let keys = [key]
            UserDefaults.standard.set(keys, forKey: "dynamicKey")
            UserDefaults.standard.synchronize()
        }
        
        
    }
    
    func getDynamicKeys() -> [String]? {
        return UserDefaults.standard.object(forKey: "dynamicKey") as? [String]
    }
}
