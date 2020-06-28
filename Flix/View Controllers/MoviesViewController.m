//
//  MoviesViewController.m
//  Flix
//
//  Created by Angela Xu on 6/24/20.
//  Copyright © 2020 Angela Xu. All rights reserved.
//

#import "MoviesViewController.h"
#import "DetailsViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"

@interface MoviesViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) NSArray *movies;
@property (nonatomic, strong) NSArray *filteredMovies;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) UIAlertController *alert;
@property (nonatomic, strong) UIAlertController *alertResolution;
@property BOOL alertTriggered;

@end

@implementation MoviesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    
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
}

- (void)viewWillAppear:(BOOL)animated {
    [self.activityIndicator startAnimating];
    [self checkForWIFIConnection];
}

- (void)fetchMovies {
    
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error != nil) {
                if ([[error domain] isEqualToString:@"NSURLErrorDomain"]) {
                    [self presentViewController:self.alert animated:YES completion:^{}];
                } else {
                    NSLog(@"%@", error);
                }
           } else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               self.movies = dataDictionary[@"results"];
               self.filteredMovies = self.movies;
               
               [self.tableView reloadData];
               
               
           }
        [self.refreshControl endRefreshing];
        [self.activityIndicator stopAnimating];
        
    }];
    [task resume];
}

// is there an internet connection?
- (void)checkForWIFIConnection {
    Reachability *wifiReach = [Reachability reachabilityForInternetConnection];

    NetworkStatus netStatus = [wifiReach currentReachabilityStatus];

    // ReachableViaWWAN == 3G, ReachableViaWiFi == WIFI
    if (netStatus != ReachableViaWiFi) {
        self.alertTriggered = YES;
    } else if (self.alertTriggered){
        [self presentViewController:self.alertResolution animated:YES completion:^{}];
        [self.activityIndicator startAnimating];
        self.alertTriggered = NO;
    }
    [self fetchMovies];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredMovies.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MovieCell"];
    
    NSDictionary *movie = self.filteredMovies[indexPath.row];
    cell.titleLabel.text = movie[@"title"];
    cell.synopsisLabel.text = movie[@"overview"];
    
    NSString *baseURLString = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURLString = movie[@"poster_path"];
    NSString *fullPosterURLString = [baseURLString stringByAppendingString:posterURLString];
    
    NSURL *posterURL = [NSURL URLWithString:fullPosterURLString];
    [cell.posterView setImageWithURL:posterURL];
    
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
    UITableViewCell *tappedCell = sender;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
    NSDictionary *movie = self.movies[indexPath.row];
    
    //getting the new view controller
    DetailsViewController *detailViewController = [segue destinationViewController];
    detailViewController.movie = movie;
}


@end
