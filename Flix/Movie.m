//
//  Movie.m
//  Flix
//
//  Created by Angela Xu on 7/1/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "Movie.h"

@implementation Movie

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    
    self.title = dictionary[@"title"];
    self.synopsis = dictionary[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = dictionary[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    self.posterURL = [NSURL URLWithString:fullPosterURLString];
    
    NSString *backdropURLString = dictionary[@"backdrop_path"];
    NSString *fullBackdropURLString = [baseURLString stringByAppendingString:backdropURLString];
    self.backdropURL = [NSURL URLWithString:fullBackdropURLString];
    
    NSString *movieID = dictionary[@"id"];
    NSString *apiBaseURL = @"https://api.themoviedb.org/3/movie/";
    self.trailerURLString = [apiBaseURL stringByAppendingFormat:@"%@/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed&language=en-US", movieID];
    
    return self;
}

+ (NSArray *)moviesWithDictionaries: (NSArray *)dictionaries {
    NSMutableArray *movieDict = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries) {
        Movie *movie = [[Movie alloc] initWithDictionary:dictionary];
        [movieDict addObject:movie];
    }
    
    return movieDict;
}

@end
