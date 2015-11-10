//
//  LyricManager.h
//  音乐
//
//  Created by 郭海林 on 15/11/10.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricManager : NSObject
+ (LyricManager *)shardeLyricManager;
- (void)loadLyricWith:(NSString *)lyricStr;
@property (nonatomic, retain)NSArray *allLyric;
//根据播放时间获取到该播放的歌词的索引
- (NSInteger )indexWith:(NSTimeInterval)time;
@end
