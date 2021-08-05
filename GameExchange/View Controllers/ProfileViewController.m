//
//  ProfileViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/4/21.
//

#import "ProfileViewController.h"
#import "DetailsViewController.h"
#import "RequestCell.h"


#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *requestTypes;
@property (strong, nonatomic) NSMutableArray *requests;
@property (strong, nonatomic) NSMutableArray *moreDataForSection;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self setUpData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSIndexPath *selectedRow = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:selectedRow animated:YES];
}


- (void)setUpData {
    self.requestTypes = @[@"Active", @"In Progress", @"Completed"];
    self.requests = [NSMutableArray arrayWithArray:@[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array]]];
    self.moreDataForSection = [NSMutableArray arrayWithArray:@[@YES, @YES, @YES]];
    
    [self fetchDataForSection:0];
    [self fetchDataForSection:1];
    [self fetchDataForSection:2];
}

- (void)fetchDataForSection:(NSInteger)section {
    PFQuery *query = [self createProfileQueryForSection:section];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(!error) {
                [self.requests setObject:[NSMutableArray arrayWithArray:objects] atIndexedSubscript:section];
                
                if (objects.count != query.limit) {
                    [self.moreDataForSection setObject:@NO atIndexedSubscript:section];
                }
                
                [self.tableView reloadData];
                
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
}

- (void)fetchMoreDataForSection:(NSInteger)section {
    NSMutableArray *currentSectionData = self.requests[section];
    PFQuery *query = [self createProfileQueryForSection:section];
    query.limit = 5;
    query.skip = currentSectionData.count;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(!error) {
                [currentSectionData addObjectsFromArray:[NSMutableArray arrayWithArray:objects]];
                [self.requests setObject:currentSectionData atIndexedSubscript:section];
                
                if (objects.count != query.limit) {
                    [self.moreDataForSection setObject:@NO atIndexedSubscript:section];
                }
                
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
}



- (PFQuery *)createProfileQueryForSection:(NSInteger)section {
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    NSString *sectionName = self.requestTypes[section];
    [query whereKey:@"requestStatus" equalTo:[sectionName lowercaseString]];
    query.limit = 2;
    
    return query;
}

//MARK: Table View Functions

- (UITableViewCell *)createFooterCell {
    UITableViewCell *footer = [[UITableViewCell alloc] init];
    footer.textLabel.textColor = [UIColor blueColor];
    footer.textLabel.textAlignment = NSTextAlignmentCenter;
    footer.textLabel.text = @"See more...";
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *currentSection = self.requests[indexPath.section];
    
    if (indexPath.row >= currentSection.count) {
        return [self createFooterCell];
    }
    
    
    [tableView registerNib:[UINib nibWithNibName:@"RequestCell" bundle:nil] forCellReuseIdentifier:@"RequestCell"];
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    cell.request = currentSection[indexPath.row];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.requestTypes[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.requestTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSMutableArray *currentSection = self.requests[section];
    
    if ([self.moreDataForSection[section]  isEqual: @YES]) {
        return currentSection.count + 1;
    }
    return currentSection.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *currentSection = self.requests[indexPath.section];
    if (indexPath.row >= currentSection.count) {
        [self fetchMoreDataForSection:indexPath.section];
    } else {
        [self performSegueWithIdentifier:@"profileDetailSegue" sender:indexPath];
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"profileDetailSegue"]) {
        NSIndexPath *indexPath = sender;
        Request *request = self.requests[indexPath.section][indexPath.row];
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.request = request;
        detailsViewController.editable = YES;
    }
}


@end
