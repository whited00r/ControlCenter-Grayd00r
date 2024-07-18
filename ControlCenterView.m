#import "ControlCenterView.h"
#import <Flipswitch/Flipswitch.h>
#import "ControlCenterPanel.h"

@implementation ControlCenterView

-(id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	if(self){

    screenWidth = frame.size.width;
    screenHeight = frame.size.height;

	self.backgroundColor = [UIColor clearColor]; //The panel holder background is blurred.
    self.backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
    self.backgroundView.image = [UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/BackgroundOverlay_iPod.png"];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) self.backgroundView.image = [UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/BackgroundOverlay_iPad.png"];
    [self addSubview:self.backgroundView];

    //---------Top switch row -------------//
    self.topRowHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0,20,frame.size.width, 60)];
    self.topRowHolder.backgroundColor = [UIColor clearColor];
    self.topRowHolder.showsHorizontalScrollIndicator = FALSE;
    self.topRowHolder.contentSize = CGSizeMake(screenWidth, 60);
    [self addSubview:self.topRowHolder];



 NSMutableDictionary* brightnessDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    float brightness = [[brightnessDict objectForKey:@"SBBacklightLevel2"] floatValue];
    
    self.brightnessSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, 100, screenWidth - 110, 3)];
    [self.brightnessSlider addTarget:self action:@selector(setBrightness:) forControlEvents:UIControlEventValueChanged];
    [self.brightnessSlider setBackgroundColor:[UIColor clearColor]];
    self.brightnessSlider.minimumValue = 0.01f;
    self.brightnessSlider.maximumValue = 1.0f;
    self.brightnessSlider.continuous = YES;
    self.brightnessSlider.value = brightness;
 self.brightnessSlider.userInteractionEnabled = TRUE;
 [self addSubview:self.brightnessSlider];
 [brightnessDict release];

    //---------------Media Controls initilization --------------//
	//Yeah yeah use _mediaControlsHolder and such during init...





    self.mediaControlsHolder = [[UIView alloc] initWithFrame:CGRectMake(0,120, frame.size.width, 180)];
    self.mediaControlsHolder.backgroundColor = [UIColor clearColor];


      

    self.mediaArtistAlbumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,80,frame.size.width,20)];
    self.mediaArtistAlbumLabel.textAlignment = UITextAlignmentCenter;
    [self.mediaArtistAlbumLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    self.mediaArtistAlbumLabel.textColor = [UIColor whiteColor];
    self.mediaArtistAlbumLabel.backgroundColor = [UIColor clearColor];
    self.mediaArtistAlbumLabel.alpha = 0.6;

    self.mediaSongLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,50,frame.size.width,30)];
    self.mediaSongLabel.textAlignment = UITextAlignmentCenter;
    [self.mediaSongLabel setFont:[UIFont fontWithName:@"Arial" size:18]];
    self.mediaSongLabel.textColor = [UIColor whiteColor];
    self.mediaSongLabel.backgroundColor = [UIColor clearColor];


    self.mediaPausePlayButton = [[UIButton alloc] initWithFrame:CGRectMake((frame.size.width / 2) - 15, self.mediaArtistAlbumLabel.frame.origin.y + 30, 30, 20 )];
    [self.mediaPausePlayButton setBackgroundColor:[UIColor clearColor]];
    //[self.mediaPausePlayButton setTitle:@">" forState:UIControlStateNormal];
    [self.mediaPausePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Play.png"] forState:UIControlStateNormal];

    self.mediaPausePlayButton.tag = 2;

    self.mediaPreviousButton = [[UIButton alloc] initWithFrame:CGRectMake(self.mediaPausePlayButton.frame.origin.x - 70, self.mediaArtistAlbumLabel.frame.origin.y + 30, 30, 20 )];
    [self.mediaPreviousButton setBackgroundColor:[UIColor clearColor]];
    //[self.mediaPreviousButton setTitle:@"<<" forState:UIControlStateNormal];
    [self.mediaPreviousButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Previous.png"] forState:UIControlStateNormal];


    self.mediaPreviousButton.tag = 1;

    self.mediaForwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.mediaPausePlayButton.frame.origin.x + 70, self.mediaArtistAlbumLabel.frame.origin.y + 30, 30, 20 )];
    [self.mediaForwardButton setBackgroundColor:[UIColor clearColor]];
    //[self.mediaForwardButton setTitle:@">>" forState:UIControlStateNormal];
    [self.mediaForwardButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Forward.png"] forState:UIControlStateNormal];

 
    self.mediaForwardButton.tag = 3;

      float volume = [[objc_getClass("SBMediaController") sharedInstance] volume];
    self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, self.mediaForwardButton.frame.origin.y + 40, screenWidth - 110, 3)];
    [self.volumeSlider addTarget:self action:@selector(setVolume:) forControlEvents:UIControlEventValueChanged];
    [self.volumeSlider setBackgroundColor:[UIColor clearColor]];
    self.volumeSlider.minimumValue = 0.01f;
    self.volumeSlider.maximumValue = 1.0f;
    self.volumeSlider.continuous = YES;
    self.volumeSlider.value = volume;
 self.volumeSlider.userInteractionEnabled = TRUE;
//[self.volumeSlider setMinimumTrackImage:[[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/LuminosityMinimum.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal ];
//[self.volumeSlider setMaximumTrackImage:[[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/LuminosityFull.png"] stretchableImageWithLeftCapWidth:10.0 topCapHeight:0.0] forState:UIControlStateNormal ];
//[self.volumeSlider setThumbImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/LuminosityPoint.png"] forState:UIControlStateNormal];


    [self.mediaControlsHolder addSubview:self.mediaSongLabel];
    [self.mediaControlsHolder addSubview:self.mediaArtistAlbumLabel];
    [self.mediaControlsHolder addSubview:self.mediaPreviousButton];
    [self.mediaControlsHolder addSubview:self.mediaForwardButton];
    [self.mediaControlsHolder addSubview:self.mediaPausePlayButton];
    [self.mediaControlsHolder addSubview:self.volumeSlider];


    self.bottomRowHolder = [[UIScrollView alloc] initWithFrame:CGRectMake(0,self.mediaControlsHolder.frame.origin.y + self.mediaControlsHolder.frame.size.height + 15,frame.size.width, 60)];
    self.bottomRowHolder.backgroundColor = [UIColor clearColor];
    self.bottomRowHolder.showsHorizontalScrollIndicator = FALSE;
    self.bottomRowHolder.contentSize = CGSizeMake(screenWidth, 60);
    [self addSubview:self.bottomRowHolder];
    [self addSubview:self.mediaControlsHolder];
	}
	return self;
}

-(void)loadUp{ //So we can access the delegate. I probably missed some method to access properties during the init method but I can't think what that would be seeing you have to init something before you can set them.
	[self.mediaPausePlayButton addTarget:self.cController action:@selector(togglePlayback:) forControlEvents:UIControlEventTouchUpInside];
    [self.mediaPreviousButton addTarget:self.cController action:@selector(togglePlayback:) forControlEvents:UIControlEventTouchUpInside];
    [self.mediaForwardButton addTarget:self.cController action:@selector(togglePlayback:) forControlEvents:UIControlEventTouchUpInside];


}

-(void)reloadSwitches{

    if(!self.cController.hasFlipswitch){
        NSLog(@"CCDEBUG: reloadSwitches - ERROR: unable to access flipswitch");
         [[self.topRowHolder subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [[self.bottomRowHolder subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];

       UILabel * flipSwitchlabel = [[UILabel alloc] initWithFrame:CGRectMake(0,20,screenWidth,20)];
    flipSwitchlabel.textAlignment = UITextAlignmentCenter;
    [flipSwitchlabel setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:12]];
    flipSwitchlabel.textColor = [UIColor whiteColor];
    flipSwitchlabel.backgroundColor = [UIColor clearColor];
    flipSwitchlabel.alpha = 0.6;
    flipSwitchlabel.text = @"Please install Flipswitch from Cydia";

    [self.topRowHolder addSubview:flipSwitchlabel];
    [self.bottomRowHolder addSubview:flipSwitchlabel];
    [flipSwitchlabel release];
        return;
    }
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    FSSwitchPanel *fsp = [FSSwitchPanel sharedPanel];
    NSBundle *templateTopRowBundle = [NSBundle bundleWithPath:@"/Library/Panel/Panels/ControlCenter.bundle/TopRow.bundle"];
    NSBundle *templateBottomRowBundle = [NSBundle bundleWithPath:@"/Library/Panel/Panels/ControlCenter.bundle/BottomRow.bundle"];
    NSMutableDictionary *preferenceDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.greyd00r.controlcenter.plist"];
    if(!(preferenceDict == NULL)){
        if([preferenceDict objectForKey:@"topRowSwitches"]){
            NSArray *topRowSwitches = [preferenceDict objectForKey:@"topRowSwitches"];
           [[self.topRowHolder subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
           self.topRowHolder.contentSize = CGSizeMake(screenWidth, self.topRowHolder.frame.size.height);
           int divider = [topRowSwitches count];
           if(divider > 4) divider = 4;
            topSwitchPadding = (screenWidth / divider) - 40;
            topSwitchOffset = topSwitchPadding;
            for(NSString *switchID in topRowSwitches){
                UIButton *button = [fsp buttonForSwitchIdentifier:switchID usingTemplate:templateTopRowBundle];
                button.center = CGPointMake(topSwitchOffset, (self.topRowHolder.frame.size.height / 2));
                [self.topRowHolder addSubview:button];
                topSwitchOffset = topSwitchOffset + (40 + topSwitchPadding);
            }
            self.topRowHolder.contentSize = CGSizeMake(topSwitchOffset, self.topRowHolder.frame.size.height);
        }

        if([preferenceDict objectForKey:@"bottomRowSwitches"]){
                    NSArray *bottomRowSwitches = [preferenceDict objectForKey:@"bottomRowSwitches"];
                   [[self.bottomRowHolder subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
                   self.bottomRowHolder.contentSize = CGSizeMake(screenWidth, self.bottomRowHolder.frame.size.height);
                   int divider = [bottomRowSwitches count];
                   if(divider > 4) divider = 4;
                    bottomSwitchPadding = (screenWidth / divider) - 40;
                    bottomSwitchOffset = bottomSwitchPadding;
                    for(NSString *switchID in bottomRowSwitches){
                        UIButton *button = [fsp buttonForSwitchIdentifier:switchID usingTemplate:templateBottomRowBundle];
                        button.center = CGPointMake(bottomSwitchOffset, (self.bottomRowHolder.frame.size.height / 2));
                        [self.bottomRowHolder addSubview:button];
                        bottomSwitchOffset = bottomSwitchOffset + (40 + bottomSwitchPadding);
                    }
                    self.bottomRowHolder.contentSize = CGSizeMake(bottomSwitchOffset, self.bottomRowHolder.frame.size.height);
        }
    }



    [pool drain];
}

-(void)reloadData{
    NSMutableDictionary* brightnessDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
    float brightness = [[brightnessDict objectForKey:@"SBBacklightLevel2"] floatValue];
self.brightnessSlider.value = brightness;
 [brightnessDict release];
 float volume = [[objc_getClass("SBMediaController") sharedInstance] volume];
  self.volumeSlider.value = volume;
}


-(void)setVolume:(UISlider*)sender{


float volume = sender.value;

[[objc_getClass("SBMediaController") sharedInstance] setVolume:volume];
}


-(void)setBrightness:(UISlider*)sender{


NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

float val = sender.value;

  GSEventSetBacklightLevel(val);

NSMutableDictionary* plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist"];
       [plistDict setValue:[NSNumber numberWithFloat:val] forKey:@"SBBacklightLevel2"];
       [plistDict writeToFile:@"/var/mobile/Library/Preferences/com.apple.springboard.plist" atomically: YES];
//[[objc_getClass("SBBrightnessController") sharedBrightnessController] setBrightnessLevel:val];
  [[objc_getClass("SBBrightnessController") sharedBrightnessController] adjustBacklightLevel:TRUE];
 [plistDict release];
  [pool drain];
}

-(void)sliderLuminosity:(id)sender{
    /*

  */
}

-(void)dealloc{
	[self.mediaArtistAlbumLabel release];
	[self.mediaSongLabel release];
	[self.mediaControlsHolder release];
	[self.mediaForwardButton release];
	[self.mediaPreviousButton release];
	[self.mediaPausePlayButton release];
    [self.bottomRowHolder release];
    [self.topRowHolder release];
    [self.backgroundView release];
	[super dealloc];
    [self.volumeSlider release];

}
@end