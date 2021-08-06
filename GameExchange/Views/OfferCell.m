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
    _gameName = gameName;
    self.offerNameLabel.text = gameName;
}

- (void)setUserAuthor:(BOOL)userAuthor {
    _userAuthor = userAuthor;
    
    if (self.userAuthor == YES) {
        [self.acceptButton setHidden:YES];
    }
}

- (IBAction)didPressAccept:(id)sender {
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.gameName forKey:@"offerAccepted"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"offerAccepted" object:self userInfo:userInfo];
}


@end
