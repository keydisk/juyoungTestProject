//
//  UIImageExtension.swift
//  KakaoVXBooking
//
//  Created by jychoi on 2019/12/19.
//  Copyright © 2019 jychoi. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

extension UIImage {
    
    /// 카메라로 찍은 사진 원래대로 돌리기
    var photoBookFixOrientation: UIImage? {
        // No-op if the orientation is already correct
        
        if self.imageOrientation == .up {
            return self
        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform = CGAffineTransform.identity

        if (imageOrientation == .down || imageOrientation == .downMirrored) {

            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        }

        if (imageOrientation == .left
            || imageOrientation == .leftMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat(Double.pi / 2))
        }

        if (imageOrientation == .right
            || imageOrientation == .rightMirrored) {

            transform = transform.translatedBy(x: 0, y: size.height);
            transform = transform.rotated(by: CGFloat(-(Double.pi / 2)));
        }

        if (imageOrientation == .upMirrored
            || imageOrientation == .downMirrored) {

            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        }

        if (imageOrientation == .leftMirrored
            || imageOrientation == .rightMirrored) {

            transform = transform.translatedBy(x: size.height, y: 0);
            transform = transform.scaledBy(x: -1, y: 1);
        }


        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)


        if (imageOrientation == .left
            || imageOrientation == .leftMirrored
            || imageOrientation == .right
            || imageOrientation == .rightMirrored
            ) {


            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))

        } else {
            ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.width,height:size.height))
        }


        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
    
    var fixOrientation: UIImage? {
        // No-op if the orientation is already correct
        
//        if self.imageOrientation == .up {
//            return self
//        }

        // We need to calculate the proper transformation to make the image upright.
        // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
        var transform:CGAffineTransform = CGAffineTransform.identity

        transform = transform.translatedBy(x: 0, y: size.height);
        transform = transform.rotated(by: CGFloat(-(Double.pi / 2)));

        // Now we draw the underlying CGImage into a new context, applying the transform
        // calculated above.
        let ctx = CGContext(data: nil, width: Int(size.width), height: Int(size.height),
                                      bitsPerComponent: cgImage!.bitsPerComponent, bytesPerRow: 0,
                                      space: cgImage!.colorSpace!,
                                      bitmapInfo: cgImage!.bitmapInfo.rawValue)!

        ctx.concatenate(transform)
        ctx.draw(cgImage!, in: CGRect(x:0,y:0,width:size.height,height:size.width))
        
        // And now we just create a new UIImage from the drawing context
        let cgimg:CGImage = ctx.makeImage()!
        let imgEnd:UIImage = UIImage(cgImage: cgimg)

        return imgEnd
    }
    
    
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            return rotatedImage ?? self
        }

        return self
    }
    
    /// 이미지를 데이터로 변환하여 리턴 (nil은 변환 실패)
    public var imgData: Data? {
        
        return self.pngData() ?? self.jpegData(compressionQuality: 1.0)
    }
    
    /// 이미지 리사이징
    ///
    /// - Parameters:
    ///   - inRect: 이미지 크기
    ///   - opaque: 투명 여부
    /// - Returns: 리사이징된 이미지
    public func resizedImage(_ inRect:CGSize, opaque:Bool = false) -> UIImage {
        
        let scale = UIScreen.main.scale;
        
        UIGraphicsBeginImageContextWithOptions(inRect, opaque, scale);
        
        if !opaque {
            
            UIGraphicsGetCurrentContext()?.interpolationQuality = .none
        }
        
        self.draw(in: CGRect(x:0, y:0, width:inRect.width, height:inRect.height));
        let newImg = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return newImg;
    }
    
    
    /// 이미지 스트레처블
    ///
    /// - Parameters:
    ///   - width: 늘릴 이미지 넓이
    ///   - height: 늘릴 이미지 높이
    /// - Returns: 스트레처블된 이미지
    
    /// 이미지 스트레처블
    ///
    /// - Parameters:
    ///   - width: 늘릴 이미지 넓이
    ///   - height: 늘릴 이미지 높이
    /// - Returns: 스트레처블된 이미지
    public func stretchableImg(width:CGFloat, height:CGFloat ) -> UIImage {
        var rtnImg = self.resizedImage(CGSize(width:width, height:height));
        
        rtnImg = rtnImg.resizableImage(withCapInsets: UIEdgeInsets(top: (height / 2), left: 0, bottom: (height / 2), right: width ), resizingMode: .stretch)
        
        return rtnImg
    }
    
    
    /// CIImage를 UIImage로 만들어 주는 메소드
    ///
    /// - Parameters:
    ///   - aCIImage: ci image
    ///   - anOrientation: 회전
    /// - Returns: 이미지
    public static func imageWithCGImage(aCIImage:CIImage?, anOrientation: UIImage.Orientation) -> UIImage? {
        guard let aciImg = aCIImage else {
            
            return nil
        }
        
        let imageRef: CGImage = CIContext(options: nil).createCGImage(aciImg, from: aciImg.extent)!
        let image   = UIImage(cgImage: imageRef, scale: 1.0, orientation: anOrientation)
        
        return image
    }
    
    /// 이미지 자르기 메소드
    ///
    /// - Parameter rect: 이미지를 자를 범위
    /// - Returns: 잘린 이미지
    public func cropImage(toRect rect:CGRect) -> UIImage? {
        
        if let imageRef     = self.cgImage?.cropping(to: rect) {
            let croppedImage = UIImage(cgImage:imageRef)
            
            return croppedImage
        }

        return nil
    }
    
    
    /// 이미지 URL로 부터 로딩하기
    ///
    /// - Parameters:
    ///   - urlText: 로딩할 이미지 URL
    ///   - complete: 로딩성공 여부 리턴( image(optional) <- 로딩 이미지, error(optional) <- 에러시 리턴 )
    public static func loadingImg(_ urlText: String, complete:((_ img: UIImage?, _ error: NSError?) -> Void)? = nil) {
        
        guard let tmpUrlText = urlText.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: tmpUrlText) else {
                
            let error = NSError(code: -1, message: "로딩 실패")
            complete?(nil, error)
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil) { (image, error, cacheType, url) in

            if error != nil {

                complete?(nil, error)
            } else {

                complete?(image, nil)
            }
        }
    }
}


// MARK:- QR코드 및 바코드 생성 (다 static 메소드)
extension UIImage {
    
    /// QR 코드 생성기
    ///
    /// - Parameters:
    ///   - QRCode: 생성할 QR Code
    ///   - size: 생성할 size
    /// - Returns: 생성된 QR코드 이미지
    static func QRImageWithString(QRCode:String, size:CGSize) -> UIImage? {
        // 필터 생성
        let qrFilter = CIFilter(name: "CIQRCodeGenerator");
        
        if qrFilter == nil {
            
            return nil;
        }
        
        // 수정 레벨 설정
        qrFilter?.setValue("H", forKey: "inputCorrectionLevel")
        
        //입력 문자열 설정
        let codeData = QRCode.data(using: .utf8)!
        qrFilter?.setValue(codeData, forKey: "inputMessage")
        
        //결과 이미지 가져오기
        if let outputImg = qrFilter?.value(forKey: "outputImage") as? CIImage {
            
            let smallImg  = UIImage.imageWithCGImage(aCIImage: outputImg, anOrientation: .up)!
            return smallImg.resizedImage(size)
        }
        
        return nil
    }
    
    /// 바코드 생성
    ///
    /// - Parameter barcodeText: 바코드 문자열
    /// - Returns: 이미지
    static func getBarcodeImg(barcodeText : String) -> UIImage? {
        
        let data:Data? = barcodeText.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                return UIImage(ciImage: output)
            }
        }
        
        return nil;
    }
    
    /// 애플워치에 보낼 바코드 이미지 생성
    ///
    /// - Parameter barcodeText: 바코드 텍스트
    /// - Returns: 이미지
    static func getBarcodeImgForAppleWatch(barcodeText : String) -> UIImage? {
        
        if let data = barcodeText.data(using: String.Encoding.ascii) {
            
            if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
                
                filter.setValue(data, forKey: "inputMessage")
                let transform = CGAffineTransform(scaleX: 3, y: 3)
                
                if let output = filter.outputImage?.transformed(by: transform) {
                    
                    var barcodeImg = UIImage(ciImage: output)
                    barcodeImg = barcodeImg.resizedImage(CGSize(width: 340, height: 40))
                    
                    return barcodeImg
                }
            }
        }
        
        return nil
    }
    
    
    /// 애플워치에 보낼 바코드 이미지 데이터 생성
    ///
    /// - Parameter barcodeText: 바코드 텍스트
    /// - Returns: 바코드 이미지 데이터
    static func getBarcodeImgDataForAppleWatch(barcodeText : String) -> Data? {
        
        let barcodeData = barcodeText.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
            
            filter.setValue(barcodeData, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            
            if let output = filter.outputImage?.transformed(by: transform) {
                
                var barcodeImg = UIImage(ciImage: output)
                barcodeImg = barcodeImg.resizedImage(CGSize(width: 340, height: 40))
                
                if let imgData = barcodeImg.pngData() {
                    
                    return imgData
                }
                else  {
                    
                    return barcodeImg.jpegData(compressionQuality: 1.0)
                }
            }
        }
        
        return nil
    }
}
