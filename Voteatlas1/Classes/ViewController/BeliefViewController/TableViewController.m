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

#define IMG_HGT 120
#define CUSTOME_BTN_HGT 44

@interface TableViewController () <CustomeTableViewDelegate, CalloutAnnotationViewDelegate, UITextFieldDelegate, keepMePostedDelegate,FlagDelegate>{

    UISearchBar *searchBarVote;
    NSInteger rowIndex;
    BOOL isSearch;
    UIActivityIndicatorView *activityIndicator;
    UIButton *btnHideMap;
    UIView *vwTranslation;
    UILabel *lblStatement;
    UIScrollView *scrollVw;

    UIButton *btnAddTranslation;

    User *userObject;
    BOOL isUserDispose;

    KeepMePostView *vwKeepMwPosted;
    FlagView *vwFlag;
    TableViewCell *tbleVwcell;
}

@property(nonatomic, retain) AppApi *api;
@property (nonatomic, strong) NSMutableArray *arryBeliefs;
@property (nonatomic, strong) NSMutableArray *arrySearchBeliefs;
@property (nonatomic, strong) NSMutableArray *arrySupportLocation;
@property (nonatomic, strong) NSMutableArray *arryOpposeLocation;
@property (nonatomic, strong) CustomTextField *txtFiledTranslation;
@property (nonatomic, strong) Belief *objBeliefForTranslation;
@property (nonatomic, strong) NSMutableArray *arryTranslations;
@property (nonatomic, strong) NSMutableDictionary *dictSelfSeggeddion;

@end

@implementation TableViewController
@synthesize mapVwBelief;

#pragma mark - View Controller Configration

- (void)viewDidLoad {

    [super viewDidLoad];

    self.api = [AppApi sharedClient];
    [self configureSearchBar];

    [[NSUserDefaults standardUserDefaults]removeObjectForKey:SEARCH_KEYS];
    [[NSUserDefaults standardUserDefaults]synchronize];

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

    [self addTranslationView]; //add translation view
    self.mapVwBelief.frame = CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 0, 0);
    self.mapVwBelief.zoomEnabled = NO;

    NSArray *arrFetchedData = [User MR_findAll];
    userObject = [arrFetchedData objectAtIndex:0];
    NSLog(@"%@ %@",userObject.language, userObject.name);
    self.tbleVwBelief.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tbleVwBelief.separatorColor = [UIColor setCustomColorOfTextField];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSDictionary *dictSearch = [[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS];
    if (dictSearch.count != 0) {
        if ([[dictSearch valueForKey:@"category"]integerValue] != 0) {
            [self getAllBelievesAccordingToCategory];
        } else {
            [self getAllBelievesAccordingToSearch];
        }
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:SEARCH_KEYS];
    } else {
        [self getAllBelievesList];
    }
}

#pragma mark - Set default setting of UI
- (void)defaulUISettings {
    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    } else if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    } else if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    } else if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(tapRightBarBtn:)];
    barBtnAdd.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setRightBarButtonItem:barBtnAdd];

    UIBarButtonItem *barBtnSearch = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"eye"] style:UIBarButtonItemStylePlain target:self action:@selector(tapLeftBarBtn:)];
    barBtnSearch.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:barBtnSearch];
}

- (void)writeSomething:(id)sender {

}

#pragma mark - Add Search bar

- (void)configureSearchBar{

    searchBarVote = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 2.0,self.view.frame.size.width - 110, 35.0)];
    searchBarVote.searchBarStyle = UISearchBarStyleMinimal;
    searchBarVote.delegate = self;
        //  UIView *searchBarView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 260.0, 44.0)];
        // [searchBarView addSubview:searchBarVote];
    self.navigationItem.titleView = searchBarVote;
    self.arryBeliefs = [[NSMutableArray alloc]init];
    self.arrySearchBeliefs = [[NSMutableArray alloc]init];
}

#pragma mark - Remove background of search bar

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

- (void)whenRightItemTapped:(id)sender{

}

- (void)whenLeftItemTapped:(id)sender{
  
}

#pragma mark - Get belief list
- (void)getAllBelievesList{

    if ([ConstantClass checkNetworkConection] == YES) {

        dispatch_queue_t queue = dispatch_queue_create("get belief", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{

                [self.api callGETUrlWithHeaderAuthentication:nil method:@"/api/v1/all_list_beliefs" success:^(AFHTTPRequestOperation *task, id responseObject) {
                    NSLog(@"%@",responseObject);

                    NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
                    NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];

                    if (arryBelief.count == 0) {
                        [self NoDataInlist];
                        return;
                    }
                    [self.arryBeliefs removeAllObjects];
                    [self convertDataIntoModelClass:arryBelief];
                    [self.tbleVwBelief reloadData];
                    [self hideActivityIndicator];
                    self.tbleVwBelief.hidden = NO;
                } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self hideActivityIndicator];
                }];
            });
        });
    }
}

#pragma mark - get search belief

- (void)getAllBelievesAccordingToSearch {

    if ([ConstantClass checkNetworkConection] == YES) {

        NSDictionary *param = [[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS];
        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/sort_search" success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSLog(@"%@",responseObject);

            NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
            NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
            [self.arryBeliefs removeAllObjects];
            [self convertDataIntoModelClass:arryBelief];
            [self.tbleVwBelief reloadData];
            self.tbleVwBelief.hidden = NO;
            [self hideActivityIndicator];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@",error);
            [self hideActivityIndicator];

            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No recoed found." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];

        }];
    }
}

#pragma mark - Get search belief according to category
- (void)getAllBelievesAccordingToCategory {

    if ([ConstantClass checkNetworkConection] == YES) {

        NSDictionary *param = [[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS];
        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/category_search" success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSLog(@"%@",responseObject);

            NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
            NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
            [self.arryBeliefs removeAllObjects];
            [self convertDataIntoModelClass:arryBelief];
            [self.tbleVwBelief reloadData];
            self.tbleVwBelief.hidden = NO;
            [self hideActivityIndicator];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@",error);
            [self hideActivityIndicator];
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"No recoed found for this category." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];
        }];
    }
}

#pragma mark - When no data in list

- (void)NoDataInlist {

    UIButton *btnNodata = [[UIButton alloc]initWithFrame:CGRectMake((self.view.frame.size.width - 12)/2, (self.view.frame.size.height - 112)/2, 112, 112)];
    [btnNodata setImage:[UIImage imageNamed:@"sad"] forState:UIControlStateNormal];
    [btnNodata addTarget:self action:@selector(profileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNodata];
}

#pragma mark - Convert data in to model class
- (void)convertDataIntoModelClass:(NSArray *)arryBelief {

    NSLog(@"%@", arryBelief);
    if (arryBelief.count !=0 && isSearch == NO) {
        //[self.arryBeliefs removeAllObjects];
    }
    if (isSearch == YES) {
        [self.arrySearchBeliefs removeAllObjects];
    }

    @autoreleasepool {
        for (NSDictionary *dictBelief in arryBelief) {

            Belief *objBelief = [[Belief alloc]init];
            objBelief.beliefId = [[dictBelief valueForKey:@"id"] integerValue];
            objBelief.statement = [dictBelief valueForKey:@"text"];
            objBelief.hasImage = [[dictBelief valueForKey:@"has_image"] boolValue];
            objBelief.hasVideo = [[dictBelief valueForKey:@"has_video"]boolValue];
            objBelief.hasYouTubeUrl = [[dictBelief valueForKey:@"has_youtube_video"]boolValue];

            if (objBelief.hasVideo == 1) {
                objBelief.videoUrl = [dictBelief valueForKey:@"video_url"];
                objBelief.thumbImage_Url = [[dictBelief valueForKey:@"video_image"] valueForKey:@"url"];
                NSLog(@"%@", objBelief.thumbImage_Url);
            }

            if (objBelief.hasImage == 1) {
                objBelief.imageUrl = [dictBelief valueForKey:@"image_url"];
            }

            if (objBelief.hasYouTubeUrl == 1) {
                objBelief.youtubeUrl = [dictBelief valueForKey:@"youtube_url"];
                objBelief.thumbImage_Url = [dictBelief valueForKey:@"youtube_image"];
            }

            if (![[dictBelief valueForKey:@"get_desposition"] isKindOfClass:[NSNull class]]) {
                objBelief.dictDisposition = [dictBelief valueForKey:@"get_desposition"];
            }

            if (![[dictBelief valueForKey:@"language_id"] isKindOfClass:[NSNull class]]) {
                objBelief.languageId = [dictBelief valueForKey:@"language_id"];
            }

            if (isSearch == YES) {
                [self.arrySearchBeliefs addObject:objBelief];
            } else {
                [self.arryBeliefs addObject:objBelief];
            }
        }
    }
    NSLog(@"%@", self.arryBeliefs);
}

- (void)whenSearchTapped:(id)sender{
  
}

#pragma mark - UISearch bar Delegates
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
        // [self chakeNetworkConection];

    [searchBar resignFirstResponder];
    NSDictionary *dict = @{@"text":searchBar.text};
    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callPostUrl:dict method:@"/api/v1/search" success:^(AFHTTPRequestOperation *task, id responseObject) {

            NSLog(@"%@", responseObject);
            NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
            NSArray *arryBelief = [dictResponse valueForKey:@"beliefs"];
            isSearch = YES;
            [self convertDataIntoModelClass:arryBelief];
            [self.tbleVwBelief reloadData];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@", task.responseString);
        }];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [searchBar resignFirstResponder];
    searchBarVote.text = @"";
    isSearch = NO;
    [self.tbleVwBelief reloadData];
}


#pragma mark - UIBar button action
- (void)tapRightBarBtn:(id)sender {
  BelieveViewController *vcBelief = [self.storyboard instantiateViewControllerWithIdentifier:@"BelieveID"];
  vcBelief.userID = self.userID;
  [self.navigationController pushViewController:vcBelief animated:YES];
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
    if (isSearch == YES) {
        return [[self arrySearchBeliefs]count ];
    } else {
        return [[self arryBeliefs] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];

    Belief *objBelief;
    if (isSearch == YES) {
        objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
    } else {
        objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
    }

    cell.delegate = self;
    [cell setValueInTableVw:objBelief withVwController:self forRow:indexPath.row withCellWidth:self.tbleVwBelief.frame.size.width withLaguagleId:userObject.language];
    [cell.btnProfilPic addTarget:self action:@selector(profileBtnTapped:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - Table view data Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    rowIndex = indexPath.row;
    DetailPageViewController *vcDetailPage = [self.storyboard instantiateViewControllerWithIdentifier:@"detailPage"];
    [searchBarVote resignFirstResponder];
    Belief *objBelief;
    if (isSearch == YES) {
        objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
    } else {
        objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
    }
    vcDetailPage.belief_Id = objBelief.beliefId;
    [self.navigationController pushViewController:vcDetailPage animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Belief *objBelief;
    if (isSearch == YES) {
        objBelief = [[self arrySearchBeliefs] objectAtIndex:indexPath.row];
    } else {
        objBelief = [[self arryBeliefs] objectAtIndex:indexPath.row];
    }

    NSString *strSuppose = objBelief.statement;
    CGRect rect = [strSuppose boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-140, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    if (rect.size.height > 64) {
        return (rect.size.height + CUSTOME_BTN_HGT + IMG_HGT + 41);
    } else {
        return 263;
    }
}

#pragma mark - Profile Btn tapped
- (void)profileBtnTapped:(id)sender {
    ProfileViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfilID"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Delegates of Custom button view
- (void)sharebtnTapped:(Belief*)belief {
    NSString *url;
    if (belief.imageUrl.length != 0){
        url = belief.imageUrl;
    } else if (belief.videoUrl.length != 0) {
        url = belief.videoUrl;
    } else if (belief.youtubeUrl.length != 0) {
        url = belief.youtubeUrl;
    }

    NSString *strShare = [NSString stringWithFormat:@"Voteatlas-- \n %@ \n  %@", belief.statement, url];
    NSArray *objectsToShare = @[strShare];

    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    controller.excludedActivityTypes = @[UIActivityTypeMessage];
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - Map view method
- (void)addMapView {

    self.vwMap.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.vwMap.frame = self.view.frame;

    btnHideMap = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHideMap.frame = CGRectMake(self.view.frame.size.width - 40, 75, 35, 35);
    [btnHideMap setTitle:@"X" forState:UIControlStateNormal];
    [btnHideMap setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnHideMap addTarget:self action:@selector(hideViewWithAnimation) forControlEvents:UIControlEventTouchUpInside];
    btnHideMap.titleLabel.textColor = [UIColor darkGrayColor];
    [self.vwMap addSubview:btnHideMap];
}

- (void)showViewWithAnimation {

    [UIView animateWithDuration:0.4 animations:^{
        [self.vwMap setHidden:NO];
        mapVwBelief.frame = CGRectMake(10, 100, self.tbleVwBelief.frame.size.width - 20, self.tbleVwBelief.frame.size.height - 130);
        [mapVwBelief setHidden:NO];
    }completion:^(BOOL finished) {
        [self addAnotation];
    }];
}

- (void)hideViewWithAnimation {

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
             //annotation.coordinate = coordinate2d;

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

- (void)mapbtnTapped:(Belief *)belief {
    NSDictionary *param = @{@"belief":[NSNumber numberWithInteger:belief.beliefId]};

    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callGETUrl:param method:@"/api/v1/map" success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSLog(@"%@",responseObject);

            NSDictionary *dictResponse = [responseObject valueForKey:@"data"];
            NSArray *arryOppose = [dictResponse valueForKey:@"belief_oppose"];

            @autoreleasepool {
                for (NSDictionary *dictMap in arryOppose) {
                    MapLocations*objMapLocation = [[MapLocations alloc]init];
                    objMapLocation.title = @"oppose";
                    objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
                    objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
                    objMapLocation.suppose = [dictResponse valueForKey:@"agree"];
                    objMapLocation.oppose = [dictResponse valueForKey:@"dis_agree"];
                    [self.arryOpposeLocation addObject:objMapLocation];
                }
            }

            NSArray *arryBeliefSupport = [dictResponse valueForKey:@"beliefs_support"];
            @autoreleasepool {
                for (NSDictionary *dictMap in arryBeliefSupport) {
                    MapLocations*objMapLocation = [[MapLocations alloc]init];
                    objMapLocation.title = @"support";
                    objMapLocation.latitute = [[[dictMap objectForKey:@"location"]valueForKey:@"latitude"] floatValue];
                    objMapLocation.longitute = [[[dictMap objectForKey:@"location"]valueForKey:@"longitude"]floatValue];
                    objMapLocation.suppose = [dictResponse valueForKey:@"agree"];
                    objMapLocation.oppose = [dictResponse valueForKey:@"dis_agree"];
                    [self.arrySupportLocation addObject:objMapLocation];
                }
            }

            [self.mapVwBelief removeAnnotations:self.mapVwBelief.annotations];
            [self showViewWithAnimation];

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@",error);

        }];
    }
}

#pragma mark - MKMapView delegate

- (MKAnnotationView *)mapView:(MKMapView *)mapview viewForAnnotation:(id <MKAnnotation>)annotation {
    MKAnnotationView *annotationView;
    NSString *identifier;

    if ([annotation isKindOfClass:[PinAnnotation class]]) {
            // Pin annotation.
        identifier = @"Pin";
        annotationView = (MKPinAnnotationView *)[mapVwBelief dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
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
                             mapVwBelief.centerCoordinate = calloutAnnotation.coordinate;
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

#pragma mark - Activity Indicator

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

- (void)addTranslationView {

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

    UILabel *lblHeading = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, vwTranslation.frame.size.width - 30, 42)];
    lblHeading.numberOfLines = 0;
    lblHeading.text = @"Translate the statement below from english to hindi";
    lblHeading.textColor = [UIColor darkGrayColor];
    lblHeading.font = [UIFont systemFontOfSize:15.0f];
    [scrollVw addSubview:lblHeading];

    UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 55, vwTranslation.frame.size.width - 20, 1)];
    imgVwLine1.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine1];

    lblStatement = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.origin.y + 10, vwTranslation.frame.size.width - 20, 21)];
    lblStatement.numberOfLines = 0;
    lblStatement.textColor = [UIColor darkGrayColor];
    lblStatement.font = [UIFont systemFontOfSize:13.0f];
    [scrollVw addSubview:lblStatement];
}

#pragma mark - Translation btn tapped

- (void)translatebtnTapped:(Belief*)belief {
    [self showTranslationVwWithAnimation];

    NSString *strSuppose = belief.statement;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-60, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    lblStatement.frame = CGRectMake(10, lblStatement.frame.origin.y, vwTranslation.frame.size.width - 20, rect.size.height);
    lblStatement.text = belief.statement;

    UIImageView *imgVwLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, lblStatement.frame.origin.y + lblStatement.frame.size.height + 5, vwTranslation.frame.size.width - 20, 1)];
    imgVwLine2.backgroundColor = [UIColor lightGrayColor];
    [scrollVw addSubview:imgVwLine2];

    [self callTranslateApi:belief];
    [self.view bringSubviewToFront:activityIndicator];
    [self showActivityIndicator];
}

- (void)showTranslationVwWithAnimation {
    [self addTranslationView];
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

#pragma mark - call translation api

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
    }
}

- (void)setValuesOfTranslation :(NSDictionary *)response {

    NSDictionary * dictVerified;

    NSLog(@"%@ ****** %@", self.dictSelfSeggeddion, self.arryTranslations);

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
    NSLog(@"%@", self.dictSelfSeggeddion);

    if ([[response valueForKey:@"verified_translation"] isKindOfClass:[NSDictionary class]]) {
        if ([[response valueForKey:@"verified_translation"]count ] != 0) {
            dictVerified = [response valueForKey:@"verified_translation"];
        }
    }

    isUserDispose = [[response valueForKey:@"user_dispose"] boolValue]; //user Dispose

    int yAxisOfSuggestedHeading = lblStatement.frame.origin.y + lblStatement.frame.size.height + 10;

    if (dictVerified.count != 0) {
        UILabel *lblVerified = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading, vwTranslation.frame.size.width - 20, 21)];
        lblVerified.textColor = [UIColor darkGrayColor];
        lblVerified.text = @"Verified Translation :";
        lblVerified.font = [UIFont boldSystemFontOfSize:14.0f];
        [scrollVw addSubview:lblVerified];

        UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, lblVerified.frame.size.height + lblVerified.frame.origin.y + 5 , vwTranslation.frame.size.width - 20, 1)];
        imgVwLine1.backgroundColor = [UIColor lightGrayColor];
        [scrollVw addSubview:imgVwLine1];

        NSString *strTranslate = [dictVerified valueForKey:@"translation"];
        CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-60, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

        UILabel *lblVerifiedTrana = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 5 , vwTranslation.frame.size.width - 20, rect.size.height)];
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
        CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-60, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

        UILabel *lblSelfSuggestedTrans = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading + 25, vwTranslation.frame.size.width - 20, rect.size.height)];
        lblSelfSuggestedTrans.textColor = [UIColor darkGrayColor];
        lblSelfSuggestedTrans.text = strTranslate;
        lblSelfSuggestedTrans.font = [UIFont systemFontOfSize:13.0f];
        [scrollVw addSubview:lblSelfSuggestedTrans];

        UIImageView *imgVwLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0,  lblSelfSuggestedTrans.frame.size.height + lblSelfSuggestedTrans.frame.origin.y + 5 , vwTranslation.frame.size.width - 20, 1)];
        imgVwLine1.backgroundColor = [UIColor lightGrayColor];
        [scrollVw addSubview:imgVwLine1];


        yAxisOfSuggestedHeading = imgVwLine1.frame.size.height + imgVwLine1.frame.origin.y + 10;
    }

    UILabel *lblSuggestedTrans = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxisOfSuggestedHeading, vwTranslation.frame.size.width - 20, 21)];
    lblSuggestedTrans.textColor = [UIColor darkGrayColor];
    lblSuggestedTrans.text = @"Suggested translations:";
    lblSuggestedTrans.font = [UIFont boldSystemFontOfSize:14.0f];
    [scrollVw addSubview:lblSuggestedTrans];

    int  yAxis = lblSuggestedTrans.frame.origin.y + lblSuggestedTrans.frame.size.height + 5;

    int tag = 0;
    if (self.arryTranslations.count == 0) {
        UILabel *lblNoTranslation = [[UILabel alloc]initWithFrame:CGRectMake(10, lblSuggestedTrans.frame.origin.y + lblSuggestedTrans.frame.size.height + 10, vwTranslation.frame.size.width - 20, 21)];
        lblNoTranslation.textColor = [UIColor darkGrayColor];
        lblNoTranslation.text = @"No Suggession Available";
        lblNoTranslation.font = [UIFont systemFontOfSize:13.0f];
        [scrollVw addSubview:lblNoTranslation];

        yAxis = yAxis + 21;
    } else {
        for (NSDictionary *dict in self.arryTranslations) {

            NSString *strTranslate = [dict valueForKey:@"translation"];
            CGRect rect =[strTranslate boundingRectWithSize:CGSizeMake(self.tbleVwBelief.frame.size.width-60, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

            UILabel *lblTranslation = [[UILabel alloc]initWithFrame:CGRectMake(10, yAxis, vwTranslation.frame.size.width - 20, rect.size.height)];
            lblTranslation.textColor = [UIColor darkGrayColor];
            lblTranslation.text = strTranslate;
            lblTranslation.font = [UIFont systemFontOfSize:13.0f];
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

         UILabel *lblNoSupport = [[UILabel alloc]initWithFrame:CGRectMake(10, imgVwLine1.frame.origin.y + imgVwLine1.frame.size.height + 10, vwTranslation.frame.size.width - 20, 21)];
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

    NSDictionary *dict = @{@"language_id":userObject.language,
                            @"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                            @"translation":self.txtFiledTranslation.text
                            };

    NSDictionary *param = @{@"belief_translation": dict};
    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callPostUrlWithHeader:param method:@"/api/v1/belief_translation" success:^(AFHTTPRequestOperation *task, id responseObject) {

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {

            NSString *strError = task.responseString;
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:strError delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertVw show];
        }];
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

- (void)keepmePostedBtnTapped:(Belief *)belief withTag:(NSInteger)tag {
    self.objBeliefForTranslation = belief;
    [self showKeepMePostVwWithAnimation];
    tbleVwcell = (TableViewCell*)[self.tbleVwBelief cellForRowAtIndexPath:[NSIndexPath indexPathForRow:tag inSection:0]];
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

#pragma mark - Send Keep me posted Delegates

- (void)cancelBtnTapped {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [vwKeepMwPosted removeFromSuperview];
        self.objBeliefForTranslation = nil;
    }];
}

- (void)sendKeepMePosted:(NSInteger)duration {
    if (duration == 0) {
        UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select one type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertVw show];
        return;
    }

    NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                            @"duration":[NSNumber numberWithInteger:duration]
                            };
    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callPostUrlWithHeader:param method:@"/api/v1/keep_me_notified" success:^(AFHTTPRequestOperation *task, id responseObject) {
            [tbleVwcell.customVwOfBtns.btnNotes setImage:[UIImage imageNamed:@"12.png"] forState:UIControlStateNormal];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@", task.responseString);
        }];
    }
    [self cancelBtnTapped];
}


#pragma mark - Flag btn tapped

- (void)flagBtnTapped:(Belief *)belief {

    self.objBeliefForTranslation = belief;
    [self showFlagVwWithAnimation];
}

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

#pragma mark - Flag Delegates

- (void)cancelFlagBtnTapped {
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [vwFlag removeFromSuperview];
        self.objBeliefForTranslation = nil;
    }];
}

- (void)sendFlag:(NSString *)strFlagStatus {
    if (strFlagStatus.length == 0) {
        UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Please select one type" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertVw show];
        return;
    }

    NSDictionary *param = @{@"belief_id":[NSNumber numberWithInteger:self.objBeliefForTranslation.beliefId],
                            @"text":strFlagStatus
                            };
    if ([ConstantClass checkNetworkConection] == YES) {
        [self.api callPostUrlWithHeader:param method:@"/api/v1/flag_belief" success:^(AFHTTPRequestOperation *task, id responseObject) {

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@", task.responseString);
        }];
    }
    [self cancelFlagBtnTapped];
}

- (void)supportOpposeBtnTapped {
    [self getAllBelievesList];
}

@end
