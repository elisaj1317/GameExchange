//
//  GenreViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/2/21.
//

#import "GenreViewController.h"

#import "APIManager.h"
#import "GenreCell.h"

@interface GenreViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *genres;


@end

@implementation GenreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self fetchGenres];
}

- (void)fetchGenres {
    self.genres = [[NSMutableArray alloc] init];
    [[APIManager shared] getGenresWithCompletion:^(NSArray *data, NSError *error) {
            if (!error) {
                for (NSDictionary *platform in data) {
                    [self.genres addObject:platform[@"name"]];
                }
                [self.genres sortUsingSelector:@selector(compare:)];
                
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    cell.name = self.genres[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.genres.count;
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
