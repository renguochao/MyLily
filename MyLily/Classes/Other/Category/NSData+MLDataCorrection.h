//
//  NSData+MLDataCorrection.h
//  MyLily
//
//  Created by rgc on 16/2/21.
//  Copyright © 2016年 rgc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MLDataCorrection)

/**
 *  NSDATA转NSSTRING – 如何处理不合法编码问题
 */
- (NSString *)GB18030String;

@end
