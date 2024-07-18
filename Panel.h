#import <UIKit/UIKit.h>
@interface PanelController : NSObject
@property (nonatomic, assign) UIView *dimView; //Maybe needed if you need to make it different, such as hide it if needed. It will always animate the alpha though when opening/closing. Shouldn't matter if you hide it though or change alpha/properties while hidden.
@property (nonatomic, assign) bool panelOpen; //In case you need to check if the panel is open.
-(void)showPanel; //You can manually show the panel, or hide it if needed.
-(void)hidePanel;
@end


@protocol Panel
@property (nonatomic, assign) float maxHeight; //The height of the panel you are creating. Yes, you can go over the size of the screen but I wouldn't advise it.
@property (nonatomic, assign) float screenWidth; 
@property (nonatomic, assign) float screenHeight;
@property (nonatomic, assign) UIView *view; //The actual view for the panel. Doesn't have to be in the same class.
@property (nonatomic, assign) PanelController *pController; //Access to the panel holder.
-(id)init;
-(void)loadUp; //Called after initialization so you can access any properties you might need to, or something like that.
-(float)panelVersion; //API version used.
@optional
@property (nonatomic, assign) float maxXOffset; //Not used yet.
@property (nonatomic, assign) float maxYOffset; //Not used yet.
-(void)reloadData; //This is called on the first touch for the begining of the swipe to open the panel. Reload any data you may need to here if you want. 
-(void)didRotate:(UIInterfaceOrientation)orientation; //Currently, the panel holder itself does not rotate, but it does give you notifications for when it does...
-(void)prepareForShow; //Called before the animation for fully opening is called, not sure if this is handy to have or not. The panel may already be visible at this point.
-(void)prepareForHide; //Called before the animation for closing is called. 
-(void)showFinished; //The animation for showing the panel has finished.
-(void)hideFinished; //The animation for hiding the panel has finished.
-(void)yOffsetChanged:(float)y; //Currently the top of your view is at (y). This is called during the swipe up/down, and during the animation open/close as well.
@end


