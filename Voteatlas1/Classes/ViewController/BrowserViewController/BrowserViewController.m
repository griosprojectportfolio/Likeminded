//
//  BrowserViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "BrowserViewController.h"

@implementation BrowserViewController {

  UIActivityIndicatorView *activityIndicator;
}

- (void)viewDidLoad {

  [super viewDidLoad];

  NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.strBrowseUrl]];
  [self.webVwBrowser loadRequest:request];
  [self addActivityIndicator];
  [self showActivityIndicator];

  UIBarButtonItem *barBtnAdd = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneBtnTapped:)];
  barBtnAdd.tintColor = [UIColor setCustomColorOfTextField];
  [self.navigationItem setLeftBarButtonItem:barBtnAdd];
}

- (void)doneBtnTapped:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
  [self hideActivityIndicator];
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

@end
