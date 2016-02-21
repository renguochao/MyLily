//
//  MLNetTool.m
//  MyLily
//
//  Created by rgc on 15/9/16.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLNetTool.h"
#import "Common.h"
#import "NSData+MLDataCorrection.h"

@implementation MLNetTool

+ (NSData *)loadHtmlDataFromUrl:(NSString *)url {
    // 1. 加载Data
    NSURL *absoluteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kBASEURL, url]];
    NSData *htmlData = [NSData dataWithContentsOfURL:absoluteUrl];
    
    // 2. 转码成utf8Data:先转成gb2312, 替换meta, 然后转成utf8
    NSString *postHtmlStr = [htmlData GB18030String];
    
    NSString *uft8HtmlStr = [postHtmlStr stringByReplacingOccurrencesOfString:@"<meta HTTP-EQUIV=\"Content-Type\" CONTENT=\"text/html; charset=gb2312\">" withString:@"<meta http-equiv=\"Content-Type\" content=\"text/html; charset=utf-8\">"];
    NSData *utf8HtmlData = [uft8HtmlStr dataUsingEncoding:NSUTF8StringEncoding];

    return utf8HtmlData;
}

@end
