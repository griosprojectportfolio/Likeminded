//
//  ProfileViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 23/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ProfileViewController.h"
#import "SupposeOppose.h"
#import "CustomCellOfSupposeOppose.h"
#import "SignUpViewController.h"
#import "DetailPageViewController.h"
#import "User.h"
#import "AdminViewController.h"
#import "SearchUserViewController.h"
#import "ModeratorViewController.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate>{

    UIView *vwOverlay;
    UIActivityIndicatorView *activityIndicator;
}

@property(nonatomic,strong)NSMutableArray *arrySupprot;
@property(nonatomic,strong)NSMutableArray *arryOppose;
@property(nonatomic,strong)AppApi *api;
@property (nonatomic, strong) NSString *comment;

@end

@implementation ProfileViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    btnMyAccount.tag = 5;
    [self getProfileOfUser];
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"Profile";
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    [btnAdmin setHidden:YES];

    UIBarButtonItem *barBtnLogout = [[UIBarButtonItem alloc]initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(logoutBntTapped)];
    self.navigationItem.rightBarButtonItem = barBtnLogout;

    self.arryOppose = [[NSMutableArray alloc]init];
    self.arrySupprot = [[NSMutableArray alloc]init];

    if (IS_IPHONE_5 | IS_IPHONE_4_OR_LESS) {
        self.scrollVwProfile.contentSize = CGSizeMake( self.scrollVwProfile.frame.size.width, 550);
    }

    [self addActivityIndicator];
    [self startAnimation];

    [self defaulUISettings];
    self.comment = @"suppose";
    self.tableVwSupposeOppose.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setFrameOfImgVwOfContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Default settings
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

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];
}

#pragma mark - Back button tapped
- (void)backBtnTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Get Profile of user
- (void)getProfileOfUser {

    if([ConstantClass checkNetworkConection] == YES) {

        dispatch_queue_t queue = dispatch_queue_create("belief", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{

                [self.api profileUrl:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
                  self.dictProfile  = [responseObject objectForKey:@"data"];
                    [self setDataContents];
                    [self stopAnimation];
                } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self stopAnimation];
                }];
            });
        });
    }
}

#pragma mark - Logout button tapped
- (void)logoutBntTapped {

    if ([ConstantClass checkNetworkConection] == YES) {

        [self.api callDeleteUrl:nil method:@"/api/v1/sessions/sign_out" success:^(AFHTTPRequestOperation *task, id responseObject) {

            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self.navigationController popToRootViewControllerAnimated:NO];

        } failure:^(AFHTTPRequestOperation *task, NSError *error) {

            NSLog(@"%@", task.responseString);
        }];
    }
}

#pragma mark - Set data into fields
- (void)setDataContents  {

    NSString *str = [self.dictProfile objectForKey:@"about"];
    if ([str isKindOfClass:[NSNull class]]) {
    } else {
        self.txtVwAboutme.text = [self.dictProfile valueForKey:@"about"];
        NSString *strStatus = [self.dictProfile objectForKey:@"status"];
        if (![strStatus isKindOfClass:[NSNull class]]) {
            lblStatus.text = strStatus;
        }
    }

    NSArray *arry = [self.dictProfile objectForKey:@"role"];
    if (arry.count!= 0) {
        if ([[arry objectAtIndex:0] isEqualToString:@"admin"] || [[arry objectAtIndex:0] isEqualToString:@"Moderator"]) {
            [btnAdmin setHidden:NO];
        }
    }

    lblAgree.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"agree"]];
    lblTotVoate.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"total_vote"]];
    lblfanmails.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"fan_mail"]];
    lblDisagree.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"dis_agree"]];
    lblCommaon.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"comman"]];
    lblNotCommon.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"uncomman"]];

    NSArray *arrySuppose =[self.dictProfile objectForKey:@"beliefs_support"];
    NSArray *arryOppos  = [self.dictProfile objectForKey:@"beliefs_unsupport"];

    //convert into model class
    for (NSDictionary *dictSuppose in arrySuppose) {
        SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
        objSuppose.statement = [dictSuppose valueForKey:@"text"];
        objSuppose.belief_Id = [[dictSuppose valueForKey:@"id"] integerValue];
        [self.arrySupprot addObject:objSuppose];
    }

    for (NSDictionary *dictSuppose in arryOppos) {
        SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
        objSuppose.statement = [dictSuppose valueForKey:@"text"];
        [self.arryOppose addObject:objSuppose];
    }
    [self.tableVwSupposeOppose reloadData];
}

#pragma mark - Set frame of image view
- (void)setFrameOfImgVwOfContent {

    int iRemainingSpace = self.view.frame.size.width - (95*3);
    int iGapInImg = iRemainingSpace/3;

    imgvwFanmails.frame = CGRectMake(10, imgvwFanmails.frame.origin.y, imgvwFanmails.frame.size.width, imgvwFanmails.frame.size.height);
    imgvwFanmails.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwFanmails.layer.borderWidth = 0.7;
    imgvwFanmails.layer.cornerRadius = 4.0;
    imgvwFanmails.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    lblfanmails.frame = CGRectMake(imgvwFanmails.frame.origin.x +3,lblfanmails.frame.origin.y,lblfanmails.frame.size.width, lblfanmails.frame.size.height);
    lblfanmailsHeading.frame = CGRectMake(imgvwFanmails.frame.origin.x +3,lblfanmailsHeading.frame.origin.y,lblfanmailsHeading.frame.size.width, lblfanmailsHeading.frame.size.height);

    imgvwTotVoate.frame = CGRectMake((imgvwFanmails.frame.origin.x + imgvwFanmails.frame.size.width) + iGapInImg, imgvwTotVoate.frame.origin.y, imgvwTotVoate.frame.size.width, imgvwTotVoate.frame.size.height);
    imgvwTotVoate.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwTotVoate.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwTotVoate.layer.borderWidth = 0.7;
    imgvwTotVoate.layer.cornerRadius = 4.0;

    lblTotVoate.frame = CGRectMake(imgvwTotVoate.frame.origin.x +3,lblTotVoate.frame.origin.y,lblTotVoate.frame.size.width, lblTotVoate.frame.size.height);
    lblTotVoateHeading.frame = CGRectMake(imgvwTotVoate.frame.origin.x +3,lblTotVoateHeading.frame.origin.y,lblTotVoateHeading.frame.size.width, lblTotVoateHeading.frame.size.height);

    imgvwComman.frame = CGRectMake((imgvwTotVoate.frame.origin.x + imgvwTotVoate.frame.size.width) + iGapInImg, imgvwComman.frame.origin.y, imgvwComman.frame.size.width, imgvwComman.frame.size.height);
    imgvwComman.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwComman.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwComman.layer.borderWidth = 0.7;
    imgvwComman.layer.cornerRadius = 4.0;

    lblCommaon.frame = CGRectMake(imgvwComman.frame.origin.x +3,lblCommaon.frame.origin.y,lblCommaon.frame.size.width, lblCommaon.frame.size.height);
    lblCommaonHeading.frame = CGRectMake(imgvwComman.frame.origin.x +3,lblCommaonHeading.frame.origin.y,lblCommaonHeading.frame.size.width, lblCommaonHeading.frame.size.height);

    imgvwAgree.frame = CGRectMake(10, imgvwAgree.frame.origin.y, imgvwAgree.frame.size.width, imgvwAgree.frame.size.height);
    imgvwAgree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwAgree.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwAgree.layer.borderWidth = 0.7;
    imgvwAgree.layer.cornerRadius = 4.0;

    lblAgree.frame = CGRectMake(imgvwAgree.frame.origin.x +3,lblAgree.frame.origin.y,lblAgree.frame.size.width, lblAgree.frame.size.height);
    lblAgreeHeading.frame = CGRectMake(imgvwAgree.frame.origin.x +3,lblAgreeHeading.frame.origin.y,lblAgreeHeading.frame.size.width, lblAgreeHeading.frame.size.height);

    imgvwNotCommon.frame = CGRectMake((imgvwAgree.frame.origin.x + imgvwAgree.frame.size.width) + iGapInImg, imgvwNotCommon.frame.origin.y, imgvwNotCommon.frame.size.width, imgvwNotCommon.frame.size.height);
    imgvwNotCommon.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwNotCommon.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwNotCommon.layer.borderWidth = 0.7;
    imgvwNotCommon.layer.cornerRadius = 4.0;

    lblNotCommon.frame = CGRectMake(imgvwNotCommon.frame.origin.x +3,lblNotCommon.frame.origin.y,lblNotCommon.frame.size.width, lblNotCommon.frame.size.height);
    lblNotCommonHeading.frame = CGRectMake(imgvwNotCommon.frame.origin.x +3,lblNotCommonHeading.frame.origin.y,lblNotCommonHeading.frame.size.width, lblNotCommonHeading.frame.size.height);

    imgvwDisagree.frame = CGRectMake((imgvwNotCommon.frame.origin.x + imgvwNotCommon.frame.size.width)+ iGapInImg , imgvwAgree.frame.origin.y, imgvwDisagree.frame.size.width, imgvwDisagree.frame.size.height);
    imgvwDisagree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwDisagree.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwDisagree.layer.borderWidth = 0.7;
    imgvwDisagree.layer.cornerRadius = 4.0;

    lblDisagree.frame = CGRectMake(imgvwDisagree.frame.origin.x +3,lblDisagree.frame.origin.y,lblDisagree.frame.size.width, lblDisagree.frame.size.height);
    lblDisagreeHeading.frame = CGRectMake(imgvwDisagree.frame.origin.x +3,lblDisagreeHeading.frame.origin.y,lblDisagreeHeading.frame.size.width, lblDisagreeHeading.frame.size.height);

    self.txtVwAboutme.layer.borderWidth = 0.7;
    self.txtVwAboutme.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.txtVwAboutme.layer.cornerRadius = 4.0;

    [btnMyAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMyAccount setBackgroundColor:[UIColor setCustomSignUpColor]];
    btnMyAccount.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [btnMyAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        // [btnAdmin setBackgroundColor:[UIColor setCustomSignUpColor]];
    btnAdmin.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [btnAdmin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnAdmin addTarget:self action:@selector(gotoAdminPart) forControlEvents:UIControlEventTouchUpInside];
    
    segmentSupposeOppose.tintColor = [UIColor whiteColor];
    self.tableVwSupposeOppose.backgroundColor = [UIColor clearColor];
    if (!IS_IPHONE_4_OR_LESS && !IS_IPHONE_5) {
        self.tableVwSupposeOppose.frame = CGRectMake(self.tableVwSupposeOppose.frame.origin.x, self.tableVwSupposeOppose.frame.origin.y, self.tableVwSupposeOppose.frame.size.width, self.view.frame.size.height - (self.tableVwSupposeOppose.frame.origin.y + 64));
    } else {
        self.tableVwSupposeOppose.frame = CGRectMake(self.tableVwSupposeOppose.frame.origin.x, self.tableVwSupposeOppose.frame.origin.y, self.tableVwSupposeOppose.frame.size.width, 170);
    }
    self.tableVwSupposeOppose.separatorColor = [UIColor darkGrayColor];
}

#pragma mark - Comment segment tapped
- (IBAction)CommentSegmenttapped:(id)sender{

    UISegmentedControl *segDetail = (UISegmentedControl *)sender;
    NSInteger index = segDetail.selectedSegmentIndex;
    if (index == 0) {
        self.comment = @"suppose";
    } else{
        self.comment = @"oppose";
    }
    [self.tableVwSupposeOppose reloadData];
}

#pragma mark - UITable view datasources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([self.comment isEqualToString:@"suppose"]) {
        return self.arrySupprot.count;
    } else {
        return self.arryOppose.count;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomCellOfSupposeOppose *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Suppose" forIndexPath:indexPath];

    if ([self.comment isEqualToString:@"suppose"]) {
        [cell setSupposeOrOppose:[self.arrySupprot objectAtIndex:indexPath.row] withVwController:self];
    } else {
        [cell setSupposeOrOppose:[self.arryOppose objectAtIndex:indexPath.row] withVwController:self];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITable view Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SupposeOppose *objSupposeOppose;
    if ([self.comment isEqualToString:@"suppose"]) {
        objSupposeOppose = [self.arrySupprot objectAtIndex:indexPath.row];
    } else {
       objSupposeOppose = [self.arryOppose objectAtIndex:indexPath.row];
    }
    NSString *strSuppose = objSupposeOppose.statement;
    CGRect rect =[strSuppose boundingRectWithSize:CGSizeMake(self.tableVwSupposeOppose.frame.size.width-20, 200) options:(NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin)attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:14.0]} context:nil];

    if (rect.size.height < 40) {
        return 44;
    } else {
        return (rect.size.height + 10);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DetailPageViewController *vcDetailPage = [self.storyboard instantiateViewControllerWithIdentifier:@"detailPage"];
    SupposeOppose *objSupposeOppose;
    if ([self.comment isEqualToString:@"suppose"]) {
        objSupposeOppose = [self.arrySupprot objectAtIndex:indexPath.row];
    } else {
        objSupposeOppose = [self.arryOppose objectAtIndex:indexPath.row];
    }
    vcDetailPage.belief_Id = objSupposeOppose.belief_Id;
    [self.navigationController pushViewController:vcDetailPage animated:YES];
}

#pragma mark - My Account button tapped
- (IBAction)btnMyAccountTapped:(id)sender{

    UIButton *btn = (UIButton*)sender;
    SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    vcSignUp.btnUpdatetag = btn.tag;
    [self.navigationController pushViewController:vcSignUp animated:YES];
}


#pragma mark - Go to admin part
- (void)gotoAdminPart {

    UITabBarController *tBCAdmin= [[UITabBarController alloc] init];

    SearchUserViewController *vcSearch = [self.storyboard instantiateViewControllerWithIdentifier:@"searchUser"];
    AdminViewController *vcAdmin = [self.storyboard instantiateViewControllerWithIdentifier:@"admin"];
    ModeratorViewController *vcModerator = [self.storyboard instantiateViewControllerWithIdentifier:@"moderator"];

    tBCAdmin.viewControllers = @[vcAdmin, vcSearch, vcModerator];
    tBCAdmin.hidesBottomBarWhenPushed = YES;

    [[[tBCAdmin.viewControllers objectAtIndex:0] tabBarItem] setTitle:@"Category"];
    [[[tBCAdmin.viewControllers objectAtIndex:1] tabBarItem] setTitle:@"Users"];
    [[[tBCAdmin.viewControllers objectAtIndex:2] tabBarItem] setTitle:@"Moderator"];

    [self.navigationController pushViewController:tBCAdmin animated:YES];
}

#pragma mark - Add activity indicator
- (void)addActivityIndicator {

    vwOverlay = [[UIView alloc]initWithFrame:self.view.frame];
    vwOverlay.backgroundColor = [UIColor clearColor];
    [vwOverlay setHidden:YES];
    [self.view addSubview:vwOverlay];

    activityIndicator = [[UIActivityIndicatorView alloc]init];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, (self.view.frame.size.height-35)/2);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.tintColor = [UIColor setCustomColorOfTextField];
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

@end
