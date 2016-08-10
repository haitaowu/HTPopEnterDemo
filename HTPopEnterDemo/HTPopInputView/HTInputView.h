//
//  HTInputView.h
//  TMPDemo
//
//  Created by taotao on 8/8/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoneBlock) (NSArray*);
typedef void(^CancelBlock) ();

@interface HTInputView : UIView
@property (nonatomic,weak)UILabel  *titleLabel;
@property (nonatomic,strong)NSArray *placeholders;
- (instancetype)initWith:(NSString*)title itemTitles:(NSArray*) itemTitles placeholders:(NSArray*)placeholders done:(DoneBlock) doneblock cancel:(CancelBlock) cancelBlock;
//+ (void)showPopViewWith:(NSArray*)titles placeholders:(NSArray*)placeholders;
//+ (void)didConfirm:(DoneBlock)confirmBlock;
- (void)showPopView;

@end
