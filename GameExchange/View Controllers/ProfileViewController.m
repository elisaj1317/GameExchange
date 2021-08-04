//
//  ProfileViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/4/21.
//

#import "ProfileViewController.h"
#import "RequestCell.h"


#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *requestTypes;
@property (strong, nonatomic) NSMutableArray *requests;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.requestTypes = @[@"Active", @"In Progress", @"Completed"];
    self.requests = [NSMutableArray arrayWithArray:@[[NSMutableArray array], [NSMutableArray array], [NSMutableArray array]]];
    
    [self fetchActiveData];
    [self fetchInProgressData];
    [self fetchSoldData];
}

- (void)fetchActiveData {
    PFQuery *activeQuery = [self createProfileQuery];
    [activeQuery whereKey:@"requestStatus" equalTo:@"active"];
    
    [activeQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.requests setObject:[NSMutableArray arrayWithArray:objects] atIndexedSubscript:0];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchInProgressData {
    PFQuery *progressQuery = [self createProfileQuery];
    [progressQuery whereKey:@"requestStatus" equalTo:@"progress"];
    
    
    [progressQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.requests setObject:[NSMutableArray arrayWithArray:objects] atIndexedSubscript:1];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (void)fetchSoldData {
    PFQuery *soldQuery = [self createProfileQuery];
    [soldQuery whereKey:@"requestStatus" equalTo:@"sold"];
    
    
    [soldQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            [self.requests setObject:[NSMutableArray arrayWithArray:objects] atIndexedSubscript:2];
            [self.tableView reloadData];
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (PFQuery *)createProfileQuery {
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query includeKey:@"author"];
    [query whereKey:@"author" equalTo:[PFUser currentUser]];
    [query orderByDescending:@"createdAt"];
    query.limit = 5;
    
    return query;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView registerNib:[UINib nibWithNibName:@"RequestCell" bundle:nil] forCellReuseIdentifier:@"RequestCell"];
    RequestCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestCell"];
    cell.request = self.requests[indexPath.section][indexPath.row];
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
    return currentSection.count;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
