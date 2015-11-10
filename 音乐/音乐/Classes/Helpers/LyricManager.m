//
//  LyricManager.m
//  音乐
//
//  Created by 郭海林 on 15/11/10.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import "LyricManager.h"
#import "LyricModel.h"


@interface LyricManager ()

//用来存放歌词的数组
@property (nonatomic, retain)NSMutableArray *lyrics;

@end



static LyricManager *lyricManager = nil;
@implementation LyricManager
+(LyricManager *)shardeLyricManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lyricManager = [LyricManager new];
        });
 
    return lyricManager;
}
- (void)loadLyricWith:(NSString *)lyricStr{
//    1.分行
    NSMutableArray *lyricStringArray =(NSMutableArray *) [lyricStr componentsSeparatedByString:@"\n"];
    
//    最后一行是@""
//    所以需要将最后一行移除
    [lyricStringArray removeLastObject];
//    要现将之前的歌曲的歌词移除
    [self.lyrics removeAllObjects];
//
    for (NSString *str in lyricStringArray) {
//        2.分开时间和歌词
        NSArray *timeAndLyric = [str componentsSeparatedByString:@"]"];
//        3.去掉时间左边的"["
        NSString *time = [timeAndLyric[0] substringFromIndex:1];
//        time = 02:32.080
//        4.截取时间获取分和秒
        NSArray *minuteAndSecond = [time componentsSeparatedByString:@":"];
//        分
        NSInteger minute = [minuteAndSecond[0] integerValue];
//        秒
        double second = [minuteAndSecond[1] doubleValue];
        LyricModel *model = [[LyricModel alloc] initWithTime:(minute * 60 + second) lyric:timeAndLyric[1]];
        [self.lyrics addObject:model];
        
    }

}
-(NSArray *)allLyric{
    return self.lyrics;
}
- (NSMutableArray *)lyrics{
    if (!_lyrics) {
        _lyrics = [NSMutableArray arrayWithCapacity:5];
    }
    return _lyrics;
}
- (NSInteger )indexWith:(NSTimeInterval)time{
    NSInteger index = 0;
//    遍历数组,找到还没有播放的那一句歌词
    for (int i = 0; i < self.lyrics.count; i++) {
        LyricModel *model = self.lyrics[i];
        if (model.time > time) {
//            注意如果是第0个元素,而且元素时间比播放的时间大,i - 1就会小于0,这样tableview就会
           index = (i - 1 > 0)?i - 1 : 0;
//            一定要break,要不就会一直循环下去
            break;
        }
        
    }
    return index;
}
@end
