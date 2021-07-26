//
//  AppDelegate.m
//  GameExchange
//
//  Created by Elisa Jacobo Arill on 7/12/21.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "IQKeyboardManager.h"
#import "APIManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    ParseClientConfiguration *config = [ParseClientConfiguration  configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"QEiTyqUb1omAayRksEN8eoQAiJv2xx464qiTGUPw";
        configuration.clientKey = @"cKMdFLTTSuDkIFs3AdPMW1NfFaiSfhluoZtJVtFi";
        configuration.server = @"https://parseapi.back4app.com";
        
    }];

    [Parse initializeWithConfiguration:config];
    
    [APIManager shared];
    
    [IQKeyboardManager.sharedManager setToolbarTintColor:[UIColor colorNamed:@"royalBlue"]];
    [IQKeyboardManager.sharedManager setShouldShowToolbarPlaceholder:NO];
    

    return YES;
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
