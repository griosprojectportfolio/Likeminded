//
//  CalloutAnnotationView.m
//  CustomCalloutSample
//
//  Created by tochi on 11/05/17.
//  Copyright 2011 aguuu,Inc. All rights reserved.
//

#import "CalloutAnnotationView.h"
#import "CalloutAnnotation.h"

@implementation CalloutAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
  
    if (self) {
        self.frame = CGRectMake(0.0f, 0.0f, 80, 65);
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4.0;
        
        self.lblOppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 35.0f, 30.0f, 25.0f)];
        self.lblOppose.textColor = [UIColor setCustomSignUpColor];
        self.lblOppose.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblOppose];

        self.lblSuppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 5.0f, 30.0f, 25.0f)];
        self.lblSuppose.textColor = [UIColor setCustomSignUpColor];
        self.lblSuppose.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblSuppose];

        self.imgVwSuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 20.0f, 25.0f)];
        self.imgVwSuppose.image = [UIImage imageNamed:@"4"];
        [self addSubview:self.imgVwSuppose];

        self.imgVwOuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 35.0f, 20.0f, 25.0f)];
        self.imgVwOuppose.image = [UIImage imageNamed:@"5"];
        [self addSubview:self.imgVwOuppose];
      }
  return self;
}


- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];
    self.lblOppose.text = self.titleOppose;
    self.lblSuppose.text = self.titleSuppose;
}

#pragma mark - Button clicked
- (void)calloutButtonClicked {

        //CalloutAnnotation *annotation = self.annotation;
        // [self.delegate calloutButtonClicked:(NSString *)annotation.title];
}

@end
