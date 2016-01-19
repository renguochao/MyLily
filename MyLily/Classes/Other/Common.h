//
//  Common.h
//  MyLily
//
//  Created by rgc on 15/9/9.
//  Copyright (c) 2015年 rgc. All rights reserved.
//

#ifndef MyLily_Common_h
#define MyLily_Common_h

// 1. 判断是否为iOS7
#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)

// 2. 服务器URL
#define kBASEURL @"http://bbs.nju.edu.cn/"
#define kTOP10URL @"bbstop10"
#define kTOPALL @"bbstopall"

#define ScreenRect   [[UIScreen mainScreen] bounds]
#define ScreenWidth  [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

// 3. 帖子
/** 帖子内容字体 */
#define kPostContentFont [UIFont systemFontOfSize:14]
#define kPostAuthorFont [UIFont boldSystemFontOfSize:16]

#endif
