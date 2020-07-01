//
//  MovieCell.m
//  Flix
//
//  Created by Angela Xu on 6/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "MoviesViewController.h"

@implementation MovieCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)setMovie:(Movie *)movie {
    _movie = movie;
    
    self.titleLabel.text = movie.title;
    self.synopsisLabel.text = movie.synopsis;

    self.posterView.image = nil;
    NSURLRequest *posterRequest = [NSURLRequest requestWithURL:movie.posterURL];
    
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
}

@end
