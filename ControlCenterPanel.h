#import "Panel.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface ControlCenterPanel : NSObject <Panel>{
  SBMediaController *mediaController;
  NSMutableArray *topSwitches;
  NSMutableArray *bottomSwitches;
}
@property (nonatomic, assign) float maxHeight; //The height of the panel you are creating. Yes, you can go over the size of the screen but I wouldn't advise it.
@property (nonatomic, assign) float screenWidth; 
@property (nonatomic, assign) float screenHeight;
@property (nonatomic, assign) bool hasFlipswitch;
@property (nonatomic, assign) ControlCenterView *view; //The actual view for the panel. Doesn't have to be in the same class.
@property (nonatomic, assign) PanelController *pController; //Access to the panel holder.
-(ControlCenterPanel*)initWithWidth:(float)width height:(float)height;
-(void)loadUp; //Called after initialization so you can access any properties you might need to, or something like that.
-(float)panelVersion; //API version used.
-(void)nowPlayingInfoChanged;
-(void)reloadData;
@end