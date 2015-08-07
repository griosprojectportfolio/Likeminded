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

NSString *client_id = GOOGLE_PLUS_CLIEND_ID;
NSString *secret = GOOGLE_PLUS_SECRET_ID;
NSString *callbakc = GOOGLE_PLUS_CALL_BACK_URL;
NSString *scope = GOOGLE_PLUS_SCOPE;
NSString *visibleactions = GOOGLE_PLUS_VIVIBLE_ACTION;

@interface LogInViewController () {
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

    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"auth_token"] != nil) {

        TableViewController *vwController = (TableViewController*)[self.storyboard instantiateViewControllerWithIdentifier: @"TableViewID"];
        vwController.schemaBeliefId = self.schemaBeliefId;
        [self.navigationController pushViewController:vwController animated:NO];
        [self loginWithGoolgePlus:nil];
        return;
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    NSDictionary *userDetail = [[NSUserDefaults standardUserDefaults] objectForKey:@"Remember"];
    if (userDetail.count != 0) {
        self.txtUserID.text = [userDetail valueForKey:@"email"];
        self.txtPassword.text = [userDetail valueForKey:@"password"];
        self.btnCheckRemeber.checkState = 1;
    } else {
        self.txtPassword.text = @"";
        self.txtUserID.text = @"";
    }
    [self removeWebView];
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
  NSLog(@"%@", self.navigationController.viewControllers);

    [MagicalRecord setupCoreDataStackWithStoreNamed:@"Voteatlas"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Set Default UI
/**************************************************************************************************
 Function to set default ui
 **************************************************************************************************/
- (void)defaulUISettings {

    self.view.backgroundColor = [UIColor colorWithPatternImage:[ConstantClass imageAccordingToPhone]];
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

        self.btnCheckRemeber = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.lblRememberMe.frame.origin.x - 27, self.lblRememberMe.frame.origin.y + 2 , 22, 22)];
        [self.view addSubview:self.btnCheckRemeber];

        if (!IS_IPHONE_5) {
            self.imgViewTextLogo.frame = CGRectMake((self.view.frame.size.width - (self.imgViewTextLogo.frame.size.width+20))/2,self.imgViewTextLogo.frame.origin.y-20, self.imgViewTextLogo.frame.size.width+20, self.imgViewTextLogo.frame.size.height+20);
        }
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
    btnFb.frame = CGRectMake(fbXAxs, self.lblRememberMe.frame.origin.y + yAxis, btnFb.frame.size.width, btnFb.frame.size.height);
    btnTwitter.frame = CGRectMake(btnFb.frame.origin.x+ btnFb.frame.size.width + 25, self.lblRememberMe.frame.origin.y + yAxis, btnTwitter.frame.size.width , btnTwitter.frame.size.height);
    btnGooglePlus.frame = CGRectMake(btnTwitter.frame.origin.x+ btnTwitter.frame.size.width + 25, self.lblRememberMe.frame.origin.y + yAxis, btnGooglePlus.frame.size.width, btnGooglePlus.frame.size.height);
}

- (void)setFrameForiPhone4 {

    self.imgViewTextLogo.frame = CGRectMake((self.view.frame.size.width - self.imgViewTextLogo.frame.size.width)/2,self.imgViewTextLogo.frame.origin.y-40, self.imgViewTextLogo.frame.size.width, self.imgViewTextLogo.frame.size.height);
    self.txtPassword.frame = CGRectMake(self.txtPassword.frame.origin.x,self.txtPassword.frame.origin.y-40, self.txtPassword.frame.size.width, self.txtPassword.frame.size.height);
    self.txtUserID.frame = CGRectMake(self.txtUserID.frame.origin.x,self.txtUserID.frame.origin.y-40, self.txtUserID.frame.size.width, self.txtUserID.frame.size.height);
    self.btnSignUp.frame = CGRectMake(self.txtPassword.frame.origin.x,self.txtPassword.frame.origin.y+55,self.txtPassword.frame.size.width/2 - 10, 40);
    self.btnLogIn.frame = CGRectMake(self.btnSignUp.frame.size.width+self.btnSignUp.frame.origin.x+17, self.btnSignUp.frame.origin.y, self.btnSignUp.frame.size.width, 40);
    self.lblRememberMe.frame = CGRectMake(self.lblRememberMe.frame.origin.x, self.btnSignUp.frame.origin.y + 50 , self.lblRememberMe.frame.size.width, self.lblRememberMe.frame.size.height);
    self.btnCheckRemeber = [[M13Checkbox alloc]initWithFrame:CGRectMake(self.lblRememberMe.frame.origin.x - 22, self.lblRememberMe.frame.origin.y + 1 , 20, 20)];
    [self.view addSubview:self.btnCheckRemeber];
}

#pragma mark - Login button tapped
/**************************************************************************************************
 Function to login btn tapped
 **************************************************************************************************/
- (IBAction)loginButtonTapped:(id)sender {

    [self.view endEditing:YES];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimation];
    });

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
        } completion:^(BOOL success, NSError *error) {
            self.auth_token = [dis objectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:[[dis objectForKey:@"language"] objectForKey:@"name"] forKey:@"userlanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            NSLog(@"%@",self.auth_token);
            [self stopAnimation];
            TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
            vc.userID = self.auth_token;
            [self.navigationController pushViewController:vc animated:YES];
            flag = TRUE;
        }];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        [self stopAnimation];
        NSLog(@"%@",task.responseString);
        NSString *jsonMessage = task.responseString;
        NSData *data = [jsonMessage dataUsingEncoding:NSUTF8StringEncoding];
        if (data != nil) {
            id jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSDictionary *dictMessage = (NSDictionary *)jsonResponse;
            NSString *msg = [NSString stringWithFormat:@"%@.", [dictMessage valueForKey:@"info"]];
            if ([msg isKindOfClass:[NSNull class]]) {
                    msg = @"Please try again.";
            }
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Alert"message:msg delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alertVw show];
        } else {
            UIAlertView *alertVw = [[UIAlertView alloc]initWithTitle:@"Alert"message:@"Please try again. Server has been time out." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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

#pragma mark - Close button tapped
-(IBAction)closeButtonTapped:(id)sender{
  TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
  [self.navigationController pushViewController:vc animated:NO];
}



#pragma mark - Sign Up button tapped
/**************************************************************************************************
 Function to sign up btn tapped
 **************************************************************************************************/
- (IBAction)signupButtonTapped:(id)sender {

    SignUpViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Forgot password button tapped
/**************************************************************************************************
 Function to forgot password btn tapped
 **************************************************************************************************/
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

    [FBSession openActiveSessionWithReadPermissions:@[ @"basic_info", @"read_stream"]  allowLoginUI:YES
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

    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimation];
    });

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
        } completion:^(BOOL success, NSError *error) {
            [self stopAnimation];
            self.auth_token = [dis objectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
            NSString *languageName = @"English";
            NSString *strLagguage = [dis objectForKey:@"language"];
            if (![strLagguage isKindOfClass:[NSNull class]]) {
              languageName = [[dis objectForKey:@"language"] objectForKey:@"name"];
            }
            [[NSUserDefaults standardUserDefaults]setValue:languageName forKey:@"userlanguage"];
            [[NSUserDefaults standardUserDefaults] synchronize];

            TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
            vc.userID = self.auth_token;
            [self.navigationController pushViewController:vc animated:YES];
        }];
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

    UIButton *btn = (UIButton*)sender;
    self.btnTag = btn.tag;

    if ([ConstantClass checkNetworkConection] == NO) {
        return;
    }

    if (![SLComposeViewController
          isAvailableForServiceType:SLServiceTypeTwitter]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Error" message:TWITTER_CONNECT_ERROR delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return;
    } else {

        dispatch_async(dispatch_get_main_queue(), ^{
            [self startAnimation];
        });

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
           }
         }];
    }
}

- (void)callTwitterLoginApi:(NSDictionary *)dictUser {

    NSDictionary *param = @{@"token":[dictUser valueForKey:@"id"]};
    [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/social_login" success:^(AFHTTPRequestOperation *task, id responseObject) {
        NSLog(@"%@",responseObject);
        [self stopAnimation];
        NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
        NSDictionary *dis = [dicst objectForKey:@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            [User entityFromArray:arr inContext:localContext];
        } completion:^(BOOL success, NSError *error) {
            self.auth_token = [dis objectForKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
            [[NSUserDefaults standardUserDefaults]setValue:[[dis objectForKey:@"language"] objectForKey:@"name"] forKey:@"userlanguage"];
            NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"userlanguage"]);
            [[NSUserDefaults standardUserDefaults] synchronize];

            TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
            vc.userID = self.auth_token;
            [self.navigationController pushViewController:vc animated:YES];
        }];
    } failure:^(AFHTTPRequestOperation *task, NSError *error) {
        NSLog(@"%@",task.responseString);
        SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
        vcSignUp.dictUserDetail = dictUser;
        vcSignUp.btnTag = self.btnTag;
        [self stopAnimation];
        [self.navigationController pushViewController:vcSignUp animated:YES];
    }];
}

- (void)addWebViewOfGooglePlus {

    vwOverlayWebView = [[UIView alloc]initWithFrame:self.view.frame];
    vwOverlayWebView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:1.0];
    [self.view addSubview:vwOverlayWebView];

    webview = [[UIWebView alloc]initWithFrame:CGRectMake(10, 20, vwOverlay.frame.size.width-20, vwOverlay.frame.size.height-40)];
    webview.delegate = self;
    [vwOverlayWebView addSubview:webview];

    UIButton *btnHideMap = [UIButton buttonWithType:UIButtonTypeCustom];
    btnHideMap.frame = CGRectMake(self.view.frame.size.width - 44, 9, 44, 44);
    [btnHideMap setTitle:@"X" forState:UIControlStateNormal];
    [btnHideMap setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnHideMap addTarget:self action:@selector(removeWebView) forControlEvents:UIControlEventTouchUpInside];
    btnHideMap.titleLabel.textColor = [UIColor darkGrayColor];
    [vwOverlayWebView addSubview:btnHideMap];
}

- (void)removeWebView {

    if(vwOverlayWebView != nil) {
        [vwOverlayWebView removeFromSuperview];
    }
}

#pragma mark - Login with google plus
/**************************************************************************************************
 Function to google plus btn tapped
 **************************************************************************************************/
- (IBAction)loginWithGoolgePlus:(id)sender {

    [self addWebViewOfGooglePlus];
    NSHTTPCookieStorage* cookies = [NSHTTPCookieStorage sharedHTTPCookieStorage]; // Delete cookies
    NSArray *allCookies = [cookies cookies];
    for(NSHTTPCookie *cookie in allCookies) {
        if([[cookie domain] rangeOfString:@"google.com"].location != NSNotFound) {
            [cookies deleteCookie:cookie];
        }
    }

    [self startAnimation];
    NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/auth?response_type=code&client_id=%@&redirect_uri=%@&scope=%@&data-requestvisibleactions=%@",client_id,callbakc,scope,visibleactions];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopAnimation];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {

  if ([[[request URL] host] isEqualToString:@"localhost"]) {

      // Extract oauth_verifier from URL query
    NSString* verifier = nil;
    NSArray* urlParams = [[[request URL] query] componentsSeparatedByString:@"&"];
    for (NSString* param in urlParams) {
      NSArray* keyValue = [param componentsSeparatedByString:@"="];
      NSString* key = [keyValue objectAtIndex:0];
      if ([key isEqualToString:@"code"]) {
        verifier = [keyValue objectAtIndex:1];
        NSLog(@"verifier %@",verifier);
        break;
      } else if ([key isEqualToString:@"error"]) {
          [self removeWebView];
          return YES;
      }
    }

    if (verifier) {
      NSString *data = [NSString stringWithFormat:@"code=%@&client_id=%@&client_secret=%@&redirect_uri=%@&grant_type=authorization_code", verifier,client_id,secret,callbakc];
      NSString *url = [NSString stringWithFormat:@"https://accounts.google.com/o/oauth2/token"];
      NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
      [request setHTTPMethod:@"POST"];
      [request setHTTPBody:[data dataUsingEncoding:NSUTF8StringEncoding]];
      NSURLConnection *aConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
      NSLog(@"%@",aConnection);
      receivedData = [[NSMutableData alloc] init];
    } else {
        // ERROR!
    }
    return YES;
  }
  return YES;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

    [receivedData appendData:data];
    NSLog(@"verifier %@",receivedData);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                  message:[NSString stringWithFormat:@"%@", error]
                                                 delegate:nil
                                        cancelButtonTitle:@"OK"
                                        otherButtonTitles:nil];
    [alert show];
    [self removeWebView];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {

    [self removeWebView];
    NSDictionary *tokenData = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableContainers error:nil];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self startAnimation];
        [self momentButton:[tokenData objectForKey:@"access_token"]];
    });
}

- (void)momentButton:(NSString*)accessTocken {

    NSString *str =  [NSString stringWithFormat:@"https://www.googleapis.com/oauth2/v1/userinfo?access_token=%@",accessTocken];
    NSString *escapedUrl = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",escapedUrl]];
    NSString *jsonData = [[NSString alloc] initWithContentsOfURL:url usedEncoding:nil error:nil];
    NSData *data = [jsonData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dictUserInfo = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if(dictUserInfo.count != 0) {
        [self finishedWithAuth:dictUserInfo];
    }
    NSLog(@"%@",dictUserInfo);
}

- (void)finishedWithAuth:(NSDictionary *)dictUserInfo {

    NSDictionary *param = @{@"google":@"1",
                            @"email":[dictUserInfo objectForKey:@"email"]};

    [self.api callGETUrlWithHeaderAuthentication:param method:@"/api/v1/social_login" success:^(AFHTTPRequestOperation *task, id  responseObject) {
          NSLog(@"%@",responseObject);
          NSDictionary *dicst = [[NSDictionary alloc]initWithDictionary:responseObject];
          NSDictionary *dis = [dicst objectForKey:@"data"];
          NSMutableArray *arr = [NSMutableArray arrayWithObject:dis];
          [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
              [User entityFromArray:arr inContext:localContext];
          } completion:^(BOOL success, NSError *error) {
          self.auth_token = [dis objectForKey:@"auth_token"];
              [[NSUserDefaults standardUserDefaults]setValue:self.auth_token forKey:@"auth_token"];
              [[NSUserDefaults standardUserDefaults]setValue:[[dis objectForKey:@"language"] objectForKey:@"name"] forKey:@"userlanguage"];
              [[NSUserDefaults standardUserDefaults] synchronize];

              [self stopAnimation];
              TableViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TableViewID"];
              vc.userID = self.auth_token;
              [self.navigationController pushViewController:vc animated:YES];
          }];
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          [self removeWebView];
          NSLog(@"%@",task.responseString);
          SignUpViewController *vcSignUp = [self.storyboard instantiateViewControllerWithIdentifier:@"signupID"];
          vcSignUp.btnTag = self.btnTag;
          vcSignUp.isGoogle = YES;
          vcSignUp.strGPlusMailId = [dictUserInfo objectForKey:@"email"];
          [self.navigationController pushViewController:vcSignUp animated:YES];
          [self stopAnimation];
      }];
}


#pragma mark - Add activity indicator
/**************************************************************************************************
 Function to add and show activity indicaor
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

@end
