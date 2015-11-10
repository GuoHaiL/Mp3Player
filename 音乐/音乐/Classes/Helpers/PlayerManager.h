//
//  PlayerManager.h
//  音乐
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@protocol PlayerManagerDelegate <NSObject>
//当播放完一首歌,让代理去做的事情
- (void)playerDidPlayEnd;
//播放中间一直在重复执行的一个方法
- (void)playerPlayingWithTime:(NSTimeInterval)time;
@end





@interface PlayerManager : NSObject

//是否正在播放
@property (nonatomic, assign) BOOL isPlaying;
//设置代理
@property (nonatomic, assign)id<PlayerManagerDelegate>delegate;
+ (instancetype)sharedManager;

//给个链接，让AVPlayer播放
- (void)playWithUrlString:(NSString *)urlStr;

//播放
- (void)play;

//暂停
- (void)pause;
- (void)seekToTime:(NSTimeInterval)time;
@end
