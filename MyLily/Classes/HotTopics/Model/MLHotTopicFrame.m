//
//  MLHotTopicFrame.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLHotTopicFrame.h"

#define kTopPadding 25
#define kLeftPadding 15
#define kBottomPadding 5
#define kMargin 5
#define kTopicTitleLabelFont [UIFont boldSystemFontOfSize:15]
#define kBoardFont [UIFont systemFontOfSize:13]

@implementation MLHotTopicFrame

- (void)setHotTopic:(MLPost *)hotTopic {
    _hotTopic = hotTopic;
    
    // cell的宽度
    CGFloat cellW = [[UIScreen mainScreen] bounds].size.width;
    
    // 1.热门话题标题
    CGFloat hotTopicTitleX = kLeftPadding;
    CGFloat hotTopicTitleY = kTopPadding;
    CGFloat hotTopicTitleMaxW = cellW - kLeftPadding * 2;
    NSString *title = [NSString stringWithFormat:@"口 %@", hotTopic.title];
    CGSize hotTopicSize = [title sizeWithFont:kTopicTitleLabelFont constrainedToSize:CGSizeMake(hotTopicTitleMaxW, MAXFLOAT)];
    _hotTopicTitleFrame = (CGRect){{hotTopicTitleX, hotTopicTitleY}, hotTopicSize};
    
    
    // 2.信区
    CGFloat hotTopicBoardX = hotTopicTitleX;
    CGFloat hotTopicBoardY = CGRectGetMaxY(_hotTopicTitleFrame);
    NSString *board = [NSString stringWithFormat:@"信区：%@", hotTopic.board];
    CGSize  hotTopicBoardSize = [board sizeWithFont:kBoardFont];
    _hotTopicBoardFrame = (CGRect){{hotTopicBoardX, hotTopicBoardY}, hotTopicBoardSize};
    
    // 3.cell的高度
    _cellHeight = CGRectGetMaxY(_hotTopicBoardFrame) + kBottomPadding;
}

@end
