//
//  OfferCell.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import "OfferCell.h"

@implementation OfferCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setGameName:(NSString *)gameName {
    self.offerNameLabel.text = gameName;
}

@end
