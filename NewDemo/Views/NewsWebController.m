//
//  NewsWebView.m
//  toolsDemo
//
//  Created by Mr.Q on 16/6/5.
//  Copyright © 2016年 钱立顺. All rights reserved.
//

#import "NewsWebController.h"
#import "UIView+SDAutoLayout.h"

@interface NewsWebController ()<UIWebViewDelegate>

@property (nonatomic,strong) UIWebView *webView;

@end

@implementation NewsWebController


- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -42, kSize.width, kSize.height)];

    [self.view addSubview:self.webView];

    self.webView.delegate = self;
    
    // 发送请求
    NSURL *url = [NSURL URLWithString:self.url];
    NSLog(@"url %@",url);
    // 请求
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // 发送异步请求
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        // response,服务器返回的响应头
        // data 服务器返回的响应体
        // connecionError 链接错误
        // 判断请求是否有错误
        if (!connectionError) {
            [self.webView loadRequest:request];
        }else{
            NSLog(@"连接错误%@",connectionError);
        }
    }];
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{//a_adtemp a_topad js-topad 广告  /      topbar  头部 bar
 //    [self.webView stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName(\"topbar\")[0].hidden = true"];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.webView stringByEvaluatingJavaScriptFromString:
         @"document.getElementsByClassName(\"topbar\")[0].style.display = 'none'"];

        [self.webView stringByEvaluatingJavaScriptFromString:
         @"document.getElementsByClassName(\"a_adtemp a_topad js-topad\")[0].style.display = 'none'"];

        [self performSelector:@selector(changeWebView) withObject:nil afterDelay:1.5];

    });

          // starting the load, show the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    // finished loading, hide the activity indicator in the status bar
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

    // 获取 webView 当前网页的 JSON  
    //    NSString *docStr=[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.textContent"];
    //    NSLog(@"json : %@",docStr);
}

- (void)changeWebView{

    self.webView.sd_layout.yIs(0);
}

-(void)dealloc{
    NSLog(@"web dealloc ");
}

@end
