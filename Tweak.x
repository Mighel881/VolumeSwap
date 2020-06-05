@interface SBVolumeControl
-(void)changeVolumeByDelta:(float)arg1;
@end
static BOOL shouldSwap;
%hook SBVolumeControl
-(BOOL)_isVolumeHUDVisibleOrFading {
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationLandscapeLeft){
		shouldSwap = YES;
	} else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown){
		shouldSwap = YES;
	} else {
		shouldSwap = NO;
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