//
//  DetailPageViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "DetailPageViewController.h"

@interface DetailPageViewController ()

@end

@implementation DetailPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)likeBtnTapped:(id)sender {

    if ([btnLike.imageView.image isEqual:[UIImage imageNamed:@"5.png"]]) {

    }
}


- (IBAction)unlikeBtnTapped:(id)sender {

    if ([btnUnlike.imageView.image isEqual:[UIImage imageNamed:@"4.png"]]) {

    }
}


- (IBAction)shareBtnTapped:(id)sender {

    if ([btnShare.imageView.image isEqual:[UIImage imageNamed:@".png"]]) {

    }
}


- (IBAction)downloadBtnTapped:(id)sender {

    if ([btnDownload.imageView.image isEqual:[UIImage imageNamed:@"6.png"]]) {

    }
}


- (IBAction)mapBtnTapped:(id)sender {

    if ([btnMap.imageView.image isEqual:[UIImage imageNamed:@"4.png"]]) {

    }
}


@end
