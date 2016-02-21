//
//  MLTopicPageViewController.m
//  MyLily
//
//  Created by rgc on 16/2/19.
//  Copyright © 2016年 rgc. All rights reserved.
//

#import "MLTopicPageViewController.h"
#import "MLNetTool.h"
#import "TFHpple.h"
#import "MLPost.h"
#import "MLAuthor.h"
#import "Common.h"

@interface MLTopicPageViewController()

@property (nonatomic, strong) UIWebView *webview;

@property (nonatomic, strong) NSMutableArray *posts;

@end

@implementation MLTopicPageViewController

- (NSMutableArray *)posts {
    if (_posts == nil) {
        _posts = [NSMutableArray array];
    }
    return _posts;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置界面
    [self buildUI];
    
    // 2. 加载数据
    [self loadData];
}

- (void)buildUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    _webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webview.scrollView.bounces = NO;
    
    [self.view addSubview:_webview];
}

- (void)loadData {
    // 1. 获取Data
    NSData *postDetailHtmlData = [MLNetTool loadHtmlDataFromUrl:self.topicUrl];
    
    // 2.解析数据
    [self parseData:postDetailHtmlData];
    
    // 3.在webview中展示
    [self showInWebView];
}

/**
 *  解析数据
 */
- (void)parseData:(NSData *)data {
    // 1. 从HTML中搜索tbody节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *postsXpathQueryString = @"//table[@class='main']";
    NSArray *postsNodes = [doc searchWithXPathQuery:postsXpathQueryString];
    
    for (int i = 0; i < [postsNodes count]; i ++) {
        MLPost *post = [[MLPost alloc] initWithTFHppleElement:[postsNodes objectAtIndex:i]];
        post.level = i;
        
        [self.posts addObject:post];
    }
    
}

#pragma mark - ******************** 拼接html语言
- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">",[[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    
    [html appendString:[NSString stringWithFormat:@"<body background=\"%@\">", [[NSBundle mainBundle] URLForResource:@"back2.png" withExtension:nil]]];
    [html appendString:[self touchBody]];
    [html appendString:@"</body>"];
    
    [html appendString:@"</html>"];
    
    [self.webview loadHTMLString:html baseURL:nil];
}

- (NSString *)touchBody {
    
    NSMutableString *body = [NSMutableString string];
    
    NSString *lzId = nil;
    NSString *hr = [NSString stringWithFormat:@"<hr width=%f size=0.5 color=#D2FB9F>", (ScreenWidth - 40)];
    
    for (int i = 0; i < self.posts.count; i ++) {
        MLPost *post = [self.posts objectAtIndex:i];
        
        NSMutableString *topicPostInfo = [NSMutableString string];
        [topicPostInfo appendString:@"<div>"];
        if (i == 0) {
            lzId = post.author.authorId;
            [topicPostInfo appendFormat:@"楼主：%@（%@）<br>", post.author.authorId, post.author.authorScreenName];
            [topicPostInfo appendFormat:@"信区：%@<br>", post.board];
            [topicPostInfo appendFormat:@"标题：%@<br>", post.title];
        } else {
            [topicPostInfo appendFormat:@"%d楼：%@（%@）<br>", i, [lzId isEqualToString:post.author.authorId] ? @"楼主" : post.author.authorId, post.author.authorScreenName];
        }
        [topicPostInfo appendFormat:@"发信于：%@<br><br>", post.postTime];
        [topicPostInfo appendString:@"</div>"];
        [body appendString:topicPostInfo];
        
        [body appendString:post.content];

        if (i != self.posts.count - 1) {
            [body appendString:hr];
        }
    }
    
    return body;
}

- (void)dealloc
{
    NSLog(@"%s",__func__);
}

@end
