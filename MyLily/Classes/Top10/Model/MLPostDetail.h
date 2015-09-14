//
//  MLPostDetail.h
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFHppleElement.h"

@class MLPost;
@interface MLPostDetail : NSObject

@property (nonatomic, strong) MLPost *postBriefInfo; //帖子基本信息
@property (nonatomic, strong) NSString *level; // 几楼
@property (nonatomic, strong) NSString *postTime; // 时间
@property (nonatomic, strong) NSString *content; // 帖子内容
@property (nonatomic, strong) NSString *postFrom; //发帖的ip

- (id)initWithTFHppleElement:(TFHppleElement *)element;
@end
