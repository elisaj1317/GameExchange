//
//  GenreViewController.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 8/2/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GenreViewControllerDelegate

- (void)didSelectGenres:(NSArray *)genres;

@end

@interface GenreViewController : UIViewController

@property (nonatomic, weak) id<GenreViewControllerDelegate> delegate;
@property (strong, nonatomic) NSMutableArray *selectedGenres;

@end

NS_ASSUME_NONNULL_END
