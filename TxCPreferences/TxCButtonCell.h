//
//  TxCButtonCell.h
//  FRPreferences
//
//  Created by Fouad Raheb on 7/2/15.
//  Copyright (c) 2015 F0u4d. All rights reserved.
//

#import "FRPCell.h"

typedef void (^TxCButtonCellChanged)(UILabel *sender);

@interface TxCButtonCell : FRPCell

@property (nonatomic, strong) UILabel *TextAction;

+ (instancetype)cellWithTitle:(NSString *)title subTitle:(NSString *)subTitle setting:(FRPSettings *)setting postNotification:(NSString *)notification changeBlock:(TxCButtonCellChanged)block;
 
@end
