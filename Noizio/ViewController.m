//
//  ViewController.m
//  Noizio
//
//  Created by DiegoSan on 4/3/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "ViewController.h"
#import "AboutViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DSButton.h"
#import "YYKit.h"
#import "DSTableCell.h"
#import "PlayerControl.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource, DSTableCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *soundsArray;
@property (nonatomic, strong) NSMutableArray *controls;
@property (nonatomic, strong) DSButton *titleButton;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation ViewController
@synthesize isPlaying = _isPlaying;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage *leftBarButtonImage = [UIImage imageNamed:@"logo"];
    DSButton *leftButton = [DSButton new];
    [leftButton setImage:leftBarButtonImage forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftBarButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    UIImage *rightBarButtonIamge = [UIImage imageNamed:@"settings-button"];
    DSButton *rightButton = [DSButton new];
    [rightButton setImage:rightBarButtonIamge forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIImage *titleIamge = [UIImage imageNamed:@"play-button"];
    _titleButton = [DSButton new];
    [_titleButton setImage:titleIamge forState:UIControlStateNormal];
    [_titleButton addTarget:self action:@selector(titleButtonDidPressed) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = _titleButton;
    
    _tableView = [UITableView new];
    _tableView.frame = self.view.bounds;
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = 64;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.allowsSelection = NO;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SoundsSettings" ofType:@"plist"];
    _soundsArray = [NSMutableArray arrayWithPlistData:[NSData dataWithContentsOfFile:path]];
    _controls = [NSMutableArray new];
    
    NSError *error = [NSError new];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    _isPlaying = NO;
    
    NSString *documentPath = [[[UIApplication sharedApplication]documentsPath]stringByAppendingPathComponent:@"test.plist"];
    [_soundsArray writeToFile:documentPath atomically:YES];
    
    NSMutableDictionary *test = _soundsArray[0];
    NSNumber *number = @100;
    [test setObject:number forKey:@"id"];
    [[NSUserDefaults standardUserDefaults]setObject:_soundsArray forKey:@"test"];
}


- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (isPlaying) {
        [_titleButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
    }else{
        [_titleButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
    }
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)leftBarButtonDidPressed{
    AboutViewController *aboutVC = [AboutViewController new];
    [self.navigationController pushViewController:aboutVC animated:YES];
}

- (void)rightButtonDidPressed{
    
}

- (void)titleButtonDidPressed{
    if (!_isPlaying) {
        [_titleButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
        for (PlayerControl *control in _controls) {
            if (control.isPlaying) {
                [control.player pause];
                control.isPlaying = !control.isPlaying;
                [control.cell changeToPauseState];
            }
        }
    }else{
        [_titleButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
        for (PlayerControl *control in _controls) {
            if (!control.isPlaying) {
                [control.player play];
                control.isPlaying = !control.isPlaying;
                [control.cell changeToPlayingState];
            }
        }
    }
    _isPlaying = !_isPlaying;
    
}

#pragma mark delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _soundsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DSTableCell *cell = (DSTableCell *)[tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    if (!cell) {
        cell = [[DSTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[NSString stringWithFormat:@"%ld",(long)indexPath.row]];
    }
    NSDictionary *soundDict = _soundsArray[indexPath.row];
    
    cell.playingAvatarIamge = soundDict[@"normal_icon"];
    cell.pauseAvatarIamge = soundDict[@"disabled_icon"];
    cell.nameLabel.text = soundDict[@"display_name"];
    cell.delegate = self;
    
    [cell changeToPauseState];

    for (PlayerControl *control in _controls) {
        if (control.index == indexPath.row) {
            if (control.isPlaying) {
                [cell changeToPlayingState];
            }else{
                [cell changeToPauseState];
            }
            
            cell.volumSlider.value = control.volum;
        }
    }
    
    return cell;
}

- (void)cellWasClicked:(DSTableCell *)cell{
    if (!cell.control) {
        cell.control = [PlayerControl new];
        [_controls addObject:cell.control];
        cell.control.index = [_tableView indexPathForCell:cell].row;
        NSDictionary *soundDict = _soundsArray[[_tableView indexPathForCell:cell].row];
        NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundDict[@"sound_name"] withExtension:@"caf" ];
        
        cell.control.cell = cell;
        cell.control.soundURL = soundURL;
        cell.control.playerItem = [[AVPlayerItem alloc]initWithURL:cell.control.soundURL];
        cell.control.player = [[AVPlayer alloc]initWithPlayerItem:cell.control.playerItem];
        cell.control.volum = cell.volumSlider.value;
        cell.control.player.volume = cell.control.volum;
    }
    if (cell.control.isPlaying) {
        [cell.control.player pause];
        [cell changeToPauseState];
    }else{
        [cell.control.player play];
        [cell changeToPlayingState];
        _isPlaying = YES;
    }
    cell.control.isPlaying = !cell.control.isPlaying;
    cell.control.index = [_tableView indexPathForCell:cell].row;
    
    for (PlayerControl *control in _controls) {
        NSLog(@"%ld, %d",control.index, control.isPlaying);
        if (control.isPlaying) {
            [self setIsPlaying:YES];
            break;
        }else{
            [self setIsPlaying:NO];
        }
    }
    printf("\n");

}

- (void)sliderValueChanged:(DSTableCell *)cell{
    cell.control.player.volume = cell.volumSlider.value;
    cell.control.volum = cell.volumSlider.value;
}

@end
