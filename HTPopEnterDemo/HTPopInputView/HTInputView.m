//
//  HTInputView.m
//  TMPDemo
//
//  Created by taotao on 8/8/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "HTInputView.h"
#import "HTInputField.h"


#define kManBarColor                   [UIColor colorWithRed:251/255.0 green:39/255.0 blue:96/255.0 alpha:1]

#define kScreenSize                     [UIScreen mainScreen].bounds.size
#define kTitleHeight                    50
#define kSubTitleHeight                 25
#define kSubTitleVerticalMargin         8
#define kMarginsSide                    50
#define kItemsHeight                    50
#define kSubViewMarginSide              10
#define kConfirmBtnHeight               44
#define kConfirmBtnMarginsSide          30
#define kConfirmBtnBottomMargin         10



@interface HTInputView()
@property (nonatomic,strong)NSMutableArray *inputItems;
@property (nonatomic,strong)NSMutableArray *titleItems;
@property (nonatomic,strong)NSArray *subTitles;
@property (nonatomic,weak)UIButton  *overlayerView;
@property (nonatomic,weak)UIButton  *confirmBtn;
@property (nonatomic,copy) DoneBlock doneBlock;
@property (nonatomic,copy) CancelBlock cancelBlock;
@end




@implementation HTInputView

- (instancetype)initWith:(NSString*)title itemTitles:(NSArray*) itemTitles placeholders:(NSArray*)placeholders done:(DoneBlock) doneblock cancel:(CancelBlock) cancelBlock{
    self = [self init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(boardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        self.inputItems = [NSMutableArray array];
        self.titleItems = [NSMutableArray array];
        self.backgroundColor = [UIColor whiteColor];
        [self setupUIWithTitle:title];
        self.doneBlock = doneblock;
        self.cancelBlock = cancelBlock;
        [self setSubTitles:itemTitles];
        [self setPlaceholders:placeholders];
    }
    return self;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize viewSize = self.bounds.size;
    CGRect frame = CGRectMake(0, 0, viewSize.width, kTitleHeight);
    self.titleLabel.frame = frame;
    [self.titleItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *label = (UILabel*)obj;
        CGFloat width = viewSize.width - (2 * kSubViewMarginSide);
        CGFloat titleY  = idx * (kItemsHeight + kSubTitleHeight  + kSubTitleVerticalMargin) + kTitleHeight + kSubTitleVerticalMargin;
        CGRect titleF = CGRectMake(kSubViewMarginSide, titleY, width, kSubTitleHeight);
        label.frame = titleF;
        CGFloat inputY  = titleY + kSubTitleHeight;
        HTInputField *item = [self.inputItems objectAtIndex:idx];
        CGRect inputF = CGRectMake(kSubViewMarginSide, inputY, width, kItemsHeight);
        item.frame = inputF;
    }];
    
    CGFloat btnY  = viewSize.height - kConfirmBtnHeight - kConfirmBtnBottomMargin;
    CGFloat btnX  = kConfirmBtnMarginsSide;
    CGFloat btnWidth  = viewSize.width - 2 * kConfirmBtnMarginsSide;
    CGRect btnF = CGRectMake(btnX, btnY, btnWidth, kConfirmBtnHeight);
    self.confirmBtn.frame = btnF;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - private methods
- (NSMutableArray*)inputContents
{
    NSMutableArray *contents = [NSMutableArray array];
    for (UITextField *textF in self.inputItems) {
        NSString *txt = [textF.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        if (txt.length > 0) {
            [contents addObject:textF.text];
        }else{
            [self shakeView:textF];
            return nil;
        }
    }
    if (contents.count > 0) {
        return contents;
    }else{
        return nil;
    }
}

#pragma mark - setup ui
- (void)setupUIWithTitle:(NSString*)title
{
    self.layer.cornerRadius = 10.0;
    self.clipsToBounds = YES;
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = kManBarColor;
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = title;
    [self addSubview:label];
    self.titleLabel = label;
    //2.confirm button init
    UIButton *confirmBtn = [[UIButton alloc] init];
    confirmBtn.layer.cornerRadius = 5.0;
    confirmBtn.backgroundColor = kManBarColor;
    self.confirmBtn = confirmBtn;
    [confirmBtn setTitle:@"Confirm" forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(tapConfirmBtn) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmBtn];
    
}

- (void)shakeView:(UITextField*)textField
{
    CAPropertyAnimation *animation = [self shakeFrontBackAnimation];
    [textField.layer addAnimation:animation forKey:nil];
}

- (CAPropertyAnimation*)shakeHorizontalAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    NSArray *values = @[[NSNumber numberWithFloat:-5],[NSNumber numberWithFloat:0],[NSNumber numberWithFloat:5]];
    animation.values = values;
    animation.duration = 0.2;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = 2;
    return animation;
}

- (CAPropertyAnimation*)shakeFrontBackAnimation
{
     CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.3;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale
                       
                       (0.1, 0.1, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale
                       
                       (1.2, 1.2, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale
                       
                       (0.9, 0.9, 0.9)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale
                       
                       (1.0, 1.0, 1.0)]];
    
    animation.values = values;
    animation.fillMode = kCAFillModeForwards;
    
    return  animation;
}

#pragma mark -  setter and getter methods 
- (void)setSubTitles:(NSArray *)subTitles
{
    _subTitles = subTitles;
    for(NSString *obj in subTitles){
        //title label init
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UIColorFromRGB(0x888888);
        label.text = obj;
        [self addSubview:label];
        [self.titleItems addObject:label];
        //input textField init
        HTInputField *item = [[HTInputField alloc] init];
        item.font = [UIFont systemFontOfSize:14];
        [self addSubview:item];
        [self.inputItems addObject:item];
    }
    
    CGFloat viewWidth = kScreenSize.width - 2 * kMarginsSide;
    CGFloat titlesHeight = kTitleHeight + self.subTitles.count * kSubTitleHeight;
    CGFloat itemsHeight =  self.subTitles.count * kItemsHeight;
    CGFloat marginsHeight =  self.subTitles.count * kSubTitleVerticalMargin + kConfirmBtnBottomMargin;
    CGFloat viewHeight =  kConfirmBtnHeight + titlesHeight + itemsHeight + marginsHeight + self.subTitles.count * 10;
    CGFloat x = (kScreenSize.width - viewWidth) * 0.5;
    CGFloat y = (kScreenSize.height - viewHeight) * 0.5;
    self.frame = CGRectMake(x, y, viewWidth, viewHeight);
}

- (void)setPlaceholders:(NSArray *)placeholders
{
    _placeholders = placeholders;
    [self.inputItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UITextField *item = (UITextField*)obj;
        NSString *placeholder = nil;
        if (idx > (_placeholders.count - 1)) {
            placeholder = [self.subTitles objectAtIndex:idx];
        }else{
            placeholder = [placeholders objectAtIndex:idx];
        }
        
        if (placeholder != nil) {
            item.placeholder = placeholder;
        }
    }];
}

#pragma mark - public methods
- (void)showPopView
{
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    UIButton *overView = [[UIButton alloc] init];
    overView.alpha = 0.0;
    self.alpha = 0.0;
    overView.frame = [UIScreen mainScreen].bounds;
    overView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.3];
    [overView addTarget:self action:@selector(tapoverlayerView) forControlEvents:UIControlEventTouchUpInside];
    self.overlayerView = overView;
    [keyWindow addSubview:overView];
    [keyWindow addSubview:self];
    
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 1.0;
        self.overlayerView.alpha = 1.0;
    } completion:^(BOOL finished) {
        UITextField *firstTextField = [self.inputItems firstObject];
        [firstTextField becomeFirstResponder];
    }];
}

- (void)dismissPopView
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.8 animations:^{
        self.alpha = 0.0;
        self.overlayerView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.overlayerView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - selectors 
- (void)tapConfirmBtn
{
    if (self.doneBlock != nil) {
        NSMutableArray *contents = [self inputContents];
        if (contents != nil) {
            [self dismissPopView];
            self.doneBlock(contents);
        }
    }
}

- (void)tapoverlayerView
{
    [self dismissPopView];
    if (self.cancelBlock != nil) {
        self.cancelBlock();
    }
}

- (void)boardWillChangeFrame:(NSNotification*)notification
{
    NSDictionary *notif = notification.userInfo;
    NSValue *endFrameValue = [notif objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect endFrame = [endFrameValue CGRectValue];
    CGRect popFrame = self.frame;
    if(CGRectIntersectsRect(endFrame, popFrame)){
        CGFloat popMaxY = CGRectGetMaxY(popFrame);
        CGFloat delta = popMaxY - endFrame.origin.y;
        CGFloat popY = popFrame.origin.y - delta;
        CGRect frame = {{popFrame.origin.x,popY},popFrame.size};
        [UIView animateWithDuration:0.8 animations:^{
            self.frame = frame;
        } completion:^(BOOL finished) {
            
        }];
    }
}









@end
