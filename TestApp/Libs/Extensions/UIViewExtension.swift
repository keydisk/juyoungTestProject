//
//  UIViewExtension.swift
//  Cafe24PlusApp
//
//  Created by 최주영 on 2017. 9. 14..
//  Copyright © 2017년 jychoi04_T1. All rights reserved.
//

import UIKit

extension UIView
{
    public var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }
    
    public var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }
    
    public var w: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    public var h: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    public var width: CGFloat {
        get {
            return frame.size.width
        }
        set {
            frame.size.width = newValue
        }
    }
    
    public var height: CGFloat {
        get {
            return frame.size.height
        }
        set {
            frame.size.height = newValue
        }
    }
    
    var top: CGFloat {
        get {
            return self.frame.origin.y
        }
        set {
            self.frame.origin.y = newValue
        }
    }
    
    var left: CGFloat {
        get {
            return self.frame.origin.x
        }
        set {
            self.frame.origin.x = newValue
        }
    }
    
    var bottom: CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
        set {
            self.frame.origin.y = newValue - self.frame.size.height
        }
    }
    
    var right: CGFloat {
        get {
            return self.frame.origin.x + self.frame.size.width
        }
        set {
            self.frame.origin.x = newValue - self.frame.size.width
        }
    }
    
    public var origin: CGPoint {
        get {
            return self.frame.origin
        } set(value) {
            self.frame = CGRect(origin: value, size: self.frame.size)
        }
    }
    
    public var size: CGSize {
        get {
            return self.frame.size
        } set(value) {
            self.frame = CGRect(origin: self.frame.origin, size: value)
        }
    }
    
    public var centerX: CGFloat {
        get {
            return self.center.x
        } set(value) {
            self.center.x = value
        }
    }
    
    public var centerY: CGFloat {
        get {
            return self.center.y
        } set(value) {
            self.center.y = value
        }
    }
    
    /// 코너 레디어스
    public var cornerRadius: CGFloat {
        get {
            return self.layer.cornerRadius
        }
        set (value) {
            self.layer.cornerRadius = value
        }
    }
    
    /// 보더 컬러
    public var borderColor: UIColor? {
        get {
            guard let cgColor = self.layer.borderColor else {
                
                return nil
            }
            
            let layerBorderColor = UIColor(cgColor: cgColor)
            return layerBorderColor
        }
        set {
            if self.layer.borderWidth < 1 {
                self.layer.borderWidth = 1
            }
            
            self.layer.borderColor = newValue?.cgColor
        }
    }
    
    /// 보더 넓이
    public var borderWidth: CGFloat {
        get {
            
            return self.layer.borderWidth
        }
        set {
            
            self.layer.borderWidth = newValue
        }
    }
    
    /// 레이어 백그라운드 컬러
    public var layerBackgroundColor: UIColor? {
        get {
            guard let cgColor = self.layer.backgroundColor else {
                
                return nil
            }
            
            let layerBorderColor = UIColor(cgColor: cgColor)
            return layerBorderColor
        }
        set {
            self.layer.backgroundColor = newValue?.cgColor
        }
    }
    
    /// targetView가 보이는지 여부 (targetView가 baseView보다 크기가 작을때)
    /// - Parameters:
    ///   - baseView: targetView가 올라가 있는 뷰가 @objc 그려진 위치
    ///   - targetView: 현재 위치
    /// - Returns: 보이는 비율 0 ~ 100
    static func visibleViewRate(baseView: CGRect, targetView: CGRect) -> Int {
        
        let baseX = baseView.origin.x
        let baseX2 = baseView.origin.x + baseView.size.width
        let baseY = baseView.origin.y
        let baseY2 = baseView.origin.y + baseView.size.height
        
        let targetX = targetView.origin.x
        let targetX2 = targetX + targetView.size.width
        let targetY = targetView.origin.y
        let targetY2 = targetY + targetView.size.height
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        
        if baseX < targetX && targetX < baseX2 {
            if baseX2 < targetX2 {
                width = baseX2 - targetX
            } else {
                width = targetView.size.width
            }
        } else if targetX2 < baseX2 && targetX2 > baseX {
            
            width = targetX2 - baseX
        } else if baseX == targetX && targetX2 == baseX2 {
            width = targetX + targetX2
        }
        
        if baseY < targetY && targetY < baseY2 {
            
            if baseY2 < targetY2 {
                height = baseY2 - targetY
            } else {
                height = targetView.size.height
            }
        } else if targetY < baseY && targetY2 < baseY2 {
            height = targetY2 - baseY
        } else if baseY == targetY && targetY2 == baseY2 {
            height = targetY + targetY2
        }
//        debugPrint("visibleViewRate width : \(width) height : \(height) targetView.size : \(targetView.size)")
        width  = width  < 1 ? 1 : width
        height = height < 1 ? 1 : height
        let targetWidth  = targetView.size.width  < 1 ? 1 : targetView.size.width
        let targetHeight = targetView.size.height < 1 ? 1 : targetView.size.height
        
        return Int( ((width * height) / (targetWidth * targetHeight) ) * 100 )
    }
    
    var globalFrame: CGRect? {
        let rootView = UIApplication.shared.keyWindow?.rootViewController?.view
        return self.superview?.convert(self.frame, to: rootView)
    }
}

extension UIView
{
    public func centerXInSuperview() {
        if let parentView = superview {
            self.x = parentView.w/2 - self.w/2
        }
    }
    
    public func centerYInSuperview() {
        if let parentView = superview {
            self.y = parentView.h/2 - self.h/2
        }
    }
    
    public func centerInSuperview() {
        
        self.centerXInSuperview()
        self.centerYInSuperview()
    }
    
    public func addSubviews(views: UIView...) {
        
        views.forEach { addSubview($0) }
    }
    
    public func removeAllSubviews() {
        
        subviews.forEach { $0.removeFromSuperview() }
    }
    
    public func superview<T>(of type: T.Type) -> T? {
        return superview as? T ?? superview.flatMap { $0.superview(of: type) }
    }
    
    /// view를 이미지로 변경
    ///
    /// - Returns: 변경된 이미지
    func viewConvertImg() -> UIImage? {
        
        if #available(iOS 10.0, *) {
            
            let renderer = UIGraphicsImageRenderer(bounds: self.bounds)
            
            return renderer.image { rendererContext in
                
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            
            UIGraphicsBeginImageContext(self.bounds.size)
            
            self.layer.render(in: UIGraphicsGetCurrentContext()!)
            
            if let image = UIGraphicsGetImageFromCurrentImageContext() {
                
                UIGraphicsEndImageContext()
                
                let rtnImg = image.resizedImage(self.bounds.size)
                return rtnImg
            }
            
            return nil
        }
    }
    
    /// 화면 회전
    ///
    /// - Parameters:
    ///   - degree: 회전 각도
    ///   - animated: 애니메이션 여부
    ///   - duration: 애니메이션 시간
    ///   - completion: 에니메이션 완료 여부 리턴
    public func rotate(toDegree degree: CGFloat, animated: Bool = false, duration: TimeInterval = 0.25, completion:((Bool) -> Void)? = nil) {
        
        let angle = CGFloat.pi * degree / 180.0
        let aDuration = animated ? duration : 0
        UIView.animate(withDuration: aDuration, animations: {
            self.transform = self.transform.concatenating(CGAffineTransform(rotationAngle: angle))
        }, completion: completion)
    }
    
    /// 뷰 위에 박스를 그려주는 메소드
    ///
    /// - Parameters:
    ///   - rect: 박스의 범위
    ///   - lineWidth: 라인 두께(박스의 바깥쪽으로 늘어 난다)
    ///   - strokeColor: 라인 색
    ///   - fillColor: 박스 채우기 색
    /// - Returns: 박스 레이어 객체
    public func drawRectOnView(rect: CGRect, lineWidth: CGFloat, strokeColor: CGColor, fillColor: CGColor) -> CAShapeLayer {
        
        let rectPath = UIBezierPath(rect: rect)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = rectPath.cgPath
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth   = lineWidth
        shapeLayer.fillColor   = fillColor
        
        self.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    public func drawShadow(withoutBorder: Bool = false, shadowOffset: CGSize = CGSize(width: 5, height: 0), shadowColor: UIColor? = nil) {
        
        self.layer.borderWidth  = 1
        self.layer.shadowOpacity = 1
        if withoutBorder == false {
            self.layer.borderColor  = UIColor.RGB(229, 229, 229).cgColor
        }
        
        self.layer.shadowOffset = shadowOffset
        self.layer.masksToBounds = false
        if let shadowColor = shadowColor {
            self.layer.shadowColor = shadowColor.cgColor
        } else {
            self.layer.shadowColor = UIColor.RGBA(0, 0, 0, 12).cgColor
        }
        
    }
    
    /// 뷰 닫기
    ///
    /// - Parameters:
    ///   - durationTime: 에니메이션 시간
    ///   - animationType: 애니메이션 콜백
    public func closeView(durationTime: TimeInterval = 0.2, animationType: @escaping( () -> Void ), isComplete: (() -> Void)? = nil) {
        
        UIView.animate(withDuration: durationTime, animations: { () in
            
            animationType()
        }, completion: {[weak self] complete in
            isComplete?()
            self?.removeFromSuperview()
        })
    }
    
    /// 뷰를 원으로 만든다
    public func setCircleView() {
        
        self.clipsToBounds      = true
        self.layer.cornerRadius = self.frame.size.height / 2
    }
    
    /// 특정 코너 라운드 설정
    ///
    /// - Parameters:
    ///   - corners: 코너 설정
    ///   - radius: 라운드 포인트
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        
        let path = UIBezierPath(roundedRect: self.frame, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        
        self.layer.mask = mask
    }
    
    /// 라운드 사각형을 그리기 위한 메소드
    ///
    /// - Parameters:
    ///   - center: 현재 뷰의 상대적인 중심
    ///   - size: 현재 뷰의 크기
    ///   - corner: 코너 크기
    /// - Returns: 배지어 패스
    func roundedPathAtCenter(_ center: CGPoint, size: CGSize, corner: CGFloat) -> UIBezierPath {
        
        let width  = size.width
        let height = size.height
        
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: center.x - width / 2.0 + corner / 2.0, y: center.y - height / 2.0 + corner / 2.0))
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y - height / 2.0), controlPoint: CGPoint(x: center.x - width / 2.0 + corner, y: center.y - height / 2.0))
        path.addQuadCurve(to: CGPoint(x: center.x + width / 2.0 - corner / 2.0, y: center.y - height / 2.0 + corner / 2.0), controlPoint: CGPoint(x: center.x + width / 2.0 - corner, y: center.y - height / 2.0))
        
        // path to upper right
        path.addQuadCurve(to: CGPoint(x: center.x + width / 2.0 - corner / 2.0, y: center.y - height / 2.0 + corner / 2.0), controlPoint: CGPoint(x: center.x + width / 2.0 - corner, y: center.y - height / 2.0) )
        // path to mid right
        path.addQuadCurve(to: CGPoint(x: center.x + width / 2.0, y: center.y), controlPoint: CGPoint(x: center.x + width / 2.0, y: center.y - height / 2.0 + corner) );
        // path to lower right
        path.addQuadCurve(to: CGPoint(x: center.x + width / 2.0 - corner / 2.0, y: center.y + height / 2.0 - corner / 2.0), controlPoint: CGPoint(x: center.x + width / 2.0, y: center.y + height / 2.0 - corner) )
        // path to center bottom
        path.addQuadCurve(to: CGPoint(x: center.x, y: center.y + height / 2.0), controlPoint: CGPoint(x: center.x + width / 2.0 - corner, y: center.y + height / 2.0));
        // path to lower left
        path.addQuadCurve(to: CGPoint(x: center.x - width / 2.0 + corner / 2.0, y: center.y + height / 2.0 - corner / 2.0), controlPoint: CGPoint(x: center.x - width / 2.0 + corner, y: center.y + height / 2.0) )
        // path to mid left
        path.addQuadCurve(to: CGPoint(x: center.x - width / 2.0, y: center.y), controlPoint: CGPoint(x: center.x - width / 2.0, y: center.y + height / 2.0 - corner))
        // path to top left
        path.addQuadCurve(to: CGPoint(x: center.x - width / 2.0 + corner / 2.0, y: center.y - height / 2.0 + corner / 2.0), controlPoint: CGPoint(x: center.x - width / 2.0, y: center.y - height / 2.0 + corner))
        path.close()
        
        return path
    }
    
    
    /// 뷰에 라인을 그린다
    ///
    /// - Parameters:
    ///   - startPoint: 시작 좌표
    ///   - endPoint: 끝나는 좌표
    ///   - thick: 선의 두께
    ///   - lineColor: 라인의 색
    ///   - lineFillColor: 라인을 채우는 색
    /// - Returns: 라인 객체
    func drawLine(startPoint: CGPoint, endPoint: CGPoint, thick:CGFloat, lineColor: UIColor, lineFillColor: UIColor) -> CAShapeLayer {
        
        let path = UIBezierPath()
        
        path.move(to: startPoint)
        path.addLine(to: endPoint)
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.path = path.cgPath;
        shapeLayer.strokeColor = lineColor.cgColor
        shapeLayer.lineWidth = thick
        shapeLayer.fillColor = lineFillColor.cgColor
        
        self.layer.addSublayer(shapeLayer)
        
        return shapeLayer
    }
    
    func parentView<T: UIView>(of type: T.Type) -> T? {
        guard let view = self.superview else {
            return nil
        }
        return (view as? T) ?? view.parentView(of: T.self)
    }
    
    func mask(withRect rect: CGRect, inverse: Bool = false) {
        let path = UIBezierPath(rect: rect)
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }

    func mask(withPath path: UIBezierPath, inverse: Bool = false) {
        
        let maskLayer = CAShapeLayer()

        if inverse {
            path.append(UIBezierPath(rect: self.bounds))
            maskLayer.fillRule = CAShapeLayerFillRule.evenOdd
        }

        maskLayer.path = path.cgPath

        self.layer.mask = maskLayer
    }
    
}
