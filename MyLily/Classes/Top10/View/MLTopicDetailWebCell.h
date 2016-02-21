//
//  MLTopicDetailWebCell.h
//  MyLily
//
//  Created by rgc on 16/1/20.
//  Copyright © 2016年 rgc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLPost.h"

@class MLTopicDetailWebCell;

@protocol MLTopicDetailWebCellDelegate <NSObject>

@optional
- (void)topicDetailWebCellRefreshHeight;

@end

@interface MLTopicDetailWebCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic, strong) MLPost *post;

@property (nonatomic, weak) id<MLTopicDetailWebCellDelegate> delegate;

- (void)updatePost:(MLPost *)post;

@end
