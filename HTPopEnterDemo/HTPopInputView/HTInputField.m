//
//  HTInputField.m
//  TMPDemo
//
//  Created by taotao on 8/8/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import "HTInputField.h"

@interface HTInputField()
@property (nonatomic,weak)CALayer  *separatorLine;
@end



@implementation HTInputField


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self != nil){
        [self setupUI];
    }
    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    self.separatorLine.frame = CGRectMake(0.0f, self.frame.size.height - 1, self.frame.size.width, 1.0f);
}

#pragma mark - setup ui
- (void)setupUI
{
    CALayer *bottomLayer = [CALayer layer];
    UIColor *bgColor = UIColorFromRGB(0x888888);
    bottomLayer.backgroundColor = [bgColor CGColor];
    [self.layer addSublayer:bottomLayer];
    self.separatorLine = bottomLayer;
}

@end
