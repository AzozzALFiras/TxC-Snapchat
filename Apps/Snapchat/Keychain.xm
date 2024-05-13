#import "UIKit/UIKit.h"
#include <Foundation/Foundation.h>
#include "../../interface/TxCManagerHelper.h"

@interface UICKeyChainStore : NSObject
+ (UICKeyChainStore *)keyChainStoreWithService:(NSString *)service;
+ (BOOL)removeAllItems;
- (BOOL)removeAllItems;
- (NSArray *)allItems;
- (instancetype)initWithService:(NSString *)service;
@end


%group SnapKeycain

%config(generator=internal)

//Snapchat
%hook SCUnauthenticatedLandingPage
- (void)logInTapped {
    


dispatch_async(dispatch_get_main_queue(), ^{
UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"TxC"
message:[[NSUserDefaults standardUserDefaults] stringForKey:@"fc_uuidForDevice"]
preferredStyle:UIAlertControllerStyleAlert];

UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"1" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {

Class UICKeyChainStore = NSClassFromString(@"UICKeyChainStore");
[UICKeyChainStore removeAllItems];


}];

UIAlertAction* default1Action = [UIAlertAction actionWithTitle:@"2" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {

[[NSUserDefaults standardUserDefaults] setObject:@"82f8d1919edc49c5866e35a0699286d2" forKey:@"fc_uuidForDevice"];

}];

UIAlertAction* default2Action = [UIAlertAction actionWithTitle:@"3" style:UIAlertActionStyleDefault
handler:^(UIAlertAction * action) {
   %orig;
}];

[alert addAction:defaultAction];
[alert addAction:default1Action];
[alert addAction:default2Action];


[TxCShowView() presentViewController:alert animated:YES completion:nil];
});

}
%end 
%end 
%ctor{
    %init(SnapKeycain);
}