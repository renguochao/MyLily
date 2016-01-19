//
//  MLPostContentSegment.h
//  MyLily
//
//  Created by rgc on 15/11/30.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MLPostContentSegment : NSObject
/** Segment是否为图片 */
@property (nonatomic, assign) BOOL isImage;
/** 如果Segment为图片，内容为图片url；否则是Segment内容 */
@property (nonatomic, strong) NSString *content;

- (NSString *)description;

@end
