//
//  ProfileViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 23/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewController : UIViewController

@property(nonatomic,strong)NSMutableDictionary *dictProfile;

@property(nonatomic,strong)IBOutlet UILabel *lblStatus;

@property(nonatomic,strong)IBOutlet UIImageView *imgProfil;

@property(nonatomic,strong)IBOutlet UITextField *txtfanmails;
@property(nonatomic,strong)IBOutlet UITextField *txtTotVoate;
@property(nonatomic,strong)IBOutlet UITextField *txtAgree;
@property(nonatomic,strong)IBOutlet UITextField *txtDisagree;
@property(nonatomic,strong)IBOutlet UITextField *txtCommon;
@property(nonatomic,strong)IBOutlet UITextField *txtNotCommon;
@property(nonatomic,strong)IBOutlet UITextField *txtAboutme;

@end
