//
//  PlayingViewController.m
//  音乐
//
//  Created by lanou3g on 15/11/5.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import "PlayingViewController.h"
#import "PlayerManager.h"
#import "MusicModel.h"
#import "LyricManager.h"
#import "LyricModel.h"

@interface PlayingViewController ()<PlayerManagerDelegate,UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIButton *btn4playORpause;
@property (nonatomic, retain)NSTimer *timer;
@property (strong, nonatomic) IBOutlet UIImageView *imgeView;
@property (strong, nonatomic) IBOutlet UILabel *lab4playTime;
@property (strong, nonatomic) IBOutlet UILabel *lab4LastTime;
@property (strong, nonatomic) IBOutlet UISlider *slider4Time;
@property (strong, nonatomic) IBOutlet UISlider *slider4Volume;
@property (strong, nonatomic) IBOutlet UITableView *tableVIEW;
@property (strong, nonatomic) IBOutlet UIImageView *brakImage;

//记录一下当前播放的音乐的索引
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, retain) AVPlayerItem *playerItem;

@property (nonatomic, retain) AVPlayer *player;
//记录当前正在播放的音乐
@property (nonatomic, retain)MusicModel *currentmodel;
@end

static PlayingViewController *playingVC = nil;

static NSString *identifier = @"cell";
@implementation PlayingViewController

+ (instancetype)sharedPlayingPVC{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       //拿到main sb
       UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
       //在main sb 拿到我们要用的视图控制器
       playingVC = [sb instantiateViewControllerWithIdentifier:@"playingVC"];
        
    });
    return playingVC;
}
//播放器播放结束,开始播放下一首
-(void)playerDidPlayEnd{
//    _currentIndex++;
//    //    判断是不是最后一首
//    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
//        _currentIndex = 0;
//    }
//    [self startPlay];
    [self action4Next:nil];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    _currentIndex = -1;
    [PlayerManager sharedManager].delegate = self;
//    注册cell
    [self.tableVIEW registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    // Do any additional setup after loading the view.
}

#pragma mark 播放音乐
//- (void)startPlay{
//    NSLog(@"_index3 = %ld",_index);
//    //取出要播放的model
//    MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.index];
//    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:model.mp3Url]];
//    self.playerItem = playerItem;
//    self.player = [PlayerManager sharedManager].player;
//    [[PlayerManager sharedManager].player replaceCurrentItemWithPlayerItem:playerItem];
//
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orderPlayer) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
//    });
//    
//    [[PlayerManager sharedManager].player play];
//}
- (void)startPlay{
        [[PlayerManager sharedManager]playWithUrlString:self.currentmodel.mp3Url];
    self.imgeView.layer.masksToBounds = YES;
   _imgeView.layer.cornerRadius = 120;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(clickTime) userInfo:nil repeats:YES];
    
    [self buildUI];
    

}
- (IBAction)fanhui:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
//- (void)clickTime{
// }
- (IBAction)action4Prev:(id)sender {
    [[PlayerManager sharedManager] pause];
    
    _currentIndex--;
    if (_currentIndex == -1) {
        _currentIndex = [DataManager sharedManager].allMusic.count - 1;
    }
    [self startPlay];
    
    
}
- (IBAction)action4PlayOrPause:(UIButton *)sender {
//    判断是否正在播放
    if ([PlayerManager sharedManager].isPlaying == YES) {
//        如果正在播放,就让播放器暂停,同时改变butten的text
        [[PlayerManager sharedManager] pause];
        [sender setTitle:@"播放" forState:(UIControlStateNormal)];
    }else{
        [[PlayerManager sharedManager] play];
        [sender setTitle:@"暂停" forState:(UIControlStateNormal)];
    }
    
    
    
    
}
- (IBAction)action4Next:(UIButton *)sender {
    [[PlayerManager sharedManager] pause];
    _currentIndex++;
//    判断是不是最后一首
    if (_currentIndex == [DataManager sharedManager].allMusic.count) {
        _currentIndex = 0;
    }
    [self startPlay];
}
- (IBAction)action4Change:(UISlider *)sender {

    [[PlayerManager sharedManager] seekToTime:sender.value];
    
    
    
}
//播放器没0.1秒会让代理(也就是这个页面)执行一下这个事件
-(void)playerPlayingWithTime:(NSTimeInterval)time{
   
    self.slider4Time.value = time;
    self.lab4playTime.text = [self stringWithTime:time];
    NSTimeInterval time2 = self.currentmodel.duration/1000 - time;
    self.lab4LastTime.text = [self stringWithTime:time2];
    [UIView animateWithDuration:1
                     animations:^{
                         self.imgeView.transform = CGAffineTransformRotate(_imgeView.transform, M_PI_2/60);
                         
                     }];
//    根据 当前播放时间或取到应该播放那句歌词
    NSInteger inedx = [[LyricManager shardeLyricManager] indexWith:time];
    NSIndexPath *path = [NSIndexPath indexPathForRow:inedx inSection:0];
//    让tableView选中我们找到的歌词
    [self.tableVIEW selectRowAtIndexPath:path animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    

}
//改变音量
- (IBAction)action4Volume:(id)sender {
    
    
    
    
    
}
//根据时间获取字符串
-(NSString *)stringWithTime:(NSTimeInterval)time{
    NSInteger minutes = time/60;
    NSInteger seconde = (int)time%60;
    NSString *string = [NSString stringWithFormat:@"%ld : %ld",minutes,seconde];
    return string;
}
- (void)buildUI{
    self.slider4Time.value = 0;
    [self.imgeView sd_setImageWithURL:[NSURL URLWithString:self.currentmodel.picUrl]];
    
   [self.brakImage sd_setImageWithURL:[NSURL URLWithString:self.currentmodel.blurPicUrl]];
    self.tableVIEW.backgroundColor = [UIColor clearColor];
    [self.btn4playORpause setTitle:@"暂停" forState:(UIControlStateNormal)];
    self.slider4Time.maximumValue = self.currentmodel.duration/1000;
    self.imgeView.transform = CGAffineTransformMakeRotation(0);
    [[LyricManager shardeLyricManager] loadLyricWith:self.currentmodel.lyric];
    [self.tableVIEW reloadData];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    //如果要播放的音乐和当前播放的音乐一样，就什么都不干了
    if (_index == _currentIndex) {
        return;
    }
    _currentIndex = _index;
    [self startPlay];
}

#pragma mark 返回--点击事件
- (IBAction)action4Back:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 当播放完毕后，按顺序播放下一首
- (void)orderPlayer{
    _index++;
    [self startPlay];
    NSLog(@"_index = %ld",_index);
/*
//  MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.index];
//    int64_t durrent = _player.currentTime.value/_player.currentTime.timescale;
//    NSString *string = [NSString stringWithFormat:@"%ld",model.duration];
//    NSString *string1 = [string substringToIndex:3];
//    NSLog(@"+++++%@",string1);
//    NSLog(@"%lld",durrent);
*/
}
//确保当前的播放音乐是最新的
- (MusicModel *)currentmodel{
//    渠道需要的播放的model
     MusicModel *model = [[DataManager sharedManager]musicModelWithIndex:self.currentIndex];
    return model;
}
#pragma mark 取消状态栏
//- (BOOL)prefersStatusBarHidden{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [LyricManager shardeLyricManager].allLyric.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    LyricModel *model = [LyricManager shardeLyricManager].allLyric[indexPath.row];
    cell.textLabel.text = model.lyricContext;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.textColor = [UIColor cyanColor];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
