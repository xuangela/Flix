//
//  DetailsViewController.m
//  Flix
//
//  Created by Angela Xu on 6/26/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "DetailsViewController.h"
#import "TrailerViewController.h"
#import "UIImageView+AFNetworking.h"

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *backDropView;
@property (weak, nonatomic) IBOutlet UIImageView *posterView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *synopsisLabel;
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapToTrailerGesture;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    
    NSString *posterURLString = self.movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:posterURL];
    
    [self.posterView setImageWithURLRequest:posterRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
            self.posterView.alpha = 0.0;
            self.posterView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                self.posterView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Image was cached so just update the image");
            self.posterView.image = image;
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
    NSString *backdropURLString = self.movie[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    
    NSURL *backdropURL = [NSURL URLWithString:fullBackdropURLString];
    NSURLRequest *backdropRequest = [NSURLRequest requestWithURL:backdropURL];
    [self.backDropView setImageWithURLRequest:backdropRequest placeholderImage:nil
    success:^(NSURLRequest *imageRequest, NSHTTPURLResponse *imageResponse, UIImage *image) {
        
        // imageResponse will be nil if the image is cached
        if (imageResponse) {
            NSLog(@"Image was NOT cached, fade in image");
            self.backDropView.alpha = 0.0;
            self.backDropView.image = image;
            
            //Animate UIImageView back to alpha 1 over 0.3sec
            [UIView animateWithDuration:0.3 animations:^{
                self.backDropView.alpha = 1.0;
            }];
        }
        else {
            NSLog(@"Image was cached so just update the image");
            self.backDropView.image = image;
        }
    }
    failure:^(NSURLRequest *request, NSHTTPURLResponse * response, NSError *error) {}];
    
    
    self.titleLabel.text = self.movie[@"title"];
    self.synopsisLabel.text = self.movie[@"overview"];
    
    [self.titleLabel sizeToFit];
    [self.synopsisLabel sizeToFit];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    
    //getting the new view controller
    TrailerViewController *trailerViewController = [segue destinationViewController];
    trailerViewController.movie = self.movie;
}


@end
