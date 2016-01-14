//
//  ViewController.m
//  JChat
//
//  Created by Jana on 1/11/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "ViewController.h"
#import "JChatViewController.h"
#import "JMessages.h"

@interface ViewController ()

@property (strong, nonatomic) NSMutableArray *messagesArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JMessages *textYou = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:@"Em chào anh, anh cho em làm quen được không ạ?" mediaData:nil];
    JMessages *textMe = [[JMessages alloc] initWithSenderID:@"me" displayName:@"Vũ Văn Khắc" createAtDate:[NSDate date] textMessage:@"Không được? Anh đẹp trai chứ anh không dễ dãi đâu nhé!" mediaData:nil];
    
    self.messagesArray = [[NSMutableArray alloc] initWithObjects:textYou, textMe, nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self delayMethod1];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self delayMethod2];
    });
}

- (void)delayMethod1 {
    JMessages *push = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:@"Em thích anh" mediaData:nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:push forKey:@"messages"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SMS" object:self userInfo:userInfo];
}

- (void)delayMethod2 {
    JMessages *push = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:@"Thật đấy." mediaData:nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:push forKey:@"messages"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SMS" object:self userInfo:userInfo];
}

- (IBAction)goChatAction:(id)sender {
    JChatViewController *chat = [[UIStoryboard storyboardWithName:@"JChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JChat"];
    chat.messagesArray = self.messagesArray;
    chat.guestAvatar = [UIImage imageNamed:@"avatar.jpg"];
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
