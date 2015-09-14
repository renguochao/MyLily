//
//  MLPostDetail.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLPostDetail.h"
#import "MLAuthor.h"
#import "MLPost.h"

@implementation MLPostDetail

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
    self.postBriefInfo = [[MLPost alloc] init];
    TFHppleElement *firstTrNode = [trNodes objectAtIndex:0];
    TFHppleElement *tdInFirstTrNode = [firstTrNode firstChild];
    TFHppleElement *lastAInTd = [[tdInFirstTrNode childrenWithTagName:@"a"] objectAtIndex:2];
    MLAuthor *author = [[MLAuthor alloc] init];
    author.name = [lastAInTd text];
    author.url = [[lastAInTd attributes] objectForKey:@"href"];
    self.postBriefInfo.author = author;
    
    TFHppleElement *secondTrNode = [trNodes objectAtIndex:1];
    TFHppleElement *textarea = [[[secondTrNode firstChild] childrenWithTagName:@"textarea"] objectAtIndex:0];
    self.content = [textarea text];
    
    
//    NSLog(@"second tr node:%@", [[trNodes objectAtIndex:1] content]);
}


@end
