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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRequest:(Request *)request {
    _request = request;
    
    // set up image
    self.itemImage.file = request.image;
    [self.itemImage loadInBackground];
    
    [self setUpLabels];
}

- (void)setUpLabels {
    self.nameLabel.text = self.request.itemSelling;
    self.usernameLabel.text = self.request.author.username;
    self.locationLabel.text = self.request.location;
    self.itemRequestLabel.text = self.request.itemRequest[0];
}

@end
