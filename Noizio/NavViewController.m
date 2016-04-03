//
//  NavViewController.m
//  Noizio
//
//  Created by DiegoSan on 4/3/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "NavViewController.h"

@interface NavViewController ()

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.196 green:0.200 blue:0.204 alpha:1.00];
    self.navigationBar.translucent = NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
