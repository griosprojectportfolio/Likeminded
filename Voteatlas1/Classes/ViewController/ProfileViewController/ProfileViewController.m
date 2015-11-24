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
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "AdminViewController.h"
#import "SearchUserViewController.h"
#import "ModeratorViewController.h"
#import "UIImage+Resize.h"

@interface ProfileViewController () <UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate>{

    UIView *vwOverlay;
    UIActivityIndicatorView *activityIndicator;
    BOOL isAgreeSelected;
    BOOL isDisagreeSelected;
    BOOL isNotCommanComment;
    NSString *strProfileImage;
    UIImage *imgProfileSelect;
}

@property (nonatomic, strong) NSMutableArray *arrySupprot;
@property (nonatomic, strong) NSMutableArray *arryOppose;
@property (nonatomic, strong) NSMutableArray *arryComment;
@property (nonatomic, strong) NSMutableArray *arryNotCommon;
@property (nonatomic, strong) NSMutableArray *arryNotCommonOppose;
@property (nonatomic, strong) UIImagePickerController *imagePickerProfile;

@property (nonatomic, strong) AppApi *api;
@property (nonatomic, strong) NSString *comment;

@end

@implementation ProfileViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    btnMyAccount.tag = 5;
    btnEdit.hidden = YES;

    NSArray *arrFetchedData = [User MR_findAll];
    User *userObject = [arrFetchedData objectAtIndex:0];
    btnProfile.hidden = YES;
    if ([self.userName isEqualToString:@"LoginUser"]) {
      self.userName = userObject.slug;
    }

    if ([self.userName isEqualToString:userObject.slug]) {
      btnEdit.hidden = NO;
      btnProfile.hidden = NO;
    }
    [self getOtherUserProfile];

    self.navigationController.navigationBar.translucent = YES;
    self.title = @"Profile";
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    [btnAdmin setHidden:YES];
    self.arryOppose = [[NSMutableArray alloc]init];
    self.arrySupprot = [[NSMutableArray alloc]init];
    self.arryNotCommon = [[NSMutableArray alloc]init];
    self.arryNotCommonOppose = [[NSMutableArray alloc]init];

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Default settings
/**************************************************************************************************
 Function to set default setting
 **************************************************************************************************/
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];

    UIBarButtonItem *btnFavo = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"menuHeartWhite"] style:UIBarButtonItemStylePlain target:self action:@selector(favoBtnTapped:)];
    btnFavo.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setRightBarButtonItem:btnFavo];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Back button tapped
/**************************************************************************************************
 Function to back view
 **************************************************************************************************/
- (void)backBtnTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)favoBtnTapped:(UIButton *)sender {
    if (sender.tag) {
        sender.tintColor = [UIColor setCustomColorOfTextField];
        sender.tag = sender.tag - 1;
    }else {
        sender.tintColor = [UIColor setCustomDisLikeButtonColor];
        sender.tag = sender.tag + 1;
    }
}

/**************************************************************************************************
 Function to get user profile
 *************************************************************************************************
- (void)getProfileOfUser {

    if([ConstantClass checkNetworkConection] == YES) {

        dispatch_queue_t queue = dispatch_queue_create("belief", NULL);
        dispatch_async(queue, ^ {
            dispatch_async (dispatch_get_main_queue(), ^{

                [self.api profileUrl:nil success:^(AFHTTPRequestOperation *task, id responseObject) {
                  self.dictProfile  = [responseObject objectForKey:@"data"];
                    [self setDataContents];
                    self.tableVwSupposeOppose.hidden = NO;
                    [self stopAnimation];
                } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                    NSLog(@"%@",error);
                    [self stopAnimation];
                }];
            });
        });
    }
}*/
#pragma mark - Get Profile of user
- (void)getOtherUserProfile {

  if([ConstantClass checkNetworkConection] == YES) {

    dispatch_queue_t queue = dispatch_queue_create("belief", NULL);
    dispatch_async(queue, ^ {
      dispatch_async (dispatch_get_main_queue(), ^{

        NSDictionary *param = @{@"user_id":self.userName};
       [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/profile" success:^(AFHTTPRequestOperation *task, id responseObject) {
         self.dictProfile  = [responseObject objectForKey:@"data"];
         [self setDataContents];
         self.tableVwSupposeOppose.hidden = NO;
         [self stopAnimation];
       } failure:^(AFHTTPRequestOperation *task, NSError *error) {
         [self stopAnimation];
       }];
      });
    });
  }
}


#pragma mark - Set data into fields
/**************************************************************************************************
 Function to set data in to corresponding fields
 **************************************************************************************************/
- (void)setDataContents  {

    lblUserName.text = [[self.dictProfile objectForKey:@"user"]valueForKey:@"name"];
    lblStatus.text = (![[self.dictProfile objectForKey:@"status"]isKindOfClass:[NSNull class]]?[self.dictProfile valueForKey:@"status"] :@"Not Available");
    self.txtVwAboutme.text = (![[self.dictProfile valueForKey:@"about"]isKindOfClass:[NSNull class]]?[self.dictProfile valueForKey:@"about"] :@"");

    NSString *userProfileImg = [[[self.dictProfile objectForKey:@"user"] valueForKey:@"profile_image"] valueForKey:@"url"];
    if (![userProfileImg isKindOfClass:[NSNull class]]) {
      [self setProfileImage:userProfileImg];
    }

    NSArray *arry = [self.dictProfile objectForKey:@"role"];
    if (arry.count!= 0) {
        if ([[arry objectAtIndex:0] isEqualToString:@"admin"] || [[arry objectAtIndex:0] isEqualToString:@"Moderator"]) {
            //[btnAdmin setHidden:NO];
        }
    }

    lblAgree.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"agree"]];
    lblTotVoate.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"total_vote"]];
    lblfanmails.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"fan_mail"]];
    lblDisagree.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"dis_agree"]];
    lblCommaon.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"comman"]];
    lblNotCommon.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"uncomman"]];

    NSArray *arrySuppose = [[self.dictProfile objectForKey:@"common"]objectForKey:@"support_agree"];
    NSArray *arryOppos  = [[self.dictProfile objectForKey:@"common"]objectForKey:@"support_disagree"];
    NSArray *arryNotCommon  = [self.dictProfile objectForKey:@"beliefs_support"];
    NSArray *arryNotCommonOppos  = [self.dictProfile objectForKey:@"beliefs_unsupport"];

    //convert into model class
    for (NSDictionary *dictSuppose in arrySuppose) {
        SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
        objSuppose.statement = [dictSuppose valueForKey:@"text"];
        objSuppose.belief_Id = [[dictSuppose valueForKey:@"id"] integerValue];
        [self.arrySupprot addObject:objSuppose];
        self.arryComment = self.arrySupprot;
    }

    for (NSDictionary *dictSuppose in arryOppos) {
        SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
        objSuppose.statement = [dictSuppose valueForKey:@"text"];
        objSuppose.belief_Id = [[dictSuppose valueForKey:@"id"] integerValue];
        [self.arryOppose addObject:objSuppose];
    }

    for (NSArray *dictCommon in arryNotCommon) {
      SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
      NSLog(@"%@", [[dictCommon valueForKey:@"belief"]valueForKey:@"text"]);
      objSuppose.belief_Id = [[[dictCommon valueForKey:@"belief"]valueForKey:@"id"] longValue];
      objSuppose.statement = [[dictCommon valueForKey:@"belief"]valueForKey:@"text"];
      [self.arryNotCommon addObject:objSuppose];
    }

    for (NSDictionary *dictNotCommon in arryNotCommonOppos) {
      SupposeOppose *objSuppose = [[SupposeOppose alloc]init];
      NSLog(@"%@", [[dictNotCommon valueForKey:@"belief"]valueForKey:@"text"]);
      objSuppose.belief_Id = [[[dictNotCommon valueForKey:@"belief"]valueForKey:@"id"] integerValue];
      objSuppose.statement = [[dictNotCommon valueForKey:@"belief"]valueForKey:@"text"];
      [self.arryNotCommonOppose addObject:objSuppose];
    }

    [self.tableVwSupposeOppose reloadData];
}

- (void)setProfileImage:(NSString *)profileImg {

  dispatch_queue_t postImageQueue = dispatch_queue_create("profileimage", NULL);
  dispatch_async(postImageQueue, ^{
    NSData *image = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:profileImg]];

    dispatch_async(dispatch_get_main_queue(), ^{

      UIImage *img = [UIImage imageWithData:image];
      UIImage *imgProfile = [ConstantClass maskImage:img withMask:[UIImage imageNamed:@"mask.png"]];
      self.imgVwProfile.image = imgProfile;
      self.imgVwProfile.hidden = NO;
    });
  });
}

- (IBAction)changeBackgroundColorOfBoxes:(id)sender {

    imgvwAgree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwComman.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwDisagree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwNotCommon.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    UIButton *btnSender = (UIButton*)sender;

    if ([btnSender.titleLabel.text isEqualToString:@"Disagree"]) {
        imgvwDisagree.backgroundColor = [UIColor setCustomColorOfTextField];
        self.comment = @"oppose";
        isDisagreeSelected = YES;
        isAgreeSelected = NO;
        isNotCommanComment = NO;

        segmentSupposeOppose.selectedSegmentIndex = 1;
        self.arryComment = self.arryOppose;
        [self.tableVwSupposeOppose reloadData];
        [self.tableVwSupposeOppose setHidden:NO];
        return;
    }

    if ([btnSender.titleLabel.text isEqualToString:@"Agree"]) {
        imgvwAgree.backgroundColor = [UIColor setCustomColorOfTextField];
        self.comment = @"suppose";
        isAgreeSelected = YES;
        isDisagreeSelected = NO;
        isNotCommanComment = NO;

        segmentSupposeOppose.selectedSegmentIndex = 0;
        self.arryComment = self.arrySupprot;
        [self.tableVwSupposeOppose reloadData];
        [self.tableVwSupposeOppose setHidden:NO];
        return;
    }

    if ([btnSender.titleLabel.text isEqualToString:@"Common"]) {
        imgvwComman.backgroundColor = [UIColor setCustomColorOfTextField];
        isAgreeSelected = NO;
        isDisagreeSelected = NO;
        isNotCommanComment = NO;

        segmentSupposeOppose.selectedSegmentIndex = 0;
        self.arryComment = self.arrySupprot;
        [self.tableVwSupposeOppose reloadData];
        [self.tableVwSupposeOppose setHidden:NO];
        return;
    }

    if ([btnSender.titleLabel.text isEqualToString:@"Not Common"]) {
        imgvwNotCommon.backgroundColor = [UIColor setCustomColorOfTextField];
        isAgreeSelected = NO;
        isDisagreeSelected = NO;
        isNotCommanComment = YES;

        segmentSupposeOppose.selectedSegmentIndex = 0;
        self.arryComment = self.arryNotCommon;
        [self.tableVwSupposeOppose reloadData];
        [self.tableVwSupposeOppose setHidden:NO];
        return;
    }
}

#pragma mark - Set frame of image view
/**************************************************************************************************
 Function to set frame of image view
 **************************************************************************************************/
- (void)setFrameOfImgVwOfContent {

    int iRemainingSpace = self.view.frame.size.width - (95*3);
    int iGapInImg = iRemainingSpace/3;
    imgvwTotVoate.frame = CGRectMake(10, imgvwTotVoate.frame.origin.y, imgvwTotVoate.frame.size.width, imgvwTotVoate.frame.size.height);
    imgvwTotVoate.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwTotVoate.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwTotVoate.layer.borderWidth = 0.7;
    imgvwTotVoate.layer.cornerRadius = 4.0;

    lblTotVoate.frame = CGRectMake(imgvwTotVoate.frame.origin.x +3,lblTotVoate.frame.origin.y,lblTotVoate.frame.size.width, lblTotVoate.frame.size.height);
    btnTotVoateHeading.frame = CGRectMake(imgvwTotVoate.frame.origin.x +3,btnTotVoateHeading.frame.origin.y,btnTotVoateHeading.frame.size.width, btnTotVoateHeading.frame.size.height);

    imgvwAgree.frame = CGRectMake((imgvwTotVoate.frame.origin.x + imgvwTotVoate.frame.size.width) + iGapInImg, imgvwAgree.frame.origin.y, imgvwAgree.frame.size.width, imgvwAgree.frame.size.height);
    imgvwAgree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwAgree.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwAgree.layer.borderWidth = 0.7;
    imgvwAgree.layer.cornerRadius = 4.0;

    lblAgree.frame = CGRectMake(imgvwAgree.frame.origin.x +3,lblAgree.frame.origin.y,lblAgree.frame.size.width, lblAgree.frame.size.height);
    btnAgreeHeading.frame = CGRectMake(imgvwAgree.frame.origin.x +3,btnAgreeHeading.frame.origin.y,btnAgreeHeading.frame.size.width, btnAgreeHeading.frame.size.height);

    imgvwDisagree.frame = CGRectMake((imgvwAgree.frame.origin.x + imgvwAgree.frame.size.width)+ iGapInImg , imgvwDisagree.frame.origin.y, imgvwDisagree.frame.size.width, imgvwDisagree.frame.size.height);
    imgvwDisagree.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwDisagree.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwDisagree.layer.borderWidth = 0.7;
    imgvwDisagree.layer.cornerRadius = 4.0;

    lblDisagree.frame = CGRectMake(imgvwDisagree.frame.origin.x +3,lblDisagree.frame.origin.y,lblDisagree.frame.size.width, lblDisagree.frame.size.height);
    btnDisagreeHeading.frame = CGRectMake(imgvwDisagree.frame.origin.x +3,btnDisagreeHeading.frame.origin.y,btnDisagreeHeading.frame.size.width, btnDisagreeHeading.frame.size.height);

    imgvwFanmails.frame = CGRectMake(10, imgvwFanmails.frame.origin.y, imgvwFanmails.frame.size.width, imgvwFanmails.frame.size.height);
    imgvwFanmails.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwFanmails.layer.borderWidth = 0.7;
    imgvwFanmails.layer.cornerRadius = 4.0;
    imgvwFanmails.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];

    lblfanmails.frame = CGRectMake(imgvwFanmails.frame.origin.x +3,lblfanmails.frame.origin.y,lblfanmails.frame.size.width, lblfanmails.frame.size.height);
    btnfanmailsHeading.frame = CGRectMake(imgvwFanmails.frame.origin.x +3,btnfanmailsHeading.frame.origin.y,btnfanmailsHeading.frame.size.width, btnfanmailsHeading.frame.size.height);

    imgvwComman.frame = CGRectMake((imgvwFanmails.frame.origin.x + imgvwFanmails.frame.size.width) + iGapInImg, imgvwComman.frame.origin.y, imgvwComman.frame.size.width, imgvwComman.frame.size.height);
    imgvwComman.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwComman.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwComman.layer.borderWidth = 0.7;
    imgvwComman.layer.cornerRadius = 4.0;

    lblCommaon.frame = CGRectMake(imgvwComman.frame.origin.x +3,lblCommaon.frame.origin.y,lblCommaon.frame.size.width, lblCommaon.frame.size.height);
    btnCommaonHeading.frame = CGRectMake(imgvwComman.frame.origin.x +3,btnCommaonHeading.frame.origin.y,btnCommaonHeading.frame.size.width, btnCommaonHeading.frame.size.height);

    imgvwNotCommon.frame = CGRectMake((imgvwComman.frame.origin.x + imgvwComman.frame.size.width) + iGapInImg, imgvwNotCommon.frame.origin.y, imgvwNotCommon.frame.size.width, imgvwNotCommon.frame.size.height);
    imgvwNotCommon.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    imgvwNotCommon.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    imgvwNotCommon.layer.borderWidth = 0.7;
    imgvwNotCommon.layer.cornerRadius = 4.0;

    lblNotCommon.frame = CGRectMake(imgvwNotCommon.frame.origin.x +3,lblNotCommon.frame.origin.y,lblNotCommon.frame.size.width, lblNotCommon.frame.size.height);
    btnNotCommonHeading.frame = CGRectMake(imgvwNotCommon.frame.origin.x +3,btnNotCommonHeading.frame.origin.y,btnNotCommonHeading.frame.size.width, btnNotCommonHeading.frame.size.height);

    self.txtVwAboutme.layer.borderWidth = 0.7;
    self.txtVwAboutme.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
    self.txtVwAboutme.layer.cornerRadius = 4.0;

    [btnMyAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnMyAccount setBackgroundColor:[UIColor setCustomSignUpColor]];
    btnMyAccount.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [btnMyAccount setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

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

    self.tableVwSupposeOppose.hidden = NO;
    UISegmentedControl *segDetail = (UISegmentedControl *)sender;
    NSInteger index = segDetail.selectedSegmentIndex;
    if (index == 0) {
        self.comment = @"suppose";
        if (isNotCommanComment == YES) {
            self.arryComment = self.arryNotCommon;
        } else {
            self.arryComment = self.arrySupprot;
        }
        if (isDisagreeSelected == YES) {
            self.tableVwSupposeOppose.hidden = YES;
        }
    } else {
        self.comment = @"oppose";
        if (isNotCommanComment == YES) {
            self.arryComment = self.arryNotCommonOppose;
        } else {
            self.arryComment = self.arryOppose;
        }
        if (isAgreeSelected == YES) {
            self.tableVwSupposeOppose.hidden = YES;
        }
    }
    [self.tableVwSupposeOppose reloadData];
}

#pragma mark - UITable view datasources
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arryComment.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CustomCellOfSupposeOppose *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"Suppose" forIndexPath:indexPath];
    [cell setSupposeOrOppose:[self.arryComment objectAtIndex:indexPath.row] withVwController:self];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - UITable view Delegates
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    SupposeOppose *objSupposeOppose;
    objSupposeOppose = [self.arryComment objectAtIndex:indexPath.row];
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
    objSupposeOppose = [self.arryComment objectAtIndex:indexPath.row];
    vcDetailPage.belief_Id = objSupposeOppose.belief_Id;
    [self.navigationController pushViewController:vcDetailPage animated:YES];
}

#pragma mark - My Account button tapped
/**************************************************************************************************
 Function to edit my profile button tapped
 **************************************************************************************************/
- (IBAction)btnMyAccountTapped:(id)sender{

    UIButton *btn = (UIButton*)sender;
    SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    vcSignUp.btnUpdatetag = btn.tag;
    [self.navigationController pushViewController:vcSignUp animated:YES];
}

#pragma mark - Go to admin part
/**************************************************************************************************
 Function to Go to admin part
 **************************************************************************************************/
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

- (void)keyboardWillShow:(NSNotification *)notification {

    UIViewAnimationCurve animationCurve = [[[notification userInfo] valueForKey: UIKeyboardAnimationCurveUserInfoKey] intValue];
    NSTimeInterval animationDuration = [[[notification userInfo] valueForKey: UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect keyboardBounds = [(NSValue *)[[notification userInfo] objectForKey: UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    [UIView beginAnimations:nil context: nil];
    [UIView setAnimationCurve:animationCurve];
    [UIView setAnimationDuration:animationDuration];
    [toolBarDone setFrame:CGRectMake(0.0f, self.view.frame.size.height - (keyboardBounds.size.height + toolBarDone.frame.size.height + 64), toolBarDone.frame.size.width, toolBarDone.frame.size.height)];
    toolBarDone.hidden = NO;
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification  {

    [toolBarDone setFrame:CGRectMake(0.0f, self.view.frame.size.height+ 46 - toolBarDone.frame.size.height, toolBarDone.frame.size.width, toolBarDone.frame.size.height)];
}

- (IBAction)doneBtnTapped:(id)sender {
    [self.view endEditing:YES];
}

- (IBAction)editBtnTapped:(id)sende {

    btnEdit.hidden = YES;
    btnSaveAboutMe.hidden = NO;
    btnCancel.hidden = NO;
    self.txtVwAboutme.editable = YES;
}

- (IBAction)saveBtnTapped:(id)sende {

    NSDictionary *param = @{@"about":self.txtVwAboutme.text};
    [self.api callPostUrlWithHeader:param method:@"/api/v1/about" success:^(AFHTTPRequestOperation *task, id responseObject) {
        [self cancelBtnTapped:nil];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
    }];
}

- (IBAction)cancelBtnTapped:(id)sende {

    btnEdit.hidden = NO;
    btnSaveAboutMe.hidden = YES;
    btnCancel.hidden = YES;
    self.txtVwAboutme.editable = NO;
}


#pragma mark - UIImage picker view delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

    [self dismissViewControllerAnimated:YES completion:Nil];
    [self startAnimation];

    UIImage *originalImage = [ConstantClass scaleAndRotateImage:[info valueForKey:UIImagePickerControllerOriginalImage]];
    if ([originalImage size].width > 640.0 || [originalImage size].height > 640.0) {
      // Image is larger than 640x640
        imgProfileSelect = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill
                                                   bounds:CGSizeMake(640.0, 640.0)
                                     interpolationQuality:kCGInterpolationMedium];
    } else {
        imgProfileSelect = originalImage;
    }

    NSData *dataImage = UIImagePNGRepresentation(imgProfileSelect);
    strProfileImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    [self uploadImageApiCall];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)uploadImageApiCall {

    NSDictionary *dictImage =  @{@"profile_image":strProfileImage};
    NSDictionary *param = @{@"user":dictImage, @"file_name":@"profileImg.png"};

    [self.api callPutUrlWithHeader:param method:@"/api/v1/update" success:^(AFHTTPRequestOperation *task, id responseObject) {
    dispatch_queue_t postImageQueue = dispatch_queue_create("profileimage", NULL);
    dispatch_async(postImageQueue, ^{
      dispatch_async(dispatch_get_main_queue(), ^{

        UIImage *img = [ConstantClass maskImage:imgProfileSelect withMask:[UIImage imageNamed:@"mask.png"]];
        self.imgVwProfile.image = img;
        self.imgVwProfile.hidden = NO;
      });
    });
    [self stopAnimation];

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Image not updated.Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil, nil];
        [alert show];
        [self stopAnimation];
    }];
}

- (IBAction)profileImgChangeBtnTapped:(id)sender {

    UIAlertView *alertVwProfileImg = [[UIAlertView alloc]initWithTitle:@"Select From" message:nil delegate:self cancelButtonTitle:@"Cancel"otherButtonTitles:@"Device", @"Camera", nil];
    [alertVwProfileImg show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    UIImagePickerControllerSourceType sourceType = 0;
    self.imagePickerProfile = [[UIImagePickerController alloc] init];
    self.imagePickerProfile.delegate = self;
    self.imagePickerProfile.editing = YES;
    if (buttonIndex == 0) {

    } else if (buttonIndex == 1) {
    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    } else if (buttonIndex == 2) {
    sourceType = UIImagePickerControllerSourceTypeCamera;
    }

    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Device has no camera." delegate:nil cancelButtonTitle:@"OK"  otherButtonTitles: nil];
    [myAlertView show];
    return;
    }
    self.imagePickerProfile.sourceType = sourceType;
    [self.navigationController presentViewController:self.imagePickerProfile animated:YES completion:nil];
}

#pragma mark - Add activity indicator
/**************************************************************************************************
 Function to add activity indicator
 **************************************************************************************************/
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

#pragma mark - Favourite button tapped
/**************************************************************************************************
 Function to check Favourite and set favourite and unfavourite
 **************************************************************************************************/

- (void)isProfileFavourite {
    
    NSDictionary *param = @{};
    
    [self startAnimation];
    dispatch_async(dispatch_queue_create("favourite", NULL), ^{
        dispatch_async (dispatch_get_main_queue(), ^{
            [self.api callPostUrlWithHeader:param method:@"/api/v1/isFavourite" success:^(AFHTTPRequestOperation *task, id responseObject) {
                [self stopAnimation];
            } failure:^(AFHTTPRequestOperation *task, NSError *error) {
                NSLog(@"%@",error);
                [self stopAnimation];
            }];
        });
    });
}

@end
