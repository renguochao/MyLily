//
//  MLNetTool.m
//  MyLily
//
//  Created by rgc on 15/9/16.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#import "MLNetTool.h"
#import "Common.h"

@implementation MLNetTool

+ (NSData *)loadHtmlDataFromUrl:(NSString *)url {
    NSURL *absoluteUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", BASEURL, TOP10URL]];
    NSData *htmlData = [NSData dataWithContentsOfURL:absoluteUrl];
    return htmlData;
}

@end
