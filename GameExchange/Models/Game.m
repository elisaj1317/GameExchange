//
//  Game.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/22/21.
//

#import "Game.h"

@implementation Game

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"];
        self.rating = dictionary[@"rating"];
        
        self.platforms = [self nameArrayFromFieldArray:dictionary[@"platforms"]];
        self.genres = [self nameArrayFromFieldArray:dictionary[@"genres"]];
        
    }
    
    return self;
}

- (NSArray *)nameArrayFromFieldArray:(NSArray *)fieldArray {
    NSMutableArray *fieldItemNames = [[NSMutableArray alloc] init];
    for (NSDictionary *dictionary in fieldArray) {
        [fieldItemNames addObject:dictionary[@"name"]];
    }
    return fieldItemNames;
}

+ (NSMutableArray *)gamesWithArray:(NSArray *)dictionaries {
    NSMutableArray *games = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in dictionaries) {
        Game *game = [[Game alloc] initWithDictionary:dictionary];
        [games addObject:game];
    }
    
    return games;
}

@end
