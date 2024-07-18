#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <GraphicsServices/GSEvent.h>
#import "SBMediaController.h"

@class ControlCenterPanel;
@interface ControlCenterView : UIView{
  
	float topRowCount;
	float bottomRowCount;
	float topSwitchOffset;
	float bottomSwitchOffset;
	float topSwitchPadding;
	float bottomSwitchPadding;
	float screenWidth;
	float screenHeight;



}
@property (nonatomic, assign) UIView *mediaControlsHolder;
@property (nonatomic, assign) UIScrollView *topRowHolder;
@property (nonatomic, assign) UIScrollView *bottomRowHolder;
@property (nonatomic, assign) UIButton *mediaPausePlayButton;
@property (nonatomic, assign) UIButton *mediaForwardButton;
@property (nonatomic, assign) UIButton *mediaPreviousButton;
@property (nonatomic, assign) UISlider *volumeSlider;
@property (nonatomic, assign) UISlider *brightnessSlider;
@property (nonatomic, assign) UILabel *mediaArtistAlbumLabel;
@property (nonatomic, assign) UILabel *mediaSongLabel;
@property (nonatomic, assign) ControlCenterPanel *cController;
@property (nonatomic, assign) UIImageView *backgroundView;
-(ControlCenterView*)initWithFrame:(CGRect)frame;
-(void)loadUp;
-(void)dealloc;
-(void)reloadSwitches;
-(void)setVolume:(id)sender;
-(void)setBrightness:(id)sender;
@end