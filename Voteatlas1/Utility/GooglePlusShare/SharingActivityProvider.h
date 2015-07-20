//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import <Foundation/Foundation.h>


@interface SharingActivityProvider : UIActivityItemProvider <UIActivityItemSource>

- (id)initwithText:(NSString *)statement withUrl:(NSURL *)url;

@end