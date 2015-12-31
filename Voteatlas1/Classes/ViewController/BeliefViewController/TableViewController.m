  //
  //  TableViewController.m
  //  Voteatlas
  //
  //  Created by GrepRuby1 on 16/12/14.
  //  Copyright (c) 2014 Voteatlas. All rights reserved.
  //

#import "TableViewController.h"
#import "TableViewCell.h"
#import "BelieveViewController.h"
#import "DetailPageViewController.h"
#import "SearchDetailViewController.h"
#import "ProfileViewController.h"
#import "Belief.h"
#import "MapLocations.h"
#import "CalloutAnnotationView.h"
#import "CustomTextField.h"
#import "CalloutAnnotation.h"
#import "PinAnnotation.h"
#import "User.h"
#import "KeepMePostView.h"
#import "FlagView.h"
#import "ConstantClass.h"
#import "SharingActivityProvider.h"
#import "SupportCommentViewController.h"
#import "ShowImageOrVideoViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "SearchCustomCell.h"
#import "BrowserViewController.h"
#import "LogInViewController.h"

#define IMG_HGT 120
#define CUSTOME_BTN_HGT 44

@interface TableViewController () <CustomeTableViewDelegate, CalloutAnnotationViewDelegate, UITextFieldDelegate, keepMePostedDelegate,FlagDelegate, sideBarDelegate,UserListDelegate>{

  UISearchBar *searchBarVote;
  UIActivityIndicatorView *activityIndicator;
  UIButton *btnAddTranslation;
  UIButton *btnHideMap;
  UIView *vwTranslation;
  UILabel *lblStatement;
  UIScrollView *scrollVw;

  BOOL isUserDispose;
  BOOL isSearch;
  BOOL ispageExist;

  User *userObject;
  KeepMePostView *vwKeepMwPosted;
  FlagView *vwFlag;
  TableViewCell *tbleVwcell;

  NSURL *_urlToLoad;
  NSString *videoUrl;
  NSInteger page;
  NSInteger supposeCount;
  NSInteger opposeCount;
  NSInteger rowIndex;
  NSDictionary *dictSearch;
}

@property (nonatomic, strong) AppApi *api;
@property (nonatomic, strong) NSMutableArray *arryBeliefs;
@property (nonatomic, strong) NSMutableArray *arrySearchBeliefs;
@property (nonatomic, strong) NSMutableArray *arrySupportLocation;
@property (nonatomic, strong) NSMutableArray *arryOpposeLocation;
@property (nonatomic, strong) NSMutableArray *arryTranslations;
@property (nonatomic, strong) NSMutableArray *arryAutoCorrection;
@property (nonatomic, strong) NSMutableDictionary *dictSelfSeggeddion;

@property (nonatomic, strong) CustomTextField *txtFiledTranslation;
@property (nonatomic, strong) Belief *objBeliefForTranslation;

@end

@implementation TableViewController
@synthesize mapVwBelief;

#pragma mark - View Controller Configration

- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    [self configureSearchBar];
    [self addActivityIndicator];
    self.navigationController.navigationBar.hidden = false;
    self.tbleVwBelief.hidden = YES;
    self.view.backgroundColor = [UIColor clearColor];
    self.tbleVwBelief.backgroundColor = [UIColor clearColor];
    [self defaulUISettings];
    self .arrySupportLocation = [[NSMutableArray alloc]init];
    self.arryOpposeLocation = [[NSMutableArray alloc]init];

    [self addMapView];
    [self showActivityIndicator];

    self.mapVwBelief.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    MKCoordinateSpan span = {.latitudeDelta = 180, .longitudeDelta = 360};
    MKCoordinateRegion region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(0.0000f, 0.0000f), span);
    [self.mapVwBelief setRegion:region animated:YES];

    self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbleVwBelief.separatorColor = [UIColor setCustomColorOfTextField];
  if([self isauth_Token_Exist]){
    
    NSArray *arrFetchedData = [User MR_findAll];
    userObject = [arrFetchedData objectAtIndex:0];

      //if admin then add admin in array
    sharedAppDelegate.sideBar.reloadSideTable;
    if (userObject.role) {
        [sharedAppDelegate.sideBar.arrMenuOption addObject:@"Admin"];
        [sharedAppDelegate.sideBar.tbleVwSideBar reloadData];
    }
  }else{
    //[self alertMassege];
  }
    [self addTableViewOfSearch];

    if (self.schemaBeliefId != 0) {
      DetailPageViewController *vwController = [self.storyboard instantiateViewControllerWithIdentifier:@"detailPage"];
      vwController.belief_Id = self.schemaBeliefId;
      [self.navigationController pushViewController:vwController animated:NO];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    ispageExist = YES;
  
  
    dictSearch = [[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS] valueForKey:@"search"];
    if (dictSearch.count != 0) {
        if ([[dictSearch valueForKey:@"category"]integerValue] != 0) {
            [self getAllBelievesAccordingToCategory];
            return;
        }

        if ([dictSearch valueForKey:@"trending"] != nil) {
            [self getAllBelievesAccordingToSearch];
            return;
        }
    }
    [self getAllBelievesList];
}

- (void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    isSearch = NO;
}

-(BOOL)isauth_Token_Exist {
  NSString *auth_Token = [[NSUserDefaults standardUserDefaults]valueForKey:@"auth_token"];
  if(auth_Token){
    return true;
  }else{
    return false;
  }
}


-(void) alertMassege {
  UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:nil message:@"You must login or create an account before you use this functionality." delegate:self cancelButtonTitle:@"Browse"otherButtonTitles:@"Login/Cretae", nil];
  [alertVw show];
}

-(void)alertMassegeBtn{
  UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:nil message:@"You must login or create an account before you use this functionality." delegate:self cancelButtonTitle:@"Browse"otherButtonTitles:@"Login/Create", nil];
  [alertVw show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
  if(buttonIndex == 1){
    LogInViewController *vwController =  [self.storyboard instantiateViewControllerWithIdentifier:@"login"];

    UINavigationController *vc = [[UINavigationController alloc]initWithRootViewController:vwController];
    //[self.navigationController pushViewController:vc animated:true];
    NSLog(@"%@*******",vc);
    sharedAppDelegate.window.rootViewController = vc;
  }
  
  if(buttonIndex == 0){
    self.tbleVwAutoCorrection.hidden = YES;
    [self getAllBelievesList];
  }

  
}



#pragma mark - Set default setting of UI
/**************************************************************************************************
 Function to Set default setting
 **************************************************************************************************/
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];

    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapRightBarBtn:)];
    barBtnAdd.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setRightBarButtonItem:barBtnAdd];
  
  UIButton *BtnFilter = [[UIButton alloc]initWithFrame:CGRectMake(0, 0,20,20)];
  [BtnFilter setImage:[UIImage imageNamed:@"filter" ] forState:UIControlStateNormal];
  [BtnFilter addTarget:self action:@selector(tapFilter:) forControlEvents:UIControlEventTouchUpInside];
  
  UIBarButtonItem *barBtnFilter = [[UIBarButtonItem alloc]initWithCustomView:BtnFilter];
   barBtnFilter.tintColor = [UIColor setCustomColorOfTextField];
  
  UIButton *BtnSearch = [[UIButton alloc]initWithFrame:CGRectMake(0,0, 30,30)];
  [BtnSearch setImage:[UIImage imageNamed:@"menu" ] forState:UIControlStateNormal];
  [BtnSearch addTarget:self action:@selector(openSideBar:) forControlEvents:UIControlEventTouchUpInside];

  UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithCustomView:BtnSearch];
    barBtnSearch.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItems:@[barBtnSearch,barBtnFilter]];
}

#pragma mark - Add Search bar
/**************************************************************************************************
 Function to add search bar
 **************************************************************************************************/
- (void)configureSearchBar{

    searchBarVote = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2.0,self.view.frame.size.width - 110, 35.0)];
    searchBarVote.searchBarStyle = UISearchBarStyleMinimal;
    searchBarVote.delegate = self;
    self.navigationItem.titleView = searchBarVote;
    self.arryBeliefs = [[NSMutableArray alloc]init];
    self.arrySearchBeliefs = [[NSMutableArray alloc]init];
}

  // Remove background of search bar
- (void)removeUISearchBarBackgroundInViewHierarchy:(UIView *)view {

    for (UIView *subview in [view subviews]) {
      if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
        [subview removeFromSuperview];
        break; //To avoid an extra loop as there is only one UISearchBarBackground
      } else {
        [self removeUISearchBarBackgroundInViewHierarchy:subview];
      }
    }
}

#pragma mark - Get belief list
/**************************************************************************************************
 Function to Get all believe list
 **************************************************************************************************/
- (void)getAllBelievesList {

    if ([ConstantClass checkNetworkConection] == YES) {
        NSDictionary *param = ([[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"] count]!= 0)?[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"]:nil;

        dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{

                [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/all_list_beliefs" success:^(AFHTTPRequestOperation *task, id responseObject) {
                    NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
                    page = [[dictResponse valueForKey:@"page"] integerValue];
                    NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];

                    if (arryBelief.count == 0) {
                        [self NoDataInlist];
                        [self hideActivityIndicator];
                        return;
                    }
                    [self.arryBeliefs removeAllObjects];
                    [self convertDataIntoModelClass:arryBelief];
                    [self.tbleVwBelief reloadData];
                    self.tbleVwBelief.hidden = NO;
                    [self hideActivityIndicator];
                } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                    [self hideActivityIndicator];
                   [self.tbleVwBelief reloadData];
                }];
            });
        });
    } else {
        [self hideActivityIndicator];
    }
}

#pragma mark - get search belief
/**************************************************************************************************
 Function to get believe list after search
 **************************************************************************************************/
- (void)getAllBelievesAccordingToSearch {

  if ([ConstantClass checkNetworkConection] == YES) {

    NSDictionary *param = [[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"];
    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
      dispatch_async (dispatch_get_main_queue(), ^{
        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/sort_search" success:^(AFHTTPRequestOperation *task, id responseObject) {
          NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
          page = [[dictResponse valueForKey:@"page"] integerValue];
          NSArray *arryBelief = [dictResponse valueForKey:@"trends"];

          if (arryBelief.count == 0) {
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];
            [self hideActivityIndicator];
            return;
          }
          [self.arryBeliefs removeAllObjects];
          [self convertDataIntoModelClass:arryBelief];
          [self.tbleVwBelief reloadData];
          self.tbleVwBelief.hidden = NO;
          [self hideActivityIndicator];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
          [alertVw show];
          [self hideActivityIndicator];
        }];
      });
    });
  } else {
    [self hideActivityIndicator];
  }
}

#pragma mark - Get search belief according to category
/**************************************************************************************************
 Function to get believe list after category search
 **************************************************************************************************/
- (void)getAllBelievesAccordingToCategory {

  if ([ConstantClass checkNetworkConection] == YES) {
    [self showActivityIndicator];
    NSDictionary *param = [[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"];

    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
      dispatch_async (dispatch_get_main_queue(), ^{
        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/category_search" success:^(AFHTTPRequestOperation *task, id responseObject) {

          NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
          page = [[dictResponse valueForKey:@"page"] integerValue];

          NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
          if (arryBelief.count == 0) {
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No record found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];
            [self hideActivityIndicator];
          }

          [self.arryBeliefs removeAllObjects];
          [self convertDataIntoModelClass:arryBelief];
          [self.tbleVwBelief reloadData];
          self.tbleVwBelief.hidden = NO;
          [self hideActivityIndicator];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          [self hideActivityIndicator];
        }];
      });
    });
  } else {
    [self hideActivityIndicator];
  }
}

- (void)callNextPageofBeliefApi {

  if ([ConstantClass checkNetworkConection] == YES) {
    if (isSearch == YES) {
      [self callNextSearchWithPagination];
    } else {
      NSString *method = @"/api/v1/all_list_beliefs";

      if (dictSearch.count != 0) {
        if ([[dictSearch valueForKey:@"category"]integerValue] != 0) {
          method = @"/api/v1/category_search";
        } else {
          method = @"/api/v1/sort_search";
        }
      }

      NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
      if (([[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"] count]!= 0)) {
        param = [[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"]mutableCopy];
      }
      [param setValue:[NSNumber numberWithInteger:page] forKey:@"page"];

      dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
      dispatch_async(queue, ^ {
        dispatch_async (dispatch_get_main_queue(), ^{

          [self.api callGETUrlWithHeaderAuthentication:param method:method success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
            page = [[dictResponse valueForKey:@"page"] integerValue];
            NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];

            if ([dictSearch valueForKey:@"trending"] != nil) {
              arryBelief = [dictResponse valueForKey:@"trends"];
            }
            if (arryBelief.count == 0) {
              self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
              [self hideActivityIndicator];
              return;
            }
            [self convertDataIntoModelClass:arryBelief];
            [self.tbleVwBelief reloadData];
            [self hideActivityIndicator];
          } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            ispageExist = NO;
            self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            [self hideActivityIndicator];
          }];
        });
      });
    }
  } else {
    [self hideActivityIndicator];
  }
}

- (void)callNextSearchWithPagination {

  NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
  if (([[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"] count]!= 0)) {
    param = [[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"]mutableCopy];
  }

  [param setValue:[NSNumber numberWithInteger:page] forKey:@"page"];
  [param setValue:searchBarVote.text forKey:@"text"];

  [self.api callPostUrlWithHeader:param method:@"/api/v1/search" success:^(AFHTTPRequestOperation *task, id responseObject) {
    NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
    page = [[dictResponse valueForKey:@"page"] integerValue];
    NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
    isSearch = YES;
    if (arryBelief.count == 0) {
      self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
      [self hideActivityIndicator];
      return;
    }
    [self convertDataIntoModelClass:arryBelief];
    [self.tbleVwBelief reloadData];
    [self hideActivityIndicator];
  } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    [self hideActivityIndicator];
    self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
  }];
}


#pragma mark - When no data in list
/**************************************************************************************************
 Function called when no data found
 **************************************************************************************************/
- (void)NoDataInlist {

  UIButton *btnNodata = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 200)/2, (self.view.frame.size.height - 200)/2, 200, 200)];
  [btnNodata setImage:[UIImage imageNamed:@"sad"] forState:UIControlStateNormal];
  btnNodata.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  [btnNodata addTarget:self action:@selector(profileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:btnNodata];
  [self.view bringSubviewToFront:btnNodata];
}

#pragma mark - Convert data in to model class
/**************************************************************************************************
 Function to convert data into model class
 **************************************************************************************************/
- (void)convertDataIntoModelClass:(NSArray *)arryBelief {

  @autoreleasepool {
    for (NSDictionary *dictBelief in arryBelief) {

      Belief *objBelief = [[Belief alloc]init];
      objBelief.beliefId = [[dictBelief valueForKey:@"id"] integerValue];
      objBelief.statement = [dictBelief valueForKey:@"text"];
      objBelief.hasImage = [[dictBelief valueForKey:@"has_image"] boolValue];
      objBelief.hasVideo = [[dictBelief valueForKey:@"has_video"]boolValue];
      objBelief.hasYouTubeUrl = [[dictBelief valueForKey:@"has_youtube_video"]boolValue];
      objBelief.weblink = (![[dictBelief valueForKey:@"belief_url"] isKindOfClass:[NSNull class]]?[dictBelief valueForKey:@"belief_url"]:@"");
      objBelief.userId = [[[dictBelief valueForKey:@"user"]valueForKey:@"user_id"] integerValue];
      objBelief.userName = [[dictBelief valueForKey:@"user"]valueForKey:@"name"];

      if (![[dictBelief valueForKey:@"show_author"] isKindOfClass:[NSNull class]]) {
        objBelief.isShowAuther = [[dictBelief valueForKey:@"show_author"]boolValue];
      }

      if (objBelief.isShowAuther == 1 && isSearch == NO) {
        if (![[[dictBelief valueForKey:@"user"] valueForKey:@"profile_image"] isKindOfClass:[NSNull class]]) {
          objBelief.profileImg = [[[dictBelief valueForKey:@"user"] valueForKey:@"profile_image"]valueForKey:@"url"];
        }
      }

      if (objBelief.isShowAuther == 1) {
        if (![[[dictBelief valueForKey:@"profile_image"] valueForKey:@"profile_image"] isKindOfClass:[NSNull class]]) {
          objBelief.profileImg = [[[dictBelief valueForKey:@"profile_image"] valueForKey:@"profile_image"]valueForKey:@"url"];
        }
      }

      if (objBelief.hasVideo == 1) {
        objBelief.videoUrl = [dictBelief valueForKey:@"video_url"];
        objBelief.thumbImage_Url = [[dictBelief valueForKey:@"video_image"] valueForKey:@"url"];
      }

      if (objBelief.hasImage == 1) {
        objBelief.imageUrl = [dictBelief valueForKey:@"image_url"];
      }

      if (objBelief.hasYouTubeUrl == 1) {
        objBelief.youtubeUrl = [dictBelief valueForKey:@"youtube_url"];
        objBelief.thumbImage_Url = [dictBelief valueForKey:@"youtube_image"];
      }

      if (![[dictBelief valueForKey:@"language_id"] isKindOfClass:[NSNull class]]) {
        objBelief.languageId = [dictBelief valueForKey:@"language_id"];
        objBelief.languageName = [[dictBelief valueForKey:@"language"] valueForKey:@"name"];
      }

      if (![[dictBelief valueForKey:@"get_desposition"] isKindOfClass:[NSNull class]]) {
        objBelief.dictDisposition = [dictBelief valueForKey:@"get_desposition"];
      }

      if (isSearch == YES) {
        [self.arrySearchBeliefs addObject:objBelief];
      } else {
        [self.arryBeliefs addObject:objBelief];
      }
    }
  }
}

- (void)whenSearchTapped:(id)sender{

}

#pragma mark - UISearch bar Delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

  [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

  if(searchText.length != 0) {

      // search_autocomplete
    NSDictionary *param = @{@"text":searchBar.text};
    [self.api callGETUrl:param method:@"/api/v1/search_autocomplete" success:^(AFHTTPRequestOperation *task, id responseObject) {
      self.arryAutoCorrection = [NSMutableArray new];

      self.arryAutoCorrection = [[responseObject valueForKey:@"data"]valueForKey:@"search"];
      [self.tbleVwAutoCorrection reloadData];
      self.tbleVwAutoCorrection.hidden = NO;
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
  }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {

  [searchBar resignFirstResponder];
  [self.tbleVwAutoCorrection setHidden:YES];
  ispageExist = YES;
  NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
  if (([[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"] count]!= 0)) {
    param = [[[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]valueForKey:@"search"]mutableCopy];
  }
  [param setValue:searchBar.text forKey:@"text"];
  [self showActivityIndicator];
  [self.arrySearchBeliefs removeAllObjects];

  if ([ConstantClass checkNetworkConection] == YES) {

    [self.api callPostUrlWithHeader:param method:@"/api/v1/search" success:^(AFHTTPRequestOperation *task, id responseObject) {

      NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
      page = [[dictResponse valueForKey:@"page"] integerValue];
      NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
      isSearch = YES;
      [self convertDataIntoModelClass:arryBelief];
      [self.tbleVwBelief reloadData];
      [self hideActivityIndicator];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Try search with different text." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alertVw show];
      [self hideActivityIndicator];
    }];
  } else {
    [self hideActivityIndicator];
  }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
  [self.tbleVwAutoCorrection setHidden:YES];
  [searchBar resignFirstResponder];
  [searchBar setShowsCancelButton:NO animated:YES];
  searchBarVote.text = @"";

  isSearch = NO;
  [self.tbleVwBelief reloadData];
}


#pragma mark - UIBar button action
- (void)tapRightBarBtn:(id)sender {
  if([self isauth_Token_Exist]){
  BelieveViewController *vcBelief = [self.storyboard instantiateViewControllerWithIdentifier:@"BelieveID"];
  vcBelief.userID = self.userID;
  [self.navigationController pushViewController:vcBelief animated:YES];
  }else{
    [self alertMassege];
  }
}

- (void)tapLeftBarBtn:(id)sender {

  SearchDetailViewController *vcSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
  [self.navigationController pushViewController:vcSearch animated:YES];
}

#pragma mark - UITable view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

  if (tableView == self.tbleVwBelief) {
    if (isSearch == YES) {
      return [[self arrySearchBeliefs]count ];
    } else {
      return [[self arryBeliefs] count];
    }
  }

  return self.arryAutoCorrection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (tableView == self.tbleVwBelief) {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

      Belief *objBelief;
      if (isSearch == YES) {
      objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
      } else {
      objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
      }

      cell.delegate = self;
    if([self isauth_Token_Exist]){
      [cell setValueInTableVw:objBelief withVwController:self forRow:indexPath.row withCellWidth:self.tbleVwBelief.frame.size.width withLaguagleId:userObject.language];
    }else{
      NSNumber *langID = [[NSNumber alloc]initWithUnsignedInt:1];
      [cell setValueInTableVw:objBelief withVwController:self forRow:indexPath.row withCellWidth:self.tbleVwBelief.frame.size.width withLaguagleId:langID];
    }
      NSInteger lastRowIndex = [tableView numberOfRowsInSection:0] - 1;

      if (ispageExist == YES && lastRowIndex == indexPath.row) {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        spinner.frame = CGRectMake(0, 0, self.view.frame.size.width, 44);
        [spinner startAnimating];
        self.tbleVwBelief.tableFooterView = spinner;
        [self performSelector:@selector(callNextPageofBeliefApi) withObject:nil afterDelay:0.5];
      }
      return cell;
    } else {
    SearchCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"searchCell" forIndexPath:indexPath];
    cell.lblSearch.text = [self.arryAutoCorrection objectAtIndex:indexPath.row];
    CGRect rect = [ConstantClass sizeOfString:cell.lblSearch.text withSize:CGSizeMake(self.view.frame.size.width - 10 , 100)];
    cell.lblSearch.frame = CGRectMake(5, 5,self.view.frame.size.width, rect.size.height+5);
    return cell;
  }

}

#pragma mark - Table view data Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if([self isauth_Token_Exist]){
  if (tableView == self.tbleVwBelief) {

    Belief *objBelief;
    if (isSearch == YES) {
        objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
    } else {
        objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
    }
    self.objBeliefForTranslation = objBelief;
    [self showFlagVwWithAnimation];
  } else {
    searchBarVote.text = [self.arryAutoCorrection objectAtIndex:indexPath.row];
    self.tbleVwAutoCorrection.hidden = YES;
  }
  }else{
    [self alertMassege];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

  if (tableView == self.tbleVwBelief) {

    Belief *objBelief;
    if (isSearch == YES) {
      objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
    } else {
      objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
    }

    NSString *strSuppose = [objBelief.statement stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    CGRect rect = [strSuppose boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-140, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    CGRect rectLink = [ConstantClass sizeOfString:objBelief.weblink withSize:CGSizeMake(self.tbleVwBelief.frame.size.width - 140, 100)];

    if (rect.size.height > 64) {
      return (rect.size.height + CUSTOME_BTN_HGT + IMG_HGT + 97 + rectLink.size.height);
    } else {
      return (300 + rectLink.size.height);
    }
  } else {
    NSString *strText = [self.arryAutoCorrection objectAtIndex:indexPath.row];
    CGRect rect = [ConstantClass sizeOfString:strText withSize:CGSizeMake(self.view.frame.size.width - 10 , 100)];
    if (rect.size.height < 35) {
      return 44;
    }
    return (rect.size.height+10);
  }
}

#pragma mark - Profile Btn tapped
/**************************************************************************************************
 Function to profile button tapped
 **************************************************************************************************/
- (void)profileBtnTapped:(Belief *)belief {
  if([self isauth_Token_Exist]){
  if ([belief.profileImg isKindOfClass:[NSNull class]] || belief.profileImg == nil) {

    UIAlertView *alertVwAnonymousAuthor = [[UIAlertView alloc]initWithTitle:@"Anonymous Author" message:nil delegate:nil cancelButtonTitle:@"Ok"otherButtonTitles:nil];
    [alertVwAnonymousAuthor show];
    return;
  }

    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilID"];
    vc.userName = belief.userName;
    [self.navigationController pushViewController:vc animated:YES];
  }else{
    [self alertMassege];
  }
}

#pragma mark - Delegates of Custom button view
- (void)sharebtnTapped:(Belief*)belief {
  if([self isauth_Token_Exist]){
  [self showActivityIndicator];
  dispatch_queue_t queue = dispatch_queue_create("get image", NULL);
  dispatch_async(queue, ^ {
    dispatch_async(dispatch_get_main_queue(), ^{

    NSString *url;
    UIImage *image;
    NSArray *objectsToShare;

    NSString *strShare = [NSString stringWithFormat:@"%@ \n", belief.statement];
    NSString *strOPenInWeb = [NSString stringWithFormat:@"https://likeminded.co/beliefs/%ld", (long)belief.beliefId];
    SharingActivityProvider *shareActivity = [[SharingActivityProvider alloc]initwithText:strShare withUrl:[NSURL URLWithString:strOPenInWeb]];

    if (belief.imageUrl.length != 0){

        url = belief.imageUrl;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        image = [UIImage imageWithData:data];
        objectsToShare = @[shareActivity,image];
    } else {

      if ([belief.thumbImage_Url isKindOfClass:[NSNull class]] || belief.thumbImage_Url == nil){
        objectsToShare = @[shareActivity];
      } else {

        url = belief.thumbImage_Url;
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
        image = [UIImage imageWithData:data];
        objectsToShare = @[shareActivity,image];
      }
    }

      UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
      controller.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll, UIActivityTypeMessage, UIActivityTypeAirDrop];
      [self presentViewController:controller animated:YES completion:nil];

      [self hideActivityIndicator];

      controller.completionHandler = ^(NSString *activityType, BOOL completed){
          if (completed) {
            NSLog(@"Selected activity was performed.");
          } else {
            if (activityType == NULL) {
              NSLog(@"User dismissed the view controller without making a selection.");
            } else {
              NSLog(@"Activity was not performed.");
            }
          }
        NSString* result = completed ? @"success" : @"fail";
        if ([result isEqualToString:@"success"] && ![activityType isEqualToString:@"com.google.GooglePlus.ShareExtension"]) {
          UIAlertView *alertvw = [[UIAlertView alloc]initWithTitle:@"Success" message:@"Your post has been send successfully!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
          [alertvw show];
        }
        if (activityType == NULL) {
        }
        [self hideActivityIndicator];
      };
    });
  });
  }else{
    [self alertMassege];
  }
  
}


- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {

  NSString *shareString = @"voteatlas.com";
  if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
    shareString = [NSString stringWithFormat:@"Attention Facebook: %@", shareString];
  } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
    shareString = [NSString stringWithFormat:@"Attention Twitter: %@", shareString];
  } else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
    shareString = [NSString stringWithFormat:@"Attention Weibo: %@", shareString];
  } else if ([activityType isEqualToString:@"com.captech.googlePlusSharing"]) {
    shareString = [NSString stringWithFormat:@"Attention Google+: %@", shareString];
  }

  return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
  return @"";
}

#pragma mark - Map view method
/**************************************************************************************************
 Function to add map view
 **************************************************************************************************/
- (void)addMapView {

  self.vwMap.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
  self.vwMap.frame = self.view.frame;

  btnHideMap = [UIButton buttonWithType:UIButtonTypeCustom];
  btnHideMap.frame = CGRectMake(self.view.frame.size.width - 40,65, 40, 40);
  [btnHideMap setTitle:@"X" forState:UIControlStateNormal];
  [btnHideMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [btnHideMap addTarget:self action:@selector(hideMapViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
  btnHideMap.titleLabel.textColor = [UIColor darkGrayColor];
  [self.vwMap addSubview:btnHideMap];
}

- (void)showMapViewWithAnimation:(Belief *)belief withCellTag:(int)tagOfCell {

  [UIView animateWithDuration:0.4 animations:^{
    [self.vwMap setHidden:NO];
    [self showStaticDataOnMapVw:belief];
    mapVwBelief.frame = CGRectMake(10, 100, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 130);
    [mapVwBelief setHidden:NO];
  }completion:^(BOOL finished) {
    [self addAnotation];
    TableViewCell *cell = (TableViewCell*)[self.tbleVwBelief cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tagOfCell inSection:0]];
    [cell.customVwOfBtns.btnMap setImage:[UIImage imageNamed:@"9_unselect.png"] forState:UIControlStateNormal];
  }];
}

- (void)hideMapViewWithAnimation {

  [UIView animateWithDuration:0.4 animations:^{
    mapVwBelief.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    mapVwBelief.hidden = YES;
    [self.vwMap setHidden:YES];
  }];
}

- (void)addAnotation {

  [self.mapVwBelief removeAnnotations:self.mapVwBelief.annotations];
  NSMutableArray *arryAnnotation = [[NSMutableArray alloc]init];
  @autoreleasepool {
    for (MapLocations *location in self.arrySupportLocation) {

      CLLocationCoordinate2D coordinate2d;
      coordinate2d.latitude = location.latitute;//22.6909904;
      coordinate2d.longitude = location.longitute;//75.870318;
      PinAnnotation* pinAnnotation = [[PinAnnotation alloc] init];
      pinAnnotation.title = location.title;
      pinAnnotation.suppose = [NSString stringWithFormat:@"%@", location.suppose];
      pinAnnotation.oppose = [NSString stringWithFormat:@"%@",location.oppose];
      pinAnnotation.coordinate = coordinate2d;
      [arryAnnotation addObject:pinAnnotation];
    }
  }

  @autoreleasepool {
    for (MapLocations *location in self.arryOpposeLocation) {

      CLLocationCoordinate2D coordinate2d;
      coordinate2d.latitude = location.latitute;//22.6909904;
      coordinate2d.longitude = location.longitute;//75.870318;
      PinAnnotation* pinAnnotation = [[PinAnnotation alloc] init];
      pinAnnotation.title = location.title;
      pinAnnotation.suppose = [NSString stringWithFormat:@"%@", location.suppose];
      pinAnnotation.oppose = [NSString stringWithFormat:@"%@", location.oppose];
      pinAnnotation.coordinate = coordinate2d;
      [arryAnnotation addObject:pinAnnotation];
    }
  }

  [mapVwBelief addAnnotations:arryAnnotation];
}

- (void)mapbtnTapped:(Belief *)belief withCellTag:(NSInteger)tag {
  if([self isauth_Token_Exist]){
  NSDictionary *param = @{@"belief":[NSNumber numberWithInteger:belief.beliefId]};

  if ([ConstantClass checkNetworkConection] == YES) {
    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
      dispatch_async(dispatch_get_main_queue(), ^{

        [self.api callGETUrl:param method:@"/api/v1/map" success:^(AFHTTPRequestOperation *task, id responseObject) {
          NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
          NSArray *arryOppose = [dictResponse valueForKey:@"belief_oppose"];

          @autoreleasepool {
            [self.arryOpposeLocation removeAllObjects];
            for (NSDictionary *dictMap in arryOppose) {
              MapLocations*objMapLocation = [[MapLocations alloc]init];
              objMapLocation.title = @"oppose";
              objMapLocation.suppose = [dictResponse valueForKey:@"agree"];
              objMapLocation.oppose = [dictResponse valueForKey:@"dis_agree"];

              supposeCount =  [[dictResponse valueForKey:@"agree"] integerValue];
              opposeCount =  [[dictResponse valueForKey:@"dis_agree"] integerValue];

              if ([[dictMap objectForKey:@"location"]count] != 0) {
                objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
                objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
                [self.arryOpposeLocation addObject:objMapLocation];
              }
            }
          }

          NSArray *arryBeliefSupport = [dictResponse valueForKey:@"beliefs_support"];
          [self.arrySupportLocation removeAllObjects];
          @autoreleasepool {
            for (NSDictionary *dictMap in arryBeliefSupport) {
              MapLocations*objMapLocation = [[MapLocations alloc]init];
              objMapLocation.title = @"support";
              objMapLocation.suppose = [dictResponse valueForKey:@"agree"];
              objMapLocation.oppose = [dictResponse valueForKey:@"dis_agree"];

              supposeCount =  [[dictResponse valueForKey:@"agree"] integerValue];
              opposeCount =  [[dictResponse valueForKey:@"dis_agree"] integerValue];

              if ([[dictMap objectForKey:@"location"]count] != 0) {
                objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
                objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
                [self.arrySupportLocation addObject:objMapLocation];
              }
            }
          }
          [self.mapVwBelief removeAnnotations:self.mapVwBelief.annotations];
          [self showMapViewWithAnimation:belief withCellTag:(int)tag];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
      });
    });
  } else {
    [self hideActivityIndicator];
  }
  }else{
    [self alertMassege];
  }
}

#pragma mark - MKMapView delegate
- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation {
  MKAnnotationView *annotationView;
  NSString *identifier;

  if ([annotation isKindOfClass:[PinAnnotation class]]) {
      // Pin annotation.
    identifier = @"Pin";
    annotationView = (MKAnnotationView *)[mapVwBelief dequeueReusableAnnotationViewWithIdentifier:identifier];
    if (annotationView == nil) {
      annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }
    if ([annotation.title isEqualToString:@"support"]) {
      annotationView.image = [UIImage imageNamed:@"greenPin"];
    } else {
      annotationView.image = [UIImage imageNamed:@"redPin"];
    }

  } else if ([annotation isKindOfClass:[CalloutAnnotation class]]) {
      // Callout annotation.
    identifier = @"Callout";
    annotationView = (CalloutAnnotationView *)[mapVwBelief dequeueReusableAnnotationViewWithIdentifier:identifier];

    if (annotationView == nil) {
      annotationView = [[CalloutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
    }

    CalloutAnnotation *calloutAnnotation = (CalloutAnnotation *)annotation;

    ((CalloutAnnotationView *)annotationView).titleSuppose = calloutAnnotation.suppose;
    ((CalloutAnnotationView *)annotationView).titleOppose = calloutAnnotation.oppose;
    ((CalloutAnnotationView *)annotationView).delegate = self;
    [annotationView setNeedsDisplay];

    [annotationView setCenterOffset:CGPointMake(0, -70)];
      // Move the display position of MapView.
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                     }];
  }
  annotationView.annotation = annotation;
  return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {

  if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
      // Selected the pin annotation.
    CalloutAnnotation *calloutAnnotation = [[CalloutAnnotation alloc] init];

    PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
    calloutAnnotation.suppose = pinAnnotation.suppose;
    calloutAnnotation.oppose = pinAnnotation.oppose;
    calloutAnnotation.coordinate = pinAnnotation.coordinate;
    pinAnnotation.calloutAnnotation = calloutAnnotation;
    [mapView addAnnotation:calloutAnnotation];
  }
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
  if ([view.annotation isKindOfClass:[PinAnnotation class]]) {
      // Deselected the pin annotation.
    PinAnnotation *pinAnnotation = ((PinAnnotation *)view.annotation);
    [mapView removeAnnotation:pinAnnotation.calloutAnnotation];
    pinAnnotation.calloutAnnotation = nil;
  }
}

- (void)showStaticDataOnMapVw:(Belief *)belief {

  UIView *vwMapStatic = [[UIView alloc]initWithFrame:CGRectMake(10.0f, self.vwMap.frame.size.height - 115, 170, 85)];
  vwMapStatic.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
  vwMapStatic.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
  vwMapStatic.layer.borderWidth = 1.0f;
  vwMapStatic.layer.cornerRadius = 4.0;

  UILabel *lblOppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 35.0f, 70.0f, 25.0f)];
  lblOppose.textColor = [UIColor setCustomSignUpColor];
  lblOppose.font = [UIFont systemFontOfSize:14];
  [vwMapStatic addSubview:lblOppose];

  UILabel *lblSuppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 5.0f, 70.0f, 25.0f)];
  lblSuppose.textColor = [UIColor setCustomSignUpColor];
  lblSuppose.font = [UIFont systemFontOfSize:14];
  [vwMapStatic addSubview:lblSuppose];

  UIImageView *imgVwSuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 20.0f, 25.0f)];
  imgVwSuppose.image = [UIImage imageNamed:@"4"];
  [vwMapStatic addSubview:imgVwSuppose];

  UIImageView *imgVwOuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 35.0f, 20.0f, 25.0f)];
  imgVwOuppose.image = [UIImage imageNamed:@"5"];
  [vwMapStatic addSubview:imgVwOuppose];

  UIImageView *imgVwLine = [[UIImageView alloc]initWithFrame:CGRectMake(40.0f, 55.0f, 70.0f, 1.0f)];
  imgVwLine.backgroundColor = [UIColor blackColor];
  [vwMapStatic addSubview:imgVwLine];

  UILabel *lblTotal = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 56.0f, 70.0f, 25.0f)];
  lblTotal.textColor = [UIColor setCustomSignUpColor];
  lblTotal.font = [UIFont systemFontOfSize:14];
  [vwMapStatic addSubview:lblTotal];
  [self.vwMap addSubview:vwMapStatic];

  NSInteger totalComment = supposeCount + opposeCount;
  double supposePerc = ((supposeCount*100)/totalComment);
  double opposePerc = ((opposeCount*100)/totalComment);
  NSString *strSuppose;
  NSString *strOppose;
  if (100%totalComment != 0) {
    strSuppose = [NSString stringWithFormat:@"-%ld-%.01f%%", (long)supposeCount,supposePerc];//-1-100%
    strOppose = [NSString stringWithFormat:@"-%ld-%.01f%%", (long)opposeCount,opposePerc];//-1-100%
  } else {
    strSuppose = [NSString stringWithFormat:@"-%ld-%d%%", (long)supposeCount,((int)supposePerc)];//-1-100%
    strOppose = [NSString stringWithFormat:@"-%ld-%d%%", (long)opposeCount,((int)opposePerc)];//-1-100%
  }
  lblOppose.text = strOppose;
  lblSuppose.text = strSuppose;
  lblTotal.text = [NSString stringWithFormat:@"%li",(long)totalComment];
    
  UIButton *btnLike = [[UIButton alloc] initWithFrame:CGRectMake( vwMapStatic.frame.size.width - 60, 10, 50 , 20)];
  btnLike.backgroundColor = [UIColor setCustomLikeButtonColor];
  btnLike.layer.cornerRadius = 5.0;
  btnLike.tag = belief.beliefId;
  btnLike.titleLabel.font = [UIFont systemFontOfSize:14.0];
  [btnLike setTitle:@"View" forState:UIControlStateNormal];
  [btnLike addTarget:self action:@selector(showSupposeUserListWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
  [vwMapStatic addSubview:btnLike];
    
  UIButton *btnDisLike = [[UIButton alloc] initWithFrame:CGRectMake( vwMapStatic.frame.size.width - 60, 35, 50 , 20)];
  btnDisLike.backgroundColor = [UIColor setCustomDisLikeButtonColor];
  btnDisLike.layer.cornerRadius = 5.0;
  btnDisLike.tag = belief.beliefId;
  btnDisLike.titleLabel.font = [UIFont systemFontOfSize:14.0];
  [btnDisLike setTitle:@"View" forState:UIControlStateNormal];
  [btnDisLike addTarget:self action:@selector(showOpposeUserListWithAnimation:) forControlEvents:UIControlEventTouchUpInside];
  [vwMapStatic addSubview:btnDisLike];
    
}

#pragma mark - Like-Dislike Users List and there Delegate methods
- (void)addUserListView:(NSInteger)belief_id isOppose:(BOOL)objIsOppose {
    self.vwUserList = [[UsersListView alloc] initWithFrame:CGRectMake(self.view.center.x, self.view.center.y, 0, 0)];
    self.vwUserList.delegate = self;
    objIsOppose ? [self.vwUserList loadOpposeUserListData:belief_id] : [self.vwUserList loadSupposeUserListData:belief_id];
    [self.view addSubview:self.vwUserList];
}

- (void)showOpposeUserListWithAnimation:(UIButton *)sender {
    
    [self addUserListView:sender.tag isOppose:TRUE];
    [UIView animateWithDuration:0.4 animations:^{
        self.vwUserList.frame = CGRectMake(10, 75, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 100);
        self.vwUserList.btnHideList.frame = CGRectMake(self.view.frame.size.width - 60,0, 40, 40);
        self.vwUserList.tblUserList.frame = CGRectMake(0, 50, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 150);
        self.vwUserList.activityIndicator.center = CGPointMake(self.vwUserList.frame.size.width/2, (self.vwUserList.frame.size.height - 64)/2);
    }completion:^(BOOL finished) {
    }];
}

- (void)showSupposeUserListWithAnimation:(UIButton *)sender {
    
    [self addUserListView:sender.tag isOppose:FALSE];
    [UIView animateWithDuration:0.4 animations:^{
        self.vwUserList.frame = CGRectMake(10, 75, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 100);
        self.vwUserList.btnHideList.frame = CGRectMake(self.view.frame.size.width - 60,0, 40, 40);
        self.vwUserList.tblUserList.frame = CGRectMake(0, 50, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 150);
        self.vwUserList.activityIndicator.center = CGPointMake(self.vwUserList.frame.size.width/2, (self.vwUserList.frame.size.height - 64)/2);
    }completion:^(BOOL finished) {
    }];
}

- (void)showTappedUserProfile:(NSString *)userName {

    ProfileViewController *vwControllerProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilID"];
    vwControllerProfile.userName = userName;
    [self.navigationController pushViewController:vwControllerProfile animated:YES];
}

#pragma mark - Mail compose delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
  if (result) {
    NSLog(@"Result : %d",result);
  }
  if (error) {
    NSLog(@"Error : %@",error);
  }
  [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Add activity Indicator
/**************************************************************************************************
 Function to add and show activity indicator
 **************************************************************************************************/
- (void)addActivityIndicator {

  activityIndicator = [[UIActivityIndicatorView alloc]init];
  activityIndicator.frame = CGRectMake((self.view.frame.size.width-35)/2, (self.view.frame.size.height-35)/2, 35, 35);
  activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
  [self.view addSubview:activityIndicator];
  [self.view bringSubviewToFront:activityIndicator];
}

- (void)hideActivityIndicator {

  [activityIndicator setHidden:YES];
  [activityIndicator stopAnimating];
}

- (void)showActivityIndicator {

  [activityIndicator setHidden:NO];
  [activityIndicator startAnimating];
}

#pragma mark - Add translation view
/**************************************************************************************************
 Function to add translate view
 **************************************************************************************************/
- (void)addTranslationView:(Belief*)belief {

  vwTranslation = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.tbleVwBelief.frame.size.height)];
  [vwTranslation setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
  [vwTranslation setHidden:YES];
  [self.view addSubview:vwTranslation];

  scrollVw = [[UIScrollView alloc]initWithFrame:CGRectMake(10, 10, vwTranslation.frame.size.width - 20, self.tbleVwBelief.frame.size.height-100)];
  scrollVw.backgroundColor = [UIColor whiteColor];
  [vwTranslation addSubview:scrollVw];

  UIButton * btnHide = [UIButton buttonWithType:UIButtonTypeCustom];
  btnHide.frame = CGRectMake(scrollVw.frame.size.width - 40, 2, 40, 40);
  [btnHide setTitle:@"x" forState:UIControlStateNormal];
  [btnHide setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [btnHide addTarget:self action:@selector(hideTranslationViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
  btnHide.titleLabel.textColor = [UIColor darkGrayColor];
  [scrollVw addSubview:btnHide];

  UILabel *lblHeading = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, scrollVw.frame.size.width - 60, 42)];
  lblHeading.numberOfLines = 0;
  NSString *strTranslation = [NSString stringWithFormat:@"Translate the statement below from %@ to %@.", belief.languageName ,[[NSUserDefaults standardUserDefaults] valueForKey:@"userlanguage"]];
  lblHeading.text = strTranslation;
  lblHeading.textColor = [UIColor darkGrayColor];
  lblHeading.font = [UIFont systemFontOfSize:15.0f];
  [scrollVw addSubview:lblHeading];

  UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, scrollVw.frame.size.width - 20, 1)];
  imgVwLine1.backgroundColor = [UIColor lightGrayColor];
  [scrollVw addSubview:imgVwLine1];

  lblStatement = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.origin.y + 10, scrollVw.frame.size.width - 20, 21)];
  lblStatement.numberOfLines = 0;
  lblStatement.textColor = [UIColor darkGrayColor];
  lblStatement.font = [UIFont systemFontOfSize:13.0f];
  [scrollVw addSubview:lblStatement];
}

  //Translation btn tapped
- (void)translatebtnTapped:(Belief*)belief {
  if([self isauth_Token_Exist]){
    [self showTranslationVwWithAnimation:belief];
    NSString *strSuppose = belief.statement;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(scrollVw.frame.size.width-30, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    lblStatement.frame = CGRectMake(10, lblStatement.frame.origin.y, scrollVw.frame.size.width - 20, rect.size.height);
    lblStatement.text = belief.statement;

    UIImageView *imgVwLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, lblStatement.frame.origin.y + lblStatement.frame.size.height + 5, vwTranslation.frame.size.width - 20, 1)];
    imgVwLine2.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine2];

    [self callTranslateApi:belief];
    [self.view bringSubviewToFront:activityIndicator];
    [self showActivityIndicator];
  }else{
    [self alertMassege];
  }
  
}

- (void)showTranslationVwWithAnimation:(Belief*)belief {

    [self addTranslationView:belief];
    [UIView animateWithDuration:0.4 animations:^{
        vwTranslation.hidden = NO;
    }];
}

- (void)hideTranslationViewWithAnimation {

    [UIView animateWithDuration:0.4 animations:^{
    vwTranslation.hidden = YES;
    [vwTranslation removeFromSuperview];
    self.objBeliefForTranslation = nil;
  }];
}

  //translation api
- (void)callTranslateApi:(Belief *)belief {

    self.objBeliefForTranslation = belief;
    NSDictionary *param = @{@"language_id":userObject.language,
                          @"belief_id":[NSNumber numberWithInteger:belief.beliefId]
                          };
    if ([ConstantClass checkNetworkConection] == YES) {

    dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
    dispatch_async(queue, ^ {
      dispatch_async (dispatch_get_main_queue(), ^{
        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/translation_for_statement" success:^(AFHTTPRequestOperation *task, id responseObject) {
          NSDictionary *response = (NSDictionary *)responseObject;
          [self setValuesOfTranslation:response];
          [self hideActivityIndicator];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          [self hideActivityIndicator];
        }];
      });
    });
    } else {
        [self hideActivityIndicator];
    }
}

- (void)setValuesOfTranslation :(NSDictionary *)response {

  NSDictionary *dictVerified;
  if (self.arryTranslations != nil) {
    self.arryTranslations = nil;
  }
  if (self.dictSelfSeggeddion != nil) {
    self.dictSelfSeggeddion = nil;
  }

  self.arryTranslations = [[NSMutableArray alloc]init];
  self.dictSelfSeggeddion = [[NSMutableDictionary alloc]init];

  if ([[response valueForKey:@"translations"] isKindOfClass:[NSArray class]]) {
    if ([[response valueForKey:@"translations"]count] != 0)
      self.arryTranslations = [response valueForKey:@"translations"];
  }
  if (![[response valueForKey:@"current_user_translation"] isKindOfClass:[NSNull class]]) {
    self.dictSelfSeggeddion = [response valueForKey:@"current_user_translation"];
  }
  if ([[response valueForKey:@"verified_translation"] isKindOfClass:[NSDictionary class]]) {
    if ([[response valueForKey:@"verified_translation"]count ] != 0) {
      dictVerified = [response valueForKey:@"verified_translation"];
    }
  }

  isUserDispose = [[response valueForKey:@"user_dispose"] boolValue]; //user Dispose

  int yAxisOfSuggestedHeading = lblStatement.frame.origin.y + lblStatement.frame.size.height + 10;

  if (dictVerified.count != 0) {
    UILabel *lblVerified = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading, scrollVw.frame.size.width - 20, 21)];
    lblVerified.textColor = [UIColor darkGrayColor];
    lblVerified.text = @"Verified Translation :";
    lblVerified.font = [UIFont boldSystemFontOfSize:14.0f];
    [scrollVw addSubview:lblVerified];

    UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, lblVerified.frame.size.height + lblVerified.frame.origin.y + 5 , scrollVw.frame.size.width - 20, 1)];
    imgVwLine1.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine1];

    NSString *strTranslate = [dictVerified valueForKey:@"translation"];
    CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(scrollVw.frame.size.width-30, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    UILabel *lblVerifiedTrana = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 5 , scrollVw.frame.size.width - 20, rect.size.height)];
    lblVerifiedTrana.textColor = [UIColor darkGrayColor];
    lblVerifiedTrana.text = strTranslate;
    lblVerifiedTrana.font = [UIFont systemFontOfSize:13.0f];
    [scrollVw addSubview:lblVerifiedTrana];

    UIImageView *imgVwLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  lblVerifiedTrana.frame.size.height + lblVerifiedTrana.frame.origin.y + 7 , vwTranslation.frame.size.width - 20, 1)];
    imgVwLine2.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine2];
    return;
  }

  if (self.dictSelfSeggeddion.count != 0){

    UILabel *lblYourfSuggestedHeading = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading, vwTranslation.frame.size.width - 20, 21)];
    lblYourfSuggestedHeading.textColor = [UIColor darkGrayColor];
    lblYourfSuggestedHeading.text = @"Your translation:";
    lblYourfSuggestedHeading.font = [UIFont boldSystemFontOfSize:14.0f];
    [scrollVw addSubview:lblYourfSuggestedHeading];

    NSString *strTranslate = [self.dictSelfSeggeddion valueForKey:@"translation"];
    CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(scrollVw.frame.size.width-30, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    UILabel *lblSelfSuggestedTrans = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading + 25, scrollVw.frame.size.width - 20, rect.size.height)];
    lblSelfSuggestedTrans.textColor = [UIColor darkGrayColor];
    lblSelfSuggestedTrans.text = strTranslate;
    lblSelfSuggestedTrans.numberOfLines = 0;
    lblSelfSuggestedTrans.font = [UIFont systemFontOfSize:13.0f];
    [scrollVw addSubview:lblSelfSuggestedTrans];

    UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  lblSelfSuggestedTrans.frame.size.height + lblSelfSuggestedTrans.frame.origin.y + 5 , vwTranslation.frame.size.width - 20, 1)];
    imgVwLine1.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine1];
    yAxisOfSuggestedHeading = imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 10;
  }

  UILabel *lblSuggestedTrans = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading, scrollVw.frame.size.width - 20, 21)];
  lblSuggestedTrans.textColor = [UIColor darkGrayColor];
  lblSuggestedTrans.text = @"Suggested translations:";
  lblSuggestedTrans.font = [UIFont boldSystemFontOfSize:14.0f];
  [scrollVw addSubview:lblSuggestedTrans];

  int  yAxis = lblSuggestedTrans.frame.origin.y + lblSuggestedTrans.frame.size.height + 5;

  int tag = 0;
  if (self.arryTranslations.count == 0) {
    UILabel *lblNoTranslation = [[UILabel alloc]initWithFrame:CGRectMake(10, lblSuggestedTrans.frame.origin.y + lblSuggestedTrans.frame.size.height + 10, scrollVw.frame.size.width - 20, 21)];
    lblNoTranslation.textColor = [UIColor darkGrayColor];
    lblNoTranslation.text = @"No Suggession Available";
    lblNoTranslation.font = [UIFont systemFontOfSize:13.0f];
    [scrollVw addSubview:lblNoTranslation];

    yAxis = yAxis + 21;
  } else {

    for (NSDictionary *dict in self.arryTranslations) {

      NSString *strTranslate = [dict valueForKey:@"translation"];
      CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(scrollVw.frame.size.width-30, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

      UILabel *lblTranslation = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxis, scrollVw.frame.size.width - 20, rect.size.height)];
      lblTranslation.textColor = [UIColor darkGrayColor];
      lblTranslation.text = strTranslate;
      lblTranslation.font = [UIFont systemFontOfSize:13.0f];
      lblTranslation.numberOfLines = 0;
      [scrollVw addSubview:lblTranslation];

      UIButton *btnSupport = [UIButton buttonWithType:UIButtonTypeCustom];
      btnSupport.frame = CGRectMake(10, yAxis + rect.size.height + 5, 80, 21);
      btnSupport.tag = tag;
      [btnSupport setTitle:@"click to support" forState:UIControlStateNormal];
      [btnSupport setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
      btnSupport.backgroundColor = [UIColor setCustomSignUpColor];
      btnSupport.titleLabel.font = [UIFont systemFontOfSize:10];
      btnSupport.layer.cornerRadius = 5.0;
      [btnSupport addTarget:self action:@selector(supportBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
      [scrollVw addSubview:btnSupport];

      yAxis = yAxis + rect.size.height + 30;
      tag = tag + 1;
    }
  }

  UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  yAxis + 7 , vwTranslation.frame.size.width - 20, 1)];
  imgVwLine1.backgroundColor = [UIColor lightGrayColor];
  [scrollVw addSubview:imgVwLine1];

  scrollVw.contentSize = CGSizeMake(scrollVw.frame.size.width, (yAxis+ 20));

  if (self.dictSelfSeggeddion.count == 0) {

    UILabel *lblNoSupport = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.origin.y + imgVwLine1.frame.size.height + 10, scrollVw.frame.size.width - 20, 21)];
    lblNoSupport.textColor = [UIColor darkGrayColor];
    lblNoSupport.text = @"If you don't support above translation";
    lblNoSupport.font = [UIFont systemFontOfSize:13.0f];
    [scrollVw addSubview:lblNoSupport];

    btnAddTranslation = [UIButton buttonWithType:UIButtonTypeCustom];
    btnAddTranslation.frame = CGRectMake(10, lblNoSupport.frame.origin.y + lblNoSupport.frame.size.height + 5, 135, 21);
    [btnAddTranslation setTitle:@"Add your translation" forState:UIControlStateNormal];
    [btnAddTranslation setTitleColor:[UIColor setCustomSignUpColor] forState:UIControlStateNormal];
    btnAddTranslation.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btnAddTranslation addTarget:self action:@selector(addTranslation) forControlEvents:UIControlEventTouchUpInside];
    [scrollVw addSubview:btnAddTranslation];

    scrollVw.contentSize = CGSizeMake(scrollVw.frame.size.width, (btnAddTranslation.frame.size.height +btnAddTranslation.frame.origin.y + 20));
  }
}

- (void)addTranslation {

  self.txtFiledTranslation = [[CustomTextField  alloc]initWithFrame:CGRectMake(10, btnAddTranslation.frame.origin.y + btnAddTranslation.frame.size.height + 10, scrollVw.frame.size.width - 20, 30) withImage:@""];
  self.txtFiledTranslation.delegate = self;
  self.txtFiledTranslation.returnKeyType = UIReturnKeyDone;
  self.txtFiledTranslation.textColor = [UIColor setCustomColorOfTextField];
  self.txtFiledTranslation.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Enter Translation" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];
  [scrollVw addSubview:self.txtFiledTranslation];

  UIButton *btnAdd = [UIButton buttonWithType:UIButtonTypeCustom];
  btnAdd.frame = CGRectMake(scrollVw.frame.size.width - 160, self.txtFiledTranslation.frame.origin.y + self.txtFiledTranslation.frame.size.height + 5, 70, 30);
  [btnAdd setTitle:@"Add" forState:UIControlStateNormal];
  btnAdd.backgroundColor = [UIColor setCustomSignUpColor];
  [btnAdd addTarget:self action:@selector(postTranslation) forControlEvents:UIControlEventTouchUpInside];
  [scrollVw addSubview:btnAdd];

  UIButton *btnCancel  = [UIButton buttonWithType:UIButtonTypeCustom];
  btnCancel.frame = CGRectMake((scrollVw.frame.size.width - 80), btnAdd.frame.origin.y , 70, 30);
  [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
  btnCancel.backgroundColor = [UIColor setCustomRedColor];
  [btnCancel addTarget:self action:@selector(hideTranslationViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
  [scrollVw addSubview:btnCancel];

  scrollVw.contentSize = CGSizeMake(scrollVw.frame.size.width, (btnCancel.frame.size.height +btnCancel.frame.origin.y + 20));
}

- (void)postTranslation {

  [self.view endEditing:YES];
  [self showActivityIndicator];
  NSDictionary *dict = @{@"language_id":userObject.language,
                         @"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                         @"translation":self.txtFiledTranslation.text
                         };

  NSDictionary *param = @{@"belief_translation": dict};
  if ([ConstantClass checkNetworkConection] == YES) {

    [self.api callPostUrlWithHeader:param method:@"/api/v1/belief_translation" success:^(AFHTTPRequestOperation *task, id responseObject) {

      [vwTranslation removeFromSuperview];
      [self translatebtnTapped:self.objBeliefForTranslation];
      [self hideActivityIndicator];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {

      NSString *strError = task.responseString;
      UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alertVw show];
      [self hideActivityIndicator];
    }];
  } else {
    [self hideActivityIndicator];
  }
}

- (void)supportBtnTapped:(id)sender {

  if (self.dictSelfSeggeddion.count != 0) {
    UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Not Supported!" message:@"You alreadt created translation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertVw show];
    return;
  }

  if (isUserDispose == 1) {
    UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Not Supported!" message:@"You cannot support more then one translation." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alertVw show];
    return;
  }

  UIButton *btnSender = (UIButton *)sender;
  NSDictionary *dictTranslation = [self.arryTranslations objectAtIndex:btnSender.tag];

  NSDictionary *param = @{@"belief_translation_id":[NSNumber numberWithInteger:[[dictTranslation valueForKey:@"id"] integerValue]]};
  if ([ConstantClass checkNetworkConection] == YES) {

    [self.api callPostUrlWithHeader:param method:@"/api/v1/toggle_translation_support" success:^(AFHTTPRequestOperation *task, id responseObject) {
      isUserDispose = 1;
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      NSString *strError = task.responseString;
      UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
      [alertVw show];
    }];
  } else {
    [self hideActivityIndicator];
  }
}

#pragma mark - UIText Field Deleagets

- (void)textFieldDidBeginEditing:(UITextField *)textField {
  scrollVw.contentOffset = CGPointMake(0, 180);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  return [textField resignFirstResponder];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
  scrollVw.contentOffset = CGPointMake(0, 0);
}

#pragma mark - Send Keep me posted
/**************************************************************************************************
 Function to add and show keep me posted
 **************************************************************************************************/
- (void)keepmePostedBtnTapped:(Belief *)belief withTag:(NSInteger)tag {
  if([self isauth_Token_Exist]){
  self.objBeliefForTranslation = belief;
  [self showKeepMePostVwWithAnimation];
  tbleVwcell = (TableViewCell*)[self.tbleVwBelief cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
  }else{
    [self alertMassege];
  }
}

- (void)addKeepMePostView {

  vwKeepMwPosted = [[KeepMePostView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.tbleVwBelief.frame.size.height)];
  [vwKeepMwPosted setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
  vwKeepMwPosted.delegate = self;
  [vwKeepMwPosted setHidden:YES];
  [self.view addSubview:vwKeepMwPosted];
}

- (void)showKeepMePostVwWithAnimation {

  [self addKeepMePostView];
  [UIView animateWithDuration:0.4 animations:^{
    vwKeepMwPosted.hidden = NO;
  }];
}

  //Send Keep me posted Delegates
- (void)cancelBtnTapped {

  ispageExist = YES;
  [self.view endEditing:YES];
  [UIView animateWithDuration:0.4 animations:^{
    [vwKeepMwPosted removeFromSuperview];
    self.objBeliefForTranslation = nil;
  }];
}

- (void)sendKeepMePosted:(NSInteger)duration {

  if (duration == 0) {
    UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select one type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertVw show];
    return;
  }

  NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                          @"duration":[NSNumber numberWithInteger:duration]
                          };
  if ([ConstantClass checkNetworkConection] == YES) {

    dispatch_queue_t queue = dispatch_queue_create("KeepMePosted", NULL);
    dispatch_async(queue, ^ {
      [self.api callPostUrlWithHeader:param method:@"/api/v1/keep_me_notified" success:^(AFHTTPRequestOperation *task, id responseObject) {
        dispatch_async (dispatch_get_main_queue(), ^{
          [tbleVwcell.customVwOfBtns.btnNotes setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];
        });
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
      }];
    });
  } else {
    [self hideActivityIndicator];
  }
  [self cancelBtnTapped];
}

- (void)linkBtnTapped:(Belief *)belief {
  
  BrowserViewController *vwController = [self.storyboard instantiateViewControllerWithIdentifier:@"BrowserVC"];
  vwController.strBrowseUrl = belief.weblink;
  UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vwController];
  [self presentViewController:navController animated:YES completion:nil];
  
  }

#pragma mark - Flag btn tapped
/**************************************************************************************************
 Function to add and show flag view
 **************************************************************************************************/

- (void)addFlagView {

  vwFlag = [[FlagView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.tbleVwBelief.frame.size.height)];
  [vwFlag setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.3]];
  vwFlag.delegate = self;
  [vwFlag setHidden:YES];
  [self.view addSubview:vwFlag];
}

- (void)showFlagVwWithAnimation {

  [self addFlagView];
  [UIView animateWithDuration:0.4 animations:^{
    vwFlag.hidden = NO;
  }];
}

  // Flag Delegates
- (void)cancelFlagBtnTapped {

  [self.view endEditing:YES];
  [UIView animateWithDuration:0.4 animations:^{
    [vwFlag removeFromSuperview];
    self.objBeliefForTranslation = nil;
  }];
}

- (void)sendFlag:(NSString *)strFlagStatus {

  if (strFlagStatus.length == 0) {
    UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select one type." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertVw show];
    return;
  }

  NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                          @"text":strFlagStatus
                          };
  if ([ConstantClass checkNetworkConection] == YES) {
    [self.api callPostUrlWithHeader:param method:@"/api/v1/flag_belief" success:^(AFHTTPRequestOperation *task, id responseObject) {

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
  } else {
    [self hideActivityIndicator];
  }
  [self cancelFlagBtnTapped];
}

- (void)supportOpposeBtnTapped {
  if([self isauth_Token_Exist]){
  if (isSearch == NO){
    //[self getAllBelievesList];
      [self viewDidAppear:false];
  }
  }else{
    [self alertMassege];
  }
  
}

- (void)fileItBtnTapped:(NSInteger)cellTag {
  if([self isauth_Token_Exist]){
  [self.arryBeliefs removeObjectAtIndex:cellTag];
  [self.tbleVwBelief reloadData];
  }else{
    [self alertMassege];
  }
  }

#pragma amrk - Play btn tapped
- (void)videoBtnTapped:(Belief *)belief {
  
  if (belief.hasYouTubeUrl == YES) {
    [self submitYouTubeURL:belief];
  } else  if (belief.hasVideo == YES){
    [self playBtnTapped:belief];
  } if(belief.hasImage == YES) {
    ShowImageOrVideoViewController *vcShowImgOrVideo = [self.storyboard instantiateViewControllerWithIdentifier:@"PlayVideo"];
    vcShowImgOrVideo.belief = belief;
    UINavigationController *navController = [[UINavigationController alloc]initWithRootViewController:vcShowImgOrVideo];
    [self presentViewController:navController animated:YES completion:nil];
  }
  
}

#pragma mark - Play button tapped
- (void)playBtnTapped:(Belief *)belief {

    self.mpvc = [[MPMoviePlayerViewController alloc] init];
        // [self.view addSubview:self.mpvc.view];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(doneButtonClick:)
                                                 name:MPMoviePlayerWillExitFullscreenNotification
                                               object:nil];

    self.mpvc.moviePlayer.contentURL = [NSURL URLWithString:belief.videoUrl];
    [self.mpvc.view setFrame:self.view.frame];
    [self.mpvc.moviePlayer setUseApplicationAudioSession:NO];
    self.mpvc.view.hidden = NO;
    [self presentViewController:self.mpvc animated:YES completion:^{
        self.mpvc.moviePlayer.allowsAirPlay = YES;
        [[self.mpvc moviePlayer] setControlStyle:2];
        self.mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
        self.mpvc.moviePlayer.shouldAutoplay = YES;
    }];
}

#pragma mark - Play Youtube url
- (void)submitYouTubeURL:(Belief *)belief {

  _urlToLoad = nil;
  NSURL *url = [NSURL URLWithString:belief.youtubeUrl];
  [HCYoutubeParser thumbnailForYoutubeURL:url thumbnailSize:YouTubeThumbnailDefaultHighQuality completeBlock:^(UIImage *image, NSError *error) {

    if (!error) {
      [HCYoutubeParser h264videosWithYoutubeURL:url completeBlock:^(NSDictionary *videoDictionary, NSError *error) {
        NSDictionary *qualities = videoDictionary;
        NSString *URLString = nil;
        if ([qualities objectForKey:@"small"] != nil) {
          URLString = [qualities objectForKey:@"small"];
        }
        else if ([qualities objectForKey:@"live"] != nil) {
          URLString = [qualities objectForKey:@"live"];
        }
        else {
          [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Couldn't find youtube video." delegate:nil cancelButtonTitle:@"Close" otherButtonTitles: nil] show];
          return;
        }
          _urlToLoad = [NSURL URLWithString:URLString];
              // [self.view addSubview:self.mpvc.view];
          [[NSNotificationCenter defaultCenter] addObserver:self
                                                   selector:@selector(doneButtonClick:)
                                                       name:MPMoviePlayerWillExitFullscreenNotification
                                                     object:nil];
          self.mpvc = [[MPMoviePlayerViewController alloc] init];
          self.mpvc.moviePlayer.contentURL = _urlToLoad;
          [self.mpvc.view setFrame:self.view.frame];
          self.mpvc.view.hidden = NO;
          [self.mpvc.moviePlayer setUseApplicationAudioSession:NO];
          [self presentViewController:self.mpvc animated:YES completion:^{
              self.mpvc.moviePlayer.allowsAirPlay = YES;
              [[self.mpvc moviePlayer] setControlStyle:2];
              //self.mpvc.moviePlayer.movieSourceType = MPMovieSourceTypeStreaming;
              self.mpvc.moviePlayer.shouldAutoplay = YES;
          }];
      }];
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
      [alert show];
    }
  }];
}

- (void)doneButtonClick:(NSNotification*)aNotification {

  NSNumber *reason = [aNotification.userInfo objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];

  if ([reason intValue] == MPMovieFinishReasonUserExited) {

    [self.mpvc.moviePlayer stop];
    [self dismissMoviePlayerViewControllerAnimated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerWillExitFullscreenNotification object:nil];
  }
}

- (void)navigateToCommentBtnTapped:(Belief *)belief {
  if([self isauth_Token_Exist]){
    [self supportCommentBtnTapped:belief];
  }else{
    [self alertMassege];
  }
  }

#pragma mark - Support button tapped
- (void)supportCommentBtnTapped:(Belief *)belief  {

  SupportCommentViewController *vcSupposeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SupposeOpposeVC"];

  if (![belief.dictDisposition isKindOfClass:[NSNull class]]) { //(![belief.dictDisposition isKindOfClass:[NSNull class]]) {
    NSDictionary * dict = belief.dictDisposition;

    if (dict.count == 0){

      vcSupposeVC.isTrash = 1;
      vcSupposeVC.belief_Id = belief.beliefId;
    } else {

      if ([[dict valueForKey:@"is_trashed"] isKindOfClass:[NSNull class]]) {
        vcSupposeVC.isTrash = 0;
      } else {
        vcSupposeVC.isTrash = [[dict valueForKey:@"is_trashed"]boolValue];
      }
      vcSupposeVC.isSupport = [[dict valueForKey:@"is_supported"]boolValue];
    }
    vcSupposeVC.belief_Id = belief.beliefId;
    vcSupposeVC.strTitle = belief.statement;
  }

  [self.navigationController pushViewController:vcSupposeVC animated:YES];
}

#pragma mark - Open Slider

- (IBAction)openSideBar:(id)sender {
  if([self isauth_Token_Exist]){
    sharedAppDelegate.navController = self.navigationController;
    sharedAppDelegate.sideBar.tbleVwSideBar.reloadData;
    sharedAppDelegate.sideBar.delegate = self;
    if (sharedAppDelegate.isSliderOPen == NO) {

        sharedAppDelegate.isSliderOPen = YES;
        [UIView animateWithDuration:0.3 animations:^(void) {
            [sharedAppDelegate.sideBar setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        }];
        [sharedAppDelegate.window bringSubviewToFront:sharedAppDelegate.sideBar];
    }
  }else{
    [self alertMassege];
  }
}


#pragma mark - Open Slider

- (IBAction)tapFilter:(id)sender {
  if([self isauth_Token_Exist]){
    SearchDetailViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchVC"];
    [self.navigationController pushViewController:vc animated:true];

  }else{
    [self alertMassege];
  }
}


#pragma mark - Close Slider

- (void)closeSideBar {
    sharedAppDelegate.navController = self.navigationController;
    sharedAppDelegate.sideBar.tbleVwSideBar.reloadData;
    sharedAppDelegate.sideBar.delegate = self;
    if (sharedAppDelegate.isSliderOPen == NO) {
      
      sharedAppDelegate.isSliderOPen = NO;
      [UIView animateWithDuration:0.3 animations:^(void) {
        [sharedAppDelegate.sideBar setFrame:CGRectMake(-self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
      }];
      [sharedAppDelegate.window bringSubviewToFront:sharedAppDelegate.sideBar];
    }
}




- (void)popViewController:(UIViewController*)vwController{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)logoutBtnTapped {

    if ([ConstantClass checkNetworkConection] == YES) {
        [self.api callDeleteUrl:nil method:@"/api/v1/sessions/sign_out" success:^(AFHTTPRequestOperation *task, id responseObject) {

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:SEARCH_KEYS];
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"userlanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self closeSideBar];
            [self logoutAlertMsg];
            //[self.tbleVwBelief reloadData];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        }];
       // [self.navigationController popToRootViewControllerAnimated:NO];
      
        [User MR_truncateAll];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
      
    } else {
      [self hideActivityIndicator];
    }
}

-(void)logoutAlertMsg{
  UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:nil message:@"Successfully logout." delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
  [alertVw show];
}

#pragma mark - Go to admin part
/**************************************************************************************************
 Function to Go to admin part
 **************************************************************************************************/
- (void)gotoAdminPart {

    UITabBarController *tBCAdmin= [[UITabBarController alloc] init];

    UIViewController *vcSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"searchUser"];
    UIViewController *vcAdmin = [self.storyboard instantiateViewControllerWithIdentifier:@"admin"];
    UIViewController *vcModerator = [self.storyboard instantiateViewControllerWithIdentifier:@"moderator"];

    tBCAdmin.viewControllers = @[vcAdmin, vcSearch, vcModerator];
    tBCAdmin.hidesBottomBarWhenPushed = YES;

    [[[tBCAdmin.viewControllers objectAtIndex:0] tabBarItem] setTitle:@"Category"];
    [[[tBCAdmin.viewControllers objectAtIndex:1] tabBarItem] setTitle:@"Users"];
    [[[tBCAdmin.viewControllers objectAtIndex:2] tabBarItem] setTitle:@"Moderator"];

    [self.navigationController pushViewController:tBCAdmin animated:YES];
}

- (void)addTableViewOfSearch {

  self.tbleVwAutoCorrection.frame = CGRectMake(0, 64, self.view.frame.size.width,self.view.frame.size.height/2);
  self.tbleVwAutoCorrection.dataSource = self;
  self.tbleVwAutoCorrection.delegate = self;
  self.tbleVwAutoCorrection.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
  self.tbleVwAutoCorrection.hidden = YES;
  self.tbleVwAutoCorrection.backgroundColor = [UIColor clearColor];
  [self.view bringSubviewToFront:self.tbleVwAutoCorrection];
}

@end
