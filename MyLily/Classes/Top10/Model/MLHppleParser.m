//
//  MLHppleParser.m
//  MyLily
//
//  Created by rgc on 15/9/16.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLHppleParser.h"

#define kMaxRowsInSection 5

@implementation MLHppleParser

/**
 *  解析十大话题
 *
 *  @param element tr节点
 *
 *  @return 十大帖子数组
 */
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
    post.author.authorId = authorName;
    post.author.url = authorUrl;
    
    // 跟帖人数
    TFHppleElement *replyCountElement = [children objectAtIndex:4];
    NSString *replyCount = [replyCountElement text];
    post.replyCount = [replyCount intValue];
    
    return post;
}

/**
 *  解析各区热门话题
 *
 *  @param element 热门话题table节点
 *
 *  @return 所有的热门话题
 */
+ (NSArray *)parseTopAllSection:(TFHppleElement *)element {
    NSMutableArray *topAllPosts = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *trNodes = [element childrenWithTagName:@"tr"];
    NSInteger trNodesCount = [trNodes count];
    for (int i = 0; i < trNodesCount; i ++) {
        TFHppleElement *trNode = [trNodes objectAtIndex:i];
        
        // 根据tr/td中的属性colspan判断section是否开始
        NSArray *tdsInTr = [trNode children];
        if ([[tdsInTr objectAtIndex:0] objectForKey:@"colspan"] != nil) {
            
            NSMutableArray *postsInSection = [[NSMutableArray alloc] initWithCapacity:0];
            // 遍历该section的帖子，每个section最多十个帖子（5行）
            for (int j = i + 1; j <= i + kMaxRowsInSection; j ++) {
                TFHppleElement *postsRow = [trNodes objectAtIndex:j];
                
                if ([postsRow objectForKey:@"style"] != nil) {
                    // 该section有数据
                    NSArray *postsInTr = [self parseTopAllPostsRow:postsRow];
                    [postsInSection addObjectsFromArray:postsInTr];
                    
                    // 判断该section是否结束
                    int nextRow = j + 1;
                    if (nextRow < trNodesCount) {
                        if ([[[trNodes objectAtIndex:nextRow] raw] isEqualToString:@"<tr><td>\n</td></tr>"]) {
                            i = nextRow;
                            [topAllPosts addObject:postsInSection];
                            break;
                        }
                    }
                } else {
                    // 该section没有数据
                    [topAllPosts addObject:postsInSection];
                    i = j;
                    break;
                }
            }
        }
    }
    
//    for (int i = 0; i < [topAllPosts count]; i ++) {
//        NSLog(@"%d:%@", i, [topAllPosts objectAtIndex:i]);
//    }
    return topAllPosts;
}

/**
 *  解析tr数据，tr数据包含帖子信息（标题、链接）
 *  <tr style='line-height:12px' bgcolor=f0f0f0>
        <td>○<a href="bbstcon?board=sysop&file=M.1442422225.A">对六食堂工作人员的服务态度提出质疑</a> 
        [<a href=bbsdoc?board=sysop>sysop</a>]
    <tr><td>
 *
 *  @param element element description
 *
 *  @return postsInRow
 */
+ (NSArray *)parseTopAllPostsRow:(TFHppleElement *)element {
    
    NSArray *tdInPostsRow = [element childrenWithTagName:@"td"];
    
    NSMutableArray *posts = [[NSMutableArray alloc] initWithCapacity:0];
    for (TFHppleElement *tdElement in tdInPostsRow) {
        TFHppleElement *aPostInTd = [[tdElement children] objectAtIndex:1];
        NSString *postUrl = [aPostInTd objectForKey:@"href"];
        NSString *postTitle = [aPostInTd text];
        
        TFHppleElement *aBoardInTd = [[tdElement children] objectAtIndex:3];
        NSString *boardUrl = [aBoardInTd objectForKey:@"href"];
        NSString *boardName = [aBoardInTd text];
        
        MLPost *postInTd = [[MLPost alloc] init];
        postInTd.url = postUrl;
        postInTd.title = postTitle;
        postInTd.board = boardName;
        postInTd.boardUrl = boardUrl;
        postInTd.replyCount = 0;
        [posts addObject:postInTd];
    }
    
    return posts;
}


@end
