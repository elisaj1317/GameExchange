//
//  DetailsViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "DetailsViewController.h"
#import "OfferCell.h"
#import "Request.h"
#import "Functions.h"

#import <Parse/PFImageView.h>
#import <MaterialComponents/MDCFilledTextField.h>

@interface DetailsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headerView;

//MARK: Game Info
@property (weak, nonatomic) IBOutlet PFImageView *itemImageView;
@property (weak, nonatomic) IBOutlet UILabel *itemSellingLabel;
@property (weak, nonatomic) IBOutlet UILabel *platformLabel;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;

//MARK: Seller Info
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sellerUsernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

//MARK: Custom Offer
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *offerField;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.title = self.request.itemSelling;
    
    [self setUpHeader];
    
    self.offerField.label.text = @"Custom Offer";
    self.offerField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.offerField];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(didAcceptOffer:)
            name:@"offerAccepted"
            object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)didMakeOffer:(id)sender {
    [self updateRequestStatusWithGame:self.offerField.text];
}


- (void)setUpHeader {
    // set up image
    self.itemImageView.file = self.request.image;
    [self.itemImageView loadInBackground];
    
    [self setUpHeaderGameLabels];
    [self setUpHeaderSellerLabels];
    
}

- (void)setUpHeaderGameLabels {
    self.itemSellingLabel.text = self.request.itemSelling;
    self.platformLabel.text = self.request.platform;
    self.genreLabel.text = [Functions stringWithArray:self.request.genre];
}

- (void)setUpHeaderSellerLabels {
    self.sellerNameLabel.text = [self.request.author objectForKey:@"fullName"];
    self.sellerUsernameLabel.text = self.request.author.username;
    self.locationLabel.text = self.request.location;
}

- (void)didAcceptOffer:(NSNotification *)notification {
    NSString *gameName = notification.userInfo[@"offerAccepted"];
    
    [self updateRequestStatusWithGame:gameName];
}

- (void)updateRequestStatusWithGame:(NSString *)gameName {
    self.request[@"requestStatus"] = @"in progress";
    
    // create offer
    NSMutableDictionary *currentOffer = [NSMutableDictionary dictionary];
    [currentOffer setValue:[PFUser currentUser] forKey:@"user"];
    [currentOffer setValue:gameName forKey:@"name"];
    
    
    NSMutableArray *offersMade = (NSMutableArray *)self.request.offers;
    [offersMade addObject:currentOffer];
    self.request[@"offers"] = offersMade;
    
    [self.request saveInBackground];
}

- (void)setEditable:(BOOL *)editable {
    _editable = editable;
    
    UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(sendToEdit:)];
    
    self.navigationItem.rightBarButtonItem = editButton;

}

//MARK: Table View Functions

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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIView *header = self.tableView.tableHeaderView;
    CGSize size = [header systemLayoutSizeFittingSize:CGSizeMake(self.tableView.frame.size.width, UILayoutFittingCompressedSize.height)];
    
    if (header.frame.size.height != size.height) {
        header.frame = CGRectMake(header.frame.origin.x, header.frame.origin.y, header.frame.size.width, size.height);
        
        self.tableView.tableHeaderView = header;
    }
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
