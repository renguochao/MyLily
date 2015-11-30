//
//  MLHotTopicsViewController.m
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLHotTopicsViewController.h"
#import "MLTopicDetailViewController.h"

#import "MLPost.h"

#import "TFHpple.h"
#import "Common.h"
#import "MLNetTool.h"
#import "MLHppleParser.h"
#import "MLHotTopicCell.h"
#import "MLHotTopicFrame.h"

#define kSectionNums 1

@interface MLHotTopicsViewController () {
    NSMutableArray *_topAllSections;
}

@property (nonatomic, strong) NSMutableArray *allHotTopicFrame;

@end

// 12个section
@implementation MLHotTopicsViewController

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
    NSData *topAllData = [MLNetTool loadHtmlDataFromUrl:kTOPALL];
    
    [self parseData:topAllData];
}

- (void)parseData:(NSData *)data {
    
    // 1. 从HTML中搜索12个section节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *allSectionXpathQueryString = @"//table";
    NSArray *topAllNodes = [doc searchWithXPathQuery:allSectionXpathQueryString];
    
    // 2. 解析热门话题
    _topAllSections = [[NSMutableArray alloc] initWithCapacity:0];
    [_topAllSections addObjectsFromArray:[MLHppleParser parseTopAllSection:[topAllNodes objectAtIndex:0]]];
    _allHotTopicFrame = [NSMutableArray array];
    
    for (NSArray *hotTopicInSection in _topAllSections) {
        NSMutableArray *hotTopicFrameInSection = [NSMutableArray array];
        
        for (MLPost *post in hotTopicInSection) {
            MLHotTopicFrame *hotTopicFrame = [[MLHotTopicFrame alloc] init];
            hotTopicFrame.hotTopic = post;
            [hotTopicFrameInSection addObject:hotTopicFrame];
        }
        
        [_allHotTopicFrame addObject:hotTopicFrameInSection];
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_allHotTopicFrame count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_allHotTopicFrame objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"HotTopicsCell";
    MLHotTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[MLHotTopicCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }

    cell.hotTopicFrame = self.allHotTopicFrame[indexPath.section][indexPath.row];
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    MLHotTopicFrame *hotTopicFrame = self.allHotTopicFrame[indexPath.section][indexPath.row];
    
    return hotTopicFrame.cellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLPost *post = [[_topAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MLTopicDetailViewController *topicDetailVC = [[MLTopicDetailViewController alloc] init];
    topicDetailVC.topicUrl = post.url;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

@end
