//
//  MLTopicDetailCell.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLTopicDetailCell.h"
#import "MLPost.h"

#define kPostContentFont [UIFont systemFontOfSize:14]

@interface MLTopicDetailCell()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation MLTopicDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1. 添加子控件
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews {
    
    // 1.帖子内容
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.font = kPostContentFont;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    
}

- (void)setPostDetailFrame:(MLPostDetailFrame *)postDetailFrame {
    _postDetailFrame = postDetailFrame;
    
    MLPost *postDetail = postDetailFrame.post;
    
    // 1.帖子内容
    self.contentLabel.frame = postDetailFrame.postContentFrame;
    self.contentLabel.text = postDetail.content;
    
}

@end
