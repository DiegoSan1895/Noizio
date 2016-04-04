//
//  DSTableCell.h
//  Noizio
//
//  Created by DiegoSan on 4/4/16.
//  Copyright © 2016 DiegoSan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerControl.h"

@class DSTableCell;
@class PlayerControl;
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
@property (nonatomic, copy) NSString *playingAvatarIamge;
@property (nonatomic, copy) NSString *pauseAvatarIamge;
@property (nonatomic, strong) PlayerControl *control;

- (void)changeToPlayingState;
- (void)changeToPauseState;
@end
