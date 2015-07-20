//
//  BrowserViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 08/05/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrowserViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webVwBrowser;
@property (nonatomic, strong) NSString *strBrowseUrl;
@end
