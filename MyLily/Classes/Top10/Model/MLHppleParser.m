//
//  MLHppleParser.m
//  MyLily
//
//  Created by rgc on 15/9/16.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLHppleParser.h"

@implementation MLHppleParser

+ (MLPost *)parseTop10Element:(TFHppleElement *)element {
    MLPost *post = [[MLPost alloc] init];
    
    NSArray *children = [element children];
    
    // 名次
    TFHppleElement *rankingElement = [children objectAtIndex:0];
    NSString *ranking = [rankingElement text];
    post.ranking = ranking;
    
    // 讨论区
    TFHppleElement *boardElement = [children objectAtIndex:1];
    TFHppleElement *boardAElement = [[boardElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *boardName = [boardAElement text];
    NSString *boardUrl = [[boardAElement attributes] objectForKey:@"href"];
    post.board = boardName;
    post.boardUrl = boardUrl;
    
    // 标题
    TFHppleElement *titleElement = [children objectAtIndex:2];
    TFHppleElement *titleAElement = [[titleElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *title = [titleAElement text];
    NSString *postUrl = [[titleAElement attributes] objectForKey:@"href"];
    post.title = title;
    post.url = postUrl;
    
    // 作者
    TFHppleElement *authorElement = [children objectAtIndex:3];
    TFHppleElement *authorAElement = [[authorElement childrenWithTagName:@"a"] objectAtIndex:0];
    NSString *authorName = [[authorAElement text] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *authorUrl = [[authorAElement attributes] objectForKey:@"href"];
    post.author = [[MLAuthor alloc] init];
    post.author.name = authorName;
    post.author.url = authorUrl;
    
    // 跟帖人数
    TFHppleElement *replyCountElement = [children objectAtIndex:4];
    NSString *replyCount = [replyCountElement text];
    post.replyCount = [replyCount intValue];
    
    return post;
}

+ (NSArray *)parseTopAllSection:(TFHppleElement *)element {
    NSMutableArray *postsInSection = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    return postsInSection;
}


@end
