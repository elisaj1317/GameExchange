//
//  DetailsViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "DetailsViewController.h"
#import "OfferCell.h"
#import "Request.h"

#import <Parse/PFImageView.h>

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;


@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemSellingLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;


@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    
    [self setUpHeader];
}

- (void)setUpHeader {
    // set up image
    self.itemImageView.file = self.request.image;
    [self.itemImageView loadInBackground];
    
    [self setUpHeaderLabels];
    
}

- (void)setUpHeaderLabels {
    self.itemSellingLabel.text = self.request.itemSelling;
    self.sellerNameLabel.text = [self.request.author objectForKey:@"fullName"];
    self.sellerUsernameLabel.text = self.request.author.username;
    self.locationLabel.text = self.request.location;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.request.itemRequest.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OfferCell"];
    cell.gameName = self.request.itemRequest[indexPath.row];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.headerView;
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
