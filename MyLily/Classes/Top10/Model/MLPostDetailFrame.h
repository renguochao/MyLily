//
//  MLPostDetailFrame.h
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPost.h"

@interface MLPostDetailFrame : NSObject

@property (nonatomic, strong) MLPost *post;

/** 帖子基本信息的frame */
@property (nonatomic, assign, readonly) CGRect postBasicInfoFrame;

/** 楼层的frame */
@property (nonatomic, assign, readonly) CGRect postFloorFrame;

/** 时间的frame */
@property (nonatomic, assign, readonly) CGRect postTimeFrame;

/** 帖子内容的frame */
@property (nonatomic, assign, readonly) CGRect postContentFrame;

/** ip的frame */
@property (nonatomic, assign, readonly) CGRect postIpFrame;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
