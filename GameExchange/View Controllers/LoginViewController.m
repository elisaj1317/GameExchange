//
//  LoginViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "MaterialTextControls+FilledTextFields.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet MDCFilledTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *passwordField;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTextFields];
}

- (IBAction)didTapLogin:(id)sender {
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
        
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        if (error != nil) {
            [self showLoginAlertWithError:error];
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (void)showLoginAlertWithError:(NSError *)error {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:okAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (void)setupTextFields {
    UIColor *royalBlue = [UIColor colorNamed:@"royalBlue"];
    
    // set up username text field
    self.usernameField.label.text = @"Username";
    self.usernameField.placeholder = @"Input text";
    
    self.usernameField.tintColor = royalBlue;
    [self.usernameField setFloatingLabelColor:royalBlue forState:MDCTextControlStateEditing];
    [self.usernameField setUnderlineColor:royalBlue forState:MDCTextControlStateEditing];
    
    
    
    // set up password text field
    self.passwordField.label.text = @"Password";
    self.passwordField.placeholder = @"Input text";
    
    self.passwordField.tintColor = royalBlue;
    [self.passwordField setFloatingLabelColor:royalBlue forState:MDCTextControlStateEditing];
    [self. passwordField setUnderlineColor:royalBlue forState:MDCTextControlStateEditing];
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
