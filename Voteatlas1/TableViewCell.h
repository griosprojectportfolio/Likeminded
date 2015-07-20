//
//  TableViewCell.h
//  Voteatlas
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIImageView *displayIcon;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;

@property (nonatomic, strong) IBOutlet UIButton *supprtBtn;
@property (nonatomic, strong) IBOutlet UIButton *opposeBtn;
@property (nonatomic, strong) IBOutlet UIButton *trashFileBtn;

@property (nonatomic, strong) IBOutlet UIButton *mapBtn;
@property (nonatomic, strong) IBOutlet UIButton *shareBtn;
@property (nonatomic, strong) IBOutlet UIButton *postedBtn;

@property (nonatomic, strong) IBOutlet UIButton *transBtn;
@property (nonatomic, strong) IBOutlet UIButton *flageBtn;


-(IBAction) supprtBtnTapped:(id)sender;
-(IBAction) opposeBtnTapped:(id)sender;
-(IBAction) trashFileBtnTapped:(id)sender;

-(IBAction) mapBtnTapped:(id)sender;
-(IBAction) shareBtnTapped:(id)sender;
-(IBAction) postedBtnTapped:(id)sender;

-(IBAction) transBtnTapped:(id)sender;
-(IBAction) flageBtnTapped:(id)sender;

@end
