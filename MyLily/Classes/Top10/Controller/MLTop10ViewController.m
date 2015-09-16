//
//  MLTop10TableViewController.m
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//  十大

#import "MLTop10ViewController.h"
#import "MLTopicDetailViewController.h"

#import "MLPost.h"

#import "MLNetTool.h"
#import "Common.h"
#import "TFHpple.h"


@interface MLTop10ViewController () {
    NSMutableArray *_top10Posts;
}

@end

@implementation MLTop10ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置界面
    [self buildUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 1.加载数据
    [self loadData];
}

- (void)buildUI {
    
}

/**
 *  加载数据
 */
- (void)loadData {
    
    NSData *top10HtmlData = [MLNetTool loadHtmlDataFromUrl:TOP10URL];
//    NSStringEncoding encoding = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//    NSString *top10HtmlString = [[NSString alloc] initWithData:top10HtmlData encoding:encoding];
//    NSLog(@"%@", top10HtmlString);
    
    [self parseData:top10HtmlData];
}

- (void)parseData:(NSData *)data {
    
    // 1. 从HTML中搜索tr节点
    TFHpple *doc = [TFHpple hppleWithHTMLData:data];
    
    NSString *top10ArticlesXpathQueryString = @"//table/tr";
    NSArray *top10Nodes = [doc searchWithXPathQuery:top10ArticlesXpathQueryString];
    
    _top10Posts = [[NSMutableArray alloc] initWithCapacity:0];
    
    // 2. 遍历十大节点
    for (int i = 1; i < top10Nodes.count; i ++) { // 第一行是title跳过
        TFHppleElement *element = [top10Nodes objectAtIndex:i];
        MLPost *post = [[MLPost alloc] initWithTFHppleElement:element];
 
        [_top10Posts addObject:post];
    }
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_top10Posts count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseIdentifier = @"Top10Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    }
    
    MLPost *post = [_top10Posts objectAtIndex:indexPath.row];
    cell.textLabel.text = post.title;
    cell.detailTextLabel.text = post.author.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MLPost *post = [_top10Posts objectAtIndex:indexPath.row];
    MLTopicDetailViewController *topicDetailVC = [[MLTopicDetailViewController alloc] init];
    topicDetailVC.topicUrl = post.url;
    
    [self.navigationController pushViewController:topicDetailVC animated:YES];
}

@end
