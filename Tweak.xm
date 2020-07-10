static BOOL volumeDownButtonIsDown = YES;
static BOOL volumeUpButtonIsDown = YES;
static BOOL shouldSwap;
static BOOL shouldSwapReversed = NO;
static BOOL prevOrientationIsRegular = YES;
NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.volumeswapprefs"];
bool isReverse = [[bundleDefaults objectForKey:@"isReversed"]boolValue];
bool isEnabled = [[bundleDefaults objectForKey:@"isEnabled"]boolValue];
BOOL og = og;

@interface SBVolumeControl
-(void)changeVolumeByDelta:(float)arg1;
@end
@interface SBVolumeHardwareButtonActions : SBVolumeControl
@end

/*%hook SBVolumeHardwareButtonActions
-(void)volumeDecreasePressDown {
volumeDownButtonIsDown = NO;
}
-(void)volumeDecreasePressUp {
volumeDownButtonIsDown = YES;
}
-(void)volumeIncreasePressDown {
  volumeUpButtonIsDown = NO;
}
-(void)volumeIncreasePressUp {
  volumeUpButtonIsDown = YES;
}
%end*/

%hook SBVolumeControl
-(BOOL)_isVolumeHUDVisibleOrFading {
if(isEnabled){
  UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationLandscapeLeft && !isReverse){
		shouldSwap = YES;
    prevOrientationIsRegular = NO;
	} else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown && !isReverse){
		shouldSwap = YES;
    prevOrientationIsRegular = NO;
  } else if (deviceOrientation == UIDeviceOrientationFaceUp && !prevOrientationIsRegular && !isReverse){
    shouldSwap = YES;
    prevOrientationIsRegular = NO;
  } else if (deviceOrientation == UIDeviceOrientationPortrait && isReverse){
    shouldSwap = NO;
    shouldSwapReversed = YES;
    prevOrientationIsRegular = NO;
  } else if (deviceOrientation == UIDeviceOrientationLandscapeRight && isReverse) {
    shouldSwap = NO;
    shouldSwapReversed = YES;
    prevOrientationIsRegular = NO;
  } else if (deviceOrientation != UIDeviceOrientationPortrait && deviceOrientation != UIDeviceOrientationLandscapeRight && isReverse) {
    shouldSwap = NO;
    shouldSwapReversed = NO;
  } else {
		shouldSwap = NO;
    prevOrientationIsRegular = YES;
	}
  /*while(volumeUpButtonIsDown) {
    if(shouldSwap){
      [self changeVolumeByDelta:-0.0625];
    } else if (shouldSwapReversed && !shouldSwap) {
      [self changeVolumeByDelta:-0.0625];
    } else {
      return og;
      }
    }
  while(volumeDownButtonIsDown) {
    if(shouldSwap){
      [self changeVolumeByDelta:0.0625];
    } else if (shouldSwapReversed && !shouldSwap) {
      [self changeVolumeByDelta:0.0625];
    } else {
    return og;
      }
    }*/
	  return og;
  }
  return og;
}
-(void)increaseVolume {
  if(isEnabled){
    while(shouldSwap && volumeUpButtonIsDown){
      [self changeVolumeByDelta:-0.0625];
    } while (shouldSwapReversed && !shouldSwap && volumeDownButtonIsDown) {
      [self changeVolumeByDelta:-0.0625];
    }
  } else %orig;
}
-(void)decreaseVolume {
  if(isEnabled) {
    while (shouldSwap && volumeDownButtonIsDown) {
      [self changeVolumeByDelta:0.0625];
    } while (shouldSwapReversed && !shouldSwap && volumeUpButtonIsDown) {
      [self changeVolumeByDelta:0.0625];
    }
  } else %orig;
}
%end

