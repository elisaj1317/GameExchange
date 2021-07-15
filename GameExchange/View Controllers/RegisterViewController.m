//
//  RegisterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "MaterialTextControls+FilledTextFields.h"

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
    PFUser *newUser = [self initializeUser];
    if ([self checkValidName]) {
        // call sign up function on the object
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (error != nil) {
                NSLog(@"Error: %@", error.localizedDescription);
                [self showRegisterAlertWithMessage:error.localizedDescription];
            } else {
                NSLog(@"User registered successfully");
                
                [self performSegueWithIdentifier:@"registerSegue" sender:nil];
            }
        }];
    }
}

- (void)setUpTextFields {
    UIColor *royalBlue = [UIColor colorNamed:@"royalBlue"];
    [self setupNameFieldWithColor:royalBlue];
    [self setupUsernameFieldWithColor:royalBlue];
    [self setupPasswordFieldWithColor:royalBlue];
}

- (void)setupNameFieldWithColor:(UIColor *)color {
    self.nameField.label.text = @"Full Name";
    self.nameField.placeholder = @"Input text";
    
    self.nameField.tintColor = color;
    [self.nameField setFloatingLabelColor:color forState:MDCTextControlStateEditing];
    [self.nameField setUnderlineColor:color forState:MDCTextControlStateEditing];
}

- (void)setupUsernameFieldWithColor:(UIColor *)color {
    self.usernameField.label.text = @"Username";
    self.usernameField.placeholder = @"Input text";
    
    self.usernameField.tintColor = color;
    [self.usernameField setFloatingLabelColor:color forState:MDCTextControlStateEditing];
    [self.usernameField setUnderlineColor:color forState:MDCTextControlStateEditing];
}

- (void)setupPasswordFieldWithColor:(UIColor *)color {
    self.passwordField.label.text = @"Password";
    self.passwordField.placeholder = @"Input text";
    
    self.passwordField.tintColor = color;
    [self.passwordField setFloatingLabelColor:color forState:MDCTextControlStateEditing];
    [self. passwordField setUnderlineColor:color forState:MDCTextControlStateEditing];
}

- (void)showRegisterAlertWithMessage:(NSString *)message {
    UIAlertController *errorAlert = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [errorAlert addAction:okAction];
    [self presentViewController:errorAlert animated:YES completion:nil];
}

- (bool)checkValidName {
    if ([self.nameField.text isEqual:@""]) {
        [self showRegisterAlertWithMessage:@"Name is required"];
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
