//
//  AppDelegate.m
//  Voteatlas1
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import "AppDelegate.h"
#import "TableViewController.h"
#import "LogInViewController.h"

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize fbSession, accountStore, twitterAccount, facebookAccount;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    self.hasFacebook = NO;
    [FBSettings setDefaultAppID:FB_APP_ID];
    [FBAppEvents activateApp];
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Voteatlas"];

    self.sideBar = [[SideBarView alloc]initWithFrame:CGRectMake(-self.window.frame.size.width, 0, self.window.frame.size.width, self.window.frame.size.height)];
    [self.window addSubview:self.sideBar];
    [self.window bringSubviewToFront:self.sideBar];
    [self.window makeKeyAndVisible];
   
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {

  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {

  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {

  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {

  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {

  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}

- (void)saveContext {

  NSError *error = nil;
  NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
  if (managedObjectContext != nil) {
    if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
      // Replace this implementation with code to handle the error appropriately.
      // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
      NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
      abort();
    }
  }
}


- (NSManagedObjectContext *)managedObjectContext {

  if (_managedObjectContext != nil) {
    return _managedObjectContext;
  }
  
  NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
  if (coordinator != nil) {
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
  }
  return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {

  if (_managedObjectModel != nil) {
    return _managedObjectModel;
  }
  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Voteatlas" withExtension:@"momd"];
  _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
  return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {

  if (_persistentStoreCoordinator != nil) {
    return _persistentStoreCoordinator;
  }
  
  NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"Voteatlas.sqlite"];
  
  NSError *error = nil;
  _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
  if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    abort();
  }
  
  return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory {

  return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (BOOL)application: (UIApplication *)application openURL: (NSURL *)url sourceApplication: (NSString *)sourceApplication
         annotation: (id)annotation {

  NSLog(@"Launched with URL scheme: %@", url.scheme);
  if ([url.scheme isEqualToString:@"voteatlas"]) {
    NSDictionary *userDict = [self urlPathToDictionary:url.absoluteString];

    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LogInViewController *vwController = (LogInViewController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"login"];
    vwController.schemaBeliefId = [[userDict valueForKey:@"belief_id"] integerValue];
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vwController];
    self.window.rootViewController = navController;
    return YES;
  }
    return YES;
}

- (NSDictionary *)urlPathToDictionary:(NSString *)path {
  NSString *stringNoPrefix = [[path componentsSeparatedByString:@"://"] lastObject];
  NSMutableArray *parts = [[stringNoPrefix componentsSeparatedByString:@"/"] mutableCopy];
  if([[parts lastObject] isEqualToString:@""])[parts removeLastObject];
  if([parts count] % 2 != 0)//Make sure that the array has an even number
    return nil;
  NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:([parts count] / 2)];
  for (int i=0; i<[parts count]; i+=2) {
    [dict setObject:[parts objectAtIndex:i+1] forKey:[parts objectAtIndex:i]];
  }
  return [NSDictionary dictionaryWithDictionary:dict];
}

@end
