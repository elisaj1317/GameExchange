//
//  CreateViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "ComposeViewController.h"

#import "GenreViewController.h"

#import "ComposeOfferCell.h"
#import "AutocompleteView.h"

#import "Functions.h"
#import "Game.h"

#import "SceneDelegate.h"
#import "APIManager.h"

#import <DCAnimationKit/UIView+DCAnimationKit.h>
#import <Parse/PFImageView.h>

@interface ComposeViewController () <AutocompleteViewDelegate, GenreViewControllerDelegate,UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
// MARK: Table Header Properties
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *locationField;
@property (weak, nonatomic) IBOutlet AutocompleteView *nameView;
@property (weak, nonatomic) IBOutlet AutocompleteView *platformView;
@property (weak, nonatomic) IBOutlet UIView *genreView;
@property (weak, nonatomic) IBOutlet UILabel *genreLabel;
@property (strong, nonatomic) NSArray *selectedGenres;

// MARK: Table Footer Properties
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSNumber *numberOfRows;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
            selector:@selector(didChooseGame:)
            name:@"gameChosen"
            object:nil];

    self.itemImage.image = [UIImage imageNamed:@"placeholder"];
    [self setUpTableView];
    [self setupTextFields];
    
    if (self.editRequest != nil) {
        [self setUpViewEdit];
    }
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//MARK: Actions
- (IBAction)didTapImage:(id)sender {
    [self chooseSourceType];
}

- (IBAction)didTapScreen:(id)sender {
    [self dismissKeyboards];
}

- (IBAction)didTapPost:(id)sender {
    [self dismissKeyboards];
    
    NSArray *itemsRequested = [self createRequestedArray];
    
    if([self checkValidPostWithArray:itemsRequested]) {
        NSMutableDictionary *requestValues = [NSMutableDictionary dictionary];
        [requestValues setValue:self.nameView.textField.text forKey:@"itemName"];
        [requestValues setValue:self.platformView.textField.text forKey:@"platform"];
        [requestValues setValue:self.selectedGenres forKey:@"genre"];
        [requestValues setValue:self.locationField.text forKey:@"location"];
        [requestValues setValue:itemsRequested forKey:@"itemRequest"];
        
        [Request postRequestImage:self.itemImage.image withValues:requestValues withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
                    if (!error) {
                        [self segueToHome];
                    } else {
                        NSLog(@"Error: %@", error.localizedDescription);
                    }
        }];
        
    }
}

- (IBAction)didTapReset:(id)sender {
    [self dismissKeyboards];
    [self resetHeader];
    [self resetOfferTextBoxes];
}

- (IBAction)didTapGenre:(id)sender {
    
    [self performSegueWithIdentifier:@"genreSegue" sender:nil];
}

- (IBAction)didTapAddRow:(id)sender {   
    NSInteger oldRowValue = [self.numberOfRows intValue];
    if (oldRowValue == 5) {
        UIAlertController *errorAlert =  [Functions createErrorWithMessage:@"A maximum of 5 offers can be made"];
        [self presentViewController:errorAlert animated:YES completion:nil];
    } else {
        self.numberOfRows = @(oldRowValue + 1);
        
        [self.tableView reloadData];
    }
}

- (IBAction)didTapRemoveRow:(id)sender {
    NSInteger oldRowValue = [self.numberOfRows intValue];
    if (oldRowValue == 1) {
        UIAlertController *errorAlert =  [Functions createErrorWithMessage:@"At least one offer is required"];
        [self presentViewController:errorAlert animated:YES completion:nil];
    } else {
        self.numberOfRows = @(oldRowValue - 1);
        
        [self.tableView reloadData];
    }
}

//MARK: Set Up Functions
- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.numberOfRows = @(1);
    [self.tableView reloadData];
}

- (void)setupTextFields {
    self.nameView.delegate = self;
    self.nameView.textField.label.text = @"Name";
    
    self.platformView.delegate = self;
    self.platformView.textField.label.text = @"Platform";
    
    self.locationField.label.text = @"Location";
    self.locationField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.locationField];
    
    self.genreView.layer.borderWidth = 1;
    self.genreView.layer.borderColor = [[UIColor blackColor] CGColor];
    if (self.selectedGenres == nil) {
        self.selectedGenres = [NSArray array];
    }
}

- (void)setUpViewEdit {
    self.itemImage.file = self.editRequest.image;
    [self.itemImage loadInBackground];
    
    [self setUpEditTextFields];
    
    self.selectedGenres = self.editRequest.genre;
    [self setUpGenreByArray];
    
    [self setUpEditRequests];
}

- (void)setUpEditTextFields {
    self.nameView.textField.text = self.editRequest.itemSelling;
    self.platformView.textField.text = self.editRequest.platform;
    self.locationField.label.text = self.editRequest.location;
}

- (void)setUpGenreByArray {
    NSMutableString *genreString = [Functions stringWithArray:self.selectedGenres];
    [genreString insertString:@"Genres: " atIndex:0];
    self.genreLabel.text = genreString;
}

- (void)setUpEditRequests {
    self.numberOfRows = [NSNumber numberWithInteger:self.editRequest.itemRequest.count];
    [self.tableView reloadData];
    
    
    NSArray *cells = [self.tableView visibleCells];
    
    for (int index = 0; index < self.editRequest.itemRequest.count; index++) {
        ComposeOfferCell *currentCell = cells[index];
        currentCell.itemNameField.text = self.editRequest.itemRequest[index];
    }
}


- (NSArray *)createRequestedArray {
    NSMutableArray *itemsRequested = [[NSMutableArray alloc]init];
    NSArray *cells = [self.tableView visibleCells];
    
    for (ComposeOfferCell *cell in cells) {
        if (![cell.itemNameField.text isEqual:@""]) {
            [itemsRequested addObject:cell.itemNameField.text];
        }
    }
    
    return [NSArray arrayWithArray:itemsRequested];
    
}

- (bool)checkValidPostWithArray:(NSArray *)itemsRequested {
    bool valid = YES;
    if ([self.nameView.textField.text isEqual:@""]) {
        [self.nameView shake:NULL];
        valid = NO;
    }
    if ([self.platformView.textField.text isEqual:@""]) {
        [self.platformView shake:NULL];
        valid = NO;
    }
    if ([self.locationField.text isEqual:@""]) {
        [self.locationField shake:NULL];
        valid = NO;
    }
    if (itemsRequested.count == 0) {
        UIAlertController *errorAlert =  [Functions createErrorWithMessage:@"Enter name of item request"];
        [self presentViewController:errorAlert animated:YES completion:nil];
        valid = NO;
    }
    if ([self.itemImage.image isEqual:[UIImage imageNamed:@"placeholder"]]) {
        [self.itemImage shake:NULL];
        valid = NO;
    }
    return valid;
}

//MARK: Reset Functions
- (void)resetHeader {
    [self.nameView resetAutocomplete];
    [self.platformView resetAutocomplete];
    self.selectedGenres = [NSArray array];
    self.genreLabel.text = @"Genres: None";
    
    self.locationField.text = @"";
    self.itemImage.image = [UIImage imageNamed:@"placeholder"];
}

- (void)resetOfferTextBoxes {
    self.numberOfRows = @(5);
    [self.tableView reloadData];
    for (int i = 0; i< [self.numberOfRows intValue]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ComposeOfferCell *cell = [self.tableView cellForRowAtIndexPath:indexPath]; // change with your cell's class
            cell.itemNameField.text = @"";
        }
    self.numberOfRows = @(1);
    [self.tableView reloadData];
}


- (void)segueToHome {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    sceneDelegate.window.rootViewController = tabBarController;
}

//MARK: Image picker Functions
- (void)chooseSourceType {
    // Create action sheet
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    // Create camera action
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickerCamera:YES];
    }];
    [actionSheet addAction:cameraAction];
    
    // Create photo album action
    UIAlertAction *cameraRollAction = [UIAlertAction actionWithTitle:@"Photo Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self imagePickerCamera:NO];
    }];
    [actionSheet addAction:cameraRollAction];
    
    // Create cancel action
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [actionSheet addAction:cancelAction];
    
    
    // Display alert
    [self presentViewController:actionSheet animated:YES completion:nil];
    
}

- (void)imagePickerCamera: (BOOL)chooseCamera {
    UIImagePickerController *imagePickerVC = [self setUpImagePicker];
    
    // check if camera chosen and camera able
    if (chooseCamera & [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if (chooseCamera) {
            [self showCameraErrorWithPicker:imagePickerVC];
        }
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
    
}

- (UIImagePickerController *)setUpImagePicker {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    return imagePickerVC;
}

- (void)showCameraErrorWithPicker:(UIImagePickerController *)imagePicker {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Camera is not available on this device. Photo Album will be shown." preferredStyle:UIAlertControllerStyleAlert];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    // add the OK action to the alert controller
    [alert addAction:okAction];
    
    // display alert
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    // display image in image view
    UIImage *editedImage = info[UIImagePickerControllerEditedImage];
    self.itemImage.image = editedImage;
    
    // Dismiss UIImagePickerController to go back to your original view controller
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissKeyboards {
    [self.nameView hideAutocomplete];
    [self.platformView hideAutocomplete];
    
    [self.locationField resignFirstResponder];
    for (int i = 0; i< [self.numberOfRows intValue]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ComposeOfferCell *cell = [self.tableView cellForRowAtIndexPath:indexPath]; // change with your cell's class
            [cell.itemNameField resignFirstResponder];
        }
}

- (void)didSelectGenres:(NSArray *)genres {
    self.selectedGenres = genres;
    
    [self setUpGenreByArray];
}

- (NSMutableString *)stringWithArray:(NSArray *)array {
    NSMutableString *string = [NSMutableString string];
    
    if (array.count == 0) {
        [string appendString:@"None"];
    } else {
        for (NSString *item in array) {
            [string appendString:[NSString stringWithFormat:@", %@", item]];
        }
        [string deleteCharactersInRange:NSMakeRange(0, 2)];
    }
    
    return string;
}

- (void)didChooseGame:(NSNotification *)notification {
    Game *gameChosen = (Game *)notification.userInfo;
    self.platformView.startData = (NSMutableArray *)gameChosen.platforms;
    self.selectedGenres = gameChosen.genres;
    
    [self setUpGenreByArray];
    
}

- (void)fetchDataWithInView:(UIView *)view withWord:(NSString *)wordToSearch {
    if (view == self.nameView) {
        [[APIManager shared] getGameAutocompleteWithWord:wordToSearch completion:^(NSArray *data, NSError *error) {
                if (!error) {
                    self.nameView.autocompleteArray = [Game gamesWithArray:data];
                    [self.nameView showTableView];
                } else {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
        }];
    } else if (view == self.platformView) {
        [[APIManager shared] getPlatformAutocompleteWithWord:wordToSearch completion:^(NSArray *data, NSError *error) {
                if (!error) {
                    self.platformView.autocompleteArray = [Game gamesWithArray:data];
                    [self.platformView showTableView];
                } else {
                    NSLog(@"Error: %@", error.localizedDescription);
                }
        }];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numberOfRows intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComposeOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComposeOfferCell"];
    cell.itemNameField.label.text = @"Item Name";
    cell.itemNameField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:cell.itemNameField];
    
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



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqual:@"genreSegue"]) {
        UINavigationController *navigationController = [segue destinationViewController];
        GenreViewController *genreController = (GenreViewController*)navigationController.topViewController;
        genreController.delegate = self;
        genreController.selectedGenres = [NSMutableArray arrayWithArray:self.selectedGenres];
    }
}


@end
