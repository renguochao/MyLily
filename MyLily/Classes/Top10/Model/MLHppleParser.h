//
//  MLHppleParser.h
//  MyLily
//
//  Created by rgc on 15/9/16.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MLPost.h"
#import <TFHpple.h>

@interface MLHppleParser : NSObject

+ (MLPost *)parseTop10Element:(TFHppleElement *)element;
+ (NSArray *)parseTopAllSection:(TFHppleElement *)element;
+ (NSArray *)parseTopAllPostsRow:(TFHppleElement *)element;

@end
