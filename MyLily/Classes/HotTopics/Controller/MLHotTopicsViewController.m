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

#define kSectionNums 1

@interface MLHotTopicsViewController () {
    NSMutableArray *_topAllSections;
}

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
    
    _topAllSections = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 2. 遍历12个section
    _topAllSections = [[NSMutableArray alloc] initWithCapacity:0];
    [_topAllSections addObjectsFromArray:[MLHppleParser parseTopAllSection:[topAllNodes objectAtIndex:0]]];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_topAllSections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[_topAllSections objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Top10Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    MLPost *post = [[_topAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.author.name;
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLPost *post = [[_topAllSections objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    MLTopicDetailViewController *topicDetailVC = [[MLTopicDetailViewController alloc] init];
    topicDetailVC.topicUrl = post.url;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

@end
