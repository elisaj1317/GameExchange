//
//  ComposeOfferCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/14/21.
//

#import <UIKit/UIKit.h>
#import "MaterialTextControls+FilledTextFields.h"

NS_ASSUME_NONNULL_BEGIN

@interface ComposeOfferCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MDCFilledTextField *itemNameField;

@end

NS_ASSUME_NONNULL_END
