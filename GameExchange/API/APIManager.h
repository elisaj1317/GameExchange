//
//  APIManager.h
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/16/21.
//

#import <Foundation/Foundation.h>



@interface APIManager : NSObject

@property (nonatomic, retain) NSString *access_token;

+ (instancetype)shared;

@end



