    //
    //  LogInViewController.m
    //  Voteatlas1
    //
    //  Created by GrepRuby on 13/03/15.
    //  Copyright (c) 2015 Voteatlas. All rights reserved.
    //

#import "LogInViewController.h"
#import "TableViewController.h"
#import "SignUpViewController.h"
#import "Reachability.h"
#import "ForgotPasswordViewController.h"
#import "SignUpViewController.h"
#import "User.h"
#import "ConstantClass.h"

#define CLIEND_ID @"1036316931513-15iksgifetf94do55ia9cnostko4bg6n.apps.googleusercontent.com" //add your Google Plus ClientID here

static NSString * const kClientId = CLIEND_ID;

@interface LogInViewController ()<GPPSignInDelegate> {
    UIActivityIndicatorView *activityIndicator;
    UIView *vwOverlay;
}

@end

@implementation LogInViewController

@synthesize password, description;

#pragma mark - VIew life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.navigationController.navigationBar.hidden = true;
    self.txtUserID.delegate = self;
    self.txtPassword.delegate = self;
    [self defaulUISettings];
    [self addActivityIndicator];

    [[GPPSignIn sharedInstance] signOut]; //signout
    [self loginWithGoolgePlus:nil];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self deleteAllEntityObjects];
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Remember"];

    if (userDetail.count != 0) {
        self.txtUserID.text = [userDetail valueForKey:@"email"];
        self.txtPassword.text = [userDetail valueForKey:@"password"];
        self.btnCheckRemeber.checkState = 1;
    } else {
        self.txtPassword.text = @"";
        self.txtUserID.text = @"";
    }
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Default UI
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
    int txtFieldWidth = self.view.frame.size.width - 40;

    [self.txtPassword setCustomImgVw:@"password" withWidth:txtFieldWidth];
    self.txtPassword.secureTextEntry = YES;
    self.txtPassword.textColor = [UIColor setCustomColorOfTextField];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];

    [self.txtUserID setCustomImgVw:@"email" withWidth:txtFieldWidth];
    self.txtUserID.textColor = [UIColor setCustomColorOfTextField];
    self.txtUserID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]}];
    if(!IS_IPHONE_4_OR_LESS) {
        self.btnSignUp.frame = CGRectMake(self.txtPassword.frame.origin.x,self.txtPassword.frame.origin.y+60,self.txtPassword.frame.size.width/2 - 10, 40);
        self.btnLogIn.frame = CGRectMake(self.btnSignUp.frame.size.width+self.btnSignUp.frame.origin.x+17, self.btnSignUp.frame.origin.y, self.btnSignUp.frame.size.width, 40);

        self.lblRememberMe.frame = CGRectMake(self.lblRememberMe.frame.origin.x, self.btnSignUp.frame.origin.y + 63 , self.lblRememberMe.frame.size.width, self.lblRememberMe.frame.size.height);

        self.btnCheckRemeber = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.lblRememberMe.frame.origin.x - 23, self.lblRememberMe.frame.origin.y + 3 , 20, 20)];
        [self.view addSubview:self.btnCheckRemeber];
    } else {
        [self setFrameForiPhone4];
    }

    [self.btnSignUp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.btnSignUp setBackgroundColor:[UIColor setCustomSignUpColor]];

    [self.btnLogIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnLogIn.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
    [self.btnLogIn setBackgroundColor:[UIColor setCustomRedColor]];

    self.lblRememberMe.textColor = [UIColor whiteColor];

    int fbXAxs = self.view.frame.size.width - (44*3 + 25*3);

    int yAxis = 60;
    fbXAxs = fbXAxs - 75;
    if (IS_IPHONE_4_OR_LESS) {
        fbXAxs = fbXAxs + 25;
        yAxis = 35;
    } else if (IS_IPHONE_5) {
        fbXAxs = fbXAxs + 25;
    } else if (IS_IPHONE_6P) {
        fbXAxs = fbXAxs - 25;
    }
    btnFb.frame = CGRectMake(fbXAxs, self.lblRememberMe.frame.origin.y + yAxis, btnFb.frame.size.width ,  btnFb.frame.size.height);
    btnTwitter.frame = CGRectMake(btnFb.frame.origin.x+ btnFb.frame.size.width + 25, self.lblRememberMe.frame.origin.y + yAxis, btnTwitter.frame.size.width ,  btnTwitter.frame.size.height);
    btnGooglePlus.frame = CGRectMake(btnTwitter.frame.origin.x+ btnTwitter.frame.size.width + 25, self.lblRememberMe.frame.origin.y + yAxis, btnGooglePlus.frame.size.width, btnGooglePlus.frame.size.height);

    //google plus button layout
    self.signInButton = [[GPPSignInButton alloc]initWithFrame:CGRectMake(btnTwitter.frame.origin.x+ btnTwitter.frame.size.width + 25, self.lblRememberMe.frame.origin.y + yAxis, 50, 50)];
        //self.signInButton.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.signInButton];
    [self.view bringSubviewToFront:self.signInButton];
}

#pragma mark - Delete all entity
- (void)deleteAllEntityObjects {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {

        NSArray *arrEntities = [[NSArray alloc] initWithObjects:@"User",nil];
        for (int i=0; i < arrEntities.count; i++) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];

            NSEntityDescription *entity = [NSEntityDescription entityForName:[arrEntities objectAtIndex:i] inManagedObjectContext:localContext];
            [fetchRequest setEntity:entity];
            NSError *error;
            NSArray *items = [localContext executeFetchRequest:fetchRequest error:&error];

            for (NSManagedObject *managedObject in items) {
                [localContext deleteObject:managedObject];
            }
            if (![localContext save:&error]) {

            }
        }
    }];
}

- (void) setFrameForiPhone4 {
    self.imgViewEarth.frame = CGRectMake(self.imgViewEarth.frame.origin.x,self.imgViewEarth.frame.origin.y-40, self.imgViewEarth.frame.size.width, self.imgViewEarth.frame.size.height);
    self.imgViewTextLogo.frame = CGRectMake(self.imgViewTextLogo.frame.origin.x,self.imgViewTextLogo.frame.origin.y-40, self.imgViewTextLogo.frame.size.width, self.imgViewTextLogo.frame.size.height);
    self.txtPassword.frame = CGRectMake(self.txtPassword.frame.origin.x,self.txtPassword.frame.origin.y-40, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
    self.txtUserID.frame = CGRectMake(self.txtUserID.frame.origin.x,self.txtUserID.frame.origin.y-40, self.txtUserID.frame.size.width, self.txtUserID.frame.size.height);
    self.btnSignUp.frame = CGRectMake(self.txtPassword.frame.origin.x,self.txtPassword.frame.origin.y+55,self.txtPassword.frame.size.width/2 - 10, 40);
    self.btnLogIn.frame = CGRectMake(self.btnSignUp.frame.size.width+self.btnSignUp.frame.origin.x+17, self.btnSignUp.frame.origin.y, self.btnSignUp.frame.size.width, 40);
    self.lblRememberMe.frame = CGRectMake(self.lblRememberMe.frame.origin.x, self.btnSignUp.frame.origin.y + 50 , self.lblRememberMe.frame.size.width, self.lblRememberMe.frame.size.height);
    self.btnCheckRemeber = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.lblRememberMe.frame.origin.x - 22, self.lblRememberMe.frame.origin.y + 7 , 20, 20)];
    [self.view addSubview:self.btnCheckRemeber];
}

#pragma mark - Login button tapped
- (IBAction)loginButtonTapped:(id)sender {

    if ([ConstantClass checkNetworkConection] == YES) {
        [self fetchDataFromDataBase];
    }
}

- (void)fetchDataFromDataBase{

    if (self.txtUserID.text == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Please enter valid email/userID." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    }

    if (self.txtPassword.text.length == 0) {
        UIAlertView *msgAlert = [[UIAlertView alloc]initWithTitle:@"Alert" message:@"Please enter name." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [msgAlert show];
        return;
    }
    [self startAnimation];
    NSMutableDictionary *dicstUser = [[NSMutableDictionary alloc]init];
    [dicstUser setObject:self.txtUserID.text forKey:@"email"];
    [dicstUser setObject:self.txtPassword.text forKey:@"password"];

    if (self.btnCheckRemeber.checkState == 1) {
        [[NSUserDefaults standardUserDefaults]setObject:dicstUser forKey:@"Remember"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } else {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Remember"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }

    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:dicstUser forKey:@"user"];

    [self.api callPostUrl:param method:@"/api/v1/sessions/sign_in" success:^(AFHTTPRequestOperation *task, id responseObject) {

        NSLog(@"%@",responseObject);
        NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSDictionary *dis = [dicst objectForKey:@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [User entityFromArray:arr inContext:localContext];
        }];
        self.auth_token = [dis objectForKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSLog(@"%@",self.auth_token);
        [self stopAnimation];
        TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
        vc.userID = self.auth_token;
        [self.navigationController pushViewController:vc animated:YES];
        flag = TRUE;

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self stopAnimation];
        NSLog(@"%@",task.responseString);
        NSString *jsonMessage = task.responseString; //@"@{sss:asdasd, asd:asdasd}";//
        NSData *data = [jsonMessage dataUsingEncoding:NSUTF8StringEncoding];
        if (data != nil) {
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *dictMessage = (NSDictionary *)jsonResponse;
            NSString *msg = [NSString stringWithFormat:@"%@.", [dictMessage valueForKey:@"info"]];
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Alert"message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVw show];
        }
    }];
}

- (NSManagedObjectContext *)managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

#pragma mark - Sign Up button tapped
- (IBAction)signupButtonTapped:(id)sender {

    SignUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Forgot password button tapped
- (IBAction)forgotPassButtonTapped:(id)sender {

    ForgotPasswordViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordID"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UIText Field Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (IS_IPHONE_4_OR_LESS) {
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y - 50;
        self.view.frame = frame;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (IS_IPHONE_4_OR_LESS) {
        CGRect frame = self.view.frame;
        frame.origin.y = frame.origin.y + 50;
        self.view.frame = frame;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Facebook btn tapped
/**************************************************************************************************
 Function to facebook btn tapped
 **************************************************************************************************/

- (IBAction)facebookBtnTapped:(id)sender {

    UIButton *btn = (UIButton*)sender;
    self.btnTag = btn.tag;

    if ([ConstantClass checkNetworkConection] == YES) {

        if (![SLComposeViewController
              isAvailableForServiceType:SLServiceTypeFacebook]) {

            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:ERROR message:FB_CONNECT_ERROR delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVw show];

            return;
        } else {
            if (FBSession.activeSession.state == FBSessionStateOpen ||
                FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {

                sharedAppDelegate.fbSession = FBSession.activeSession;
                sharedAppDelegate.hasFacebook = YES;
            }
        }

        [self getProfileOfFB];
    }
}

#pragma mark - Login with facebook
/**************************************************************************************************
 Function to login on facebook
 **************************************************************************************************/

- (void)loginFacebook {

    [FBSession openActiveSessionWithReadPermissions:@[ @"basic_info",  @"read_stream"]  allowLoginUI:YES
                                  completionHandler:^(FBSession *session,
                                                      FBSessionState state,
                                                      NSError *error) {
                                      if (error) {

                                          sharedAppDelegate.hasFacebook = NO;
                                          UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:ERROR message:UNAUTHORIZED_USER delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                                          [alertVw show];
                                          [self stopAnimation];
                                      } else {

                                          sharedAppDelegate.hasFacebook = YES;
                                          sharedAppDelegate.fbSession = session;
                                          [self getProfileOfFB];
                                      }
                                  }];
}

#pragma mark - Get user facebook profile info
/**************************************************************************************************
 Function to get user facebook profile info
 **************************************************************************************************/

- (void)getProfileOfFB {

    [self startAnimation];
    if (!sharedAppDelegate.hasFacebook) {
        [self loginFacebook];
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"access_token"] = sharedAppDelegate.fbSession.accessTokenData;

    FBRequest *request = [FBRequest requestForGraphPath:@"me"];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (error) {
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:ERROR message:UNAUTHORIZED_USER delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVw show];
            [self stopAnimation];
        } else {

            NSDictionary *dictInfo = (NSDictionary *)result;
            NSLog(@"%@", dictInfo);
            [self callFacebookLoginApi:dictInfo];
        }
    }];
}

- (void)callFacebookLoginApi:(NSDictionary *)dictUser {

    NSDictionary *param = @{@"token":[dictUser valueForKey:@"id"]};
    [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/social_login" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"%@",responseObject);

        NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSDictionary *dis = [dicst objectForKey:@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [User entityFromArray:arr inContext:localContext];
        }];
        [self stopAnimation];
        self.auth_token = [dis objectForKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
        vc.userID = self.auth_token;
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self stopAnimation];

        NSLog(@"%@",task.responseString);
        SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
        vcSignUp.dictUserDetail = dictUser;
        vcSignUp.btnTag = self.btnTag;
        [self.navigationController pushViewController:vcSignUp animated:YES];
    }];
}

#pragma mark - Twitter btn tapped
/**************************************************************************************************
 Function to twitter btn tapped
 **************************************************************************************************/

- (IBAction)twitterBtnTapped:(id)sender {

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    if (![SLComposeViewController
          isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"Go to settings for login with Twitter." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    } else {

        [self startAnimation];
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account
                                      accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];

        [account requestAccessToAccountsWithType:accountType
                                         options:nil completion:^(BOOL granted, NSError *error)
         {
           if (granted == YES) {
               NSArray *arrayOfAccounts = [account
                                           accountsWithAccountType:accountType];

               if ([arrayOfAccounts count] > 0)
                 {
                   sharedAppDelegate.twitterAccount = [arrayOfAccounts lastObject];

                   NSURL *requestURL = [NSURL URLWithString:TWITTER_USER_PROFILE];
                   SLRequest *timelineRequest = [SLRequest
                                                 requestForServiceType:SLServiceTypeTwitter
                                                 requestMethod:SLRequestMethodGET
                                                 URL:requestURL parameters:nil];

                   timelineRequest.account = sharedAppDelegate.twitterAccount;

                   [timelineRequest performRequestWithHandler:
                    ^(NSData *responseData, NSHTTPURLResponse
                      *urlResponse, NSError *error) {

                        if (error) {
                            [self stopAnimation];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"There is some authentication problem." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                            [alert show];
                            return;
                        } else {

                            NSArray *arryTwitte = [NSJSONSerialization
                                                   JSONObjectWithData:responseData
                                                   options:NSJSONReadingMutableLeaves
                                                   error:&error];

                            if (arryTwitte.count != 0) {
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    NSDictionary *dictInfo = (NSDictionary *)arryTwitte;
                                    [self callTwitterLoginApi:dictInfo];
                                });
                            }
                        }
                    }];
                 }
           } else {

               NSLog(@"error %@",error);
                   // [Constant showAlert:ERROR_CONNECTING forMessage:ERROR_AUTHEN];
           }
         }];
    }
}

- (void)callTwitterLoginApi:(NSDictionary *)dictUser {
    NSDictionary *param = @{@"token":[dictUser valueForKey:@"id"]};

    [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/social_login" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"%@",responseObject);

        NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSDictionary *dis = [dicst objectForKey:@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [User entityFromArray:arr inContext:localContext];
        }];
        self.auth_token = [dis objectForKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
        vc.userID = self.auth_token;
        [self.navigationController pushViewController:vc animated:YES];

    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        NSLog(@"%@",task.responseString);
        SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
        vcSignUp.dictUserDetail = dictUser;
        vcSignUp.btnTag = self.btnTag;
        [self.navigationController pushViewController:vcSignUp animated:YES];
    }];
}

#pragma mark - Login with google plus
- (void)loginWithGoolgePlus:(id)sender {

    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.shouldFetchGooglePlusUser = YES;
    signIn.shouldFetchGoogleUserEmail = YES;  // Uncomment to get the user's email

        // You previously set kClientId in the "Initialize the Google+ client" step
    signIn.clientID = kClientId;

    [GPPSignIn sharedInstance].actions = [NSArray arrayWithObjects:
                                          @"http://schemas.google.com/AddActivity",
                                          @"http://schemas.google.com/BuyActivity",
                                          @"http://schemas.google.com/CheckInActivity",
                                          @"http://schemas.google.com/CommentActivity",
                                          @"http://schemas.google.com/CreateActivity",
                                          @"http://schemas.google.com/ListenActivity",
                                          @"http://schemas.google.com/ReserveActivity",
                                          @"http://schemas.google.com/ReviewActivity",
                                          nil];

        // Uncomment one of these two statements for the scope you chose in the previous step
    signIn.scopes = @[ kGTLAuthScopePlusLogin];  // "https://www.googleapis.com/auth/plus.login" scope
                                                  //signIn.scopes = @[ @"profile" ];            // "profile" scope
    signIn.delegate = self;

    [signIn trySilentAuthentication];
}

- (void)finishedWithAuth: (GTMOAuth2Authentication *)auth
                   error: (NSError *) error {

    NSLog(@"Received error %@ and auth object %@",error, auth);
    if (error) {
            // Do some error handling here.
    } else {
        NSLog(@"%@ %@",[GPPSignIn sharedInstance].userEmail, [GPPSignIn sharedInstance].userID);
            [self refreshInterfaceBasedOnSignIn];

        NSDictionary *param = @{@"google":@"1",
                                @"email":[GPPSignIn sharedInstance].userEmail };

        [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/social_login" success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSLog(@"%@",responseObject);
            NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
            NSDictionary *dis = [dicst objectForKey:@"data"];
            NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
                [User entityFromArray:arr inContext:localContext];
            }];
            self.auth_token = [dis objectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
            vc.userID = self.auth_token;
            [self.navigationController pushViewController:vc animated:YES];
        } failure:^(AFHTTPRequestOperation *task, NSError *error) {
            NSLog(@"%@",task.responseString);
            SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
            vcSignUp.btnTag = self.btnTag;
            vcSignUp.isGoogle = YES;
            vcSignUp.strGPlusMailId = [GPPSignIn sharedInstance].userEmail;
            [self.navigationController pushViewController:vcSignUp animated:YES];
        }];
    }
}

- (void)refreshInterfaceBasedOnSignIn {
    if ([[GPPSignIn sharedInstance] authentication]) {

    } else {

    }
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
