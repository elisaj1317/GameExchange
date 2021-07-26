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

@property (strong, nonatomic) NSMutableArray *selectedRows;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.expandedSectionHeaderNumber = -1;
    
    self.selectedRows = [[NSMutableArray alloc] init];
    
    [self fetchSectionItems];

}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


- (IBAction)didTapApply:(id)sender {
    NSArray *filtersApplied = [self getFiltersApplied];
    [self.delegate didFilter:filtersApplied];
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
            }
            NSArray *sortedPlatformNames = [[platformNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
            [self.sectionItems addObject:sortedPlatformNames];
            [self.sectionItems addObject:genreNames];
            
        } else {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

- (NSDictionary *)getFiltersApplied {
    NSMutableArray *platformFiltersApplied = [[NSMutableArray alloc] init];
    
    // add all filters applied to proper array
    for (NSIndexPath *selectedPath in self.selectedRows) {
        
        NSString *selectedItem = self.sectionItems[selectedPath.section][selectedPath.row];
        if (selectedPath.section == 0) {
            [platformFiltersApplied addObject:selectedItem];
        }
    }
    NSMutableDictionary *filtersApplied = [[NSMutableDictionary alloc] init];
    [filtersApplied setValue:platformFiltersApplied forKey:@"platform"];
    
    return filtersApplied;
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
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = [section objectAtIndex:indexPath.row];
    
    if ([self.selectedRows containsObject:indexPath]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.selectedRows containsObject:indexPath]) {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedRows removeObject:indexPath];
        
    } else {
        [self.tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedRows addObject:indexPath];
    }
    
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
