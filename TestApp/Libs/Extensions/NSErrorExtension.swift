//
//  NSErrorExtension.swift
//  Andar
//
//  Created by 최주영 on 2017. 10. 24..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit

// 에러 타입
enum ErrorType {
    /// 얼럿 표시
    case pop
    /// 질문으로 이동
    case move
    /// 전체 에러 페이지 노출
    case page
    /// 토스트 출력
    case toast
    /// 1:1 문의 페이지로 이동
    case qNa
    /// 이미지 팝업
    case popImg
    /// 에러 타입 모름
    case none
    
    init(type: String) {
        switch type.uppercased() {
        case "POP" :
            self = .pop
            break
        case "MOVE" :
            self = .move
            break
        case "PAGE" :
            self = .page
            break
        case "TOAST" :
            self = .toast
            break
        case "QNA" :
            self = .qNa
            break
        case "POPIMG" :
            self = .popImg
            break
        default :
            self = .none
            break
        }
    }
}

struct NSErrorConstant {
    static let customStatusCd = "customStatusCd"
    static let errorType      = "errorType"
    static let imgUrl         = "imgUrl"
    static let linkUrl        = "linkUrl"
}

extension NSError {
    
    convenience init(code: Int, message: String, customStatusCd: Int = 200, errorType: String = "", imgUrl: String = "", linkUrl: String = "") {
        
        
        self.init(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: [ NSLocalizedDescriptionKey: message, NSErrorConstant.customStatusCd: customStatusCd, NSErrorConstant.errorType: ErrorType(type: errorType), NSErrorConstant.imgUrl: imgUrl, NSErrorConstant.linkUrl: linkUrl])
    }
    
    convenience init(code: Int, customStatusCd: Int = 200) {
        
        self.init(domain: Bundle.main.bundleIdentifier!, code: code, userInfo: ["customStatusCd": customStatusCd])
    }
    
    convenience init(domain:String, code: Int, message: String) {
        
        self.init(domain: domain, code: code, userInfo: [ NSLocalizedDescriptionKey: message])
    }
    
    public var errorMsg: String {
        
        return self.userInfo[NSLocalizedDescriptionKey] as? String ?? ""
    }
    
    /// 이미지 URL
    public var imgUrl: String {
        
        return self.userInfo[NSErrorConstant.imgUrl] as? String ?? ""
    }
    
    /// 이미지 팝업 링크
    public var imgPopUpLink: String {
        
        return self.userInfo[NSErrorConstant.linkUrl] as? String ?? ""
    }
    
    /// 에러 타입
    var errorType: ErrorType {
        
        return self.userInfo["errorType"] as? ErrorType ?? .none
    }
    
    /// 스테이터스 코드
    public var customStatusCd: Int? {
        
        return self.userInfo["customStatusCd"] as? Int
    }
    
    public func showMessage(btnTitle: String, callBack: (() -> Void)? = nil) {
        
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            let alert = UIAlertController(title: nil, message: self.errorMsg, preferredStyle: .alert)
            let action = UIAlertAction(title: btnTitle, style: .default, handler: { action in
                callBack?()
            })
            
            alert.addAction(action)
            
            topController.present(alert, animated: true, completion: nil)
        }
    }
    
    /// 기본 토스트 메시지 표시 여부
    public func showDetaultErrorMsgShow() -> Bool {
        if let customStatusCd = self.customStatusCd, customStatusCd > 0 {
            CustomToastMessage.shared.showMessage(self.localizedDescription)
            return true
        } else {
            return false
        }
        
    }
}
