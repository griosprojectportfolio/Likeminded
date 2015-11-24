//
//  SearchDetailViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 27/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "SearchDetailViewController.h"
#import "ActionSheetPicker.h"
#import "ConstantClass.h"
#import "User.h"

@interface SearchDetailViewController () {

    NSArray *arryJustAdded;
    NSArray *arryGlobal;
    NSArray *arryAll;
    int categoryId;
    UIView *vwOverlay;
    UIActivityIndicatorView *activityIndicator;
    BOOL isFileIt;
    BOOL isTrash;
    User *userObject;

}
@property(nonatomic,strong)AppApi *api;
@property (nonatomic, strong) NSMutableDictionary *dictLocation;
@property (nonatomic, strong) NSMutableArray *arrayCategoryName;
@property (nonatomic, strong) NSMutableArray *arrayCategoryId;

@end

#pragma mark - View life cycle

@implementation SearchDetailViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    arryJustAdded = @[@"Just Added", @"Trending", @"Most Popular", @"None"];
    arryGlobal = @[@"Global", @"My Country", @"My State/Region", @"My Town/City", @"My Neighborhood"];

    self.title = @"Search / Filter";
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};

    self.arrayCategoryName = [[NSMutableArray alloc]init];
    self.arrayCategoryId = [[NSMutableArray alloc]init];
    self.dictLocation = [[NSMutableDictionary alloc]init];

    [self addActivityIndicator];
    [self setDefaultSeetingOfContent];
    // NSDictionary *dict = [[[NSUserDefaults standardUserDefaults]valueForKey:SEARCH_KEYS]valueForKey:@"search"];
    //if ([[dict valueForKey:@"trending"] length] != 0)
        //  txtFldJustAdded.text = [dict valueForKey:@"trending"];

    NSArray *arrFetchedData =[User MR_findAll];
    userObject = [arrFetchedData objectAtIndex:0];
    isFileIt = NO;
    isTrash = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    [self getAllFilterDataFromServer];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self getAllCategory];
}

#pragma mark - Set Default of content
- (void)setDefaultSeetingOfContent {

    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    } else if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    } else if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    } else if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    self.navigationItem.leftBarButtonItem = btnBack;

    imgVwBgImg.image = [UIImage imageNamed:@"BG5.png"];

    int txtFieldWidth = self.view.frame.size.width - 40;

    [txtFldJustAdded setCustomImgVw:@"" withWidth:txtFieldWidth];
    txtFldJustAdded.textColor = [UIColor setCustomColorOfTextField];
    txtFldJustAdded.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Just Added" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [txtFldAll setCustomImgVw:@"" withWidth:txtFieldWidth];
    txtFldAll.textColor = [UIColor setCustomColorOfTextField];
    txtFldAll.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"All" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];


    [txtFldGlobal setCustomImgVw:@"" withWidth:(self.view.frame.size.width/2)- 25];
    txtFldGlobal.textColor = [UIColor setCustomColorOfTextField];
    txtFldGlobal.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Global" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    segmentTrash.frame = CGRectMake((self.view.frame.size.width/2)+5, txtFldGlobal.frame.origin.y+5, txtFldGlobal.frame.size.width, 30);
    segmentTrash.tintColor = [UIColor whiteColor];

    [btnApply setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(applytBtnTapped) forControlEvents:UIControlEventTouchUpInside];
    btnApply.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [btnApply setBackgroundColor:[UIColor setCustomSignUpColor]];
}

#pragma mark - Back btn tapped
- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Apply btn tapped
- (void)applytBtnTapped {

    [self setFilterDataOnServer];
    
    if (txtFldJustAdded.text.length != 0 && ![txtFldJustAdded.text isEqualToString:@"None"]) {
        [self.dictLocation setValue:txtFldJustAdded.text forKey:@"trending"];
    }

    if (txtFldAll.text.length != 0 && ![txtFldAll.text isEqualToString:@"All"]) {
        [self.dictLocation removeAllObjects];
        [self.dictLocation setValue:[NSNumber numberWithInt:categoryId] forKey:@"category"];
    }

  if (isFileIt == 1) {//trash =1 and =1
    [self.dictLocation setValue:[NSNumber numberWithBool:YES] forKey:@"filled"];

    }
    if (isTrash == 1) {
        // dictSearch = @{@"search":self.dictLocation, @"segmentOption":@"fileit"};
      [self.dictLocation setValue:[NSNumber numberWithBool:YES] forKey:@"trash"];
    }

    NSDictionary *dictSearch = @{@"search":self.dictLocation};

    [[NSUserDefaults standardUserDefaults]setObject:dictSearch forKey:SEARCH_KEYS];
    [[NSUserDefaults standardUserDefaults]synchronize];

    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:SEARCH_KEYS]);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Just add btn tapped
- (IBAction)justAddedBtnTapped:(id)sender {
    
    NSInteger index = [arryJustAdded indexOfObject:txtFldJustAdded.text] ? [arryJustAdded indexOfObject:txtFldJustAdded.text] : 0 ;
    [ActionSheetPicker displayActionPickerWithView:self.view data:arryJustAdded selectedIndex:index target:self action:@selector(setAddedToField::) title:@"" width:320];
}

- (void)setAddedToField:(NSString *)selectedMonth :(id)element {

    txtFldJustAdded.text = [arryJustAdded objectAtIndex:selectedMonth.intValue];
}

#pragma mark - Global button tapped
- (IBAction)GlobalBtnTapped:(id)sender {
    
    NSInteger index = [arryGlobal indexOfObject:txtFldGlobal.text] ? [arryGlobal indexOfObject:txtFldGlobal.text] : 0 ;
    self.dictLocation = [[NSMutableDictionary alloc]init];
    [ActionSheetPicker displayActionPickerWithView:self.view data:arryGlobal selectedIndex:index target:self action:@selector(setGlobalToField::) title:@"" width:320];
}

- (void)setGlobalToField:(NSString *)selectedMonth :(id)element {

    txtFldGlobal.text = [arryGlobal objectAtIndex:selectedMonth.intValue];
    NSString *country, *state, *city, *postalCode;

  if (txtFldJustAdded.text.length == 0)
    txtFldJustAdded.text = @"Just Added";

    //country, state, city
    switch (selectedMonth.intValue) {
        case 1:
            country = userObject.country;
            [self.dictLocation setValue:country forKey:@"country"];
            break;

        case 2:
            country = userObject.country;
            state = userObject.state;

            [self.dictLocation setValue:country forKey:@"country"];
            [self.dictLocation setValue:state forKey:@"state"];
            break;

        case 3:
            country = userObject.country;
            state = userObject.state;
            city = userObject.city;

            [self.dictLocation setValue:country forKey:@"country"];
            [self.dictLocation setValue:state forKey:@"state"];
            [self.dictLocation setValue:city forKey:@"city"];
            break;

        case 4:
            country = userObject.country;
            state = userObject.state;
            city = userObject.city;
            postalCode = userObject.postalCode;

            [self.dictLocation setValue:country forKey:@"country"];
            [self.dictLocation setValue:state forKey:@"state"];
            [self.dictLocation setValue:city forKey:@"city"];
            [self.dictLocation setValue:postalCode forKey:@"postal_code"];
            break;

        default:
            break;
    }
}

#pragma mark - All button tapped
- (IBAction)allBtnTapped:(id)sender {
    
    NSInteger index = [self.arrayCategoryName indexOfObject:txtFldAll.text] ? [self.arrayCategoryName indexOfObject:txtFldAll.text] : 0 ;
    [ActionSheetPicker displayActionPickerWithView:self.view data:self.arrayCategoryName selectedIndex:index target:self action:@selector(setAllToField::) title:@"" width:320];
}

- (void)setAllToField:(NSString *)selectedMonth :(id)element {

  if (self.arrayCategoryName.count-1 != selectedMonth.intValue){
    txtFldAll.text = [self.arrayCategoryName objectAtIndex:selectedMonth.intValue];
    categoryId = [[self.arrayCategoryId objectAtIndex:selectedMonth.intValue] intValue];
  } else {
    txtFldAll.text =  @"All";
  }
}

#pragma mark - Get user profile
- (void)getProfileOfUser {

    if ([ConstantClass checkNetworkConection] == YES) {
        [self.api profileUrl:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSDictionary *dictProfile  = [responseObject objectForKey:@"data"];
            self.dictLocation = [dictProfile objectForKey:@"location"];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@",error);
        }];
    }
}

#pragma mark - Add activity indicator
- (void)addActivityIndicator {

    vwOverlay = [[UIView alloc]initWithFrame:self.view.frame];
    vwOverlay.backgroundColor = [UIColor clearColor];
    [vwOverlay setHidden:YES];
    [self.view addSubview:vwOverlay];

    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.center = CGPointMake((self.view.frame.size.width)/2, (self.view.frame.size.height-35)/2);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view bringSubviewToFront:activityIndicator];
    [self.view addSubview:activityIndicator];
    [activityIndicator setHidden:YES];
}

- (void)startAnimation {

    [vwOverlay setHidden:NO];
    [activityIndicator setHidden:NO];
    [activityIndicator startAnimating];
}

- (void)stopAnimation {

    [vwOverlay setHidden:YES];
    [activityIndicator setHidden:YES];
    [activityIndicator stopAnimating];
}

#pragma mark - Get all category
- (void)getAllCategory {

    [self startAnimation];
    dispatch_queue_t queue = dispatch_queue_create("category", NULL);
    dispatch_async(queue, ^ {
        dispatch_async (dispatch_get_main_queue(), ^{

            [self.api callGETUrl:nil method:@"/api/v1/categories" success:^(AFHTTPRequestOperation *task, id responseObject) {

                NSLog(@"%@",responseObject);
                NSArray *arryCategory = [[responseObject valueForKey:@"data"]valueForKey:@"categories"];

                for (NSDictionary *dictResp in arryCategory) {

                    NSInteger catId = [[dictResp valueForKey:@"id"] integerValue];
                    NSString *strCatName = [dictResp valueForKey:@"name"];
                    [self.arrayCategoryId addObject:[NSNumber numberWithInteger:catId]];
                    [self.arrayCategoryName addObject:strCatName];
                }

              [self.arrayCategoryName addObject:@"All"];
//              NSDictionary *dict = [[[NSUserDefaults standardUserDefaults]valueForKey:SEARCH_KEYS]valueForKey:@"search"];
//
//              if([dict valueForKey:@"category"] != nil && [[dict valueForKey:@"category"] integerValue] != 0) {
//                NSLog(@"%i",[[dict valueForKey:@"category"] integerValue]);
//                NSInteger indexOfCategory = [self.arrayCategoryId indexOfObject:[NSNumber numberWithInteger:[[dict valueForKey:@"category"] integerValue]]];
//                txtFldAll.text = [self.arrayCategoryName objectAtIndex:indexOfCategory];
//              }
                [self stopAnimation];
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                NSLog(@"%@",error);
            }];
        });
    });
}

- (IBAction)changeSegmentSettings:(id)sender {

  UISegmentedControl *segDetail = (UISegmentedControl *)sender;
  NSInteger index = segDetail.selectedSegmentIndex;

  if (index == 1) {
    isFileIt = YES;
  } else if (index == 2) {
    isTrash = YES;
  } else {
    isFileIt = NO;
    isTrash = NO;
  }
}

#pragma mark - Get and Set all Filters

- (void)getAllFilterDataFromServer {
    
    [self startAnimation];
    dispatch_async(dispatch_queue_create("getFilter", NULL), ^{
        dispatch_async (dispatch_get_main_queue(), ^{
            [self.api callGETUrlWithHeaderAuthentication:nil method:@"/api/v1/get_user_filters" success:^(AFHTTPRequestOperation *task, id responseObject) {
                [self assignDataToRespectiveControl:[responseObject valueForKey:@"data"]];
                [self stopAnimation];
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                NSLog(@"%@",error);
                [self stopAnimation];
            }];
        });
    });
}

- (void)setFilterDataOnServer {
    
    NSDictionary *param = @{@"tab":txtFldJustAdded.text, @"scope":txtFldGlobal.text, @"category":txtFldAll.text, @"filed":[NSNumber numberWithBool:isFileIt], @"trashed" : [NSNumber numberWithBool:isTrash]};
    
    dispatch_async(dispatch_queue_create("setFilter", NULL), ^{
        dispatch_async (dispatch_get_main_queue(), ^{
            [self.api callPostUrlWithHeader:param method:@"/api/v1/set_user_filters" success:^(AFHTTPRequestOperation *task, id responseObject) {
                NSLog(@"%@",responseObject);
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                NSLog(@"%@",error);
            }];
        });
    });
}

- (void)assignDataToRespectiveControl:(NSDictionary *)dictParams {
    
    if ([dictParams valueForKey:@"tab"] != nil || ![[dictParams valueForKey:@"tab"] isEmpty] ) {
        txtFldJustAdded.text = [dictParams valueForKey:@"tab"];
    }
    
    if ([dictParams valueForKey:@"scope"] != nil || ![[dictParams valueForKey:@"scope"] isEmpty] ) {
        txtFldGlobal.text = [dictParams valueForKey:@"scope"];
    }
    
    if ([dictParams valueForKey:@"category"] != nil || ![[dictParams valueForKey:@"category"] isEmpty] ) {
        txtFldAll.text = [dictParams valueForKey:@"category"];
    }
    
    if ([[dictParams valueForKey:@"filed"] boolValue]) {
        segmentTrash.selectedSegmentIndex = 1;
    }else if ([[dictParams valueForKey:@"trashed"] boolValue]) {
        segmentTrash.selectedSegmentIndex = 2;
    }else {
        segmentTrash.selectedSegmentIndex = 0;
    }
    
}

@end
