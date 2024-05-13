#import "Snapchat.h"

static BOOL Allow_Seen_Story = FALSE;

%group HooksSCStory
// Save & Seen Button 
%hook SCOperaPageViewController
-(void)viewDidLoad{
%orig;


// "Stories Auto-Seen", "Automatically mark all non-friends stories as seen.",
if([TxCManagerHelper TxCGetSettings:@"STOIRES_AUTO_SEEN_SNAPCHAT"]){
NSDictionary* properties = (NSDictionary*)[[self performSelector:@selector(page)] performSelector:@selector(properties)];
if(properties[@"discover_story_composite_id"] != nil){
Allow_Seen_Story = TRUE;
}
}
if([TxCManagerHelper TxCGetSettings:@"SAVE_MEDIA_SNAPCHAT"]){
UIImage *Save = [TxCManagerHelper TxCImage:@"square.and.arrow.down"];
[TxCManagerHelper TxCButtonSnapchat:Save height:0.70 InView:self.view Target:self Action:@selector(TxCSaveMedia)];
}

if([TxCManagerHelper TxCGetSettings:@"BUTTON_SEEN_STORIRES_SNAPCHAT"]){
UIImage *Eyes = [TxCManagerHelper TxCImage:@"eye.fill"];
[TxCManagerHelper TxCButtonSnapchat:Eyes height:0.65 InView:self.view Target:self Action:@selector(TxCMakeSeen)];
}

}
%new 
-(void)TxCMakeSeen{
Allow_Seen_Story = TRUE;
}
%new 
-(void)TxCSaveMedia{
NSArray *mediaArray = [self shareableMedias];
if(mediaArray.count == 1){
SCOperaShareableMedia *mediaObject = (SCOperaShareableMedia *) [mediaArray firstObject];
if(mediaObject.mediaType == 0){
UIImage *snapImage = [mediaObject image];
UIImageWriteToSavedPhotosAlbum(snapImage, nil, nil, nil);
NSLog(@"Saved");
} else {
NSLog(@"error");
}
} else {
for (SCOperaShareableMedia *mediaObject in mediaArray){
if ((mediaObject.mediaType == 1) && (mediaObject.videoAsset) && (mediaObject.videoURL == nil)){
AVURLAsset *asset = (AVURLAsset *)(mediaObject.videoAsset);
NSURL *assetURL = asset.URL;
NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject];
NSURL *tempVideoFileURL = [documentsURL URLByAppendingPathComponent:[assetURL lastPathComponent]];
AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality];
exportSession.outputURL = tempVideoFileURL;
exportSession.outputFileType = AVFileTypeQuickTimeMovie;
[exportSession exportAsynchronouslyWithCompletionHandler:^{
UISaveVideoAtPathToSavedPhotosAlbum(tempVideoFileURL.path, nil, @selector(video:didFinishSavingWithError:contextInfo:), nil);
NSLog(@"Saved 2");
}];
} else if (mediaObject.mediaType == 1 && mediaObject.videoURL && mediaObject.videoAsset == nil){
UISaveVideoAtPathToSavedPhotosAlbum(mediaObject.videoURL.path, nil, @selector(video:didFinishSavingWithError:contextInfo:), nil);
NSLog(@"Saved 1");
} else {
NSLog(@"error");
}
}
}
}
%new
-(void)ASS{

}
%end 


// disable Seen 
%hook SCSingleStoryViewingSession
-(void)_markStoryAsViewedWithStorySnap:(id)arg1{
// Seen Button
if([TxCManagerHelper TxCGetSettings:@"DISABLE_SEEN_STOIRES_SNAPCHAT"]){
if(Allow_Seen_Story){
%orig;
Allow_Seen_Story = FALSE;
} else{
return;
}
} else{
%orig;
}
}
%end 


// Upload Media 

%hook SCSwipeViewContainerViewController
-(void)viewDidLoad{
%orig;
if([TxCManagerHelper TxCGetSettings:@"UPLOAD_MEDIA_SNAPCHAT"]){
if([[self valueForKey:@"_debugName"] isEqual:@"Camera"]){
UIImage *Upload = [TxCManagerHelper TxCImage:@"icloud.and.arrow.up.fill"];
[TxCManagerHelper TxCButtonSnapchat:Upload height:0.70 InView:self.view Target:self Action:@selector(TxCUploadMedia)];
}
}

}
%new
-(void)TxCUploadMedia{
UIImagePickerController *picker = [[UIImagePickerController alloc] init];
picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
picker.delegate = self;
picker.allowsEditing = YES;
picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
[self presentViewController:picker animated:YES completion:NULL];
[self.view endEditing:YES];
}
%new
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
[picker dismissViewControllerAnimated:YES completion:NULL];
NSURL *ImageURL = [info objectForKey:@"UIImagePickerControllerImageURL"];
NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
__block SCMainCameraViewController *SCMainUpload;
dispatch_async(dispatch_get_main_queue(), ^{
@try{
SCMainUpload = [((UIViewController*)self).childViewControllers firstObject];
}@catch(NSException*e){
NSLog(@"error");
}
if(videoURL !=nil){
[SCMainUpload _handleDeepLinkShareToPreviewWithVideoFile:videoURL]; // Upload Video
} else{
[SCMainUpload _handleDeepLinkShareToPreviewWithImageFile:ImageURL]; // Upload Image
}
});
[picker dismissViewControllerAnimated:YES completion:NULL];
}
%end 




// Spoof 

%hook SCUnifiedProfileMyStoriesHeaderDataModel
- (long long) totalViewCount{
return [TxCManagerHelper TxCGetNumber:@"SPOOF_TOTALVIEW_SNAPCHAT"];
}
- (long long) totalScreenshotCount{
return [TxCManagerHelper TxCGetNumber:@"SPOOF_SCREENSHOT_SNAPCHAT"];
}

- (long long) totalStoryReplyCount{
return [TxCManagerHelper TxCGetNumber:@"SPOOF_STORYREPLAY_SNAPCHAT"];
}
%end 


// Streak Expiry
%hook SCFriendmojiPresenter
- (id) _streakStringWithLength:(long long)arg1 expiration:(float)arg2 friendUserId:(id)arg3 shouldDisplayStreakCounter:(bool)arg4 showExpiryTimeForDebugging:(bool)arg5{
arg1 = [TxCManagerHelper TxCGetNumber:@"SPOOF_STREAKSTRING_SNAPCHAT"];
return %orig(arg1,arg2,arg3,arg4,arg5);
}
%end 


// Chanage Location 


%hook SCLocationManager
-(id)location{
if([TxCManagerHelper TxCGetSettings:@"CHANAGE_LOCATION_SANPCHAT"]){
NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
double longitude = [[prefs stringForKey:@"longitude"] doubleValue];
double latitude  = [[prefs stringForKey:@"latitude"] doubleValue];
CLLocation * newlocation = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
return newlocation;
}
return %orig;
}
%end


%hook SCAdsHoldoutExperimentContext
- (bool)canShowAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowCognacAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowStoryAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowContentInterstitialAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowDiscoverAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowShowsAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowEmbeddedWebViewAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}

- (bool)canShowPublicStoriesAds {
if(![TxCManagerHelper TxCGetSettings:@"DISABLE_ADS_SNAPCHAT"]){
return %orig;
}
return 0;
}
%end


%end 
%ctor{
if(BUNDLEIDEQUALS(@"com.toyopagroup.picaboo")){
%init(HooksSCStory);
}
}
