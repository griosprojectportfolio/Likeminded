//
//  ShowImageOrVideoViewController.m
//  SocialIntegaration
//
//  Created by GrepRuby on 19/11/14.
//  Copyright (c) 2014 GrepRuby. All rights reserved.
//

#import "ShowImageOrVideoViewController.h"

@interface ShowImageOrVideoViewController () <UIWebViewDelegate, NSURLConnectionDelegate> {

    NSMutableData *_responseData;
    NSURLConnection *conn;
    NSString *videoUrl;
}

@end

@implementation ShowImageOrVideoViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {

    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    self.navigationController.navigationBarHidden = NO;
    [self.webViewVideo setHidden:YES];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationItem.hidesBackButton = YES;

    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlay setImage:[UIImage imageNamed:@"play-btn.png"] forState:UIControlStateNormal];
    btnPlay.frame = self.imgVwLargeImg.frame;

    UIBarButtonItem *barBtnBack = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backBtnTapped:)];
    barBtnBack.tintColor = [UIColor setCustomColorOfTextField];
    self.navigationItem.leftBarButtonItem = barBtnBack;

    if (self.belief.hasImage == 1) { // video on web view
        self.navigationItem.title = @"Show Image";

        [self.imgVwLargeImg setHidden:NO];
        [self.imgVwLargeImg sd_setImageWithURL:[NSURL URLWithString:self.self.belief.imageUrl] placeholderImage:nil];
    }

    self.scrollVwImg.backgroundColor = [UIColor whiteColor];
    self.scrollVwImg.minimumZoomScale = 1.0;
    self.scrollVwImg.maximumZoomScale = 3.0;
    [self.scrollVwImg setZoomScale:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - ImageVwDelegates
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.imgVwLargeImg;
}

#pragma mark - Back Btn tapped
- (IBAction)backBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
