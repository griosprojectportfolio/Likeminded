//
//  CustomButtonsView.h
//  Voteatlas1
//
//  Created by GrepRuby on 25/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomButtonsDelegate <NSObject>

@optional

- (void)shareBtnTapped;
- (void)mapBtnTapped;
- (void)supportBtnTapped;
- (void)opposeBtnTapped;
- (void)keepmePostedBtnTapped;
- (void)fileItBtnTapped;

@end

@interface CustomButtonsView : UIView <UIActionSheetDelegate> {

    IBOutlet UIButton *btnLike;
    IBOutlet UIButton *btnUnlike;
    IBOutlet UIButton *btnArchive;
    IBOutlet UIImageView *imgVwlockOppose;
    IBOutlet UIVisualEffectView *blurVw;
}

@property (nonatomic, strong) IBOutlet UIButton *btnMap;
@property (nonatomic, strong) IBOutlet UIButton *btnNotes;
@property (nonatomic, strong) IBOutlet UIButton *btnShare;
@property (nonatomic, strong) IBOutlet UIImageView *imgVwlockSupport;
@property (nonatomic) BOOL isDetailVw;
@property (unsafe_unretained) id <CustomButtonsDelegate>delegate;
@property(nonatomic, retain) AppApi *api;


- (void)setFrameOfButtons:(NSInteger)extraSpace additionSpace:(NSInteger)space;
- (void)instantiateAppApi;
- (void)assignValuetoButton:(NSDictionary *)dictDiscopose;

@end
