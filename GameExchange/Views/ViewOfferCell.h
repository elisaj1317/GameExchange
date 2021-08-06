//
//  ViewOfferCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/6/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ViewOfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *offerLabel;

@property (weak, nonatomic) NSDictionary *currentOffer;
@end

NS_ASSUME_NONNULL_END
