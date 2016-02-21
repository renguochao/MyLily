//
//  NSData+MLDataCorrection.m
//  MyLily
//
//  Created by rgc on 16/2/21.
//  Copyright © 2016年 rgc. All rights reserved.
//

#import "NSData+MLDataCorrection.h"

@implementation NSData (MLDataCorrection)

- (NSString *)GB18030String {
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *str = [[NSString alloc]initWithData:self encoding:enc];
    if (!str) {
        str = [[NSString alloc]initWithData:[self dataByHealingGB18030Stream] encoding:enc];
    }
    return str;
}

- (NSData *)dataByHealingGB18030Stream {
    NSUInteger length = [self length];
    if (length == 0) {
        return self;
    }
    
    static NSString * replacementCharacter = @"?";
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData *replacementCharacterData = [replacementCharacter dataUsingEncoding:enc];
    
    NSMutableData *resultData = [NSMutableData dataWithCapacity:self.length];
    
    const Byte *bytes = [self bytes];
    
    static const NSUInteger bufferMaxSize = 1024;
    Byte buffer[bufferMaxSize];
    NSUInteger bufferIndex = 0;
    
    NSUInteger byteIndex = 0;
    BOOL invalidByte = NO;
    
    
#define FlushBuffer() if (bufferIndex > 0) { \
[resultData appendBytes:buffer length:bufferIndex]; \
bufferIndex = 0; \
}
#define CheckBuffer() if ((bufferIndex+5) >= bufferMaxSize) { \
[resultData appendBytes:buffer length:bufferIndex]; \
bufferIndex = 0; \
}
    
    
    while (byteIndex < length) {
        Byte byte = bytes[byteIndex];
        
        //检查第一位
        if (byte >= 0 && byte <= (Byte)0x7f) {
            //单字节文字
            CheckBuffer();
            buffer[bufferIndex++] = byte;
        } else if (byte >= (Byte)0x81 && byte <= (Byte)0xfe){
            //可能是双字节，可能是四字节
            if (byteIndex + 1 >= length) {
                //这是最后一个字节了，但是这个字节表明后面应该还有1或3个字节，那么这个字节一定是错误字节
                FlushBuffer();
                return resultData;
            }
            
            Byte byte2 = bytes[++byteIndex];
            if (byte2 >= (Byte)0x40 && byte <= (Byte)0xfe && byte != (Byte)0x7f) {
                //是双字节，并且可能合法
                Byte tuple[] = {byte, byte2};
                CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 2, kCFStringEncodingGB_18030_2000, false);
                if (cfstr) {
                    CFRelease(cfstr);
                    CheckBuffer();
                    buffer[bufferIndex++] = byte;
                    buffer[bufferIndex++] = byte2;
                } else {
                    //这个双字节字符不合法，但byte2可能是下一字符的第一字节
                    byteIndex -= 1;
                    invalidByte = YES;
                }
            } else if (byte2 >= (Byte)0x30 && byte2 <= (Byte)0x39) {
                //可能是四字节
                if (byteIndex + 2 >= length) {
                    FlushBuffer();
                    return resultData;
                }
                
                Byte byte3 = bytes[++byteIndex];
                
                if (byte3 >= (Byte)0x81 && byte3 <= (Byte)0xfe) {
                    // 第三位合法，判断第四位
                    
                    Byte byte4 = bytes[++byteIndex];
                    
                    if (byte4 >= (Byte)0x30 && byte4 <= (Byte)0x39) {
                        //第四位可能合法
                        Byte tuple[] = {byte, byte2, byte3, byte4};
                        CFStringRef cfstr = CFStringCreateWithBytes(kCFAllocatorDefault, tuple, 4, kCFStringEncodingGB_18030_2000, false);
                        if (cfstr) {
                            CFRelease(cfstr);
                            CheckBuffer();
                            buffer[bufferIndex++] = byte;
                            buffer[bufferIndex++] = byte2;
                            buffer[bufferIndex++] = byte3;
                            buffer[bufferIndex++] = byte4;
                        } else {
                            //这个四字节字符不合法，但是byte2可能是下一个合法字符的第一字节，回退3位
                            //并且将byte1,byte2用?替代
                            byteIndex -= 3;
                            invalidByte = YES;
                        }
                    } else {
                        //第四字节不合法
                        byteIndex -= 3;
                        invalidByte = YES;
                    }
                } else {
                    // 第三字节不合法
                    byteIndex -= 2;
                    invalidByte = YES;
                }
            } else {
                // 第二字节不是合法的第二位，但可能是下一个合法的第一位，所以回退一个byte
                invalidByte = YES;
                byteIndex -= 1;
            }
            
            if (invalidByte) {
                invalidByte = NO;
                FlushBuffer();
                [resultData appendData:replacementCharacterData];
            }
        }
        byteIndex++;
    }
    FlushBuffer();
    return resultData;
}

@end
