//
//  HTInputField.h
//  TMPDemo
//
//  Created by taotao on 8/8/16.
//  Copyright © 2016 taotao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



@interface HTInputField : UITextField

@end
