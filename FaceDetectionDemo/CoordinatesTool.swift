//
//  CoordinatesTool.swift
//  FaceDetectionDemo
//
//  Created by isaced on 16/6/2.
//
//

import UIKit

public func rectangleFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(oldRect: CGRect, aSize: CGSize) -> CGRect {
    let oldY = oldRect.origin.y;
    let newY = aSize.height - oldY - oldRect.size.height;
    
    var newRect = oldRect;
    newRect.origin.y = newY;
    
    return newRect;
}

public func pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(oldPoint: CGPoint, aSize: CGSize) -> CGPoint {
    let oldY = oldPoint.y;
    let newY = aSize.height - oldY ;
    
    var newPoint = oldPoint;
    newPoint.y = newY;
    
    return newPoint;
}