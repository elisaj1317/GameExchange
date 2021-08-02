//
//  GenreCell.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/2/21.
//

#import "GenreCell.h"

@implementation GenreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    if (selected) {
        self.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = self.name;
}


@end
