//
//  MLPostFrame.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLPostFrame.h"

#define kCellRightPadding 60
#define kCellMargin 5
#define kPostTitleFont [UIFont systemFontOfSize:15]
#define kPostSubDetailFont [UIFont systemFontOfSize:12]

@implementation MLPostFrame

/**
 *  根据Post数据，计算Cell子控件的Frame
 *
 *  @param post 帖子数据
 */
- (void)setPost:(MLPost *)post {
    _post = post;
    
    // cell的宽度
    CGFloat cellW = [[UIScreen mainScreen] bounds].size.width;
    
    // title
    CGFloat titleLabelX = kCellMargin;
    CGFloat titleLabelY = kCellMargin * 2;
    CGFloat titleLabelMaxW = cellW - kCellRightPadding;
    NSString *title = [NSString stringWithFormat:@"口 %@", post.title];
    CGSize titleLabelSize = [title sizeWithFont:kPostTitleFont constrainedToSize:CGSizeMake(titleLabelMaxW, MAXFLOAT)];
    _titleFrame = (CGRect){{titleLabelX, titleLabelY}, titleLabelSize};
    
    // 人气
    NSString *replyCount = [NSString stringWithFormat:@"人气：%d", post.replyCount];
    CGSize replyCountLabelSize = [replyCount sizeWithFont:kPostSubDetailFont];
    CGFloat replyCountLabelX = cellW - replyCountLabelSize.width - kCellMargin;
    CGFloat replyCountLabelY = titleLabelY + titleLabelSize.height * 0.5;
    _replyCountFrame = (CGRect){{replyCountLabelX, replyCountLabelY}, replyCountLabelSize};
    
    // author
    CGFloat authorLabelX = titleLabelX;
    CGFloat authorLabelY = CGRectGetMaxY(_titleFrame);
    NSString *author = [NSString stringWithFormat:@"作者：%@", post.author.authorId];
    CGSize authorLabelSize = [author sizeWithFont:kPostSubDetailFont];
    _authorFrame = (CGRect){{authorLabelX, authorLabelY}, authorLabelSize};
    
    // board
    NSString *board = [NSString stringWithFormat:@"信区：%@", post.board];
    CGSize boardLabelSize = [board sizeWithFont:kPostSubDetailFont];
    CGFloat boardLabelX = cellW - boardLabelSize.width - kCellMargin;
    CGFloat boardLabelY = authorLabelY;
    _boardFrame = (CGRect){{boardLabelX, boardLabelY}, boardLabelSize};
    
    // cell的高度
    _cellHeight = CGRectGetMaxY(_boardFrame) + kCellMargin;
}

@end
