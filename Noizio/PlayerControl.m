//
//  PlayerControl.m
//  Noizio
//
//  Created by DiegoSan on 4/4/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "PlayerControl.h"

static NSString *const kPlayerControlKey = @"playerControl";
@implementation PlayerControl

- (instancetype)init{
    self = [super init];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_playerItem];
    return self;
}

- (void)playbackFinished: (NSNotification *)notifacation{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setVolum:(float)volum{
    _volum = volum;
    _player.volume = volum;
}


@end
