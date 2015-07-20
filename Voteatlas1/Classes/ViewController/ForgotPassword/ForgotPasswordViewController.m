//
//  ForgotPasswordViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 19/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ForgotPasswordViewController.h"
#import "ConstantClass.h"

@interface ForgotPasswordViewController ()

@end

@implementation ForgotPasswordViewController

#pragma mark - View life cycle
- (void)viewDidLoad {

    [super viewDidLoad];
    self.api = [AppApi sharedClient];
    self.navigationController.navigationBar.hidden = false;
    self.navigationController.navigationBar.translucent = YES;
    self.title = @"ForgotPassword";
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    [self defaulUISettings];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Default Settings
- (void)defaulUISettings {

    UIBarButtonItem *btnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped)];
    btnBack.tintColor = [UIColor setCustomColorOfTextField];
    [self.navigationItem setLeftBarButtonItem:btnBack];

    if (IS_IPHONE_4_OR_LESS) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG4.png"]];
    } else if (IS_IPHONE_5) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG5.png"]];
    } else if (IS_IPHONE_6) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6.png"]];
    } else if (IS_IPHONE_6P) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BG6Pluse.png"]];
    }

    [self.txtEmailID setCustomImgVw:@"email" withWidth:self.view.frame.size.width - 40];
    self.txtEmailID.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithRed:86/256.0f green:163/256.0f blue:211/256.0f alpha:1.0]}];
    self.txtEmailID.textColor = [UIColor setCustomColorOfTextField];
    self.txtEmailID.keyboardType = UIKeyboardTypeEmailAddress;

    [self.btnOK setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.btnOK.backgroundColor= [UIColor setCustomRedColor];
    self.btnOK.titleLabel.font = [UIFont boldSystemFontOfSize:14.0];
}

#pragma mark - Back btn tapped
- (void)backBtnTapped {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Ok button taped
- (IBAction)okButtonTapped:(id)sender {

    [self handleForgotPasswordApi];
}

#pragma mark - Forgot password Api call
- (void)handleForgotPasswordApi {

    if ([ConstantClass checkNetworkConection] == YES) {

        NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setObject:self.txtEmailID.text forKey:@"user[email]"];

        [self.api callPostUrl:dict method:@"/api/v1/passwords" success:^(AFHTTPRequestOperation *task, id responseObject) {
            NSLog(@"%@",responseObject);
      } failure:^(AFHTTPRequestOperation *task, NSError *error) {
          NSLog(@"%@",error);
      }];
    }
}

#pragma mark - UIText field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return NO;
}

@end
