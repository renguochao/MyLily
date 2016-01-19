//
//  MLPost.h
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLAuthor.h"
#import "TFHppleElement.h"

@interface MLPost : NSObject

@property (nonatomic, strong) NSString *ranking;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *board;
@property (nonatomic, strong) NSString *boardUrl;
@property (nonatomic, strong) MLAuthor *author;
@property (nonatomic, assign) int replyCount;

@property (nonatomic, assign) int level; // 几楼
@property (nonatomic, strong) NSString *postTime; // 时间
@property (nonatomic, strong) NSString *content; // 帖子内容
@property (nonatomic, strong) NSMutableArray *contentSegments; // 解析后的帖子片段
@property (nonatomic, strong) NSString *ip; //发帖的ip

- (id)initWithTFHppleElement:(TFHppleElement *)element;

- (NSString *)description;
@end
