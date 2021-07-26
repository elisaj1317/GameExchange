//
//  FilterViewController.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilterViewControllerDelegate

- (void)didFilter:(NSArray *)filters;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
