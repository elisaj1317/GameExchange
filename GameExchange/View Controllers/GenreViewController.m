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
    [[APIManager shared] getGenresWithCompletion:^(NSArray *data, NSError *error) {
            if (!error) {
                self.genres = [NSMutableArray arrayWithArray:data];
                
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GenreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GenreCell"];
    NSDictionary *currentGenre = self.genres[indexPath.row];
    cell.name = currentGenre[@"name"];
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
