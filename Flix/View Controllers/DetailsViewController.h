//
//  DetailsViewController.h
//  Flix
//
//  Created by Angela Xu on 6/26/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"

NS_ASSUME_NONNULL_BEGIN

@interface DetailsViewController : UIViewController

@property (nonatomic, strong) Movie *movie;

@end

NS_ASSUME_NONNULL_END
