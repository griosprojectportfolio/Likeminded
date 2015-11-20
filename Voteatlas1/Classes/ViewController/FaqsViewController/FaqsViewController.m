//
//  FaqsViewController.m
//  Voteatlas1
//
//  Created by GrepRuby3 on 04/11/15.
//  Copyright © 2015 Voteatlas. All rights reserved.
//

#import "FaqsViewController.h"

@interface FaqsViewController ()
@property(nonatomic,strong)AppApi *api;
@end

@implementation FaqsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.api = [AppApi sharedClient];
    
    self.title = @"FAQ's";
    self.navigationController.navigationBar.titleTextAttributes = @ {NSForegroundColorAttributeName:[UIColor setCustomColorOfTextField]};

    [self setDefaultSeetingOfContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
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
}

#pragma mark - Back btn tapped
- (void)backBtnTapped {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
