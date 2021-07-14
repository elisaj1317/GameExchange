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

@interface ComposeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) NSNumber *numberOfRows;


@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.itemImage.image = [UIImage imageNamed:@"placeholder"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = self.headerView;
    self.tableView.tableFooterView = self.footerView;
    
    self.numberOfRows = @(1);
    
    [self.tableView reloadData];
}

- (IBAction)didTapImage:(id)sender {
    [self chooseSourceType];
}

- (IBAction)didTapPost:(id)sender {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.numberOfRows intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ComposeOfferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComposeOfferCell"];
    
    return cell;
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
