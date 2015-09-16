//
//  MLPostDetailViewController.m
//  MyLily
//
//  Created by rgc on 15/9/14.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLTopicDetailViewController.h"

#import "MLPostDetail.h"
#import "MLPost.h"
#import "MLAuthor.h"

#import "MLNetTool.h"
#import "TFHpple.h"
#import "Common.h"

#define TEST_DOCUMENT_NAME          @"topicDetail"
#define TEST_DOCUMENT_EXTENSION     @"html"

@interface MLTopicDetailViewController () {
    NSMutableArray *_currentTopicPosts;
}

@end

@implementation MLTopicDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1. 设置界面
    [self buildUI];
    
    // 2. 加载数据
    [self loadData];
}

- (void)buildUI {
    
}

- (void)loadData {
    // 1. 获取Data
    NSData *postDetailHtmlData = [MLNetTool loadHtmlDataFromUrl:self.topicUrl];
    
    [self parseData:postDetailHtmlData];
}

- (void)parseData:(NSData *)data {
    
    // 1. 从HTML中搜索tbody节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *postsXpathQueryString = @"//table[@class='main']";
    NSArray *postsNodes = [doc searchWithXPathQuery:postsXpathQueryString];
    
    _currentTopicPosts = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (TFHppleElement *element in postsNodes) {
        MLPostDetail *postDetail = [[MLPostDetail alloc] initWithTFHppleElement:element];
        [_currentTopicPosts addObject:postDetail];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_currentTopicPosts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"TopicDetail";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    MLPostDetail *postDetail = [_currentTopicPosts objectAtIndex:indexPath.row];
    cell.textLabel.text = postDetail.content;
    cell.detailTextLabel.text = postDetail.postBriefInfo.author.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}
@end
