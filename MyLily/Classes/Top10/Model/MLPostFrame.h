//
//  MLPostFrame.h
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPost.h"

@interface MLPostFrame : NSObject

@property (nonatomic, strong) MLPost *post;

/** 标题的Frame */
@property (nonatomic, assign, readonly) CGRect titleFrame;

/** 人气的Frame */
@property (nonatomic, assign, readonly) CGRect replyCountFrame;

/** 作者的Frame */
@property (nonatomic, assign, readonly) CGRect authorFrame;

/** 信区的Frame */
@property (nonatomic, assign, readonly) CGRect boardFrame;

/** cell的高度 */
@property (nonatomic, assign, readonly) CGFloat cellHeight;

@end
