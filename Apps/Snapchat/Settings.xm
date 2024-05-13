// #import "Snapchat.h"
// #import "../../AFSocialRootViewController.h"





// @interface SIGHeaderItem : NSObject 
// @property(copy, nonatomic) NSString *title; // @synthesize title=_title;
// @end 

// @interface SIGHeader : UIView
// @end 
// %group HooksSCSettings
// %hook SIGHeader
// -(void)setUpAnimatedTransitionToHeaderItem:(id)arg1{
// %orig;
// ((SIGHeaderItem*)[self performSelector:@selector(currentHeaderItem)]).title = @"SnapTxC";

// }
// %end 

// @interface SIGHeaderTitle : UIView
// @end 

// %hook SIGHeaderTitle
// -(void)_titleTapped:(id)arg1{

// UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[AFSocialRootViewController alloc] init]];
// [TxCShowView() presentViewController:navVC animated:YES completion:nil];


// }
// %end 
// %end 
// %ctor{
// if(BUNDLEIDEQUALS(@"com.toyopagroup.picaboo")){
// NSString *Token_Spotify    = [TxCManagerHelper TokenSpotify];
// NSString *AppSericlSpotify = [TxCManagerHelper AppSericlSpotify];
// NSString *Spotify_App   = [azfencrpt decrypt:Token_Spotify password:AppSericlSpotify];
// NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
// [dateFormat setDateFormat:@"YYYY/MM/dd"];
// NSDate *SpotifySearch = [dateFormat dateFromString:Spotify_App];
// NSComparisonResult result = [[NSDate date] compare:SpotifySearch];
// BOOL SaveAction = (result != NSOrderedDescending);
// if(SaveAction){
// %init(HooksSCSettings);
// }
// }
// }