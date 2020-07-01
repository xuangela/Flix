//
//  Movie.h
//  Flix
//
//  Created by Angela Xu on 7/1/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Movie : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *synopsis;
@property (nonatomic, strong) NSURL *posterURL;
@property (nonatomic, strong) NSURL *backdropURL;
@property (nonatomic, strong) NSString *trailerURLString;


- (id)initWithDictionary:(NSDictionary *)dictionary;

+ (NSArray *)moviesWithDictionaries: (NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
