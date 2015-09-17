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

- (NSString *)description {
    return [NSString stringWithFormat:@"title:%@, url:%@, board:%@, boardUrl:%@, author:%@, replyCount:%d, ranking:%d", self.title, self.url, self.board, self.boardUrl, self.author, self.replyCount];
}

@end
