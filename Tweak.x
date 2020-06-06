@interface SBVolumeControl
-(void)changeVolumeByDelta:(float)arg1;
@end
static BOOL shouldSwap;
static BOOL prevOrientationIsRegular = YES;
%hook SBVolumeControl
-(BOOL)_isVolumeHUDVisibleOrFading {
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationLandscapeLeft){
		shouldSwap = YES;
    prevOrientationIsRegular = NO;
	} else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown){
		shouldSwap = YES;
    prevOrientationIsRegular = NO;
  } else if (deviceOrientation == UIDeviceOrientationFaceUp && !prevOrientationIsRegular){
    shouldSwap = YES;
    prevOrientationIsRegular = NO;
  } else {
		shouldSwap = NO;
    prevOrientationIsRegular = YES;
	}
	return %orig;
}
-(void)increaseVolume{
  if(shouldSwap){
    [self changeVolumeByDelta:-0.0625];
  }else{
    %orig;
  }
}
-(void)decreaseVolume {
  if(shouldSwap){
    [self changeVolumeByDelta:0.0625];
  }else{
    %orig;
  }
}
%end