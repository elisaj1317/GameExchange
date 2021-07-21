//
//  AutocompleteView.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import "AutocompleteView.h"
#import "APIManager.h"

@interface AutocompleteView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSTimer * searchTimer;
@property (strong, nonatomic) NSMutableArray *autocompleteArray;


@end

@implementation AutocompleteView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

-(void)initSubviews {
    [[NSBundle mainBundle] loadNibNamed:@"AutocompleteView" owner:self options:nil];
    [self addSubview:self.contentView];
    self.contentView.frame = self.bounds;

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setHidden:YES];
    
    self.textField.delegate = self;
    
    self.autocompleteArray = [[NSMutableArray alloc] init];
    
}

- (void)setAutocompleteArray:(NSMutableArray *)autocompleteArray {
    _autocompleteArray = autocompleteArray;
    
    [self.tableView reloadData];
}

- (IBAction)didChangeEditing:(id)sender {
    
    if ([self.textField.text isEqual:@""]) {
        [self.tableView setHidden:YES];
        return;
    }
    
    // if a timer is already active, prevent it from firing
    if (self.searchTimer != nil) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }

    // reschedule the search: in 1.0 second
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAutocomplete:) userInfo:self.textField.text repeats:NO];
}

- (void)fetchAutocomplete:(NSTimer *)timer {
    NSString *wordToSearch = (NSString *)timer.userInfo;
    if ([wordToSearch isEqual:@""]) {
        [self.tableView setHidden:YES];
        return;
    }
    
    
    NSLog(@"search for: %@", wordToSearch);
    
    [[APIManager shared] getAutocompleteWithWord:wordToSearch completion:^(NSArray *data, NSError *error) {
            if (!error) {
                self.autocompleteArray = [[NSMutableArray alloc] init];
                for (NSDictionary *game in data) {
                    NSLog(@"game: %@", game);
                    [self.autocompleteArray addObject:game[@"name"]];
                }
                [self.tableView setHidden:NO];
                [self.tableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
    
}

- (void)hideAutocomplete {
    [self.textField resignFirstResponder];
    [self.tableView setHidden:YES];
}

- (void)resetAutocomplete {
    [self hideAutocomplete];
    self.textField.text = @"";
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.autocompleteArray[indexPath.row]];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autocompleteArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.textField.text = [NSString stringWithFormat:@"%@", self.autocompleteArray[indexPath.row]];
    [self.tableView reloadData];
    [self.tableView setHidden:YES];
    [self.textField resignFirstResponder];
}




@end
