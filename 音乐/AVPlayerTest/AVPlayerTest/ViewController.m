//
//  ViewController.m
//  AVPlayerTest
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+WebCache.h"

@interface ViewController ()

@property (nonatomic, retain) AVPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)action4Play:(UIButton *)sender {
    //创建一个播放的资源
    //AVPlayerItem *item = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:@"http://m1.music.126.net/gpi8Adr_-pfCuP7ZXk_F2w==/2926899953898363.mp3"]];
    
    //创建一个播放器
    //self.player = [AVPlayer playerWithPlayerItem:item];
    
    //播放
    //[_player play];
    
    //创建一个item
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]];
    //初始化播放器
    self.player = [[AVPlayer alloc] initWithPlayerItem:item];
    //AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:<#(nonnull NSURL *)#>]
    
    //获取播放器的layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    //设置播放器的layer
    playerLayer.frame = self.view.frame;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    playerLayer.backgroundColor = [[UIColor blueColor] CGColor];
    //讲layer添加到当期页面的layer层中
    [self.view.layer addSublayer:playerLayer];
    //播发器开始播放
    [self.player play];
}

- (IBAction)action5Pause:(UIButton *)sender {
    //暂停
    [_player pause];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
