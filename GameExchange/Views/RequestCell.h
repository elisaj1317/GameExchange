//
//  RequestCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <UIKit/UIKit.h>
#import <Parse/PFImageView.h>

#import "Request.h"

NS_ASSUME_NONNULL_BEGIN

@interface RequestCell : UITableViewCell

@property (weak, nonatomic) IBOutlet PFImageView *itemImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemRequestLabel;

@property (strong, nonatomic) Request *request;

@end

NS_ASSUME_NONNULL_END
