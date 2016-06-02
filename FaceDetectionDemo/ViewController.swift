//
//  ViewController.swift
//  FaceDetectionDemo
//
//  Created by isaced on 16/6/2.
//
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.faceDetection(UIImage(named: "photo.jpg")!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func selectPhotoAction(sender: AnyObject) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "Take a picture", style: .Default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.Camera
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Album", style: .Default, handler: { (action) in
            let picker = UIImagePickerController()
            picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            picker.delegate = self
            self.presentViewController(picker, animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        self.faceDetection(image)
    }
    
    func faceDetection(image: UIImage) {
        self.imageView.image = self.markFace(image)
    }

    func markFace(originImage: UIImage) -> UIImage {
        // Context
        let contextLayer = CALayer()
        contextLayer.frame = CGRectMake(0, 0, originImage.size.width, originImage.size.height)
        contextLayer.contents = originImage.CGImage
        
        // CIImage De
        let ciImage = CIImage(CGImage: originImage.CGImage!)
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
        let features = detector.featuresInImage(ciImage) as! [CIFaceFeature]
        for faceFeature in features {
            // get the width of the face
            let faceWidth = faceFeature.bounds.width
            let faceMarkLayer = CALayer()
            faceMarkLayer.frame = CoordinatesTool.rectangleFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.bounds, aSize: originImage.size)
            faceMarkLayer.borderColor = UIColor.redColor().CGColor
            faceMarkLayer.borderWidth = 2.0
            contextLayer.addSublayer(faceMarkLayer)
            
            if faceFeature.hasLeftEyePosition {
                let keyPoint = CoordinatesTool.pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.leftEyePosition, aSize: originImage.size)
                let leftEyeMaskLayer = CALayer()
                leftEyeMaskLayer.frame = CGRectMake(keyPoint.x - faceWidth * 0.15, keyPoint.y - faceWidth * 0.15, faceWidth * 0.3, faceWidth * 0.3)
                leftEyeMaskLayer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3).CGColor
                leftEyeMaskLayer.cornerRadius = faceWidth * 0.15
                contextLayer.addSublayer(leftEyeMaskLayer)
            }

            if faceFeature.hasRightEyePosition {
                let keyPoint = CoordinatesTool.pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.rightEyePosition, aSize: originImage.size)
                let rightEyeMaskLayer = CALayer()
                rightEyeMaskLayer.frame = CGRectMake(keyPoint.x - faceWidth * 0.15, keyPoint.y - faceWidth * 0.15, faceWidth * 0.3, faceWidth * 0.3)
                rightEyeMaskLayer.backgroundColor = UIColor.blueColor().colorWithAlphaComponent(0.3).CGColor
                rightEyeMaskLayer.cornerRadius = faceWidth * 0.15
                contextLayer.addSublayer(rightEyeMaskLayer)
            }
            
            if faceFeature.hasMouthPosition {
                let keyPoint = CoordinatesTool.pointFromTraditionalToiPhoneCoordinatesWithReferenceViewOfSize(faceFeature.mouthPosition, aSize: originImage.size)
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
}

