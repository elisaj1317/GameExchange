//
//  FilterViewController.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/21/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol FilterViewControllerDelegate

- (void)didFilter:(NSDictionary *)filters;

@end

@interface FilterViewController : UIViewController

@property (nonatomic, weak) id<FilterViewControllerDelegate> delegate;
@property (nonatomic, strong) NSDictionary *filtersDictionary;
@end

NS_ASSUME_NONNULL_END
