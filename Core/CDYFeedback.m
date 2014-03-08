/*
 * Copyright 2014 Coodly LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "CDYFeedback.h"

@interface CDYFeedback () <MFMailComposeViewControllerDelegate>

@end

@implementation CDYFeedback

+ (CDYFeedback *)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[CDYFeedback alloc] initSingleton];
    });
    return _sharedObject;

}


- (id)initSingleton {
    self = [super init];
    if (self) {

    }
    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedInstance))]
                                 userInfo:nil];
    return nil;
}

- (MFMailComposeViewController *)presentEmailComposerUsingController:(UIViewController *)presentedOn {
    if (![MFMailComposeViewController canSendMail]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CDYFeedback.cant.send.email.title", nil)
                                                            message:NSLocalizedString(@"CDYFeedback.cant.send.email.message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"CDYFeedback.cant.send.email.alert.dismiss.button", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return nil;
    }

    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    [controller setToRecipients:@[self.feedbackEmail]];
    [controller setSubject:NSLocalizedString(@"CDYFeedback.email.subject", nil)];
    NSString *messageBody = [NSString stringWithFormat:NSLocalizedString(@"CDYFeedback.email.body.template", nil), [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    [controller setMessageBody:messageBody isHTML:NO];

    [presentedOn presentViewController:controller animated:YES completion:nil];

    return controller;
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (error) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CDYFeedback.email.not.sent.error.title", nil)
                                                            message:NSLocalizedString(@"CDYFeedback.email.not.sent.error.message", nil)
                                                           delegate:nil
                                                  cancelButtonTitle:NSLocalizedString(@"CDYFeedback.email.not.sent.error.dismiss.button", nil)
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
