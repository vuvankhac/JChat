//
//  JMessageTypeText.m
//  JChat
//
//  Created by Jana on 1/11/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "JMessageTypeText.h"

@implementation JMessageTypeText

- (instancetype)initWithSenderID:(NSString *)senderID displayName:(NSString *)displayName textMessage:(NSString *)textMessage {
    self.senderID = senderID;
    self.senderDisplayName = displayName;
    self.textMessage = textMessage;
    return self;
}
@end
