//
//  FilterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import "FilterViewController.h"

#import <Parse/Parse.h>
#import <MaterialComponents/MaterialActivityIndicator.h>

#import "Request.h"
#import "Functions.h"

@interface FilterViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *collapsedSectionHeaderNumbers;

@property (strong) NSMutableArray *sectionItems;
@property (strong) NSArray *sectionNames;

@end

@implementation FilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.collapsedSectionHeaderNumbers = [NSMutableArray array];
    
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
    MDCActivityIndicator *activityIndicator = [Functions startActivityIndicatorAtPosition:CGPointMake(self.view.bounds.size.width / 2, self.view.bounds.size.height / 2)];
    [self.view addSubview:activityIndicator];
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
            self.sectionNames = @[ @"Platform", @"Genre"];
            NSArray *sortedPlatformNames = [[platformNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
            NSArray *sortedGenreNames = [[genreNames allObjects] sortedArrayUsingSelector:@selector(compare:)];
            
            [self.sectionItems addObject:sortedPlatformNames];
            [self.sectionItems addObject:sortedGenreNames];
            
            [activityIndicator stopAnimating];
            [self.tableView reloadData];
            
            
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
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (![self.collapsedSectionHeaderNumbers containsObject:[NSNumber numberWithInteger:section]]) {
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
    
    [self addArrowToHeader:header forSection:section];
    
    // make headers touchable
    header.tag = section;
    UITapGestureRecognizer *headerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapSectionHeader:)];
    [header addGestureRecognizer:headerTapGesture];
}

- (void)addArrowToHeader:(UITableViewHeaderFooterView *)header forSection:(NSInteger)section {
    CGSize headerFrame = self.view.frame.size;
    UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headerFrame.width - 32, header.frame.size.height/2.0 - 9, 18, 18)];
    arrowImageView.image = [UIImage imageNamed:@"down_arrow"];
    arrowImageView.tag = section + self.sectionNames.count;
    [header addSubview:arrowImageView];
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

- (void)didTapSectionHeader:(UITapGestureRecognizer *)sender {
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)sender.view;
    NSInteger sectionInteger = headerView.tag;
    NSNumber *sectionNumber = [NSNumber numberWithInteger:headerView.tag];
    UIImageView *clickedImageView = (UIImageView *)[headerView viewWithTag:sectionInteger + self.sectionNames.count];
    
    if ([self.collapsedSectionHeaderNumbers containsObject:sectionNumber]) {
        [self.collapsedSectionHeaderNumbers removeObject:sectionNumber];
        [self tableViewExpandSection:sectionInteger withImage:clickedImageView];
        
    } else {
        [self.collapsedSectionHeaderNumbers addObject:sectionNumber];
        [self tableViewCollapseSection:sectionInteger withImage:clickedImageView];
    }
}

- (void)tableViewCollapseSection:(NSInteger)section withImage:(UIImageView *)imageView {
    NSArray *sectionData = [self.sectionItems objectAtIndex:section];
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
