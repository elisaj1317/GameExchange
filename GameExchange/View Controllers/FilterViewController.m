//
//  FilterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import "FilterViewController.h"

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@property (strong) NSArray *sectionItems;
@property (strong) NSArray *sectionNames;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //TODO: Change mock data
    self.sectionNames = @[ @"iPhone", @"iPad", @"Apple Watch" ];
       self.sectionItems = @[ @[@"iPhone 5", @"iPhone 5s", @"iPhone 6", @"iPhone 6 Plus",
    @"iPhone 7", @"iPhone 7 Plus"],
                              @[@"iPad Mini", @"iPad Air 2", @"iPad Pro", @"iPad Pro 9.7"],
                              @[@"Apple Watch", @"Apple Watch 2", @"Apple Watch 2 (Nike)"]
                            ];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionNames.count > 0) {
        self.tableView.backgroundView = nil;
        return self.sectionNames.count;
    } else {
        //TODO: Add custom loading state for data
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        messageLabel.text = @"Retrieving data.\nPlease wait.";
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
        [messageLabel sizeToFit];
        self.tableView.backgroundView = messageLabel;
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.expandedSectionHeaderNumber == section) {
        NSMutableArray *arrayOfItems = [self.sectionItems objectAtIndex:section];
        return arrayOfItems.count;
    } else {
        return 0;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.sectionNames.count) {
        return [self.sectionNames objectAtIndex:section];
    }
    return @"";
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor = [UIColor grayColor];
    header.textLabel.textColor = [UIColor blackColor];
    
    // remove previous arrow image
    UIImageView *viewWithTag = [self.view viewWithTag:section + self.sectionNames.count];
    if (viewWithTag) {
        [viewWithTag removeFromSuperview];
    }
    
    // add the arrow image
    CGSize headerFrame = self.view.frame.size;
    UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, header.frame.size.height/2.0 - 9, 18, 18)];
    theImageView.image = [UIImage imageNamed:@"down_arrow"];
    theImageView.tag = section + self.sectionNames.count;
    [header addSubview:theImageView];
    
    // make headers touchable
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sectionHeaderWasTouched:)];
    [header addGestureRecognizer:headerTapGesture];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableCell" forIndexPath:indexPath];
    NSArray *section = [self.sectionItems objectAtIndex:indexPath.section];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [section objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    //TODO: this never runs, see if necessary
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *eImageView = (UIImageView *)[headerView viewWithTag:section + self.sectionNames.count];
    self.expandedSectionHeader = headerView;
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage:eImageView];
    } else {
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage:eImageView];
            self.expandedSectionHeader = nil;
        } else {
            UIImageView *cImageView  = (UIImageView *)[self.view viewWithTag:self.sectionNames.count + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage:cImageView];
            [self tableViewExpandSection:section withImage:eImageView];
        }
    }
}

- (void)tableViewCollapeSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = [self.sectionItems objectAtIndex:section];
    self.expandedSectionHeaderNumber = -1;
    if (sectionData.count == 0) {
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((0.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

- (void)tableViewExpandSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = [self.sectionItems objectAtIndex:section];
    if (sectionData.count == 0) {
        self.expandedSectionHeaderNumber = -1;
        return;
    } else {
        [UIView animateWithDuration:0.4 animations:^{
            imageView.transform = CGAffineTransformMakeRotation((180.0 * M_PI) / 180.0);
        }];
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        self.expandedSectionHeaderNumber = section;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:arrayOfIndexPaths withRowAnimation: UITableViewRowAnimationFade];
        [self.tableView endUpdates];
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
