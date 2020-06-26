//
//  TrailerViewController.m
//  Flix
//
//  Created by Angela Xu on 6/26/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "TrailerViewController.h"
#import <WebKit/WebKit.h>

@interface TrailerViewController ()

@property (weak, nonatomic) IBOutlet WKWebView *webView;

@property (nonatomic, strong) NSURL *trailerURL;


@end

@implementation TrailerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *movieID = self.movie[@"id"];
    NSString *apiBaseURL = @"https://api.themoviedb.org/3/movie/";
    NSString *urlString = [apiBaseURL stringByAppendingFormat:@"%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieID];

    [self fetchTrailerURL:urlString];
    NSLog(@"Hello");
    NSLog(@"11111%@", self.trailerURL);
    
    


}

- (void)fetchTrailerURL: (NSString *) movieURLString {
    
    NSURL *url = [NSURL URLWithString:movieURLString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                NSLog (@"%@", error);
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSString *defaultString = @"https://www.youtube.com/watch?v=";
               NSString *trailerURLString = [defaultString stringByAppendingString:dataDictionary[@"results"][0][@"key"]];
               
               self.trailerURL = [NSURL URLWithString:trailerURLString];
               NSLog(@"%@", self.trailerURL);
               
               // Place the URL in a URL Request.
               NSURLRequest *request = [NSURLRequest requestWithURL:self.trailerURL
                                                        cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                    timeoutInterval:10.0];
               // Load Request into WebView.
               [self.webView loadRequest:request];
               

           };
    }];
    [task resume];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
