//
//  TableViewController.h
//  Voteatlas
//
//  Created by GrepRuby1 on 16/12/14.
//  Copyright (c) 2014 Voteatlas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "HCYoutubeParser.h"

@interface TableViewController : UIViewController <UISearchBarDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate,UIAlertViewDelegate> {

    MFMailComposeViewController *mailComposer;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapVwBelief;
@property (nonatomic, strong) IBOutlet UITableView *tbleVwBelief;
@property (nonatomic, strong) IBOutlet UITableView *tbleVwAutoCorrection;

@property (nonatomic, strong) IBOutlet UIView *vwMap;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) UIButton *btnSlider;
@property (nonatomic, strong) MPMoviePlayerViewController *mpvc;
@property (nonatomic) NSInteger schemaBeliefId;

- (void)profileBtnTapped:(id)sender;
-(BOOL)isauth_Token_Exist;
-(void) alertMassege;

@end
