# SketchPad

## Authors
* Andrea Liu
  
## Purpose
To create a user-friendly utility app that will allow users to create, save,
and share their own drawings on social media. SketchPad will provide a 
customizable and easy-to-use experience for aspiring digital artists.

## Features
* Side-bar with brush customization
* Adjustable brush size slider bar
* Adjustable brush opacity slider bar
* Color picker option which allows you to select any spectrum color
* Color picker option which allows you to color-pick from an image
* Several brush options (blurry, spray paint, sketchy, image stamp)
* Eraser (adjustable size and opacity)
* Paint bucket that fills in closed area
* Clear button that clears the canvas
* Customizable canvas size
* Ability to save drawings to photo gallery
* Ability to resume drawing on previous drawings
* Ability to share drawings with friends

## Control Flow
* Users are initially presented with a splash screen with the logo
* From the logo, users can choose between creating a new drawing or
resuming work on an old drawing
* If users choose to start a new drawing, they are taken to a screen
that allows them to customize canvas size before being taken to their
blank canvas
* If users choose to work on an old drawing, they are taken to a view
that presents previous drawings in a collection-type format, and they
can select which one to load
* At this point, the user will be at a canvas view that is either 
blank or an old loaded picture
* This canvas view will have a side bar, where the user can select to
use a brush, color picker, eraser, or paint bucket tool
* If the user selects the brush, they will be taken to a modally 
presented view that allows them to adjust size/opacity/brush type
* If the user selects the color picker, they will be taken to a
modally presented view that either allows them to pick from a
spectrum or click a button that takes them to image-based color
picking
  * If image-based color picking is chosen, the user will be taken back
  to the canvas view, with the cursor as a dropper, from which they can
  click some part of the canvas, and the brush color will change
  accordingly
* If the user selects the eraser, they will be taken to a modally
presented view that allows them to adjust eraser size/opacity
* If the user selects the paint bucket tool, the cursor will change to
a paint bucket and fill in the closed area that the user clicks on
* After the user has finished their drawing, they can either:
  * Click a 'Clear' button at the top of the screen to blank their canvas
  * Click a 'Save' button that saves the drawing to the phone's photo gallery
  * Click a 'Share' button that takes the user to a modally presented view
  that allows him/her to forward the image to a friend

## Implementation

### Model
* Brush.Swift
* Canvas.Swift
* ColorPicker.Swift

### View
* SplashScreenView
* NewOrOldDrawingSelectionView
* PreviouslySavedDrawingsCollectionView
* CanvasView
* BrushAdjustmentView
* ColorPickerAdjustmentView
* EraserAdjustmentView
* ShareDrawingView

### Controller
* SplashScreenViewController
* NewOrOldDrawingSelectionViewController
* PreviouslySavedDrawingsCollectionViewController
* CanvasViewController
* BrushAdjustmentViewController
* ColorPickerAdjustmentViewController
* EraserAdjustmentViewController
* ShareDrawingViewController
