//
//  UIImage+FaceDetect.swift
//  FaceDetectionDemo
//
//  Created by feeling on 16/6/2.
//
//

import UIKit

enum DetectionType {
    case CoreImage
    case FacePlusPlus
}

extension UIImage {
    func faceDetect(type: DetectionType) -> UIImage {
        
        let faceFeatureDatas: [FaceFeatureData]
        switch type {
            case .CoreImage:
                faceFeatureDatas = self.detectWithCoreImage()
            default:
                faceFeatureDatas = self.detectWithCoreImage()
        }
        
        // Context
        let contextLayer = CALayer()
        contextLayer.frame = CGRectMake(0, 0, self.size.width, self.size.height)
        contextLayer.contents = self.CGImage
        
        // Draw
        for faceFeature in faceFeatureDatas {
            // get the width of the face
            let faceBounds = faceFeature.faceBounds
            let faceWidth = faceBounds.width
            let faceMarkLayer = CALayer()
            faceMarkLayer.frame = faceBounds
            faceMarkLayer.borderColor = UIColor.redColor().CGColor
            faceMarkLayer.borderWidth = 2.0
            contextLayer.addSublayer(faceMarkLayer)
            
            if faceFeature.hasLeftEyePosition {
                let keyPoint = faceFeature.leftEyePosition
                let leftEyeMaskLayer = CALayer()
                leftEyeMaskLayer.frame = CGRectMake(keyPoint.x - faceWidth * 0.15, keyPoint.y - faceWidth * 0.15, faceWidth * 0.3, faceWidth * 0.3)
                leftEyeMaskLayer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3).CGColor
                leftEyeMaskLayer.cornerRadius = faceWidth * 0.15
                contextLayer.addSublayer(leftEyeMaskLayer)
            }
            
            if faceFeature.hasRightEyePosition {
                let keyPoint = faceFeature.rightEyePosition
                let rightEyeMaskLayer = CALayer()
                rightEyeMaskLayer.frame = CGRectMake(keyPoint.x - faceWidth * 0.15, keyPoint.y - faceWidth * 0.15, faceWidth * 0.3, faceWidth * 0.3)
                rightEyeMaskLayer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3).CGColor
                rightEyeMaskLayer.cornerRadius = faceWidth * 0.15
                contextLayer.addSublayer(rightEyeMaskLayer)
            }
            
            if faceFeature.hasMouthPosition {
                let keyPoint = faceFeature.mouthPosition
                let mouseMaskLayer = CALayer()
                mouseMaskLayer.frame = CGRectMake(keyPoint.x - faceWidth * 0.2, keyPoint.y - faceWidth * 0.2, faceWidth * 0.4, faceWidth * 0.4)
                mouseMaskLayer.backgroundColor = UIColor.greenColor().colorWithAlphaComponent(0.3).CGColor
                mouseMaskLayer.cornerRadius = faceWidth * 0.2
                contextLayer.addSublayer(mouseMaskLayer)
            }
        }
        
        // output image
        UIGraphicsBeginImageContextWithOptions(contextLayer.frame.size, false, 0)
        contextLayer.renderInContext(UIGraphicsGetCurrentContext()!)
        let outputImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return outputImage
    }
    
    // Core Image
    func detectWithCoreImage() -> [FaceFeatureData] {
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let ciImage = CoreImage.CIImage(image: self)
        let features = detector.featuresInImage(ciImage!) as! [CIFaceFeature]
        var featureDatas: [FaceFeatureData] = []
        for faceFeature in features {
            var faceFeatureData = FaceFeatureData(faceBounds: CGRectZero, hasLeftEyePosition: false, leftEyePosition: CGPointZero, hasRightEyePosition: false, rightEyePosition: CGPointZero, hasMouthPosition: false, mouthPosition: CGPointZero)
            faceFeatureData.faceBounds = rectangleFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.bounds, aSize: self.size)
            faceFeatureData.hasLeftEyePosition = faceFeature.hasLeftEyePosition
            faceFeatureData.leftEyePosition = pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.leftEyePosition, aSize: self.size)
            faceFeatureData.hasRightEyePosition = faceFeature.hasRightEyePosition
            faceFeatureData.rightEyePosition = pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.rightEyePosition, aSize: self.size)
            faceFeatureData.hasMouthPosition = faceFeature.hasMouthPosition
            faceFeatureData.mouthPosition = pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.mouthPosition, aSize: self.size)
            featureDatas.append(faceFeatureData)
        }
        return featureDatas
    }
}