//
//  RegisterViewController.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)didTapRegister:(id)sender {
    PFUser *newUser = [self initializeUser];
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        } else {
            NSLog(@"User registered successfully");
            
            [self performSegueWithIdentifier:@"registerSegue" sender:nil];
        }
    }];
}

- (PFUser *) initializeUser {
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.password = self.passwordField.text;
    [newUser setObject:self.nameField.text forKey:@"firstName"];
    [newUser setObject:self.lastNameField.text forKey:@"lastName"];
    
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
