//
//  AppDelegate.swift
//  TestApp
//
//  Created by Ethan's MacBook on 2020/11/09.
//

import UIKit

import Firebase
import RxSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
//            Fabric.with([Crashlytics.self])
        /// true : 크러시 데이터 수집, false : 수집하지 않음
        Crashlytics.crashlytics().setCrashlyticsCollectionEnabled(true)
        
        _ = ServerComm.shared.requestJsonData(.post, url: "/etc/checkversion").subscribe(onNext: { json in
            print("json : \(json)")
        }, onError: {error in
            print("error : \(error as NSError)")
        })
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

