//
//  BrushAdjustmentViewController.swift
//  SketchPad
//
//  Created by Andrea Liu on 4/28/16.
//  Copyright © 2016 iOS Decal. All rights reserved.
//

import UIKit

protocol BrushAdjustmentViewControllerDelegate: class {
    func brushAdjustmentViewControllerFinished(brushAdjustmentViewController: BrushAdjustmentViewController)
}

class BrushAdjustmentViewController: UIViewController {
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brush: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var brushType: String = "round"
    var activeBrushTypeButton:UIButton = UIButton()
    
    
    @IBOutlet weak var brushSizeSlider: UISlider!
    @IBOutlet weak var brushSizeLabel: UILabel!
    
    @IBOutlet weak var brushOpacitySlider: UISlider!
    
    @IBOutlet weak var brushOpacityLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var redLabel: UILabel!
    
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var blueLabel: UILabel!
    
    @IBOutlet weak var brushImageView: UIImageView!
    
    @IBOutlet weak var sketchyBrushTypeButton: UIButton!
    @IBOutlet weak var squareBrushTypeButton: UIButton!
    @IBOutlet weak var markerBrushTypeButton: UIButton!
    @IBOutlet weak var roundBrushTypeButton: UIButton!
    @IBOutlet weak var squareBrushImageView: UIImageView!
    @IBOutlet weak var buttBrushImageView: UIImageView!
    
   weak var delegate: BrushAdjustmentViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.brushAdjustmentViewControllerFinished(self)
    }

    @IBAction func colorChange(sender: AnyObject) {
        red = CGFloat(redSlider.value / 255.0)
        redLabel.text = NSString(format: "%d", Int(redSlider.value)) as String
        green = CGFloat(greenSlider.value / 255.0)
        greenLabel.text = NSString(format: "%d", Int(greenSlider.value)) as String
        blue = CGFloat(blueSlider.value / 255.0)
        blueLabel.text = NSString(format: "%d", Int(blueSlider.value)) as String
        
        brushPreview()
    }
    
    @IBAction func sizeOrOpacityChange(sender: UISlider) {
        if sender == brushSizeSlider {
            brush = CGFloat(sender.value)
            brushSizeLabel.text = NSString(format: "%.2f", brush.native) as String
        } else {
            opacity = CGFloat(sender.value)
            brushOpacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        }
        
        brushPreview()
    }

    
    func brushPreview() {
        UIGraphicsBeginImageContext(brushImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        if brushType == "round" || brushType == "marker" || brushType == "sketch" {
            CGContextSetLineCap(context, CGLineCap.Round)
        } else {
            CGContextSetLineCap(context, CGLineCap.Square)
        }
        CGContextSetLineWidth(context, brush)
        CGContextMoveToPoint(context, 65.0, 68.0)
        CGContextAddLineToPoint(context, 65.0, 67.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        brushImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if brushType == "round" {
            activeBrushTypeButton = roundBrushTypeButton
        } else if brushType == "marker" {
            activeBrushTypeButton = markerBrushTypeButton
        } else if brushType == "square" {
            activeBrushTypeButton = squareBrushTypeButton
        } else {
            activeBrushTypeButton = sketchyBrushTypeButton
        }
        
        brushSizeSlider.value = Float(brush)
        brushSizeLabel.text = NSString(format: "%.1f", brush.native) as String
        brushOpacitySlider.value = Float(opacity)
        brushOpacityLabel.text = NSString(format: "%.1f", opacity.native) as String
        redSlider.value = Float(red * 255.0)
        redLabel.text = NSString(format: "%d", Int(redSlider.value)) as String
        greenSlider.value = Float(green * 255.0)
        greenLabel.text = NSString(format: "%d", Int(greenSlider.value)) as String
        blueSlider.value = Float(blue * 255.0)
        blueLabel.text = NSString(format: "%d", Int(blueSlider.value)) as String
        updateBrushStyleBorder()
        brushPreview()
    }

    @IBAction func brushTypeButtonPressed(sender: UIButton) {
        
        if sender == roundBrushTypeButton {
            brushType = "round"
            activeBrushTypeButton = roundBrushTypeButton
        } else if sender == markerBrushTypeButton {
            brushType = "marker"
            activeBrushTypeButton = markerBrushTypeButton
        } else if sender == squareBrushTypeButton {
            brushType = "square"
            activeBrushTypeButton = squareBrushTypeButton
        } else {
            brushType = "sketch"
            activeBrushTypeButton = sketchyBrushTypeButton
        }
        updateBrushStyleBorder()
        brushPreview()
        
    }
    
    func updateBrushStyleBorder() {
        roundBrushTypeButton.layer.borderWidth = 0
        markerBrushTypeButton.layer.borderWidth = 0
        squareBrushTypeButton.layer.borderWidth = 0
        sketchyBrushTypeButton.layer.borderWidth = 0
        
        activeBrushTypeButton.layer.borderWidth = 2
        activeBrushTypeButton.layer.borderColor = UIColor.grayColor().CGColor
        activeBrushTypeButton.layer.cornerRadius = 15
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
