//
//  CreateViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "ComposeViewController.h"
#import "SceneDelegate.h"
#import "Request.h"
#import "ComposeOfferCell.h"
#import "AutocompleteCell.h"

#import "APIManager.h"

#import "MKDropdownMenu.h"

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKDropdownMenuDelegate, MKDropdownMenuDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSNumber *numberOfRows;


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *autocompleteTableView;

@property (strong, nonatomic) NSTimer * searchTimer;
@property (strong, nonatomic) NSMutableArray *autocompleteArray;

@property (weak, nonatomic) IBOutlet MKDropdownMenu *dropdownMenuView;



@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemImage.image = [UIImage imageNamed:@"placeholder"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.autocompleteTableView.delegate = self;
    self.autocompleteTableView.dataSource = self;
    
    self.nameField.delegate = self;
    
    self.dropdownMenuView.dataSource = self;
    self.dropdownMenuView.delegate = self;
    
    self.numberOfRows = @(1);
    
    [self.tableView reloadData];
}

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
        [Request postRequestImage:self.itemImage.image withName:self.nameField.text withLocation:self.locationField.text withRequests:itemsRequested withCompletion:^(BOOL succeeded, NSError * _Nullable error) {
            if (!error) {
                [self segueToHome];
            }
            else {
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


- (IBAction)didTapAddRow:(id)sender {   
    NSInteger oldRowValue = [self.numberOfRows intValue];
    if (oldRowValue == 5) {
        [self showErrorWithMessage:@"A maximum of 5 offers can be made"];
    } else {
        self.numberOfRows = @(oldRowValue + 1);
        
        [self.tableView reloadData];
    }
}

- (IBAction)didTapRemoveRow:(id)sender {
    NSInteger oldRowValue = [self.numberOfRows intValue];
    if (oldRowValue == 1) {
        [self showErrorWithMessage:@"At least one offer is required"];
    } else {
        self.numberOfRows = @(oldRowValue - 1);
        
        [self.tableView reloadData];
    }
}

- (IBAction)didChange:(id)sender {
    // if a timer is already active, prevent it from firing
    if (self.searchTimer != nil) {
        [self.searchTimer invalidate];
        self.searchTimer = nil;
    }

    // reschedule the search: in 1.0 second
    self.searchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(fetchAutocomplete:) userInfo:self.nameField.text repeats:NO];
}


- (void)fetchAutocomplete:(NSTimer *)timer {
    NSString *wordToSearch = (NSString *)timer.userInfo;
    if ([wordToSearch isEqual:@""]) {
        [self.autocompleteTableView setHidden:YES];
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
                [self.autocompleteTableView setHidden:NO];
                [self.autocompleteTableView reloadData];
            } else {
                NSLog(@"Error: %@", error.localizedDescription);
            }
    }];
    
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
    if ([self.nameField.text isEqual:@""]) {
        [self showErrorWithMessage:@"Enter name of item to exchange"];
        return NO;
    }
    else if ([self.locationField.text isEqual:@""]) {
        [self showErrorWithMessage:@"Enter a location"];
        return NO;
    }
    else if (itemsRequested.count == 0) {
        [self showErrorWithMessage:@"Enter name of item request"];
        return NO;
    }
    else if ([self.itemImage.image isEqual:[UIImage imageNamed:@"placeholder"]]) {
        [self showErrorWithMessage:@"Upload an image"];
        return NO;
    }
    return YES;
}

- (void)resetHeader {
    self.nameField.text = @"";
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

- (void)showErrorWithMessage:(NSString *)message{
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:okAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)segueToHome {
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    sceneDelegate.window.rootViewController = tabBarController;
}

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
    [self.nameField resignFirstResponder];
    [self.locationField resignFirstResponder];
    for (int i = 0; i< [self.numberOfRows intValue]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ComposeOfferCell *cell = [self.tableView cellForRowAtIndexPath:indexPath]; // change with your cell's class
            [cell.itemNameField resignFirstResponder];
        }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.autocompleteTableView) {
        return self.autocompleteArray.count;
    }
    return [self.numberOfRows intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.autocompleteTableView) {
        AutocompleteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AutocompleteCell"];
        
        cell.gameName = self.autocompleteArray[indexPath.row];
        return cell;
    }
    
    ComposeOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComposeOfferCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.autocompleteTableView) {
        self.nameField.text = self.autocompleteArray[indexPath.row];
        self.autocompleteArray = [[NSMutableArray alloc] init];
        [self.autocompleteTableView setHidden:YES];
        [self.autocompleteTableView reloadData];
    }
    
}

- (NSInteger)numberOfComponentsInDropdownMenu:(MKDropdownMenu *)dropdownMenu {
    return 1;
}

- (NSInteger)dropdownMenu:(MKDropdownMenu *)dropdownMenu numberOfRowsInComponent:(NSInteger)component {
    return 3;
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForComponent:(NSInteger)component {
    return @"Component Title";
}

- (NSString *)dropdownMenu:(MKDropdownMenu *)dropdownMenu titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"Row Title";
}

- (void)dropdownMenu:(MKDropdownMenu *)dropdownMenu didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //TODO: selected row is now component title
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
