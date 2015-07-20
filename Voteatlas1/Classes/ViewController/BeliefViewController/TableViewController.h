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

@interface TableViewController : UIViewController <UISearchBarDelegate,UIActionSheetDelegate,MFMailComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate> {

    MFMailComposeViewController *mailComposer;
}

@property (nonatomic, strong) IBOutlet MKMapView *mapVwBelief;
@property (nonatomic, strong)IBOutlet UITableView *tbleVwBelief;
@property (nonatomic, strong) IBOutlet UIView *vwMap;
@property(nonatomic,strong)NSString *userID;

- (IBAction)tapRightNaviButton:(id)sender;

- (void)profileBtnTapped:(id)sender;

@end
