#import "AppleMusicUserToken.h"
#import <StoreKit/StoreKit.h>


@implementation AppleMusicUserToken

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(requestUserTokenForDeveloperToken:(NSString *)developerToken resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    SKCloudServiceController *cloudController = [[SKCloudServiceController alloc] init];
    [cloudController requestUserTokenForDeveloperToken:developerToken completionHandler:^(NSString *userToken, NSError *error) {
        if (error == nil && userToken != nil) {
            resolve(userToken);
        } else {
            reject(@"user_token_request_failed", @"User token request failed", error);
        }
    }];
}

@end
