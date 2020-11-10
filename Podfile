# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

def common_pods

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'SwiftyJSON', '~> 4.2.0'
  pod 'Kingfisher', '~> 5.3.0'
  
  pod 'Firebase'
  pod 'FirebaseCore'
  pod 'FirebaseMessaging'
  pod 'FirebaseDynamicLinks'
  
  pod 'CoreStore', '~> 7.2'
  pod 'Fabric'
  
  # Add the pod for Firebase Crashlytics
  pod 'Firebase/Crashlytics'
  # Recommended: Add the Firebase pod for Google Analytics
  pod 'Firebase/Analytics'
  pod 'RxAlamofire'

end


target 'TestApp' do
  common_pods
end
