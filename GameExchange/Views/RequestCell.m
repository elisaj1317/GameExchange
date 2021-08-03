//
//  RequestCell.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "RequestCell.h"

@implementation RequestCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = false;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequest:(Request *)request {
    _request = request;
    
    // set up image
    self.itemImage.file = request.image;
    [self.itemImage loadInBackground:^(UIImage * _Nullable image, NSError * _Nullable error) {
        self.itemImage.alpha = 0.0;
        [UIView animateWithDuration:0.3 animations:^{
                self.itemImage.alpha = 1.0;
        }];
    }];
    
    [self setUpLabels];
}

- (void)setUpLabels {
    self.nameLabel.text = self.request.itemSelling;
    self.usernameLabel.text = [NSString stringWithFormat:@"@%@", self.request.author.username];
    self.locationLabel.text = self.request.location;
    self.platformName.text = self.request.platform;
}



@end
