//
//  MLTopicDetailCell.m
//  MyLily
//
//  Created by rgc on 15/11/17.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLTopicDetailCell.h"
#import "MLPost.h"
#import "MLPostContentSegment.h"

#import "UIImageView+WebCache.h"
#import "Common.h"

@interface MLTopicDetailCell()

@property (nonatomic, weak) UILabel *authorLabel;

@property (nonatomic, weak) UILabel *levelLabel;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, weak) UILabel *contentLabel;

@property (nonatomic, weak) UILabel *ipLabel;

@property (nonatomic, strong) NSMutableArray *contentSegmentArray;

@end

@implementation MLTopicDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // 1.添加子控件
        [self addSubViews];
        
        // 2.初始化变量
        [self setupVars];
    }
    return self;
}

- (void)setupVars {
    NSMutableArray *contentSegmentArray = [NSMutableArray array];
    self.contentSegmentArray = contentSegmentArray;
}

- (void)addSubViews {
    
    // 1.帖子作者
    UILabel *authorLabel = [[UILabel alloc] init];
    authorLabel.font = kPostAuthorFont;
    authorLabel.numberOfLines = 0;
    [self.contentView addSubview:authorLabel];
    self.authorLabel = authorLabel;
    
    // 2.帖子楼层
    UILabel *levelLabel = [[UILabel alloc] init];
    levelLabel.font = kPostAuthorFont;
    [self.contentView addSubview:levelLabel];
    self.levelLabel = levelLabel;
    
    // 3.帖子时间
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = kPostContentFont;
    timeLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    // 4.帖子内容
//    UILabel *contentLabel = [[UILabel alloc] init];
//    contentLabel.numberOfLines = 0;
//    contentLabel.font = kPostContentFont;
//    [self.contentView addSubview:contentLabel];
//    self.contentLabel = contentLabel;
    
    // 5.帖子Ip
    UILabel *ipLabel = [[UILabel alloc] init];
    ipLabel.font = kPostContentFont;
    ipLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:ipLabel];
    self.ipLabel = ipLabel;
    
}

- (void)setPostDetailFrame:(MLPostDetailFrame *)postDetailFrame {
    _postDetailFrame = postDetailFrame;
    
    MLPost *post = postDetailFrame.post;
    
    // 1.帖子作者
    self.authorLabel.frame = postDetailFrame.postAuthorFrame;
    self.authorLabel.text = [NSString stringWithFormat:@"%@(%@)", post.author.authorId, post.author.authorScreenName];
    
    // 2.帖子楼层
    self.levelLabel.frame = postDetailFrame.postLevelFrame;
    self.levelLabel.text = [NSString stringWithFormat:@"%d", post.level];
    
    // 3.帖子时间
    self.timeLabel.frame = postDetailFrame.postTimeFrame;
    self.timeLabel.text = post.postTime;
    
    // 4.帖子内容
    if (self.contentSegmentArray.count > 0) {
        for (int i = 0; i < self.contentSegmentArray.count; i ++) {
            [[self.contentSegmentArray objectAtIndex:i] removeFromSuperview];
        }
        
        [self.contentSegmentArray removeAllObjects];
    }
    
   NSMutableArray *contentSegmentFrameArray = postDetailFrame.contentSegmentFrameArray;
    for (int i = 0; i < post.contentSegments.count; i ++) {
        MLPostContentSegment *contentSegment = [post.contentSegments objectAtIndex:i];
        
        if (contentSegment.isImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:[[contentSegmentFrameArray objectAtIndex:i] CGRectValue]];
            imageView.clipsToBounds = YES;
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.layer.borderWidth = 2;
            imageView.layer.borderColor = [UIColor whiteColor].CGColor;
            NSString *urlString = [contentSegment.content stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            [imageView sd_setImageWithURL:[NSURL URLWithString:urlString] placeholderImage:nil options:SDWebImageRetryFailed | SDWebImageLowPriority];
            [self.contentView addSubview:imageView];
            [self.contentSegmentArray addObject:imageView];
            
        } else {
            
            UILabel *contentLabel = [[UILabel alloc] init];
            contentLabel.numberOfLines = 0;
            contentLabel.font = kPostContentFont;
            contentLabel.frame = [[postDetailFrame.contentSegmentFrameArray objectAtIndex:i] CGRectValue];
            contentLabel.text = contentSegment.content;
            [self.contentView addSubview:contentLabel];
            [self.contentSegmentArray addObject:contentLabel];
        }
    }
    
    self.contentLabel.frame = postDetailFrame.postContentFrame;
    self.contentLabel.text = post.content;
    
    
    // 5.帖子Ip
    self.ipLabel.frame = postDetailFrame.postIpFrame;
    self.ipLabel.text = post.ip;
}

@end
