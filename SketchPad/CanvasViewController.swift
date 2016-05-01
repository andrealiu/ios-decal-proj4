//
//  CanvasViewController.swift
//  SketchPad
//
//  Created by Andrea Liu on 4/27/16.
//  Copyright © 2016 iOS Decal. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!

    @IBOutlet weak var eraserButton: UIButton!
    @IBOutlet weak var dropperButton: UIButton!
    @IBOutlet weak var brushButton: UIButton!
    
    @IBOutlet weak var brushColorImageView: UIButton!
    
    var activeButton:UIButton = UIButton()
    var brushType:String = "round"
    var lastPoint = CGPoint.zero
    // Store current RGB values of selected color
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    // Brush stroke width
    var brushWidth: CGFloat = 10.0
    // Eraser width
    var eraserWidth: CGFloat = 10.0
    // Brush opacity
    var opacity: CGFloat = 1.0
    var eraserOpacity: CGFloat = 1.0
    // Identifies if brush stroke is continuous
    var swiped = false
    var savedImage:UIImage = UIImage()
    var resumeDrawing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activeButton = brushButton
        updateActiveButton()
        if resumeDrawing == true {
            let imagePath = fileInDocumentsDirectory("savedDrawing")
            let image = loadImageFromPath(imagePath)
            mainImageView.image = image
        }
        // Do any additional setup after loading the view.
    }
    
    func updateActiveButton() {
        eraserButton.layer.borderWidth = 0
        eraserButton.layer.shadowOpacity = 0
        dropperButton.layer.borderWidth = 0
        dropperButton.layer.shadowOpacity = 0
        brushButton.layer.borderWidth = 0
        brushButton.layer.shadowOpacity = 0
        activeButton.layer.borderWidth = 3
        activeButton.layer.borderColor = UIColor.whiteColor().CGColor
        activeButton.layer.shadowOpacity = 0.85
        activeButton.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        activeButton.layer.shadowRadius = 5.0
        activeButton.layer.shadowColor = UIColor.whiteColor().CGColor
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.locationInView(self.view)
            if activeButton == dropperButton {
                let location = touch.locationInView(self.view)
                let color = self.view.getColourFromPoint(location)
                self.brushColorImageView.backgroundColor = color
                let colorComponents = color.components
                self.red = colorComponents.red
                self.blue = colorComponents.blue
                self.green = colorComponents.green
                self.opacity = colorComponents.alpha
                
            }
            
        }
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        
        if activeButton == brushButton {
            if brushType == "round" || brushType == "marker" {
                CGContextSetLineCap(context, CGLineCap.Round)
            } else if brushType == "square" {
                CGContextSetLineCap(context, CGLineCap.Square)
            } else {
                CGContextSetLineCap(context, CGLineCap.Butt)
            }
            CGContextSetLineWidth(context, brushWidth)
            if brushType == "marker" {
                CGContextSetRGBStrokeColor(context, red, green, blue, 0.5)
            } else {
                CGContextSetRGBStrokeColor(context, red, green, blue, 1)
            }
        } else {
            CGContextSetLineCap(context, CGLineCap.Round)
            CGContextSetLineWidth(context, eraserWidth)
            CGContextSetRGBStrokeColor(context, 255, 255, 255, eraserOpacity)
        }

        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        if activeButton == brushButton {
            tempImageView.alpha = opacity
        } else {
            tempImageView.alpha = eraserOpacity
        }
        UIGraphicsEndImageContext()
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // 6
        swiped = true
        if let touch = touches.first{
            let currentPoint = touch.locationInView(view)
            if activeButton == brushButton || activeButton == eraserButton {
                drawLineFrom(lastPoint, toPoint: currentPoint)
            }
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        // Merge tempImageView into mainImageView
        if activeButton != dropperButton {
            UIGraphicsBeginImageContext(mainImageView.frame.size)
            mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
            if activeButton == brushButton {
                tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
            } else {
                tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: CGBlendMode.Normal, alpha: eraserOpacity)
            }
            mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        
        }
        tempImageView.image = nil
    }
    
    

    @IBAction func resetButtonPressed(sender: AnyObject) {
        mainImageView.image = nil
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if mainImageView.image == nil{
            let alertController = UIAlertController(title: nil, message:
                "Whoops! You don't seem to have drawn anything to save. Try adding some art first!", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        UIImageWriteToSavedPhotosAlbum(mainImageView.image!,self, Selector("image:withPotentialError:contextInfo:"), nil)
        let imagePath = fileInDocumentsDirectory("savedDrawing")
        saveImage(mainImageView.image!, path: imagePath)
        
        
    }
    
    @IBAction func shareButtonPressed(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func image(image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafePointer<()>) {
        //UIAlertView(title: nil, message: "Image successfully saved to Photos library", delegate: nil, cancelButtonTitle: "Dismiss").show()
        let alertController = UIAlertController(title: nil, message:
            "Image successfully saved to Photos library", preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func brushButtonPressed(sender: AnyObject) {
        activeButton = brushButton
        updateActiveButton()
    }
    
    @IBAction func dropperButtonPressed(sender: AnyObject) {
        activeButton = dropperButton
        updateActiveButton()
        
    }
    @IBAction func eraserButtonPressed(sender: AnyObject) {
        activeButton = eraserButton
        updateActiveButton()
    }
    
    
    
    func saveImage (image: UIImage, path: String ) -> Bool{
        
        let pngImageData = UIImagePNGRepresentation(image)
        //let jpgImageData = UIImageJPEGRepresentation(image, 1.0)   // if you want to save as JPEG
        let result = pngImageData!.writeToFile(path, atomically: true)
        
        return result
        
    }
    
    func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
    
    func loadImageFromPath(path: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: path)
        
        if image == nil {
            
            print("missing image at: \(path)")
        }
        print("Loading image from path: \(path)") // this is just for you to see the path in case you want to go to the directory, using Finder.
        return image
        
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "showBrushAdjustment" {
            let brushAdjustmentNavViewController = segue.destinationViewController as! UINavigationController
            let brushAdjustmentViewController = brushAdjustmentNavViewController.topViewController as! BrushAdjustmentViewController
            brushAdjustmentViewController.delegate = self
            brushAdjustmentViewController.brush = brushWidth
            brushAdjustmentViewController.opacity = opacity
            brushAdjustmentViewController.red = red
            brushAdjustmentViewController.green = green
            brushAdjustmentViewController.blue = blue
            brushAdjustmentViewController.brushType = brushType
        } else if segue.identifier == "showEraserAdjustment" {
            let eraserAdjustmentNavViewController = segue.destinationViewController as! UINavigationController
            let eraserAdjustmentViewController = eraserAdjustmentNavViewController.topViewController as! EraserAdjustmentViewController
            eraserAdjustmentViewController.delegate = self
            eraserAdjustmentViewController.eraserSize = eraserWidth
            eraserAdjustmentViewController.opacity = eraserOpacity
        } else {

        }
        
    
    }

}

extension UIView {
    func getColourFromPoint(point:CGPoint) -> UIColor {
        let colorSpace:CGColorSpace = CGColorSpaceCreateDeviceRGB()!
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.PremultipliedLast.rawValue)
        
        var pixelData:[UInt8] = [0, 0, 0, 0]
        
        let context = CGBitmapContextCreate(&pixelData, 1, 1, 8, 4, colorSpace, bitmapInfo.rawValue)
        CGContextTranslateCTM(context, -point.x, -point.y);
        self.layer.renderInContext(context!)
        
        
        let red:CGFloat = CGFloat(pixelData[0])/CGFloat(255.0)
        let green:CGFloat = CGFloat(pixelData[1])/CGFloat(255.0)
        let blue:CGFloat = CGFloat(pixelData[2])/CGFloat(255.0)
        let alpha:CGFloat = CGFloat(pixelData[3])/CGFloat(255.0)
        
        let color:UIColor = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
}

extension UIColor {
    var components:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r,g,b,a)
    }
}

extension CanvasViewController: BrushAdjustmentViewControllerDelegate {
    func brushAdjustmentViewControllerFinished(brushAdjustmentViewController: BrushAdjustmentViewController) {
        self.brushWidth = brushAdjustmentViewController.brush
        self.opacity = brushAdjustmentViewController.opacity
        self.red = brushAdjustmentViewController.red
        self.green = brushAdjustmentViewController.green
        self.blue = brushAdjustmentViewController.blue
        self.brushColorImageView.backgroundColor = UIColor(red: self.red, green: self.green, blue: self.blue, alpha: self.opacity)
        self.brushType = brushAdjustmentViewController.brushType
    }
}

extension CanvasViewController: EraserAdjustmentViewControllerDelegate {
    func eraserAdjustmentViewControllerFinished(eraserAdjustmentViewController: EraserAdjustmentViewController) {
        self.eraserWidth = eraserAdjustmentViewController.eraserSize
        self.eraserOpacity = eraserAdjustmentViewController.opacity
    }
}
