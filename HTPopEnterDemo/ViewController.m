//
//  ViewController.m
//  HTPopEnterDemo
//
//  Created by taotao on 8/10/16.
//  Copyright © 2016 taotao. All rights reserved.
//
#import "HTInputView.h"
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)tapMeBtn:(id)sender {
    //    NSArray *titles = @[@"title1"];
    //    NSArray *placehodlers = @[@"palceHOlder1"];
    NSArray *titles = @[@"TitleOne",@"TitleTwo"];
    NSArray *placehodlers = @[@"Please enter one",@"Please enter two"];
    HTInputView *popView = [[HTInputView alloc] initWith:@"Title" itemTitles:titles placeholders:placehodlers done:^(NSArray *contents) {
        NSLog(@"contents =%@",contents);
    } cancel:^{
        NSLog(@"cancel input ");
    }];
    [popView showPopView];
    //    [HTInputView showPopViewWith:titles placeholders:placehodlers];
    //    [HTInputView didConfirm:^(NSArray *contents) {
    //        NSLog(@"contents =%@",contents);
    //    }];
}

@end
