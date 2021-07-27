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
#import "AutocompleteView.h"
#import "Functions.h"
#import "Game.h"

#import "APIManager.h"

#import <DCAnimationKit/UIView+DCAnimationKit.h>

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
// MARK: Table Header Properties
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *locationField;
@property (weak, nonatomic) IBOutlet AutocompleteView *nameView;
@property (weak, nonatomic) IBOutlet AutocompleteView *platformView;
@property (weak, nonatomic) IBOutlet AutocompleteView *genreView;

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
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        NSMutableDictionary *requestValues = [NSMutableDictionary dictionary];
        [requestValues setValue:self.nameView.textField.text forKey:@"itemName"];
        [requestValues setValue:self.platformView.textField.text forKey:@"platform"];
        [requestValues setValue:self.genreView.textField.text forKey:@"genre"];
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

- (void)setUpTableView {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    self.numberOfRows = @(1);
    [self.tableView reloadData];
}

- (void)setupTextFields {
    self.nameView.textField.label.text = @"Name";
    self.nameView.game = YES;
    
    self.platformView.textField.label.text = @"Platform";
    self.platformView.platform = YES;
    
    self.genreView.textField.label.text = @"Genre";
    self.genreView.genre = YES;
    
    
    self.locationField.label.text = @"Location";
    self.locationField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.locationField];
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
    if ([self.genreView.textField.text isEqual:@""]) {
        [self.genreView shake:NULL];
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

- (void)resetHeader {
    [self.nameView resetAutocomplete];
    [self.platformView resetAutocomplete];
    [self.genreView resetAutocomplete];
    
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
    [self.genreView hideAutocomplete];
    
    [self.locationField resignFirstResponder];
    for (int i = 0; i< [self.numberOfRows intValue]; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            ComposeOfferCell *cell = [self.tableView cellForRowAtIndexPath:indexPath]; // change with your cell's class
            [cell.itemNameField resignFirstResponder];
        }
}

- (void)didChooseGame:(NSNotification *)notification {
    Game *gameChosen = (Game *)notification.userInfo;
    self.platformView.startData = (NSMutableArray *)gameChosen.platforms;
    self.genreView.startData = (NSMutableArray *)gameChosen.genres;
    
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
