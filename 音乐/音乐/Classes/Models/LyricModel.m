//
//  LyricModel.m
//  音乐
//
//  Created by 郭海林 on 15/11/10.
//  Copyright © 2015年 www.iqiyi.com. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel
-(instancetype)initWithTime:(NSTimeInterval)time
                      lyric:(NSString *)lyric{
    if (self = [super init]) {
        _time = time;
        _lyricContext = lyric;
    }
    return self;
}

@end
