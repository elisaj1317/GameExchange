//
//  FilterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import "FilterViewController.h"
#import <Parse/Parse.h>
#import "Request.h"

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (assign) NSInteger expandedSectionHeaderNumber;
@property (assign) UITableViewHeaderFooterView *expandedSectionHeader;
@property (strong) NSMutableArray *sectionItems;
@property (strong) NSArray *sectionNames;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.expandedSectionHeaderNumber = -1;
    
    if (self.filtersDictionary == nil) {
        self.filtersDictionary = [NSMutableDictionary dictionary];
    }
    
    [self fetchSectionItems];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)didTapApply:(id)sender {
    [self.delegate didFilter:self.filtersDictionary];
    [self dismissViewControllerAnimated:true completion:nil];
}


- (void)fetchSectionItems {
    self.sectionNames = @[ @"Platform", @"Genre", @"Apple Watch" ];
    self.sectionItems = [[NSMutableArray alloc] init];
    
    NSMutableSet *platformNames = [[NSMutableSet alloc] init];
    NSMutableSet *genreNames = [[NSMutableSet alloc] init];
    // construct query
    PFQuery *query = [PFQuery queryWithClassName:@"Request"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            for (Request *item in objects) {
                [platformNames addObject:item.platform];
                [genreNames addObject:item.genre];
            }
            NSArray *sortedPlatformNames = [[platformNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
            [self.sectionItems addObject:sortedPlatformNames];
            NSArray *sortedGenreNames = [[genreNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
            [self.sectionItems addObject:sortedGenreNames];
            
            
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
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
    NSString *selectedItem = [section objectAtIndex:indexPath.row];
    cell.textLabel.text = selectedItem;
    
    NSString *currentSectionName = [self.sectionNames[indexPath.section] lowercaseString];
    NSMutableArray *selectedInSection = self.filtersDictionary[currentSectionName];
    
    if ([selectedInSection containsObject:selectedItem]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *currentSectionName = [self.sectionNames[indexPath.section] lowercaseString];
    NSString *selectedItem = self.sectionItems[indexPath.section][indexPath.row];
    NSMutableArray *selectedInSection = self.filtersDictionary[currentSectionName];
    
    if (selectedInSection == nil) {
        selectedInSection = [[NSMutableArray alloc] init];
    }
    
    if ([selectedInSection containsObject:selectedItem]) {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [selectedInSection removeObject:selectedItem];

    } else {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [selectedInSection addObject:selectedItem];
    }
    
    [self.filtersDictionary setValue:selectedInSection forKey:currentSectionName];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)sectionHeaderWasTouched:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger section = headerView.tag;
    UIImageView *clickedImageView = (UIImageView *)[headerView viewWithTag:section + self.sectionNames.count];
    self.expandedSectionHeader = headerView;
    // no section is currently expanded
    if (self.expandedSectionHeaderNumber == -1) {
        self.expandedSectionHeaderNumber = section;
        [self tableViewExpandSection:section withImage:clickedImageView];
    } else {
        // clicked on expanded section, collapse
        if (self.expandedSectionHeaderNumber == section) {
            [self tableViewCollapeSection:section withImage:clickedImageView];
            self.expandedSectionHeader = nil;
        // clicked on new section, collapse previous, expand new
        } else {
            UIImageView *expandedImageView  = (UIImageView *)[self.view viewWithTag:self.sectionNames.count + self.expandedSectionHeaderNumber];
            [self tableViewCollapeSection:self.expandedSectionHeaderNumber withImage:expandedImageView];
            [self tableViewExpandSection:section withImage:clickedImageView];
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
        // collect index path of section row
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        // collapse section rows
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
        // collect index path of expanding section rows
        NSMutableArray *arrayOfIndexPaths = [NSMutableArray array];
        for (int i=0; i< sectionData.count; i++) {
            NSIndexPath *index = [NSIndexPath indexPathForRow:i inSection:section];
            [arrayOfIndexPaths addObject:index];
        }
        // expand section rows
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
