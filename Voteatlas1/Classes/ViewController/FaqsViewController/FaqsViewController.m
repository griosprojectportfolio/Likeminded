//
//  FaqsViewController.m
//  Voteatlas1
//
//  Created by GrepRuby3 on 04/11/15.
//  Copyright © 2015 Voteatlas. All rights reserved.
//

#import "FaqsViewController.h"

@interface FaqsViewController ()
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSString *htmlString;
@end

@implementation FaqsViewController
@synthesize htmlString, wvFaqs, activityIndicator;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"FAQ's";
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};
    [self setDefaultSeetingOfContent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"faq" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    wvFaqs.backgroundColor = [UIColor clearColor];
    [wvFaqs loadHTMLString:htmlString baseURL:nil];

}

#pragma mark - Back btn tapped
- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Webview delegate methods

- (void)webViewDidStartLoad:(UIWebView *)webView {
    [self addActivityIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self stopAnimation];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self stopAnimation];
}


#pragma mark - Add activity indicator

- (void)addActivityIndicator {
    
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectZero];
    activityIndicator.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activityIndicator.color = [UIColor setCustomDarkBlueColor];
    [wvFaqs bringSubviewToFront:activityIndicator];
    [wvFaqs addSubview:activityIndicator];
    [activityIndicator startAnimating];
}

- (void)stopAnimation {
    [activityIndicator stopAnimating];
    [activityIndicator removeFromSuperview];
}

@end
