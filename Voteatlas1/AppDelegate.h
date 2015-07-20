//
//  AppDelegate.h
//  Voteatlas1
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import <Accounts/ACAccountCredential.h>
#import "SideBarView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) FBSession *fbSession;
@property (nonatomic) BOOL hasFacebook;
@property (nonatomic, strong) ACAccount *twitterAccount;
@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccount *facebookAccount;

@property (strong, nonatomic) SideBarView *sideBar;
@property (nonatomic) BOOL isSliderOPen;
@property (nonatomic, strong) NSArray *arryNavController;
@property (nonatomic, strong) UINavigationController *navController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
