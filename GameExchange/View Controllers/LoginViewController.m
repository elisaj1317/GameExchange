//
//  LoginViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "LoginViewController.h"

#import <Parse/Parse.h>
#import "MaterialTextControls+FilledTextFields.h"
#import "MaterialActivityIndicator.h"

#import "Functions.h"

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
    [self dismissKeyboards];
    
    NSString *username = self.usernameField.text;
    NSString *password = self.passwordField.text;
    
    // start load state
    MDCActivityIndicator *activityIndicator = [Functions startActivityIndicatorAtPosition:CGPointMake(self.view.bounds.size.width / 2, 3*self.view.bounds.size.height / 5)];
    [self.view addSubview:activityIndicator];
        
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser * user, NSError *  error) {
        [activityIndicator stopAnimating];
        if (error != nil) {
            UIAlertController *errorAlert =  [Functions createErrorWithMessage:error.localizedDescription];
            [self presentViewController:errorAlert animated:YES completion:nil];
            NSLog(@"User log in failed: %@", error.localizedDescription);
        } else {
            NSLog(@"User logged in successfully");
            [self performSegueWithIdentifier:@"loginSegue" sender:nil];
        }
    }];
}

- (IBAction)didTapScreen:(id)sender {
    [self dismissKeyboards];
}

- (void)setupTextFields {
    [self setupUsernameField];
    [self setupPasswordField];
}

- (void)setupUsernameField {
    self.usernameField.label.text = @"Username";
    self.usernameField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.usernameField];
}

- (void)setupPasswordField {
    self.passwordField.label.text = @"Password";
    self.passwordField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.passwordField];
}

- (void)dismissKeyboards {
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
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
