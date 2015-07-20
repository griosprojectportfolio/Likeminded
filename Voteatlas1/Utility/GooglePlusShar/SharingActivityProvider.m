//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharingActivityProvider.h"


@implementation SharingActivityProvider {

}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // Log out the activity type that we are sharing with
    NSLog(@"%@", activityType);

    // Create the default sharing string
    NSString *shareString = @"CapTech is a great place to work";

    // customize the sharing string for facebook, twitter, weibo, and google+
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
        shareString = [NSString stringWithFormat:@"Attention Facebook: %@", shareString];
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        shareString = [NSString stringWithFormat:@"Attention Twitter: %@", shareString];
    } else if ([activityType isEqualToString:UIActivityTypePostToWeibo]) {
        shareString = [NSString stringWithFormat:@"Attention Weibo: %@", shareString];
    } else if ([activityType isEqualToString:@"com.captech.googlePlusSharing"]) {
        shareString = [NSString stringWithFormat:@"Attention Google+: %@", shareString];
    }

    return shareString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}

@end