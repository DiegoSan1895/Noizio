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

#define kCellHeight 64

@class DSTableCell;
@protocol DSTableCellDelegate <NSObject>
@optional
- (void)cellWasClicked:(DSTableCell *)cell;
- (void)sliderValueChanged: (DSTableCell *)cell;
@end

@interface DSTableCell : UITableViewCell
@property (nonatomic, strong) UIImageView *avatar;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UISlider *volumSlider;
@property (nonatomic, weak) id<DSTableCellDelegate> delegate;
@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, copy) NSString *playingAvatarIamge;
@property (nonatomic, copy) NSString *pauseAvatarIamge;
@end

@implementation DSTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor whiteColor];
    self.size = CGSizeMake(kScreenWidth, kCellHeight);
    self.contentView.size = self.size;
    
    _avatar = [UIImageView new];
    _avatar.size = CGSizeMake(kCellHeight / 2, kCellHeight / 2);
    _avatar.backgroundColor = [UIColor clearColor];
    _avatar.center = CGPointMake(kCellHeight / 2, kCellHeight / 2);
    _avatar.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_avatar];
    
    _nameLabel = [UILabel new];
    _nameLabel.size = CGSizeMake(kScreenWidth - kCellHeight, kCellHeight / 2);
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.right = self.contentView.right;
    [self.contentView addSubview:_nameLabel];
    
    __weak typeof(self) _self = self;
    
    _volumSlider = [UISlider new];
    _volumSlider.size = _nameLabel.size;
    _volumSlider.width -= 26;
    _volumSlider.tintColor = [UIColor blackColor];
    _volumSlider.left = _nameLabel.left;
    _volumSlider.bottom = self.contentView.bottom;
    _volumSlider.value = 0.4;
    [_volumSlider setThumbImage:[UIImage imageNamed:@"Line"] forState:UIControlStateNormal];
    [_volumSlider addBlockForControlEvents:UIControlEventValueChanged block:^(id  _Nonnull sender) {
        [_self.delegate sliderValueChanged:_self];
    }];
    [self.contentView addSubview:_volumSlider];
    
    UIImageView *bottomLine = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line1"]];
    bottomLine.size = CGSizeMake(kScreenWidth, 1);
    [self.contentView addSubview:bottomLine];
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithActionBlock:^(id  _Nonnull sender) {
        [_self.delegate cellWasClicked:_self];
    }];
    [self.contentView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:_item];
    return self;
}

- (void)prepareForReuse{
    _player = nil;
    _item = nil;
}

- (void)playbackFinished: (NSNotification *)notifacation{
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setIsPlaying:(BOOL)isPlaying{
    _isPlaying = isPlaying;
    if (_isPlaying) {
        _avatar.image = [UIImage imageNamed:_playingAvatarIamge];
        _nameLabel.alpha = 1;
        _volumSlider.alpha = 1;
        _volumSlider.minimumTrackTintColor = [UIColor blackColor];
    }else{
        _avatar.image = [UIImage imageNamed:_pauseAvatarIamge];
        _nameLabel.alpha = 0.3;
        _volumSlider.alpha = 0.3;
        _volumSlider.minimumTrackTintColor = _volumSlider.maximumTrackTintColor;
    }
}
@end

@interface ViewController () <UITableViewDelegate, UITableViewDataSource, DSTableCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *soundsArray;
@property (nonatomic, strong) NSMutableArray *palyerArray;
@property (nonatomic, strong) DSButton *titleButton;
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation ViewController

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
    
    NSString *path = [[NSBundle mainBundle]pathForResource:@"SoundsSettings" ofType:@"plist"];
    _soundsArray = [NSArray arrayWithPlistData:[NSData dataWithContentsOfFile:path]];
    _palyerArray = [NSMutableArray new];
    
    NSError *error = [NSError new];
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
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
        [_titleButton setImage:[UIImage imageNamed:@"pause-button"] forState:UIControlStateNormal];
        [_palyerArray makeObjectsPerformSelector:@selector(pause)];
    }else{
        [_titleButton setImage:[UIImage imageNamed:@"play-button"] forState:UIControlStateNormal];
        [_palyerArray makeObjectsPerformSelector:@selector(play)];
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
    DSTableCell *cell = (DSTableCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[DSTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    NSDictionary *soundDict = _soundsArray[indexPath.row];
    
    cell.playingAvatarIamge = soundDict[@"normal_icon"];
    cell.pauseAvatarIamge = soundDict[@"disabled_icon"];
    cell.nameLabel.text = soundDict[@"display_name"];
    cell.delegate = self;
    cell.isPlaying = NO;
    
    NSURL *soundURL = [[NSBundle mainBundle] URLForResource:soundDict[@"sound_name"] withExtension:@"caf" ];
    AVPlayerItem *item = [[AVPlayerItem alloc]initWithURL:soundURL];
    AVPlayer *player = [[AVPlayer alloc]initWithPlayerItem:item];
    [_palyerArray insertObject:player atIndex:indexPath.row];
    cell.player = player;
    cell.player.volume = cell.volumSlider.value;
    cell.item = item;
    
    
    return cell;
}

- (void)cellWasClicked:(DSTableCell *)cell{
    if (cell.isPlaying) {
        [cell.player pause];
    }else{
        [cell.player play];
    }
    cell.isPlaying = !cell.isPlaying;
}

- (void)sliderValueChanged:(DSTableCell *)cell{
    cell.player.volume = cell.volumSlider.value;
}

@end
