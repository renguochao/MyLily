//
//  MLPostDetailFrame.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLPostDetailFrame.h"
#import "Common.h"
#import "MLPostContentSegment.h"

#define kCellPadding 8
#define kCellMargin 5
#define kImageW ([[UIScreen mainScreen] bounds].size.width - kCellPadding * 2)
#define kImageH (kImageW * 9 / 16)

@implementation MLPostDetailFrame

- (void)setPost:(MLPost *)post {
    _post = post;
    
    // cell的宽度
    CGFloat cellW = [[UIScreen mainScreen] bounds].size.width;
    
    // 1.帖子基本信息的frame
    CGFloat postAuthorX = kCellPadding;
    CGFloat postAuthorY = kCellPadding;
    CGFloat authorLabelMaxW = cellW - kCellMargin * 6;
    CGSize postAuthorSize = [[NSString stringWithFormat:@"%@(%@)", post.author.authorId, post.author.authorScreenName] sizeWithFont:kPostAuthorFont constrainedToSize:CGSizeMake(authorLabelMaxW, MAXFLOAT)];
    _postAuthorFrame = (CGRect){{postAuthorX, postAuthorY}, postAuthorSize};
    
    // 2.楼层的frame
    CGSize levelSize = [[NSString stringWithFormat:@"%d", post.level] sizeWithFont:kPostAuthorFont];
    CGFloat levelX = cellW - levelSize.width - kCellPadding;
    CGFloat levelY = postAuthorY;
    _postLevelFrame = (CGRect){{levelX, levelY}, levelSize};
    
    // 3.时间的frame
    CGFloat postTimeX = postAuthorX;
    CGFloat postTimeY = CGRectGetMaxY(_postAuthorFrame) + kCellMargin;
    CGSize postTimeSize = [post.postTime sizeWithFont:kPostContentFont];
    _postTimeFrame = (CGRect){{postTimeX, postTimeY}, postTimeSize};
    
    // 4.帖子内容的frame
    _contentSegmentFrameArray = [[NSMutableArray alloc] init];
    CGFloat contentSegmentX = kCellPadding;
    CGFloat contentSegmentY = CGRectGetMaxY(_postTimeFrame) + kCellMargin;
    CGFloat lastSegmentHeight = 0;
    for (int i = 0; i < post.contentSegments.count; i ++) {
        MLPostContentSegment *contentSegment = [post.contentSegments objectAtIndex:i];
        if (contentSegment.isImage) {
            [_contentSegmentFrameArray addObject:[NSValue valueWithCGRect:CGRectMake(contentSegmentX, contentSegmentY, kImageW, kImageH)]];
            
            lastSegmentHeight += kImageH;
        } else {
            NSString *content = contentSegment.content;
            CGFloat contentMaxW = cellW - kCellMargin * 2;
            CGSize contentSize = [content sizeWithFont:kPostContentFont constrainedToSize:CGSizeMake(contentMaxW, MAXFLOAT)];
            [_contentSegmentFrameArray addObject:[NSValue valueWithCGRect:CGRectMake(contentSegmentX, contentSegmentY, contentSize.width, contentSize.height)]];
            
            lastSegmentHeight += contentSize.height;
        }
        
        contentSegmentY = contentSegmentY + lastSegmentHeight + kCellMargin;
    }
    
    // 5.ip的frame */
    CGFloat postIpX = postAuthorX;
    CGFloat postIpY = CGRectGetMaxY([[_contentSegmentFrameArray objectAtIndex:(_contentSegmentFrameArray.count - 1)] CGRectValue]) + kCellMargin;
    CGSize postIpSize = [post.postTime sizeWithFont:kPostContentFont];
    _postIpFrame = (CGRect){{postIpX, postIpY}, postIpSize};
    
    // 6.cell的高度
    _cellHeight = CGRectGetMaxY(_postIpFrame) + kCellPadding;
    
}


@end
