//
//  AutocompleteCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/20/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AutocompleteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *autocompleteNameLabel;

@property (strong, nonatomic) NSString *gameName;

@end

NS_ASSUME_NONNULL_END
