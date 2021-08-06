//
//  ViewOfferCell.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/6/21.
//

#import "ViewOfferCell.h"

#import "SceneDelegate.h"

#import <Parse/Parse.h>

@implementation ViewOfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCurrentOffer:(NSDictionary *)currentOffer {
    _currentOffer = currentOffer;
    
    self.offerLabel.text = currentOffer[@"name"];
    PFUser *offerUser = currentOffer[@"user"];
    [offerUser fetchIfNeededInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
            self.usernameLabel.text = offerUser.username;
    }];
}

- (IBAction)didTapAccept:(id)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"offerAccepted" object:self userInfo:nil];
    
    SceneDelegate *sceneDelegate = (SceneDelegate *)self.contentView.window.windowScene.delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController *tabBarController = [storyboard instantiateViewControllerWithIdentifier:@"TabBarController"];
    sceneDelegate.window.rootViewController = tabBarController;
    
}

@end
