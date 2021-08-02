//
//  GenreCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GenreCell : UITableViewCell

@property (strong, nonatomic) NSString *name;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

NS_ASSUME_NONNULL_END
