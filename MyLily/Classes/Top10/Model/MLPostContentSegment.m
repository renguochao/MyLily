//
//  MLPostContentSegment.m
//  MyLily
//
//  Created by rgc on 15/11/30.
//  Copyright © 2015年 rgc. All rights reserved.
//

#import "MLPostContentSegment.h"

@implementation MLPostContentSegment

- (NSString *)description {
    return [NSString stringWithFormat:@"isImage:%d, content:%@", self.isImage, self.content];
}
@end
