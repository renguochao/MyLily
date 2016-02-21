//
//  MLPost.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLPost.h"
#import "YYKit.h"

#import "Common.h"
#import "MLPostContentSegment.h"

@interface MLPost()

@end

@implementation MLPost

- (id)initWithTFHppleElement:(TFHppleElement *)element {
    self = [super init];
    if (self) {
        
        _contentSegments = [NSMutableArray array];
        
        [self parseElement:element];
    }
    return self;
}

- (void)parseElement:(TFHppleElement *)element {
    // 1. 获取两个tr节点
    NSArray *trNodes = [element childrenWithTagName:@"tr"];
    
    // 2. 填充对象
    TFHppleElement *firstTrNode = [trNodes objectAtIndex:0];
    TFHppleElement *tdInFirstTrNode = [firstTrNode firstChild];
    TFHppleElement *lastAInTd = [[tdInFirstTrNode childrenWithTagName:@"a"] objectAtIndex:2];
    MLAuthor *author = [[MLAuthor alloc] init];
    author.authorId = [lastAInTd text];
    author.url = [[lastAInTd attributes] objectForKey:@"href"];
    self.author = author;
    
    TFHppleElement *secondTrNode = [trNodes objectAtIndex:1];
    TFHppleElement *textarea = [[[secondTrNode firstChild] childrenWithTagName:@"textarea"] objectAtIndex:0];
    self.textarea = [NSString stringWithFormat:@"%@", [textarea text]];
    
    NSString *topicContent = [[textarea text] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    NSMutableString *body = [[NSMutableString alloc] init];
    
    NSArray *splits = [topicContent componentsSeparatedByString:@"<br>"];
    
    for (int i = 0; i < splits.count; i ++) {
        NSString *str = [splits objectAtIndex:i];
        str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        
        // 0.获取昵称和信区
        if (i == 0) {
            // 昵称
            NSRange range = [str rangeOfString:author.authorId];
            NSUInteger screenNameLocStart = range.location + range.length + 2;
            NSUInteger screenNameLocEnd = [str rangeOfString:@")"].location;
            NSString *screenName = [str substringWithRange:NSMakeRange(screenNameLocStart, screenNameLocEnd - screenNameLocStart)];
            author.authorScreenName = screenName;
            
            // 信区
            NSRange boardRange = [str rangeOfString:@"信区: "];
            NSUInteger loc = boardRange.location + boardRange.length;
            NSUInteger len = str.length - loc;
            NSString *boardName = [str substringWithRange:NSMakeRange(loc, len)];
            self.board = boardName;
        } else if (i == 1) { // 1.获取标题
            NSRange range = [str rangeOfString:@"标  题: "];
            NSUInteger titleLoc = range.location + range.length;
            NSUInteger titleLength = str.length - range.length;
            NSString *title = [str substringWithRange:NSMakeRange(titleLoc, titleLength)];
            self.title = title;
        } else if (i == 2) { // 2.获取时间
            NSRange range = [str rangeOfString:@"发信站: 南京大学小百合站 ("];
            NSUInteger postTimeLoc = range.location + range.length;
            NSUInteger postTimeLength = str.length - range.length - 1;
            NSString *postTime = [str substringWithRange:NSMakeRange(postTimeLoc, postTimeLength)];
            self.postTime = postTime;
        } else {
            if ([str containsString:@"※"]) { // 3.获取ip
                NSRange range = [str rangeOfString:@"[FROM: "];
                if (range.location == NSNotFound) {
                    continue;
                }
                NSUInteger ipLocStart = range.location + range.length;
                NSUInteger ipLocEnd = [str rangeOfString:@"]"].location;
                NSString *ip = [str substringWithRange:NSMakeRange(ipLocStart, ipLocEnd - ipLocStart)];
                self.ip = [NSString stringWithFormat:@"发自：%@", ip];
            } else if ([str isEqualToString:@"--"]) {
                continue;
            } else {
                // 5.获取帖子内容
                if (str.length == 0) {
                    continue;
                }
                
                // 检测到图片链接
                if ([self isImageSegment:str]) {
                    NSMutableString *imgHtml = [NSMutableString string];
                    
                    // 设置img的div
                    [imgHtml appendString:@"<div class=\"img-parent\">"];
                    CGFloat width = ScreenWidth - 40;
                    // 不设置height，图片高度会自适应
//                    CGFloat height = width * 0.75;
                    
                    NSString *onload = @"this.onclick = function() {"
                                        " window.location.href = 'sx:src=' + this.src;"
                                        "};";
                    [imgHtml appendFormat:@"<img style=\"border-right: #999999 4px outset; border-bottom: #999999 4px outset; border-left: #000000 4px outset; border-top: #000000 4px outset;\" onload=\"%@\" width=\"%f\" src=\"%@\">", onload, width, str];
                    // 结束标记
                    [imgHtml appendString:@"</div>"];
                    
                    [body appendString:imgHtml];
                    
                } else {
                    if ([str isEqualToString:@"-"]) {
                        [body appendString:@"-<br>"];
                    } else if ([str isEqualToString:@"--"]) {
                        continue;
                    } else {
                        // 帖子文本内容
                        NSStringEncoding gbkEncoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSMutableString *topicText = [NSMutableString string];
                        NSUInteger la = [str lengthOfBytesUsingEncoding:gbkEncoding];
                        if (la < 71 || la > 89) {
                            [topicText appendString:[NSString stringWithFormat:@"%@<br>", str]];
                        } else {
                            [topicText appendString:str];
                        }
                        
                        [body appendString:topicText];
                    }
                }
                
            }
        }
    }
    
    self.content = body;
}

- (NSString *)postTime {
    NSDateFormatter *sdf = [[NSDateFormatter alloc] init];
    sdf.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    sdf.dateFormat = @"EEE MMM d HH:mm:ss yyyy";
    NSDate *date = [sdf dateFromString:_postTime];
    
    sdf.dateFormat = @"yyyy年M月d日 HH:mm:ss";
    return [sdf stringFromDate:date];
}

- (BOOL)isImageSegment:(NSString *)str {
    return [str.lowercaseString hasPrefix:@"http:"]
            && ([str.lowercaseString hasSuffix:@".jpg"]
            || [str.lowercaseString hasSuffix:@".png"]
            || [str.lowercaseString hasSuffix:@".jpeg"]
            || [str.lowercaseString hasSuffix:@".gif"]);
}

@end
