//
//  RegisterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "RegisterViewController.h"

#import <Parse/Parse.h>
#import "MaterialTextControls+FilledTextFields.h"
#import "MaterialActivityIndicator.h"

#import "Functions.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet MDCFilledTextField *nameField;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *usernameField;
@property (weak, nonatomic) IBOutlet MDCFilledTextField *passwordField;


@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTextFields];
}


- (IBAction)didTapRegister:(id)sender {
    [self dismissKeyboards];
    
    PFUser *newUser = [self initializeUser];
    if ([self checkValidName]) {
        
        MDCActivityIndicator *activityIndicator = [Functions startActivityIndicatorAtPosition:CGPointMake(self.view.bounds.size.width / 2, 4*self.view.bounds.size.height / 6)];
        [self.view addSubview:activityIndicator];
        
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            [activityIndicator stopAnimating];
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                UIAlertController *errorAlert =  [Functions createErrorWithMessage:error.localizedDescription];
                [self presentViewController:errorAlert animated:YES completion:nil];
            } else {
                
                [self performSegueWithIdentifier:@"registerSegue" sender:nil];
            }
        }];
    }
}

- (IBAction)didTapScreen:(id)sender {
    [self dismissKeyboards];
}

- (void)setUpTextFields {
    [self setupNameField];
    [self setupUsernameField];
    [self setupPasswordField];
}

- (void)setupNameField {
    self.nameField.label.text = @"Full Name";
    self.nameField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.nameField];
}

- (void)setupUsernameField {
    self.usernameField.label.text = @"Username";
    self.usernameField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.usernameField];
}

- (void)setupPasswordField{
    self.passwordField.label.text = @"Password";
    self.passwordField.placeholder = @"Input text";
    [Functions setUpWithBlueMDCTextField:self.passwordField];
}

- (void)dismissKeyboards {
    [self.nameField resignFirstResponder];
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

- (bool)checkValidName {
    if ([self.nameField.text isEqual:@""]) {
        UIAlertController *errorAlert =  [Functions createErrorWithMessage:@"Name is required"];
        [self presentViewController:errorAlert animated:YES completion:nil];
        return NO;
    }
    return YES;
}

- (PFUser *) initializeUser {
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser setObject:self.nameField.text forKey:@"fullName"];
    
    return newUser;
    
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
