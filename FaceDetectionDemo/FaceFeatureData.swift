//
//  FaceFeatureData.swift
//  FaceDetectionDemo
//
//  Created by feeling on 16/6/2.
//
//

import Foundation
import CoreImage

struct FaceFeatureData {
    var faceBounds: CGRect
    
    var hasLeftEyePosition: Bool
    var leftEyePosition: CGPoint
    
    var hasRightEyePosition: Bool
    var rightEyePosition: CGPoint
    
    var hasMouthPosition: Bool
    var mouthPosition: CGPoint
}
