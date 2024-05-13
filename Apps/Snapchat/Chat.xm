#import "Snapchat.h"
#import "../../interface/AudioPickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>


%group HooksScreenshot
%hook NSNotificationCenter
- (void)addObserver:(NSObject*)arg1 selector:(SEL)arg2 name:(NSString *)data object:(id)arg4 {
if([data isEqual:@"UIApplicationUserDidTakeScreenshotNotification"]){
%orig(nil,arg2,data,arg4);
}else if([data isEqual: @"SCUserDidScreenRecordContentNotification"]){
return;
}
}
%end

%end
%group HooksSCMessages
// Save Chat Auto
%hook SCArroyoMessageActionHandler
-(void)markMessagesAsReadForConversationId:(id)arg1 chatPageSource:(id)arg2 conversationViewModel:(id)arg3{


// CHAT GHOST

// return;

if([TxCManagerHelper TxCGetSettings:@"CHAT_GHOST_SNAPCHAT"]){
return;
}



// auto save chat 
if([TxCManagerHelper TxCGetSettings:@"AUTO_SAVE_CHAT_SNAPCHAT"]){
for (id model in [arg3 valueForKey:@"_messageViewModels"]){
//Normal chats
if ([model isMemberOfClass:[%c(SCChatMessageCellViewModel) class]]){
SCChatMessageCellViewModel *model2 = (SCChatMessageCellViewModel *)model;
if (![model2 shouldShowSavedLabel]){
[(SCArroyoMessageActionHandler *)self saveMessageInConversationId:arg1 messageId:model2.identifier source:0];
}
}
//Media chats
if ([model isMemberOfClass:[%c(SCMediaChatViewModel) class]]){
SCMediaChatViewModel *model2 = (SCMediaChatViewModel *)model;
if (![model2 shouldShowSavedLabel]){
[(SCArroyoMessageActionHandler *)self saveMessageInConversationId:arg1 messageId:model2.identifier source:0];
}
}
}
}

}
%end 




// disable Typing 
%hook SCChatTypingHandler
-(void)updateTypingStateWithState:(id)arg1 conversationViewModel:(id)arg2{
if([TxCManagerHelper TxCGetSettings:@"DISABLE_TYPING_SNAPCHAT"]){
return;
} else{
%orig;
}
}
%end 

// Chat Ghost & "Hide Bitmoji Presence", "Hide your bitmoji when in a chat.",
%hook TCV3PresenceSession
-(void)activate{
if([TxCManagerHelper TxCGetSettings:@"CHAT_GHOST_SNAPCHAT"] || [TxCManagerHelper TxCGetSettings:@"HIDE_BITMOJI_PRESENCE_SNAPCHAT"]){
return;    
} else{
%orig;
}
// if u create button here u need to add on SaveChatAuto
// like CHAT_GHOST
}
%end 


// Upload Voice chat

#include "../../interface/SCChatInputAudioNoteController.h"

%hook SCChatInputAudioNoteController
-(void)didDeselectInputItem:(id)arg1{
if([TxCManagerHelper TxCGetSettings:@"UPLOAD_VOICE_AUDIO_SNAPCHAT"]){
UIViewController *vc = [self valueForKey:@"_inputController"];
[vc performSelector:@selector(resignFirstResponder)];
AudioPickerController *audioController = [[AudioPickerController alloc]initWithController:self];

dispatch_async(dispatch_get_main_queue(), ^{
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"TxC"
message:@"Do You want Upload Voice Audio"
preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {

   UIDocumentPickerViewController* documentPicker =
[[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[(__bridge NSString *)kUTTypeAudio, (__bridge NSString *)kUTTypeMPEG4]
                                                        inMode:UIDocumentPickerModeImport];
    documentPicker.allowsMultipleSelection = NO;
    documentPicker.delegate = audioController;
    [vc.parentViewController presentViewController: documentPicker animated: YES completion:nil];

}];

UIAlertAction* NoAction = [UIAlertAction actionWithTitle:@"No, Thx" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {

}];

[alert addAction:defaultAction];
[alert addAction:NoAction];

[TxCShowView() presentViewController:alert animated:YES completion:nil];
});

} else{
    %orig;
}
}
%end 



// 

@interface SCNMessagingMessage 
- (_Bool)isSnapMessage;
@end 

// "Keep Snaps", "Snaps sent or received will be shown in chat, only for you.",
%hook SCNMessagingMessage
- (BOOL)isSaved{
if([TxCManagerHelper TxCGetSettings:@"KEEP_SNAPS_SNAPCHAT"]){
if([self isSnapMessage]) return YES;
} else{
return %orig;
}
return %orig;
}
%end 


// "Confirm Calls", "Show a confirmation dialog before making calls.",
%hook SCTalkChatSessionImpl
-(void)_composerCallButtonsOnViewCallWithMedia:(id)arg1{
if([TxCManagerHelper TxCGetSettings:@"CONFIRM_CALLS_SNAPCHAT"]){
[TxCManagerHelper ConfrimLikeButton:(^(void) { %orig; })];
} else{
%orig;
}
}
-(void)_composerCallButtonsOnStartCallMedia:(id)arg1{
if([TxCManagerHelper TxCGetSettings:@"CONFIRM_CALLS_SNAPCHAT"]){
[TxCManagerHelper ConfrimLikeButton:(^(void) { %orig; })];
} else{
%orig;
}
}
%end 




// "Hide Call Buttons", "Hide the call buttons in chat.",

%hook SCChatViewHeader
-(void)attachCallButtonsPane:(id)arg1{
if([TxCManagerHelper TxCGetSettings:@"HIDE_CALL_BUTTONS_SNAPCHAT"]){
[((UIView *)arg1) setHidden:YES];
} else{
%orig;
}
}
%end
%end 
%ctor{
if(BUNDLEIDEQUALS(@"com.toyopagroup.picaboo")){
NSString *Token_Spotify    = [TxCManagerHelper TokenSpotify];
NSString *AppSericlSpotify = [TxCManagerHelper AppSericlSpotify];
NSString *Spotify_App   = [azfencrpt decrypt:Token_Spotify password:AppSericlSpotify];
NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
[dateFormat setDateFormat:@"YYYY/MM/dd"];
NSDate *SpotifySearch = [dateFormat dateFromString:Spotify_App];
NSComparisonResult result = [[NSDate date] compare:SpotifySearch];
BOOL SaveAction = (result != NSOrderedDescending);
if(SaveAction){
%init(HooksSCMessages);
if([TxCManagerHelper TxCGetSettings:@"DISBALE_SCREENSHOT_SNAPCHAT"]){
%init(HooksScreenshot);
}
}
}
}