//
//  AutocompleteView.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import "AutocompleteView.h"
#import "Functions.h"
#import "Game.h"

@interface AutocompleteView () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSTimer * searchTimer;
@property (strong, nonatomic) UIFont *regularFont;

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
    
    self.regularFont = [UIFont fontWithName:@"Montserrat-Regular" size:15];

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setHidden:YES];
    [self addShadow];
    
    self.textField.delegate = self;
    self.textField.placeholder = @"Input text";
    [self.textField setFont:self.regularFont];
    [Functions setUpWithBlueMDCTextField:self.textField];
    
    self.autocompleteArray = [[NSMutableArray alloc] init];
    
}

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.contentView.subviews) {
        if (!view.hidden && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

- (void)setStartData:(NSMutableArray *)startData {
    _startData = startData;
    self.autocompleteArray = startData;
    if (startData.count == 1) {
        self.textField.text = startData[0];
    }
}

- (IBAction)didChangeEditing:(id)sender {
    // if a timer is already active, prevent it from firing
    if (self.searchTimer != nil) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }
    
    // if textfield empty immediatly hide autocomplete results
    if ([self.textField.text isEqual:@""] && self.startData == nil) {
        [self.tableView setHidden:YES];
        return;
    } else if ([self.textField.text isEqual:@""]) {
        self.autocompleteArray = self.startData;
        [self.tableView setHidden:NO];
        return;
    }

    // reschedule the search: in 1.0 second
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAutocomplete:) userInfo:self.textField.text repeats:NO];
}

- (IBAction)didBeginEditing:(id)sender {
    [self.tableView setHidden:NO];
    [self.tableView reloadData];
}


- (void)fetchAutocomplete:(NSTimer *)timer {
    NSString *wordToSearch = (NSString *)timer.userInfo;
    
    NSLog(@"search for: %@", wordToSearch);
    
    if (self.startData != nil) {
        [self limitDataWithStartDataWithWord:wordToSearch];
    } else {
        [self.delegate fetchDataWithInView:self withWord:wordToSearch];
    }
}

- (void)limitDataWithStartDataWithWord:(NSString *)wordToSearch {
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(id  _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
        return [evaluatedObject containsString:wordToSearch];
    }];
    
    self.autocompleteArray = (NSMutableArray *)[self.startData filteredArrayUsingPredicate:predicate];
    [self.tableView reloadData];
}

- (void)hideAutocomplete {
    [self.textField resignFirstResponder];
    [self.tableView setHidden:YES];
}

- (void)resetAutocomplete {
    [self hideAutocomplete];
    self.textField.text = @"";
}

- (void)showTableView {
    [self.tableView reloadData];
    [self.tableView setHidden:NO];
}

- (void)addShadow {
    self.tableView.clipsToBounds = NO;
    self.tableView.layer.masksToBounds = NO;
    self.tableView.layer.shadowOffset = CGSizeMake(0, 0);
    self.tableView.layer.shadowRadius = 1.0;
    self.tableView.layer.shadowOpacity = 0.7;

}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSMutableAttributedString *cellContent;
    
    if (self.startData == nil) {
        Game *currentGame = self.autocompleteArray[indexPath.row];
        cellContent = [[NSMutableAttributedString alloc] initWithString:currentGame.name];
    } else {
        NSString *currentItem = self.autocompleteArray[indexPath.row];
        cellContent = [[NSMutableAttributedString alloc] initWithString:currentItem];
    }
    
    [cellContent addAttribute:NSFontAttributeName value:self.regularFont range:NSMakeRange(0,cellContent.length)];
    cell.textLabel.attributedText = cellContent;
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.autocompleteArray.count == 0) {
        [self.tableView setHidden:YES];
    }
    return self.autocompleteArray.count;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.startData == nil) {
        Game *currentGame = self.autocompleteArray[indexPath.row];
        self.textField.text = currentGame.name;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"gameChosen" object:self userInfo:(NSDictionary *)currentGame];
    } else {
        self.textField.text = self.autocompleteArray[indexPath.row];
    }
    
    [self.tableView setHidden:YES];
    [self.textField resignFirstResponder];
}




@end
