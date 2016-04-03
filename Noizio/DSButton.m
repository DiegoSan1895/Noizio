//
//  DSButton.m
//  Noizio
//
//  Created by DiegoSan on 4/3/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "DSButton.h"
#define kButtonSize CGSizeMake(20, 20)

@implementation DSButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height == 0 && frame.size.width == 0) {
        frame.size = kButtonSize;
    }
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor clearColor];
    return self;
}

@end
