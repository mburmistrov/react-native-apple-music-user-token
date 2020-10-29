#import "AppleMusicUserToken.h"
#import <StoreKit/StoreKit.h>

@implementation AppleMusicUserToken

RCT_EXPORT_MODULE()

RCT_EXPORT_METHOD(getAuthorizationStatus:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    SKCloudServiceAuthorizationStatus status = [SKCloudServiceController authorizationStatus];
    
    switch (status) {
        case SKCloudServiceAuthorizationStatusDenied:
            resolve(@{ @"type" : @"success", @"status" : @"authorization_denied" });
            break;
        case SKCloudServiceAuthorizationStatusRestricted:
            resolve(@{ @"type" : @"success", @"status" : @"authorization_restricted" });
            break;
        case SKCloudServiceAuthorizationStatusNotDetermined:
            resolve(@{ @"type"  : @"success", @"status" : @"authorization_not_determined" });
            break;
        case SKCloudServiceAuthorizationStatusAuthorized:
            resolve(@{ @"type" : @"success", @"status" : @"authorization_authorized" });
            break;
        default:
            resolve(@{ @"type" : @"failure", @"error" : @"unexpected_result", @"message" : @"Unexpected result" });
            break;
    }
}

RCT_EXPORT_METHOD(requestAuthorization:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject)
{
    [SKCloudServiceController requestAuthorization:^(SKCloudServiceAuthorizationStatus status) {
        switch (status) {
            case SKCloudServiceAuthorizationStatusDenied:
                resolve(@{ @"type" : @"failure", @"error" : @"authorization_denied", @"message" : @"Authorization denied" });
                break;
            case SKCloudServiceAuthorizationStatusRestricted:
                resolve(@{ @"type" : @"failure", @"error" : @"authorization_restricted", @"message" : @"Authorization restricted" });
                break;
            case SKCloudServiceAuthorizationStatusAuthorized:
                resolve(@{ @"type" : @"success" });
                break;
            default:
                resolve(@{ @"type" : @"failure", @"error" : @"unexpected_result", @"message" : @"Unexpected result" });
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
            if (error.code == 1 || error.code == 6 || error.code == 7 || error.code == 9) {
                // error.code == 1: Probably the user is not logged to with Apple account
                // error.code == 6: The requesting app does not have the necessary permissions
                // error.code == 7: Developer token is invalid or the user is not an Apple Music subscriber
                // error.code == 9: The user needs to read the latest Apple privacy policy
                resolve(@{ @"type" : @"failure" });
                return;
            }
            // For some reason error.code is not present in error obj recieved by js, so it is concatenated to msg
            NSString *msg = [@"An unexpected error has occurred, native code: " stringByAppendingString:@(error.code).stringValue];
            reject(@"unexpected_error", msg, error);
        }
    }];
}

@end
