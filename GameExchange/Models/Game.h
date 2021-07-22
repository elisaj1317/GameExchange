//
//  Game.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/22/21.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Game : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *rating;
@property (nonatomic, strong) NSArray *platforms;
@property (nonatomic, strong) NSArray *genres;


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (NSMutableArray *)gamesWithArray:(NSArray *)dictionaries;

@end

NS_ASSUME_NONNULL_END
