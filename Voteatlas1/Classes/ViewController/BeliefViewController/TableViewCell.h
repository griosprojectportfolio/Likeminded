//
//  TableViewCell.h
//  Voteatlas
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TableViewController.h"
#import "Belief.h"
#import "CustomButtonsView.h"

@protocol CustomeTableViewDelegate <NSObject>

- (void)sharebtnTapped:(Belief*)belief;
- (void)mapbtnTapped:(Belief*)belief;
- (void)translatebtnTapped:(Belief*)belief;
- (void)keepmePostedBtnTapped:(Belief *)belief withTag:(NSInteger)tag;
- (void)flagBtnTapped:(Belief *)belief;
- (void)supportOpposeBtnTapped;

@end

@interface TableViewCell : UITableViewCell <CustomButtonsDelegate> {
    NSURL *_urlToLoad;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIImageView *imgVwDiscloser;
    IBOutlet UIButton *btnFlag;
    IBOutlet UIButton *btnTranslation;
    UIVisualEffectView *effectView;
}

@property (nonatomic, strong) IBOutlet UILabel *lblStatement;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfilPic;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;

@property (nonatomic, strong) IBOutlet UIButton *supprtBtn;
@property (nonatomic, strong) IBOutlet UIButton  *btnProfilPic;
@property (nonatomic, strong) IBOutlet UIButton *opposeBtn;
@property (nonatomic, strong) IBOutlet UIButton *trashFileBtn;

@property (nonatomic, strong) IBOutlet UIButton *mapBtn;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIButton *postedBtn;

@property (nonatomic, strong) IBOutlet UIButton *transBtn;
@property (nonatomic, strong) IBOutlet UIButton *flageBtn;
@property (nonatomic, strong) IBOutlet CustomButtonsView *customVwOfBtns;
@property (nonatomic, strong) Belief *objBelief;

@property (unsafe_unretained)id<CustomeTableViewDelegate> delegate;


- (IBAction)transBtnTapped:(id)sender;
- (IBAction)flageBtnTapped:(id)sender;

- (void)setValueInTableVw:(Belief*)belief withVwController:(TableViewController*)vwController forRow:(NSInteger)row withCellWidth:(CGFloat)width withLaguagleId:(NSNumber*)languageId;

@end
