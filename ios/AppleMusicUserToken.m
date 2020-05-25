#import "AppleMusicUserToken.h"
#import <StoreKit/StoreKit.h>

@implementation AppleMusicUserToken

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(requestAuthorization:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
        switch (status) {
            case SKCloudServiceAuthorizationStatusDenied:
                reject(@"authorization_denied", @"Authorization denied", nil);
                break;
            case SKCloudServiceAuthorizationStatusRestricted:
                reject(@"authorization_restricted", @"Authorization restricted", nil);
                break;
            case SKCloudServiceAuthorizationStatusAuthorized:
                resolve(nil);
                break;
            default:
                break;
        }
    }];
}

RCT_EXPORT_METHOD(requestUserTokenForDeveloperToken:(NSString *)developerToken resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    SKCloudServiceController *cloudController = [[SKCloudServiceController alloc] init];
    [cloudController requestUserTokenForDeveloperToken:developerToken completionHandler:^(NSString *userToken, NSError *error) {
        if (error == nil && userToken != nil) {
            resolve(userToken);
        } else {
            if (error.code == 7) {
                // Developer token is invalid or a user is not an Apple Music subscriber
                reject(@"cannot_connect_to_cloud_service", @"Cannot connect to cloud service", error);
                return;
            }
            reject(@"user_token_request_failed", @"User token request failed", error);
        }
    }];
}

@end
