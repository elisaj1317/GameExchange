//
//  HomeViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "HomeViewController.h"
#import "DetailsViewController.h"
#import "FilterViewController.h"
#import "RequestCell.h"

#import "SceneDelegate.h"
#import "APIManager.h"
#import <Parse/Parse.h>


@interface HomeViewController () <FilterViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSMutableArray *requests;
@property (strong, nonatomic) NSMutableArray *filteredRequests;
@property (strong, nonatomic) NSDictionary *filtersDictionary;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.searchBar.delegate = self;
    
    [self setUpRefresh];
    [self fetchRequests];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
}

- (IBAction)didTapLogout:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
            if (!error) {
                [self segueToLogin];
            } else {
                NSLog(@"User log out failed: %@", error.localizedDescription);
            }
    }];
}

- (void)setUpRefresh {
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(fetchRequests) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

- (void)fetchRequests {
    // construct query
    PFQuery *query = [self setUpQueryWithFilters];
    [query orderByDescending:@"createdAt"];
    
    // fetch data
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
        if(!error) {
            self.requests = [NSMutableArray arrayWithArray:requests];
            self.filteredRequests = self.requests;
            
            [self.tableView reloadData];
            [self.refreshControl endRefreshing];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void)fetchFilteredRequestsWithString:(NSString *)searchString {
    // construct query
    PFQuery *query = [self setUpQueryWithFilters];
    [query whereKey:@"itemSelling" containsString:searchString];
    
    // fetch data
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable requests, NSError * _Nullable error) {
        if(!error) {
            self.filteredRequests = [NSMutableArray arrayWithArray:requests];
            
            [self.tableView reloadData];
        } else {
            NSLog(@"%@", error.localizedDescription);
        }
    }];
}

- (void) segueToLogin {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginNavBarController"];
    sceneDelegate.window.rootViewController = loginViewController;
}

- (void)didFilter:(NSDictionary *)filters {
    self.filtersDictionary = filters;
    
    PFQuery *mainQuery = [self setUpQueryWithFilters];
    [mainQuery orderByDescending:@"createdAt"];
    
    [mainQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                self.requests = [NSMutableArray arrayWithArray:objects];
                self.filteredRequests = self.requests;
                
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
}

- (PFQuery *)setUpQueryWithFilters {
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query includeKey:@"author"];
    query.limit = 20;
    
    for (NSString *key in self.filtersDictionary) {
        NSArray *keyFilters = self.filtersDictionary[key];
        if (keyFilters.count != 0) {
            [query whereKey:key containedIn:self.filtersDictionary[key]];
        }
    }
    
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    cell.request = self.filteredRequests[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredRequests.count;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length != 0) {
        [self fetchFilteredRequestsWithString:searchText];
            
        }
        else {
            self.filteredRequests = self.requests;
        }
        
        [self.tableView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    
    self.filteredRequests = self.requests;
    [self.tableView reloadData];
    [self.searchBar resignFirstResponder];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"detailsSegue"]) {
        // Passes selected Request into DetailsViewController
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Request *request = self.requests[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        
        detailsViewController.request = request;
    } else if ([segue.identifier isEqual:@"filterSegue"]){
        UINavigationController *navigationController = [segue destinationViewController];
        FilterViewController *filterController = (FilterViewController*)navigationController.topViewController;
        filterController.delegate = self;
        filterController.filtersDictionary = self.filtersDictionary;
    }
}


@end
