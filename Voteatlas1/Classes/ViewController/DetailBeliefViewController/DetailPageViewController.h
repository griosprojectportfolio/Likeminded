//
//  DetailPageViewController.h
//  Voteatlas1
//
//  Created by GrepRuby on 13/03/15.
//  Copyright (c) 2015 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Belief.h"
#import <MapKit/MapKit.h>
#import "CustomButtonsView.h"

@interface DetailPageViewController : UIViewController <MFMailComposeViewControllerDelegate, CustomButtonsDelegate, MKMapViewDelegate>{

    IBOutlet UIImageView *imgVwOfMedia;
    IBOutlet UIButton *btnPlayOrShowImage;
    IBOutlet UIButton *btnSuppose;
    IBOutlet UIButton *btnOppose;
    MFMailComposeViewController *mailComposer;
}

@property(nonatomic, retain) AppApi *api;
@property (nonatomic) NSInteger belief_Id;
@property (nonatomic, strong) Belief *objBelief;
@property (nonatomic, strong) IBOutlet MKMapView *mapvwBelief;
@property (nonatomic, strong) IBOutlet CustomButtonsView *customVwOfBtns;
@property (nonatomic, strong) NSMutableArray *arrySupportLocation;
@property (nonatomic, strong) NSMutableArray *arryOpposeLocation;

@end
