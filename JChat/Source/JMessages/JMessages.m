//
//  JMessages.m
//  JChat
//
//  Created by Jana on 1/11/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "JMessages.h"

@implementation JMessages

- (instancetype)initWithSenderID:(NSString *)senderID displayName:(NSString *)displayName createAtDate:(NSDate *)date textMessage:(NSString *)textMessage mediaData:(NSData *)mediaData {
    self.senderID = senderID;
    self.senderDisplayName = displayName;
    self.date = date;
    self.textMessage = textMessage;
    self.mediaData = mediaData;
    return self;
}
@end
