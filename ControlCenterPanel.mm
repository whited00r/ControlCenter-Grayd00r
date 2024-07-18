

#import <Flipswitch/Flipswitch.h>
#import "ControlCenterView.h"
#import "ControlCenterPanel.h"
#define KNORMAL  "\x1B[0m"
#define KRED  "\x1B[31m"
#define REDLog(fmt, ...) NSLog((@"%s" fmt @"%s"),KRED,##__VA_ARGS__,KNORMAL)

#import <Security/Security.h>
#import <CommonCrypto/CommonDigest.h>
//#import <sys/sysctl.h>
#import "NSData+Base64.h"
static inline void alertIfNeeded(){
  //NSLog(@"Should show for update check");
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  BOOL shouldAlert = FALSE; //Only alert if both the lockscreen tweak *and* GD7UI are disabled. GD7UI should always be enabled because everything else depends on it so use that as the fallback alert tweak.
  if(![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/liblockscreen.dylib"]){
      if(![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/gd7ui.dylib"]){
        shouldAlert = TRUE;
      }
  }


  if(shouldAlert){
            UIAlertView *alert =
            [[UIAlertView alloc] initWithTitle: @"Grayd00r Error"
                                       message: @"Your acitvation key for Grayd00r is invalid.\n\nIt also seems as though your re-activtion lockscreen is also invalid.\n\nNone of the features of Grayd00r will function until this is resolved.\nPlease re-install Grayd00r using the latest version of the installer from\nhttp://grayd00r.com."
                                      delegate: nil
                             cancelButtonTitle: @"OK"
                             otherButtonTitles: nil];
            [alert show];
            [alert release];
  }
  [pool drain];
}

static inline BOOL isSlothSleeping(){
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
NSData* fileData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.installerInfo.plist"];
NSData* signatureData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.installerInfo.plist.sig"];
//Okay, this is technically not good to do, but it's even worse if I just include the bloody certificate on the device by default because then it just gets replaced easier. Same for keeping it in the keychain perhaps because it isn't sandboxed? Hide it in the binary they said, it will be safer, they said.
NSData* certificateData = [NSData dataFromBase64String:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"MIIC6jCCAdICCQC2Zs0BWO+dxzANBgkqhkiG9w0BAQsFADA3MQswCQYDVQQGEwJV",
@"UzERMA8GA1UECgwIR3JheWQwMHIxFTATBgNVBAMMDGdyYXlkMDByLmNvbTAeFw0x",
@"NTEwMjQyMzEzNTNaFw0yMTA0MTUyMzEzNTNaMDcxCzAJBgNVBAYTAlVTMREwDwYD",
@"VQQKDAhHcmF5ZDAwcjEVMBMGA1UEAwwMZ3JheWQwMHIuY29tMIIBIjANBgkqhkiG",
@"9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsWSkvU26FQlb/IOE/QWKSyt3L5ekj+uvdVQq",
@"Eljo35THov9qKSqTMhdgMGkWDCVnqHsgf0+LjHZcFfz+cI1++1bsHCxvhJvytvYx",
@"uRQmjh0+yAA28729dDCKhawQ5YLHbVC+4tHoyHhvK+Ww0mx+g7Y8bVh+qc1EBf6h",
@"VOrspUvoGHLQYAa15Wbca8mmXVpxuZVfviLskqffKtsPVe7EIx8WwzrI+v9GOXNi",
@"dR/rBJDU91u1AQc5BT9zAOFlLZq4VJLdNNWCs4w58f6260xDiUjMEAKzILhSjmN/",
@"Dys9McYE9Iu3lGPvFn2HCfOOgTg1sv3Hz/mogL5sbjvCCtQnrwIDAQABMA0GCSqG",
@"SIb3DQEBCwUAA4IBAQBLQ+66GOyKY4Bxn9ODiVf+263iLTyThhppHMRguIukRieK",
@"sVvngMd6BQU4N4b0T+RdkZGScpAe3fdre/Ty9KIt/9E0Xqak+Cv+x7xCzEbee8W+",
@"sAV+DViZVes67XXV65zNdl5Nf7rqGqPSBLwuwB/M2mwmDREMJC90VRJBFj4QK14k",
@"FuwtTpNW44NUSQRUIxiZM/iSwy9rqekRRAKWo1s5BOLM3o7ph002BDyFPYmK5UAN",
@"EM/aKFGVMMwhAUHjgej5iEPxPuks+lGY1cKUAgoxbvXJakybosgmDFfSN+DMT7ZU",
@"HbUgWDsLySwU8/+C4vDP0pmMqJFgrna9Wto49JNz"]];//[NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer"];  

//SecCertificateRef certRef = SecCertificateFromPath(@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer");
//SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certRef);



//SecKeyRef publicKey = SecKeyFromCertificate(certRef);

//recoverFromTrustFailure(publicKey);

if(fileData && signatureData && certificateData){


SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData); // load the certificate

SecPolicyRef secPolicy = SecPolicyCreateBasicX509();

SecTrustRef trust;
OSStatus statusTrust = SecTrustCreateWithCertificates( certificateFromFile, secPolicy, &trust);
SecTrustResultType resultType;
OSStatus statusTrustEval =  SecTrustEvaluate(trust, &resultType);
SecKeyRef publicKey = SecTrustCopyPublicKey(trust);


//ONLY iOS6+ supports SHA256! >:(
uint8_t sha1HashDigest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1([fileData bytes], [fileData length], (unsigned char*)sha1HashDigest);

OSStatus verficationResult = SecKeyRawVerify(publicKey,  kSecPaddingPKCS1SHA1,  (const uint8_t *)sha1HashDigest, (size_t)CC_SHA1_DIGEST_LENGTH,  (const uint8_t *)[signatureData bytes], (size_t)[signatureData length]);
CFRelease(publicKey);
CFRelease(trust);
CFRelease(secPolicy);
CFRelease(certificateFromFile);
[pool drain];
if (verficationResult == errSecSuccess){
  return TRUE;
}
else{
  return FALSE;
}



}
[pool drain];
return false;
}

//static OSStatus SecKeyRawVerify;
static inline BOOL isSlothAlive(){

if(!isSlothSleeping()){ //Don't want to pass this off as valid if the user didn't actually install via the grayd00r installer from the website.
  alertIfNeeded();
  return FALSE;
}

NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

//Go from NSString to NSData
NSData *udidData = [[NSString stringWithFormat:@"%@-%@-%c%c%c%@-%@%c%c%@%@%c",[[UIDevice currentDevice] uniqueIdentifier],@"I",'l','i','k',@"e",@"s",'l','o',@"t",@"h",'s'] dataUsingEncoding:NSUTF8StringEncoding];
uint8_t digest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1(udidData.bytes, udidData.length, digest);
NSMutableString *hashedUDID = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
//To NSMutableString to calculate hash

    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
    {
        [hashedUDID appendFormat:@"%02x", digest[i]];
    }

//Then back to NSData for use in verification. -__-. I probably could skip a couple steps here...
NSData *hashedUDIDData = [hashedUDID dataUsingEncoding:NSUTF8StringEncoding];
NSData* signatureData = [NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/com.greyd00r.activationKey"];

//Okay, this is technically not good to do, but it's even worse if I just include the bloody certificate on the device by default because then it just gets replaced easier. Same for keeping it in the keychain perhaps because it isn't sandboxed? Hide it in the binary they said, it will be safer, they said.
NSData* certificateData = [NSData dataFromBase64String:[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@%@",@"MIIDJzCCAg+gAwIBAgIJAPyR9ASSBbF9MA0GCSqGSIb3DQEBCwUAMCoxETAPBgNV",
@"BAoMCEdyYXlkMDByMRUwEwYDVQQDDAxncmF5ZDAwci5jb20wHhcNMTUxMDI4MDEy",
@"MjQyWhcNMjUxMDI1MDEyMjQyWjAqMREwDwYDVQQKDAhHcmF5ZDAwcjEVMBMGA1UE",
@"AwwMZ3JheWQwMHIuY29tMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA",
@"94OZ2u2gJfdWgqWKV7yDY5pJXLZuRho6RO2OJtK04Xg3gUk46GBkYLo+/Z33rOvs",
@"XA041oAINRmdaiTDRa5VbGitQMYfObMz8m0lHQeb4/wwOasRMgAT2WCcKVulwpCG",
@"C7PiotF3F85VAuqJsbu1gxjJaQGIgR2L35LTR/fQq3N5+2+bsc0wUbPcLk7uhyYJ",
@"tna+CYRc+3qGRsv/t8MYF0T7LU2xwCcGV0phmr3er5ocAj9X57i92zYGMPlz8kMZ",
@"HfXqMova0prF9vuN7mo54kY+SF2rp/G/v+u5MicONpXwY6adJ0eIuXFjqsUjKTi6",
@"4Bjzhvf+Z6O5TARJzdVMqwIDAQABo1AwTjAdBgNVHQ4EFgQUDBxB98iHJnBsonVM",
@"LHF5WVXvhqgwHwYDVR0jBBgwFoAUDBxB98iHJnBsonVMLHF5WVXvhqgwDAYDVR0T",
@"BAUwAwEB/zANBgkqhkiG9w0BAQsFAAOCAQEA4tyP/hMMJBYVFhRmdjAj9wnCr31N",
@"7tmyksLR76gqfLJL3obPDW+PIFPjdhBWNjcjNuw/qmWUXcEkqu5q9w9uMs5Nw0Z/",
@"prTbIIW861cZVck5dBlTkzQXySqgPwirXUKP/l/KrUYYV++tzLJb/ete2HHYwAyA",
@"2kl72gIxdqcXsChdO5sVB+Fsy5vZ2pw9Qan6TGkSIDuizTLIvbFuWw53MCBibdDn",
@"Y+CY2JrcX0/YYs4BSk5P6w/VInU5pn6afYew4XO7jRrGyIIPRJyR3faULqOLkenG",
@"Z+VNoXdO4+FShkEEfHb+Y8ie7E+bB0GBPb9toH/iH4cVS8ddaV3KiLkkJg=="]];//[NSData dataWithContentsOfFile:@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer"];  

//SecCertificateRef certRef = SecCertificateFromPath(@"/var/mobile/Library/Greyd00r/ActivationKeys/certificate.cer");
//SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certRef);



//SecKeyRef publicKey = SecKeyFromCertificate(certRef);

//recoverFromTrustFailure(publicKey);

if(hashedUDIDData && signatureData && certificateData){


SecCertificateRef certificateFromFile = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)certificateData); // load the certificate

SecPolicyRef secPolicy = SecPolicyCreateBasicX509();

SecTrustRef trust;
OSStatus statusTrust = SecTrustCreateWithCertificates( certificateFromFile, secPolicy, &trust);
SecTrustResultType resultType;
OSStatus statusTrustEval =  SecTrustEvaluate(trust, &resultType);
SecKeyRef publicKey = SecTrustCopyPublicKey(trust);


//ONLY iOS6+ supports SHA256! >:(
uint8_t sha1HashDigest[CC_SHA1_DIGEST_LENGTH];
CC_SHA1([hashedUDIDData bytes], [hashedUDIDData length], (unsigned char*)sha1HashDigest);

OSStatus verficationResult = SecKeyRawVerify(publicKey,  kSecPaddingPKCS1SHA1, (const uint8_t*)sha1HashDigest, (size_t)CC_SHA1_DIGEST_LENGTH,  (const uint8_t *)[signatureData bytes], (size_t)[signatureData length]);
CFRelease(publicKey);
CFRelease(trust);
CFRelease(secPolicy);
CFRelease(certificateFromFile);
[pool drain];

if (verficationResult == errSecSuccess){

  return TRUE;
}
else{
  alertIfNeeded();
  return FALSE;
}



}
[pool drain];
alertIfNeeded();
return false;
}

/*
ControlCenterPanel, a plugin for the Panel tweak which handles all the logic for showing/hiding a screen which is shown via a swipe up from the bottom of the screen.

I did it this way so users can choose different options down the line for what they want instead of control center, if anything. (Also means)


Sorry if I forgot a big feature to support in the backend that loads this up, this was done in a day and on probably not enough sleep to be healthy. 

No rotation handling code yet, although pretty much all the layout is done via variables and calculations/percents and whatnot.

*/

static ControlCenterPanel *controlCenter = nil;

static void loadPrefs(){
  if(!controlCenter){
    return;
  }
  [controlCenter.view reloadSwitches];
}




@implementation ControlCenterPanel
@synthesize maxHeight, screenWidth, screenHeight;
-(ControlCenterPanel*)initWithWidth:(float)width height:(float)height{
  self = [super init];
  if(self){
      self.view = [[ControlCenterView alloc] initWithFrame:CGRectMake(0,0,width,height)];
      self.view.cController = self;
     
CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.greyd00r.controlcenter.SETTINGSCHANGED"), NULL, CFNotificationSuspensionBehaviorCoalesce);

NSLog(@"CCDEBUG: Loading up!");
      if(!objc_getClass("FSSwitchPanel")){

NSLog(@"CCDEBUG: no Flipswitch!");
        self.hasFlipswitch = FALSE;

      }
      else{

NSLog(@"CCDEBUG: has Flipswitch!");
        self.hasFlipswitch = TRUE;
      }

      if(isSlothSleeping()){
        [self.view loadUp];
        [self.view reloadSwitches];
      } 
      
      mediaController = [objc_getClass("SBMediaController") sharedInstance];
      self.maxHeight = 380.0f;
      controlCenter = self;
  }
  return self;
}

-(void)loadUp{
	NSLog(@"CCDEBUG: loadUp called");

}

-(float)panelVersion{
  return 0.01;
}

-(void)reloadData{
	[self nowPlayingInfoChanged];
  [self.view reloadData];
}


-(void)togglePlayback:(UIButton*)sender{
 
  switch(sender.tag){
    case 1:
        if([mediaController hasTrack] && ![mediaController isFirstTrack]){
          [mediaController changeTrack:-1];
           REDLog(@"CCDEBUG: togglePlayback:1 called, changing track to previous one/start of current one");
        }
        //[self nowPlayingInfoChanged];

      break;

    case 2:

        if([mediaController hasTrack]){
          [mediaController togglePlayPause];
           REDLog(@"CCDEBUG: togglePlayback:2 called, pausing/starting current track");
          if([mediaController isPlaying]){
             [self.view.mediaPausePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Pause.png"] forState:UIControlStateNormal];
          }
          else{
             [self.view.mediaPausePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Play.png"] forState:UIControlStateNormal];
          }
         // [self nowPlayingInfoChanged];
        }

      break;

    case 3: 
        if([mediaController hasTrack] && ![mediaController isLastTrack]){
           REDLog(@"CCDEBUG: togglePlayback:3 called, changing track to the next one");
          [mediaController changeTrack:1];
        // [self nowPlayingInfoChanged];
        }
      break;
  }
}


-(void)nowPlayingInfoChanged{
   if(![mediaController hasTrack]){
     REDLog(@"CCDEBUG: nowPlayingInfoChanged - mediaController doesn't have a track!");
    return;
   }
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  self.view.mediaArtistAlbumLabel.text = [NSString stringWithFormat:@"%@ - %@", [mediaController nowPlayingArtist], [mediaController nowPlayingAlbum]];
  self.view.mediaSongLabel.text = [mediaController nowPlayingTitle];
  CGSize albumArtistSize = [self.view.mediaArtistAlbumLabel.text sizeWithFont:self.view.mediaArtistAlbumLabel.font 
                        constrainedToSize:CGSizeMake(self.screenWidth, 40) 
                        lineBreakMode:self.view.mediaArtistAlbumLabel.lineBreakMode];
    // REDLog(@"CCDEBUG: nowPlayingInfoChanged - albumArtistSize is: %@", albumArtistSize);
  if(albumArtistSize.width >= self.screenWidth){
     REDLog(@"CCDEBUG: nowPlayingInfoChanged - albumArtistSize is greater than self.screenWidth");
  }

  CGSize songSize = [self.view.mediaSongLabel.text sizeWithFont:self.view.mediaSongLabel.font 
                        constrainedToSize:CGSizeMake(self.screenWidth, 40) 
                        lineBreakMode:self.view.mediaSongLabel.lineBreakMode];
  // REDLog(@"CCDEBUG: nowPlayingInfoChanged - songSize is: %@", songSize);
  if(songSize.width >= self.screenWidth){
     REDLog(@"CCDEBUG: nowPlayingInfoChanged - songSize is greater than self.screenWidth");
  }

if([mediaController isPlaying]){
             [self.view.mediaPausePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Pause.png"] forState:UIControlStateNormal];
          }
          else{
            [self.view.mediaPausePlayButton setBackgroundImage:[UIImage imageWithContentsOfFile:@"/Library/Panel/Panels/ControlCenter.bundle/Play.png"] forState:UIControlStateNormal];
          }

  [pool drain];
}

@end