//
//  AppDelegate.m
//  App
//
//  Created by Dan Kalinin on 29/09/16.
//  Copyright © 2016 Dan Kalinin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    NSString *s1 = @"#/a/b/c";
    NSString *s2 = @"http://foo.bar/schemas/address.json#/address";
    NSString *s3 = @"definitions.json#/address";
    
    NSURL *URL1 = [NSURL URLWithString:s1];
    NSURL *URL2 = [NSURL URLWithString:s2];
    NSURL *URL3 = [NSURL URLWithString:s3];
    
    NSLog(@"1 - %@", URL1.fragment.pathComponents);
    NSLog(@"2 - %@", URL2.fragment.pathComponents);
    NSLog(@"3 - %@", URL3.fragment.pathComponents);
    
    NSLog(@"1 - %@", URL1.path);
    NSLog(@"2 - %@", URL2.path);
    NSLog(@"3 - %@", URL3.path);
    
    NSLog(@"1 - %@", URL1.host);
    NSLog(@"2 - %@", URL2.host);
    NSLog(@"3 - %@", URL3.host);
    
    NSURL *baseURL = URL2.URLByDeletingLastPathComponent;
    NSURL *URL = [NSURL URLWithString:s3 relativeToURL:baseURL];
    NSLog(@"URL - %@", URL.absoluteURL);
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
