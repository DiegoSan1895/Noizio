//
//  PlayerControl.h
//  Noizio
//
//  Created by DiegoSan on 4/4/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "DSTableCell.h"

@class DSTableCell;
@interface PlayerControl : NSObject
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, weak) DSTableCell *cell;
@property (nonatomic, strong) NSURL *soundURL;
@property (nonatomic, assign) float volum;
@end
