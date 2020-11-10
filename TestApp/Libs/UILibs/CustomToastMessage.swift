//
//  CustomToastMessage.swift
//  Pays
//
//  Created by jychoi on 2016. 11. 25..
//  Copyright © 2016년 jychoi. All rights reserved.
//

import Foundation
import UIKit

/** 토스트메시지 */
class CustomToastMessage: UIView {
    
    public static let shared = CustomToastMessage()
    
    public func showMessage(_ showMessage:String ) {
        
        DispatchQueue.main.async {
            
            let window = UIApplication.shared.keyWindow
            
            self.translatesAutoresizingMaskIntoConstraints = false;
            
            let font     = UIFont.systemFont(ofSize: 15)
            let textView = UILabel()
            let baseView = UIView()
            
            textView.backgroundColor = UIColor(white:0.3, alpha: 1.0);
            baseView.backgroundColor = UIColor(white:0.3, alpha: 1.0);
            
            textView.textColor = .white;
            textView.font = font;
            textView.textAlignment = NSTextAlignment.center;
            textView.text = showMessage;
            textView.numberOfLines = 0;
            
            baseView.translatesAutoresizingMaskIntoConstraints = false;
            textView.translatesAutoresizingMaskIntoConstraints = false;
            
            baseView.addSubview(textView);
            window?.addSubview(baseView);
            
            window?.addSubview(self);
            
            let textViewCenterX = NSLayoutConstraint(item:textView, attribute:.centerX, relatedBy:.equal,           toItem:baseView, attribute:.centerX, multiplier: 1.0, constant: 0.0);
            let textViewCenterY = NSLayoutConstraint(item:textView, attribute:.centerY, relatedBy:.equal,           toItem:baseView, attribute:.centerY, multiplier: 1.0, constant: 0.0);
            let textViewWidth   = NSLayoutConstraint(item:textView, attribute:.width,   relatedBy:.lessThanOrEqual, toItem:window,   attribute:.width,   multiplier: 0.8, constant: 0.0);
            
            // baseView layout
            let baseViewXCenter = NSLayoutConstraint(item:baseView, attribute:.centerX, relatedBy:.equal,              toItem:window,   attribute:.centerX, multiplier: 1.0, constant: 0.0);
            let baseViewYLoc    = NSLayoutConstraint(item:baseView, attribute:.centerY, relatedBy:.equal,              toItem:window,   attribute:.centerY, multiplier: 1.7, constant: 0.0);
            let baseViewWidth   = NSLayoutConstraint(item:baseView, attribute:.width,   relatedBy:.greaterThanOrEqual, toItem:textView, attribute:.width,   multiplier: 1.0, constant:20.0);
            let baseViewHeight  = NSLayoutConstraint(item:baseView, attribute:.height,  relatedBy:.equal,              toItem:textView, attribute:.height,  multiplier: 1.2, constant:10.0);
            
            window?.addConstraints([baseViewXCenter, baseViewYLoc, baseViewWidth, baseViewHeight, textViewWidth]);
            baseView.addConstraints([textViewCenterX, textViewCenterY])
            
            baseView.cornerRadius = 10.0
            
            self.alpha     = 0.0;
            baseView.alpha = 0.0;
            
            // animation start
            CATransaction.begin();
            
            // 완료시 호출.
            CATransaction.setCompletionBlock {
                
                self.alpha     = 0.0;
                baseView.alpha = 0.0;
                
                baseView.isHidden = true;
                textView.isHidden = true;
                
                baseView.removeFromSuperview();
            };
            
            let animationOpacity = CAKeyframeAnimation(keyPath:"opacity")
            
            animationOpacity.duration = 3
            
            animationOpacity.values   = [NSNumber(value:1.0), NSNumber(value:0.0)];
            animationOpacity.keyTimes = [NSNumber(value:0.0), NSNumber(value:1.0)];
            
            animationOpacity.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeIn);
            baseView.layer.add(animationOpacity, forKey:"opacity");
        }
    }
}
