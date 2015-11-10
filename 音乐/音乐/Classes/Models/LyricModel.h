//
//  LyricModel.h
//  音乐
//
//  Created by 郭海林 on 15/11/10.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject
//歌词播放时间
@property (nonatomic, assign)NSTimeInterval time;
//歌词内容
@property (nonatomic, retain)NSString *lyricContext;
-(instancetype)initWithTime:(NSTimeInterval)time
                      lyric:(NSString *)lyric;
@end
