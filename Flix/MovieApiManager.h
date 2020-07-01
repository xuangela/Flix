//
//  MovieApiManager.h
//  Flix
//
//  Created by Angela Xu on 7/1/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieApiManager : NSObject

- (void)fetchNowPlaying:(void(^)(NSArray *movies, NSError *error))completion;

@end

NS_ASSUME_NONNULL_END
