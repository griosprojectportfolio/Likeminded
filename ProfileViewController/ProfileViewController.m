//
//  ProfileViewController.m
//  Voteatlas1
//
//  Created by GrepRuby on 23/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  NSLog(@"%@",self.dictProfile);
  [self setDataContents];
}

-(void)setDataContents{
  NSString *str =[self.dictProfile objectForKey:@"about"];
  if ([str isEqual:[NSNull null]]) {
  }else{
    self.txtAboutme.text = [self.dictProfile objectForKey:@"about"];
    self.lblStatus.text = [self.dictProfile objectForKey:@"status"];
  }
  self.txtAgree.text = [NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"agree"]];
  self.txtTotVoate.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"total_vote"]];
  self.txtfanmails.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"fan_mail"]];
  self.txtDisagree.text =[NSString stringWithFormat:@"%@",[self.dictProfile objectForKey:@"dis_agree"]];
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

@end
