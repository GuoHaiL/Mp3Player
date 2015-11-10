//
//  PlayingViewController.h
//  音乐
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *songName;
@property (strong, nonatomic) IBOutlet UILabel *singerName;
@property (nonatomic, assign) NSInteger index;

+ (instancetype)sharedPlayingPVC;

@end
