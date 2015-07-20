//
// Created by sbeyers on 4/1/13.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "GooglePlusActivity.h"
#import "GTLPlusConstants.h"
#import "GPPShare.h"

@interface GooglePlusActivity ()

@property(nonatomic, strong) NSString *text;
@property(nonatomic, strong) NSURL *url;

@end

@implementation GooglePlusActivity

// Create a client ID using google's api. For instructions view https://developers.google.com/+/mobile/ios/getting-started
static NSString *const kClientId = @"CLIENT_ID";

// Return the name that should be displayed below the icon in the sharing menu
- (NSString *)activityTitle {
    return @"Google+";
}

// Return the string that uniquely identifies this activity type
- (NSString *)activityType {
    return @"com.captech.googlePlusSharing";
}

// Return the image that will be displayed  as an icon in the sharing menu
- (UIImage *)activityImage {
    return [UIImage imageNamed:@"Google-icon.png"];
}

// allow this activity to be performed with any activity items
- (BOOL)canPerformWithActivityItems:(NSArray *)activityItems {
    return YES;
}

- (void)prepareWithActivityItems:(NSArray *)activityItems {
    // Loop through all activity items and pull out the two we are looking for
    for (NSObject *item in activityItems) {
        if ([item isKindOfClass:[NSString class]]) {
            self.text = (NSString *) item;
        } else if ([item isKindOfClass:[NSURL class]]) {
            self.url = (NSURL *) item;
        }
    }
}

// initiate the sharing process. First we will need to login
- (void)performActivity {
    // Get the sign in instance
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    // set the client id to my client id
    signIn.clientID = kClientId;
    // From google docs: // Know your name, basic info, and list of people you're connected to on Google+
    signIn.scopes = [NSArray arrayWithObjects:
            kGTLAuthScopePlusLogin, // defined in GTLPlusConstants.h
            nil];
    // set myself as the delegate
    signIn.delegate = self;

    // begin authentication
    [signIn authenticate];
}

// Handle response from authenticate call
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error != nil) {
        // if there is an error, notify the user and end the activity
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error loggin in." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    } else {
        // share
        id <GPPShareBuilder> shareBuilder = [[GPPShare sharedInstance] shareDialog];

        // you're sharing based on the URL you included.
        [shareBuilder setURLToShare:self.url];
        // filling in the comment text
        [shareBuilder setPrefillText:self.text];

        // open the sharing screen
        [shareBuilder open];
    }

    [self activityDidFinish:YES];
}

// handles results from sharing activity.
- (void)finishedSharing: (BOOL)shared {
    if (shared) {
        NSLog(@"User successfully shared!");
    } else {
        NSLog(@"User didn't share.");
    }
}

@end