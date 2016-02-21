//
//  MLTopicDetailWebCell.m
//  MyLily
//
//  Created by rgc on 16/1/20.
//  Copyright © 2016年 rgc. All rights reserved.
//

#import "MLTopicDetailWebCell.h"

@implementation MLTopicDetailWebCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.webView = [[UIWebView alloc] initWithFrame:self.bounds];
        [_webView setDelegate:self];
        
        // It's important that the webview doesn't autoresize when its parent's frame changes.
        [_webView setAutoresizingMask:UIViewAutoresizingNone];
        
        [_webView.scrollView setScrollEnabled:NO]; // Prevents scrolling in the webview.
        [_webView.scrollView setScrollsToTop:NO]; // Keep the "scroll to top when the status is tapped" behavior.
        
        [self.contentView addSubview:_webView];
    }
    return self;
}

- (void)updatePost:(MLPost *)post {
    
    self.post = post;
    
    NSString *htmlPath = [NSString stringWithFormat:@"%@/content_template.html", [[NSBundle mainBundle] bundlePath]];
    
    NSString *template = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    template = [template stringByReplacingOccurrencesOfString:@"[[should_monitor_size]]"
                                                   withString:post.cellHeight != 0 ? @"false" : @"true"];
    
    template = [template stringByReplacingOccurrencesOfString:@"[[content_id]]"
                                                   withString:[NSString stringWithFormat:@"%ld", (long)post.level]];
    
    template = [template stringByReplacingOccurrencesOfString:@"[[content_body]]"
                                                   withString:post.textarea];
    
    NSLog(@"template:%@", template);
    
    // Finally, load the content
    [self.webView loadHTMLString:template
                         baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.alpha = 0.f;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.alpha = 1.f;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSURL *url = [request URL];
    NSString *scheme = [url scheme];
    
    if ([scheme isEqualToString:@"ready"]) {
        
        // URLs look like ready://content/12345/232
        //                     content id --^    ^---- document height
        
        NSInteger level = [[[url pathComponents] objectAtIndex:1] integerValue];
        
        if (self.post.level != level) { // sanity check
            return NO;
        }
        
        NSInteger height = [[[url pathComponents] objectAtIndex:2] integerValue];
        
        if (height != self.post.cellHeight) {
            
            self.post.cellHeight = height;
            
            if ([self.delegate respondsToSelector:@selector(topicDetailWebCellRefreshHeight)]) {
                [self.delegate topicDetailWebCellRefreshHeight];
            }
            
        }
        
        return NO;
    }
    
    return YES;
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    // Manually resize the web view
    CGRect r = self.webView.frame;
    r.origin = CGPointZero;
    r.size = self.frame.size;
    self.webView.frame = r;
}


@end
