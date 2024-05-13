//
//  TxCButtonCell.m
//  FRPreferences
//
//  Created by Fouad Raheb on 7/2/15.
//  Copyright (c) 2015 F0u4d. All rights reserved.
//

#import "TxCButtonCell.h"
#import "../interface/Location/TxCMapView.h"
#import "../interface/TxCManagerHelper.h"

@implementation TxCButtonCell

+ (instancetype)cellWithTitle:(NSString *)title subTitle:(NSString *)subTitle setting:(FRPSettings *)setting postNotification:(NSString *)notification changeBlock:(TxCButtonCellChanged)block {
    return [[self alloc] cellWithTitle:title subTitle:subTitle setting:setting postNotification:notification changeBlock:block];
}

- (instancetype)cellWithTitle:(NSString *)title subTitle:(NSString *)subTitle setting:(FRPSettings *)setting postNotification:(NSString *)notification changeBlock:(TxCButtonCellChanged)block {
TxCButtonCell *cell = [super initWithTitle:title subTitle:subTitle setting:setting];

UIButton *UpdateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
[UpdateButton setImage:[UIImage systemImageNamed:@"repeat"] forState:UIControlStateNormal];
[UpdateButton addTarget:self action:@selector(Chanage_Location) forControlEvents:UIControlEventTouchUpInside];
[UpdateButton setFrame:CGRectMake(0, 0, 100, 35)];
cell.accessoryView = UpdateButton;

return cell;
}

-(void)Chanage_Location{
TxCMapView *mapView = [TxCMapView new];
mapView.title = @"Chanage Location";
UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:mapView];
[TxCShowView() presentViewController:navVC animated:YES completion:nil];

}
- (void)switchChanged:(UILabel *)switchItem {
    // self.setting.value = [NSNumber numberWithBool:[switchItem isOn]];
    // if (self.valueChanged) {
    //     self.valueChanged(switchItem);
    // }
    // [[NSNotificationCenter defaultCenter] postNotificationName:self.postNotification object:switchItem];
}

- (void)layoutSubviews {
    [super layoutSubviews];
  //  self.TextAction.onTintColor = self.tintUIColor;
//    self.TextAction.tintColor = self.tintUIColor;
}

@end
