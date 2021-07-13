//
//  CreateViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "ComposeViewController.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *itemImage;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *locationField;
@property (weak, nonatomic) IBOutlet UITextField *itemNameField;

@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)didTapImage:(id)sender {
    [self chooseSourceType];
}

- (IBAction)didTapPost:(id)sender {
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
