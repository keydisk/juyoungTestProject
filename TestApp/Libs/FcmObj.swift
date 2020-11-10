//
//  FcmObj.swift
//  KakaoVXBooking
//
//  Created by jychoi on 2018. 5. 4..
//  Copyright © 2018년 jychoi. All rights reserved.
//

import UIKit
import UserNotifications
import Messages
import AVFoundation

import Firebase
import FirebaseMessaging
import UserNotifications

/** FCM Controller */
class FcmObj: NSObject {
    
    enum PushAuthority: Int {
        case notDetermined
        case denied
        case authorized
    }
    
    public static let gcmMessageIDKey = "gcm.message_id" // gcm message id key
    /// 앱이 실행시 호출
    public static let showPushAlarmView = "showPushAlarmView" // gcm message id key
    let isTopicRegist = "pushTopic"
    public var pushTopic: String {
        
        if Constants.debug {
            return "/topics/KakaoVXDevForIOS"
        } else {
            return "/topics/KakaoVXRealForIOS"
        }
    }
    
    var showPushRegistMsg = true
    public var messageIds:[String: Bool] = [:]
    
    var player: AVAudioPlayer?
    /// Background에 있을때 푸시 수신 데이터를 저장
    public var recieveData:[AnyHashable : Any] = [:]
    
    /// 채팅 토큰 등록 여부 (nil은 없음)
    static var registChattingTokn: Data? {
        get {
            if let regist = UserDefaults.standard.object(forKey: "registChattingTokn") as? Data {
                
                return regist
            }
            
            return nil
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "registChattingTokn")
            UserDefaults.standard.synchronize()
        }
    }
    public static let shared = FcmObj()
    
    /// 강제 푸시 업데이트
    public var recievePermission: Bool { // 최초에 한번이라도 푸시 허용을 받았는지 여부
        
        get {
            
            if let rtnPermission = UserDefaults.standard.object(forKey: "recievePermission") as? Bool {
                
                return rtnPermission
            }
            
            return false
        }
        set {
            
            UserDefaults.standard.set(newValue, forKey: "recievePermission")
            UserDefaults.standard.synchronize()
        }
    }
    
    override init() {
        
        super.init()
    }
    
    /// 알람 허용 메시지
    public func allowAlarmMsg() {
//        let dateText = Date.serverTrustDate.toString(format: "yyyy.MM.dd")
//        CustomToastMessage.shared.showMessage("알림 설정에 수신 동의 처리 되었습니다.\n\(dateText)")
    }
    
    /// 알림 거부
    public func deniedAlarmMsg() {
//        let dateText = Date.serverTrustDate.toString(format: "yyyy.MM.dd")
//        CustomToastMessage.shared.showMessage("알림 설정에 수신 거부 처리 되었습니다.\n\(dateText)")
    }
    
    public func reRegistPush() {
        
        if UserDefaults.standard.object(forKey: "reRegist") == nil {
            
            UNUserNotificationCenter.current().getNotificationSettings {[unowned self] notificationSetting in
                let status = notificationSetting.authorizationStatus
                if status == .authorized || status == .notDetermined {
                    self.showPushRegistMsg = false
                    self.registPushAlarm()
                }
            }
        }
        
    }
    
    /// 디바이스 푸시 토큰
    var devicePushTokn: Data? {
        get {
            return UserDefaults.standard.object(forKey: "pushDeviceTokn") as? Data
        }
        set {
            
            UserDefaults.standard.setDataWithDynamicKey(newValue, forKey: "pushDeviceTokn")
        }
    }
    
    public func registChattingPush() {
        guard let pushTokn = self.devicePushTokn else {
            return
        }
        
    }
    
    /// 푸시 등록
    public func registPush() {
        
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {isConfirm, _ in
            
            if isConfirm {
                
                FcmObj.shared.fcmRegistTopic()
                UIApplication.shared.registerForRemoteNotifications()
            } else {
                
                UIApplication.shared.unregisterForRemoteNotifications()
                
//                if UserData.shared.isLogin {
//                    let settingApis = SettingAPIs()
//                    settingApis.requestSetPush(onOff: false, successCallBack: { json in
//
//                        FcmObj.shared.deniedAlarmMsg()
//                        UserData.shared.pushRegist = true
//                    })
//                }
            }
        })
    }
    
    /** 푸시 등록 */
    func registPushAlarm() {
        
        self.recievePermission = true
        
        FcmObj.shared.getPushNotificationState({ allowPush in
            
            if allowPush == .notDetermined {
                
                self.registPush()
            }
        })
    }
    
    /// 푸시 노티 허용 여부
    public func getPushNotificationState(_ callBack: ((FcmObj.PushAuthority) -> Void)!)  {
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSetting) in
            
            DispatchQueue.main.async(execute: {
                switch notificationSetting.authorizationStatus {
                case .authorized :
                    callBack(.authorized)
                    break
                case .denied :
                    callBack(.denied)
                    break
                case .notDetermined :
                    callBack(.notDetermined)
                    break
                default:
                    callBack(.notDetermined)
                    break
                }
            })
            
        }
    }
    
    /// Push를 수신했을때 데이터 처리
    ///
    /// - Parameter userInfo: 푸시 데이터
    public func pushRecieve(userInfo:[AnyHashable : Any] ) {
        
        FcmObj.shared.recieveData = userInfo
    }
    
    /// 푸시를 중복해서 받는 일이 없게 하기 위한 메소드
    ///
    /// - Parameter userInfo: 푸시발송시 받은 데이터
    /// - Returns: true  <- 중복되지 않은 푸시, false <- 중복된 푸시
    fileprivate func checkMessageId(_ userInfo: [AnyHashable : Any]) -> Bool {
        
        if  let tmpMessageID = userInfo[FcmObj.gcmMessageIDKey] as? String {
            
            if let receivedMessage = FcmObj.shared.messageIds[tmpMessageID], receivedMessage {
                
                return false
            }
            
            FcmObj.shared.messageIds[tmpMessageID] = true
            
            return true
        }
        
        return false
    }
    
    public func fcmRegistTopic() {
        
        Messaging.messaging().subscribe(toTopic: FcmObj.shared.pushTopic) { error in
            guard error == nil else {
                return
            }
            
            UserDefaults.standard.set(true, forKey: FcmObj.shared.isTopicRegist)
            UserDefaults.standard.synchronize()
            
//            Messaging.messaging().subscribe(toTopic: FcmObj.shared.pushTopic )
        }
    }
    
    /// 구독 취소
    public func fcmUnregistTopic() {
        UserDefaults.standard.removeObject(forKey: FcmObj.shared.isTopicRegist)
        UserDefaults.standard.synchronize()
        
        Messaging.messaging().unsubscribe(fromTopic: FcmObj.shared.pushTopic)
    }
        
}

extension FcmObj: UNUserNotificationCenterDelegate {


}

extension FcmObj: MessagingDelegate {
    
    func applicationReceivedRemoteMessage(_ remoteMessage: MessagingRemoteMessage) {
        
//        if Constants.debug {
//            print("Received data message: \(remoteMessage.appData)")
//        }
        #if DEBUG
        print("Received data message: \(remoteMessage.appData)")
        #endif
    }
    
//    // [START refresh_token]
//    func messaging(_ messaging: Messaging, didRefreshRegistrationToken fcmToken: String) {
//
////        print("Firebase registration token: \(fcmToken)")
////        Messaging.messaging().subscribe(toTopic: FcmObj.shared.pushTopic)
//    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Swift.Void) {
        
        let userInfo = notification.request.content.userInfo
        
        if  !FcmObj.shared.checkMessageId(userInfo)  {
            return
        }
        
        if let info = userInfo["aps"] as? [String: Any], let sound = info["sound"] as? String {
            
            let soundFile = sound.components(separatedBy: ".")
            if soundFile.count == 2,
                  let url = Bundle.main.url(forResource: soundFile[0], withExtension: soundFile[1]) {
                
                do {
                    
                    FcmObj.shared.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: nil)
                    FcmObj.shared.player?.prepareToPlay()
                    FcmObj.shared.player?.play()
                } catch _ {
                }
            }
        }
        
        completionHandler(.alert)
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Swift.Void) {
        
        let userInfo = response.notification.request.content.userInfo
        
        // Print full message.
        #if DEBUG
        print(userInfo)
        CustomToastMessage.shared.showMessage("didReceive : \(userInfo)")
        #endif
        
        completionHandler()
    }
    
    //MARK: - Remote notification
    public func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        debugPrint("error : \(error)")
    }
    
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        FcmObj.shared.devicePushTokn = deviceToken
        
        FcmObj.shared.fcmRegistTopic()
        FcmObj.shared.getPushNotificationState({ auth in
            debugPrint("auth : \(auth)")
            
        })
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        if  let sendBirdPayload = userInfo["sendbird"] as? [AnyHashable : Any] {
            if let channelUrl = (sendBirdPayload["channel"] as? [AnyHashable : Any])?["channel_url"] as? String {
                
                if application.applicationState == .active {
                    return
                }
                
                let url = "kakaovxgolf://?type=chatting&url=\(channelUrl)"
            }
        } else {
            if UIApplication.shared.applicationState == .active {
                
                FcmObj.shared.pushRecieve(userInfo: userInfo)
            }
            
        }
            
    }
}


