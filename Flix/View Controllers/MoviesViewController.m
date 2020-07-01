//
//  MoviesViewController.m
//  Flix
//
//  Created by Angela Xu on 6/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MoviesViewController.h"
#import "DetailsViewController.h"
#import "MovieApiManager.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"
#import "Movie.h"

//TODO: favorites
//TODO: refresh and connection alerts for collection view as well
//TODO: move fetch movies outside of check for wifi

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIAlertController *alertResolution;
@property BOOL alertTriggered;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // setting up no internet error message
    self.alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies" message:@"The internet connection appears to be offline." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.alertTriggered = YES;
        [self checkForWIFIConnection];
    }];
    UIAlertAction *dismissAlertAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [self.alert addAction:retryAction];
    [self.alert addAction:dismissAlertAction];
    
    //setting up an internet resolved message
    self.alertResolution = [UIAlertController alertControllerWithTitle:@"Reconnected" message:@"Reloading movies..." preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [self.alertResolution addAction:dismissAction];
    
    // setting up the pull down refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(checkForWIFIConnection) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self checkForWIFIConnection];
}

// is there an internet connection?
- (void)checkForWIFIConnection {
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];

    // ReachableViaWWAN == 3G, ReachableViaWiFi == WIFI
    if (netStatus != ReachableViaWiFi) {
        self.alertTriggered = YES;
        [self presentViewController:self.alert animated:YES completion:^{}];
    } else {
        if (self.alertTriggered){
            [self presentViewController:self.alertResolution animated:YES completion:^{}];
            self.alertTriggered = NO;
        }
        [self fetchMovies];
    }
}

- (void)fetchMovies {
    [self.activityIndicator startAnimating];
    
    MovieApiManager *manager = [MovieApiManager new];
    [manager fetchNowPlaying:^(NSArray *movies, NSError *error) {
        self.movies = movies;
        self.filteredMovies = self.movies;
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        [self.tableView reloadData];
    }];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    cell.movie = self.filteredMovies[indexPath.row];

    return cell;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSDictionary *evaluatedObject, NSDictionary *bindings) {
            if ([evaluatedObject[@"original_title"] containsString:searchText]) {
                return YES;
            }  else {
                return NO;
            }
        }];
        self.filteredMovies = [self.movies filteredArrayUsingPredicate:predicate];
        
        
    }
    else {
        self.filteredMovies = self.movies;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Navigation

    // Pass the selected object to the new view controller.
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MovieCell *tappedCell = sender;
    Movie *movie = tappedCell.movie;
    
    //getting the new view controller
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


@end
