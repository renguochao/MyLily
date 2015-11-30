//
//  MLHotTopicCell.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLHotTopicCell.h"

#define kTopicTitleLabelFont [UIFont boldSystemFontOfSize:15]
#define kBoardFont [UIFont systemFontOfSize:13]

@interface MLHotTopicCell()

/** topic */
@property (nonatomic, weak) UILabel *topicTitleLabel;

/** board */
@property (nonatomic, weak) UILabel *boardLabel;

@end

@implementation MLHotTopicCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1. 添加子控件
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    
    // 1.标题
    UILabel *topicTitleLabel = [[UILabel alloc] init];
    topicTitleLabel.numberOfLines = 0;
    topicTitleLabel.font = kTopicTitleLabelFont;
    [self.contentView addSubview:topicTitleLabel];
    self.topicTitleLabel = topicTitleLabel;
    
    // 2.信区
    UILabel *boardLabel = [[UILabel alloc] init];
    boardLabel.font = kBoardFont;
    [self.contentView addSubview:boardLabel];
    self.boardLabel = boardLabel;
    
}

- (void)setHotTopicFrame:(MLHotTopicFrame *)hotTopicFrame {
    _hotTopicFrame = hotTopicFrame;
    
    MLPost *hotTopic = hotTopicFrame.hotTopic;
    
    // 1.设置title的frame
    self.topicTitleLabel.frame = hotTopicFrame.hotTopicTitleFrame;
    self.topicTitleLabel.text = [NSString stringWithFormat:@"口 %@", hotTopic.title];
    
    // 2.设置board的frame
    self.boardLabel.frame = hotTopicFrame.hotTopicBoardFrame;
    self.boardLabel.text = [NSString stringWithFormat:@"信区：%@", hotTopic.board];
    
}

@end
