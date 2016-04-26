//
//  DSTableCell.m
//  Noizio
//
//  Created by DiegoSan on 4/4/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import "DSTableCell.h"
#import "YYKit.h"
#define kCellHeight 64

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
    
    return self;
}

- (void)prepareForReuse{

}

- (void)changeToPauseState{
    _avatar.image = [UIImage imageNamed:_pauseAvatarIamge];
    _nameLabel.alpha = 0.3;
    _volumSlider.alpha = 0.3;
    _volumSlider.userInteractionEnabled = NO;
}

- (void)changeToPlayingState{
    _avatar.image = [UIImage imageNamed:_playingAvatarIamge];
    _nameLabel.alpha = 1;
    _volumSlider.alpha = 1;
    _volumSlider.userInteractionEnabled = YES;
}
@end
