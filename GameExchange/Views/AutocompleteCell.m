//
//  AutocompleteCell.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/20/21.
//

#import "AutocompleteCell.h"

@implementation AutocompleteCell

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
    self.autocompleteNameLabel.text = gameName;
}

@end
