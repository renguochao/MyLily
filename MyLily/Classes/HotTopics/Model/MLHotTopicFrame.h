//
//  MLHotTopicFrame.h
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MLPost.h"

@interface MLHotTopicFrame : NSObject

@property (nonatomic, strong) MLPost *hotTopic;

/** 热门话题标题 */
@property (nonatomic, assign, readonly) CGRect hotTopicTitleFrame;

/** 信区 */
@property (nonatomic, assign, readonly) CGRect hotTopicBoardFrame;

@property (nonatomic, assign) CGFloat cellHeight;

@end
