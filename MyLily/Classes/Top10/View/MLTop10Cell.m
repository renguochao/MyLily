//
//  MLTop10Cell.m
//  MyLily
//
//  Created by rgc on 15/9/17.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLTop10Cell.h"
#import <Masonry/Masonry.h>
#import <MMPlaceHolder/MMPlaceHolder.h>

#import "Common.h"

#define kMargin 5.0
#define kTitleFont [UIFont systemFontOfSize:15]
#define kSubDetailFont [UIFont systemFontOfSize:12]

@interface MLTop10Cell()

/** title */
@property (nonatomic, weak) UILabel *titleLabel;

/** author */
@property (nonatomic, weak) UILabel *authorLabel;

/** board */
@property (nonatomic, weak) UILabel *boardLabel;

/** replyCount*/
@property (nonatomic, weak) UILabel *replyCountLabel;

@end

@implementation MLTop10Cell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1. 添加子控件
        [self addSubViews];
        
    }
    return self;
}

- (void)addSubViews {
    // 1.帖子标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = kTitleFont;
    titleLabel.numberOfLines = 0;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 2.作者
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.font = kSubDetailFont;
    [self.contentView addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    // 3.信区
    UILabel *boardLabel = [[UILabel alloc] init];
    boardLabel.font = kSubDetailFont;
    [self.contentView addSubview:boardLabel];
    self.boardLabel = boardLabel;
    
    // 4.人气
    UILabel *replyCountLabel = [[UILabel alloc] init];
    replyCountLabel.font = kSubDetailFont;
    [self.contentView addSubview:replyCountLabel];
    self.replyCountLabel = replyCountLabel;
}

- (void)setPostFrame:(MLPostFrame *)postFrame {
    _postFrame = postFrame;
    
    MLPost *post = postFrame.post;
    
    // 1.设置title的frame
    self.titleLabel.frame = postFrame.titleFrame;
    self.titleLabel.text = [NSString stringWithFormat:@"口 %@", post.title];
    
    // 2.设置author的frame
    self.authorLabel.frame = postFrame.authorFrame;
    self.authorLabel.text = [NSString stringWithFormat:@"作者：%@", post.author.authorId];
    
    // 3.设置board的frame
    self.boardLabel.frame = postFrame.boardFrame;
    self.boardLabel.text = [NSString stringWithFormat:@"信区：%@", post.board];
    
    // 4.设置人气的frame
    self.replyCountLabel.frame = postFrame.replyCountFrame;
    self.replyCountLabel.text = [NSString stringWithFormat:@"人气：%d", post.replyCount];
}

@end
