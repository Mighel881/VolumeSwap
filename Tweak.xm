static BOOL shouldSwap;
static BOOL shouldSwapReversed = NO;
static BOOL prevOrientationIsRegular = YES;
NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.volumeswapprefs"];
bool isReverse = [[bundleDefaults objectForKey:@"isReversed"]boolValue];
bool isEnabled = [[bundleDefaults objectForKey:@"isEnabled"]boolValue];

@interface SBVolumeControl
-(void)changeVolumeByDelta:(float)arg1;
@end
@interface SBVolumeHardwareButtonActions : SBVolumeControl
@end

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
  }
  return %orig;
}
-(void)increaseVolume {
  if(isEnabled){
    if(shouldSwap){
      [self changeVolumeByDelta:-0.0625];
    } if (shouldSwapReversed && !shouldSwap) {
      [self changeVolumeByDelta:-0.0625];
    }
  } else %orig;
}
-(void)decreaseVolume {
  if(isEnabled) {
    if (shouldSwap) {
      [self changeVolumeByDelta:0.0625];
    } if (shouldSwapReversed && !shouldSwap) {
      [self changeVolumeByDelta:0.0625];
    }
  } else %orig;
}
%end

