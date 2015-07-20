//
// Created by sbeyers on 3/25/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "SharingActivityProvider.h"


@implementation SharingActivityProvider {

  NSString *strStatement;
  NSURL *urlPath;
}

- (id)initwithText:(NSString *)statement withUrl:(NSURL *)url {
  if ([super initWithPlaceholderItem:statement]) {
    strStatement = statement;
    urlPath = url;
  }
  return self;
}

- (id)activityViewController:(UIActivityViewController *)activityViewController itemForActivityType:(NSString *)activityType {
    // Log out the activity type that we are sharing with
    NSLog(@"%@", activityType);
  NSString *strCombineString;
    // customize the sharing string for facebook, twitter, weibo, and google+
    if ([activityType isEqualToString:UIActivityTypePostToFacebook]) {
      strCombineString = [NSString stringWithFormat:@"%@\n%@", strStatement, urlPath.absoluteString];;
    } else if ([activityType isEqualToString:UIActivityTypePostToTwitter]) {
        strCombineString = [NSString stringWithFormat:@"%@\n%@", strStatement, urlPath.absoluteString];
        if (strCombineString.length > 117) {
        strCombineString = [NSString stringWithFormat:@"%@\n%@", [strStatement substringToIndex:(117-urlPath.absoluteString.length)], urlPath.absoluteString];
      }
    } else {
      strCombineString = [NSString stringWithFormat:@"%@\n%@", strStatement, urlPath.absoluteString];;
    }

    return strCombineString;
}

- (id)activityViewControllerPlaceholderItem:(UIActivityViewController *)activityViewController {
    return @"";
}


- (void)prepareWithActivityItems:(NSArray *)activityItems {

  NSLog(@"%@", activityItems);
}

@end