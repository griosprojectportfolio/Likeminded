//
//  CalloutAnnotationView.h
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol CalloutAnnotationViewDelegate;
@interface CalloutAnnotationView : MKAnnotationView

@property (nonatomic, copy) NSString *titleSuppose;
@property (nonatomic, copy) NSString *titleOppose;

@property (nonatomic, strong) UILabel *lblOppose;
@property (nonatomic, strong) UILabel *lblSuppose;
@property (nonatomic, strong) UIImageView *imgVwOuppose;
@property (nonatomic, strong) UIImageView *imgVwSuppose;

@property (nonatomic, strong) UIButton *button;

@property (nonatomic, assign) id<CalloutAnnotationViewDelegate> delegate;
@end

@protocol CalloutAnnotationViewDelegate

    //- (void)calloutButtonClicked:(NSString *)title;
@end
