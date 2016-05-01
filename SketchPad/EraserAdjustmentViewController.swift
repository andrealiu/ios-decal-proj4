//
//  EraserAdjustmentViewController.swift
//  SketchPad
//
//  Created by Andrea Liu on 4/29/16.
//  Copyright © 2016 iOS Decal. All rights reserved.
//

import UIKit

protocol EraserAdjustmentViewControllerDelegate: class {
    func eraserAdjustmentViewControllerFinished(eraserAdjustmentViewController: EraserAdjustmentViewController)
}


class EraserAdjustmentViewController: UIViewController {
    
    @IBOutlet weak var eraserSizeSlider: UISlider!
    @IBOutlet weak var eraserSizeLabel: UILabel!

    @IBOutlet weak var eraserOpacitySlider: UISlider!
    
    @IBOutlet weak var eraserOpacityLabel: UILabel!
    
    @IBOutlet weak var eraserPreviewImageView: UIImageView!
    
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var doneButton: UIButton!
    weak var delegate: EraserAdjustmentViewControllerDelegate?
    var eraserSize: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func doneButtonPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.eraserAdjustmentViewControllerFinished(self)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sizeOrOpacityChange(sender: UISlider) {
        if sender == eraserSizeSlider {
            eraserSize = CGFloat(sender.value)
            eraserSizeLabel.text = NSString(format: "%.2f", eraserSize.native) as String
        } else {
            opacity = CGFloat(sender.value)
            eraserOpacityLabel.text = NSString(format: "%.2f", opacity.native) as String
        }
        
        eraserPreview()
    }
    
    func eraserPreview() {
        UIGraphicsBeginImageContext(eraserPreviewImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, eraserSize)
        CGContextMoveToPoint(context, 126.0, 125.0)
        CGContextAddLineToPoint(context, 126.0, 125.0)
        
        CGContextSetRGBStrokeColor(context, 255, 255, 255, opacity)
        CGContextStrokePath(context)
        eraserPreviewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        eraserSizeSlider.value = Float(eraserSize)
        eraserSizeLabel.text = NSString(format: "%.1f", eraserSize.native) as String
        eraserOpacitySlider.value = Float(opacity)
        eraserOpacityLabel.text = NSString(format: "%.1f", opacity.native) as String
        
        eraserPreview()
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
