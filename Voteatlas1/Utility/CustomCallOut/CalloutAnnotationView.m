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
        self.frame = CGRectMake(0.0f, 0.0f, 120, 85);
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.9];
        self.layer.borderColor = [UIColor setCustomColorOfTextField].CGColor;
        self.layer.borderWidth = 1.0f;
        self.layer.cornerRadius = 4.0;
        
        self.lblOppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 35.0f, 70.0f, 25.0f)];
        self.lblOppose.textColor = [UIColor setCustomSignUpColor];
        self.lblOppose.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblOppose];

        self.lblSuppose = [[UILabel alloc] initWithFrame:CGRectMake(40.0f, 5.0f, 70.0f, 25.0f)];
        self.lblSuppose.textColor = [UIColor setCustomSignUpColor];
        self.lblSuppose.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblSuppose];

        self.imgVwSuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 5.0f, 20.0f, 25.0f)];
        self.imgVwSuppose.image = [UIImage imageNamed:@"4"];
        [self addSubview:self.imgVwSuppose];

        self.imgVwOuppose = [[UIImageView alloc]initWithFrame:CGRectMake(10.0f, 35.0f, 20.0f, 25.0f)];
        self.imgVwOuppose.image = [UIImage imageNamed:@"5"];
        [self addSubview:self.imgVwOuppose];

        UIImageView *imgVwLine = [[UIImageView alloc]initWithFrame:CGRectMake(40.0f, 55.0f, 70.0f, 1.0f)];
        imgVwLine.backgroundColor = [UIColor blackColor];
        [self addSubview:imgVwLine];

        self.lblTotal = [[UILabel alloc] initWithFrame:CGRectMake(45.0f, 56.0f, 70.0f, 25.0f)];
        self.lblTotal.textColor = [UIColor setCustomSignUpColor];
        self.lblTotal.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.lblTotal];
      }
  return self;
}


- (void)drawRect:(CGRect)rect {

    [super drawRect:rect];

    int totalComment = self.titleOppose.intValue + self.titleSuppose.intValue;
    double supposePerc = ((self.titleSuppose.floatValue*100)/totalComment);
    double opposePerc = ((self.titleOppose.floatValue*100)/totalComment);
    NSString *strSuppose;
    NSString *strOppose;
    if (100%totalComment != 0) {
        strSuppose = [NSString stringWithFormat:@"-%ld-%.01f%%", (long)self.titleSuppose.integerValue,supposePerc];//-1-100%
        strOppose = [NSString stringWithFormat:@"-%ld-%.01f%%", (long)self.titleOppose.integerValue,opposePerc];//-1-100%
    } else {
        strSuppose = [NSString stringWithFormat:@"-%ld-%d%%", (long)self.titleSuppose.integerValue,((int)supposePerc)];//-1-100%
        strOppose = [NSString stringWithFormat:@"-%ld-%d%%", (long)self.titleOppose.integerValue,((int)opposePerc)];//-1-100%
    }
    self.lblOppose.text = strOppose;
    self.lblSuppose.text = strSuppose;
    self.lblTotal.text = [NSString stringWithFormat:@"%.i",totalComment];
}

#pragma mark - Button clicked
- (void)calloutButtonClicked {

        //CalloutAnnotation *annotation = self.annotation;
        // [self.delegate calloutButtonClicked:(NSString *)annotation.title];
}

@end
