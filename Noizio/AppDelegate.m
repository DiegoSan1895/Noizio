//
//  AppDelegate.m
//  Noizio
//
//  Created by DiegoSan on 4/3/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "AppDelegate.h"
#import "YYKit.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.196 green:0.200 blue:0.204 alpha:1.00];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application{
    NSMutableArray *testArray = [NSMutableArray new];
    NSString *path = [[[UIApplication sharedApplication]documentsPath]stringByAppendingPathComponent:@"test.plist"];
    [testArray writeToFile:path atomically:YES];
    
}
@end
