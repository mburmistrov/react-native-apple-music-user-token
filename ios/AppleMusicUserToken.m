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
            resolve(@{ @"type" : @"success", @"token" : userToken });
        } else {
            if (error.code == 1 || error.code == 7) {
                // error.code == 1: Probably the user is not logged to with Apple account
                // error.code == 7: Developer token is invalid or the user is not an Apple Music subscriber
                resolve(@{ @"type" : @"failure" });
                return;
            }
            reject(@"unexpected_error", @"An unexpected error has occurred", error);
        }
    }];
}

@end
