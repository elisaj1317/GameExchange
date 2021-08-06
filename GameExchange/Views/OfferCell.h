//
//  OfferCell.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/13/21.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface OfferCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *offerNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptButton;


@property (strong, nonatomic) NSString *gameName;
@property (assign, nonatomic) BOOL userAuthor;

@end

NS_ASSUME_NONNULL_END
