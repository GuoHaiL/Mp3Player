//
//  PlayerManager.m
//  音乐
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import "PlayerManager.h"

@interface PlayerManager ()

//播放器 -> 全局唯一，因为如果有两个avplayer的话，就会同时播放两个音乐
@property (nonatomic, retain) AVPlayer *player;
@property (nonatomic, retain)NSTimer *timer;
@end

static PlayerManager *manager = nil;
@implementation PlayerManager

//单例方法
+ (instancetype)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PlayerManager new];
    });
    return manager;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
//        添加通知中心,当self 发出AVPlayerItemDidPlayToEndTimeNotification时触发playerDidEnd事件
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playerDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    }
    return self;
}
- (void)playerDidEnd:(NSNotification *)not{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerDidPlayEnd)]) {
//        接收到item播放结束后,让代理去干一件事,代理会怎么干,播放器不需要知道
        [self.delegate playerDidPlayEnd];
    }
}
#pragma mark 给个链接，让AVPlayer播放
- (void)playWithUrlString:(NSString *)urlStr{
    
    if(self.player.currentItem){
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    //创建一个item
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:urlStr]];
    
    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //当前正在播放的音乐
    [self.player replaceCurrentItemWithPlayerItem:item];

}

- (void)play{
    //如果正在播放的花，就不播放了，直接返回就行了
//    if(_isPlaying){
//        return;
//    }
    [self.player play];
//    开始播放后标记一下
    _isPlaying = YES;
//
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(playingTimeSeconds) userInfo:nil repeats:YES];
}
-(void)playingTimeSeconds{
    NSLog(@"%lld",self.player.currentTime.value/self.player.currentTime.timescale);
    if (self.delegate && [self.delegate respondsToSelector:@selector(playerPlayingWithTime:)]) {
//        计算一下播放器现在播放的时间
        NSInteger time = self.player.currentTime.value/self.player.currentTime.timescale;
        [self.delegate playerPlayingWithTime:time];
    }
}
- (void)pause{
    [self.player pause];
//暂停播放后标记一下
    [self.timer invalidate];
    _timer = nil;
    _isPlaying = NO;
}

#pragma mark --lazy load
- (AVPlayer *)player{
    if (!_player) {
        _player = [AVPlayer new];
    }
    return _player;
}
- (void)seekToTime:(NSTimeInterval)time{
//    先暂停
    [self pause];
    [self.player seekToTime:CMTimeMakeWithSeconds(time, self.player.currentTime.timescale) completionHandler:^(BOOL finished) {
        if (finished) {
//            拖动成功后在播放
            [self play];
            
        }
    }];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //状态变化后的新值
    AVPlayerItemStatus status = [change[@"new"] integerValue];
    switch (status) {
        case AVPlayerItemStatusReadyToPlay:
            NSLog(@"准备好了，可以播放");
            //开始播放
            [self play];
            break;
        case AVPlayerItemStatusFailed:
            NSLog(@"音乐加载失败");
            break;
        case AVPlayerItemStatusUnknown:
            NSLog(@"音乐不存在");
            break;
            
        default:
            break;
    }
}

@end
