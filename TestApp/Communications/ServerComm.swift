//
//  ServerComm.swift
//  TestApp
//
//  Created by Ethan's MacBook on 2020/11/09.
//

import Foundation

import SwiftyJSON
import RxAlamofire
import Alamofire

import RxSwift

//public enum HTTPMethod: String {
//    case options = "OPTIONS"
//    case get     = "GET"
//    case head    = "HEAD"
//    case post    = "POST"
//    case put     = "PUT"
//    case patch   = "PATCH"
//    case delete  = "DELETE"
//    case trace   = "TRACE"
//    case connect = "CONNECT"
//}
//

class ServerComm {
  
    static let shared = ServerComm()
    let commonHeader: [String: String]
//    let session: URLSession
    
    init() {
        
        self.commonHeader = ["deviceId": UIDevice.current.uuid ?? "", "appVer": UIDevice.appVersion, "device": UIDevice.modelName, "OSVersion": UIDevice.current.systemVersion, "Content-Type": "application/json"]
        
//        self.session = URLSession.shared
//
//        self.session.rx
//            .response(.get, "https://www.naver.com")
//            .observeOn(MainScheduler.instance)
//            .subscribe { print($0) }
        
    }
    
    func requestCommonInfo(request: inout URLRequest, addHeaderInfo: [String: String] = [:] ) {
        
        for key in self.commonHeader.keys {
            
            if let value = self.commonHeader[key] {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        for key in addHeaderInfo.keys {
            if let value = addHeaderInfo[key] {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
    }
    
    func requestJsonData(_ method: HTTPMethod, url: String) -> Observable<JSON> {
        let requestUrl = Constants.serverCommPrefix.appending(url)
        var request = URLRequest(url: URL(string: requestUrl)!)
        //Following code to pass post json
//        request.httpBody = "".data(using: .utf8)
        #if DEBUG
        print("request : \(request)")
        #endif
        switch method {
        case .post :
            request.httpMethod = "POST"
            break
        default :
            request.httpMethod = "GET"
            break
        }
        
        self.requestCommonInfo(request: &request)
        
        return RxAlamofire.request(request as URLRequestConvertible).observeOn(SerialDispatchQueueScheduler(qos: .default)).validate(statusCode: 200..<300).flatMap({request -> Observable<JSON> in
            
            request.rx.data().map({data -> JSON in
                let json = JSON(data)
                print("json : \(json)")
                return json
            })
        })

    }
}
