/**
 * @brief this is probably from a class dump, which I'm not sure on the legality of distrubuting, so I'm not going to include it here, just the trimmed down functions needed to at least in theory let the tweak compile.
 * used to have a whole bunch other useful features.
 * find it here
 * https://developer.limneos.net/index.php?ios=13.1.3&framework=SpringBoard&header=SBMediaController.h
 * 
 * 
 */

@class NSTimer, NSDictionary;



@interface SBMediaController {

}
@property(assign) BOOL suppressHUD;
@property(assign, nonatomic, getter=isRingerMuted) BOOL ringerMuted;
+(id)sharedInstance;
-(float)volume;
-(void)setVolume:(float)volume;

@end