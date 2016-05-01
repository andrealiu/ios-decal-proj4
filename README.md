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
* Adjustable brush RGB values
* Color picker option which allows you to color-pick from the existing drawing
* Several brush options (round, marker, square, sketchy)
* Eraser (adjustable size and opacity)
* Clear button that clears the canvas
* Ability to save drawings to photo gallery
* Ability to resume drawing on previous drawing
* Ability to share drawings with friends

## Control Flow
* Users are initially presented with a splash screen with the logo
* From the logo, users can choose between creating a new drawing or
resuming work on an old saved drawing
* If users choose to start a new drawing, they are taken to a screen
with a blank canvas
* If users choose to work on an old drawing, they are taken to the canvas view
view, with the previously saved drawing loaded
* At this point, the user will be at a canvas view that is either 
blank or an old loaded picture
* This canvas view will have a bottom bar, where the user can select to
use a brush, color picker, eraser, or to share their drawing
* If the user selects the color circle under the brush button that shows the
current color/opacity of the brush, they will be taken to a modally 
presented view that allows them to adjust size/opacity/brush type
* If the user selects the color picker, they can click some part of the canvas,
and the brush color will change accordingly
* If the user selects the eraser, they will be taken to a modally
presented view that allows them to adjust eraser size/opacity
* After the user has finished their drawing, they can either:
  * Click a 'Clear' button at the top of the screen to blank their canvas
  * Click a 'Save' button that saves the drawing to the phone's photo gallery
  	* If the user has not drawn anything, nothing is saved and user is alerted
  * Click a 'Share' button that takes the user to a modally presented view
  that allows him/her to forward the image to a friend

## Implementation

### Model
* Brush.Swift
* Canvas.Swift
* ColorPicker.Swift

### View
* NewOrOldDrawingSelectionView
* PreviouslySavedDrawingsCollectionView
* CanvasView
* BrushAdjustmentView
* EraserAdjustmentView

### Controller
* NewOrOldDrawingSelectionViewController
* PreviouslySavedDrawingsCollectionViewController
* CanvasViewController
* BrushAdjustmentViewController
* EraserAdjustmentViewController


eraser tool by icon 54 from the Noun Project
dropper tool by Scott Lewis from the Noun Project
brush tool by icons.design from the Noun Project
settings icon by Viktor Vorobyev from the Noun Project
