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

@optional

- (void)sharebtnTapped:(Belief*)belief;
- (void)mapbtnTapped:(Belief*)belief withCellTag:(NSInteger)tag;
- (void)translatebtnTapped:(Belief*)belief;
- (void)keepmePostedBtnTapped:(Belief *)belief withTag:(NSInteger)tag;
- (void)flagBtnTapped:(Belief *)belief;
- (void)supportOpposeBtnTapped;
- (void)videoBtnTapped:(Belief *)belief;
- (void)navigateToCommentBtnTapped:(Belief *)belief;
- (void)fileItBtnTapped:(NSInteger)cellTag;
- (void)profileBtnTapped:(Belief *)belief;
- (void)linkBtnTapped:(Belief *)belief;
-(void) alertMassegeBtn;

@end

@interface TableViewCell : UITableViewCell <CustomButtonsDelegate, UIGestureRecognizerDelegate,UIAlertViewDelegate,UIAlertViewDelegate> {
    NSURL *_urlToLoad;
    IBOutlet UIButton *btnPlay;
    IBOutlet UIButton *btnDiscloser;
    IBOutlet UIButton *btnFlag;
    IBOutlet UIButton *btnTranslation;
    IBOutlet UILabel *lblLine;
    IBOutlet UILabel *lblLink;
    IBOutlet UIButton *btnLink;
    UIVisualEffectView *effectView;
}

@property (nonatomic, strong) IBOutlet UILabel *lblStatement;
@property (nonatomic, strong) IBOutlet UIImageView *imgProfilPic;
@property (nonatomic, strong) IBOutlet UIImageView *displayImage;

@property (nonatomic, strong) IBOutlet UIImageView *imgViewContent;

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

- (void)setValueInTableVw:(Belief*)belief withVwController:(TableViewController*)vwController forRow:(NSInteger)row withCellWidth:(CGFloat)width withLaguagleId:(NSNumber*)languageId;
-(BOOL)isauth_Token_Exist;

@end
