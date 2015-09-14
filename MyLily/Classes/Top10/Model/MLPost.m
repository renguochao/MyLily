//
//  MLPost.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLPost.h"

@implementation MLPost

- (id)initWithTFHppleElement:(TFHppleElement *)element {
    self = [super init];
    if (self) {
        [self parseElement:element];
    }
    return self;
}

- (void)parseElement:(TFHppleElement *)element {
    NSArray *children = [element children];
    
    // 名次
    TFHppleElement *rankingElement = [children objectAtIndex:0];
    NSString *ranking = [rankingElement text];
    self.ranking = ranking;
    
    // 讨论区
    TFHppleElement *boardElement = [children objectAtIndex:1];
    TFHppleElement *boardAElement = [[boardElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *boardName = [boardAElement text];
    NSString *boardUrl = [[boardAElement attributes] objectForKey:@"href"];
    self.board = boardName;
    self.boardUrl = boardUrl;
    
    // 标题
    TFHppleElement *titleElement = [children objectAtIndex:2];
    TFHppleElement *titleAElement = [[titleElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *title = [titleAElement text];
    NSString *postUrl = [[titleAElement attributes] objectForKey:@"href"];
    self.title = title;
    self.url = postUrl;
    
    // 作者
    TFHppleElement *authorElement = [children objectAtIndex:3];
    TFHppleElement *authorAElement = [[authorElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *authorName = [[authorAElement text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *authorUrl = [[authorAElement attributes] objectForKey:@"href"];
    self.author = [[MLAuthor alloc] init];
    self.author.name = authorName;
    self.author.url = authorUrl;
    
    // 跟帖人数
    TFHppleElement *replyCountElement = [children objectAtIndex:4];
    NSString *replyCount = [replyCountElement text];
    self.replyCount = [replyCount intValue];
    
}

@end
