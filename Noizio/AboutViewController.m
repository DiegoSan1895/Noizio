//
//  AboutViewController.m
//  Noizio
//
//  Created by DiegoSan on 4/3/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"About";
    self.view.backgroundColor = [UIColor whiteColor];
    NSDictionary *attributes = @{
                                 NSFontAttributeName : [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor whiteColor]
                                 };
                                 
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.369 green:0.914 blue:0.906 alpha:1.00];
    self.navigationItem.backBarButtonItem.title = @"";
}


@end
