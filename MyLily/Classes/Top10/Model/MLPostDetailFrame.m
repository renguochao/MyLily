//
//  MLPostDetailFrame.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLPostDetailFrame.h"

#define kCellMargin 5
#define kPostContentFont [UIFont systemFontOfSize:14]

@implementation MLPostDetailFrame

- (void)setPost:(MLPost *)post {
    _post = post;
    
    // cell的宽度
    CGFloat cellW = [[UIScreen mainScreen] bounds].size.width;
    // 1.帖子基本信息的frame
//    CGFloat postBasicInfoX = kCellMargin;
//    CGFloat postBasicInfoY = kCellMargin;
//    CGSize  postBasicInfoSize = [postDetail.postBriefInfo]
    
//    @property (nonatomic, assign, readonly) CGRect postBasicInfoFrame;
    
    // 2.楼层的frame
//    @property (nonatomic, assign, readonly) CGRect postFloorFrame;
    
    // 3.时间的frame
//    @property (nonatomic, assign, readonly) CGRect postTimeFrame;
    
    // 4.帖子内容的frame
    CGFloat postContentX = kCellMargin;
    CGFloat postContentY = kCellMargin;
    CGFloat postContentMaxW = cellW - kCellMargin * 2;
    CGSize  postContentSize = [post.content sizeWithFont:kPostContentFont constrainedToSize:CGSizeMake(postContentMaxW, MAXFLOAT)];
    _postContentFrame = (CGRect){{postContentX, postContentY}, postContentSize};
    
    // 5.ip的frame */
//    @property (nonatomic, assign, readonly) CGRect postIpFrame;
    
    // 6.cell的高度
    _cellHeight = CGRectGetMaxY(_postContentFrame) + kCellMargin;
    
}


@end
