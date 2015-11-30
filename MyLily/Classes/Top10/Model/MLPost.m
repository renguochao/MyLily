//
//  MLPost.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLPost.h"

@interface MLPost()

@end

@implementation MLPost

- (id)initWithTFHppleElement:(TFHppleElement *)element {
    self = [super init];
    if (self) {
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
    self.content = [[textarea text] stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    
    NSArray *splits = [self.content componentsSeparatedByString:@"<br>"];
    
    for (int i = 0; i < splits.count; i ++) {
        NSString *str = [splits objectAtIndex:i];
        
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
        }
        
        // 1.获取标题
        if (i == 1) {
            NSRange range = [str rangeOfString:@"标  题: "];
            NSUInteger titleLoc = range.location + range.length;
            NSUInteger titleLength = str.length - range.length;
            NSString *title = [str substringWithRange:NSMakeRange(titleLoc, titleLength)];
            self.title = title;
        }
        
        // 3.获取时间
        if (i == 2) {
            NSRange range = [str rangeOfString:@"发信站: 南京大学小百合站 ("];
            NSUInteger postTimeLoc = range.location + range.length;
            NSUInteger postTimeLength = str.length - range.length - 1;
            NSString *postTime = [str substringWithRange:NSMakeRange(postTimeLoc, postTimeLength)];
            self.postTime = postTime;
        }
        
        // 4.获取帖子内容
        if (str.length == 0) {
            continue;
        }
        
        // 5.获取ip
        if ([str containsString:@"※"]) {
            NSRange range = [str rangeOfString:@"[FROM: "];
            if (range.location == NSNotFound) {
                continue;
            }
            NSUInteger ipLocStart = range.location + range.length;
            NSUInteger ipLocEnd = [str rangeOfString:@"]"].location;
            NSString *ip = [str substringWithRange:NSMakeRange(ipLocStart, ipLocEnd - ipLocStart)];
            self.ip = ip;
            NSLog(@"ip:%@", self.ip);
        }
        
    }
    
    
//    NSLog(@"level:%d, splits:%@", self.level, splits);
    
    
    //    NSLog(@"self.content:%@", [self.content stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]);
    //    NSLog(@"second tr node:%@", [[trNodes objectAtIndex:1] content]);
}


- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@, url:%@, board:%@, boardUrl:%@, author:%@, replyCount:%d, ranking:%d", self.title, self.url, self.board, self.boardUrl, self.author, self.replyCount];
}

@end
