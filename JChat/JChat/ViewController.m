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
@property (strong, nonatomic) NSTimer *sendMessageTimer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    JMessages *textYou = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:@"Em chào anh, anh cho em làm quen được không ạ?" mediaData:nil];
    JMessages *textMe = [[JMessages alloc] initWithSenderID:@"me" displayName:@"Vũ Văn Khắc" createAtDate:[NSDate date] textMessage:@"Không được? Anh đẹp trai chứ anh không dễ dãi đâu nhé!" mediaData:nil];
    
    self.messagesArray = [[NSMutableArray alloc] initWithObjects:textYou, textMe, nil];
    
    self.sendMessageTimer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(sendMessageAction) userInfo:nil repeats:YES];
}

- (void)delayMethod1 {
    JMessages *push = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:@"Em thích anh\nThật đấy" mediaData:nil];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:push forKey:@"messages"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SMS" object:self userInfo:userInfo];
}

- (void)delayMethod2 {
    NSData *dataImage = UIImagePNGRepresentation([UIImage imageNamed:@"avatar.jpg"]);
    JMessages *push = [[JMessages alloc] initWithSenderID:@"ngoctrinhfake1" displayName:@"NgocTrinh" createAtDate:[NSDate date] textMessage:nil mediaData:dataImage];
    
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:push forKey:@"messages"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SMS" object:self userInfo:userInfo];
}

- (void)sendMessageAction {
    [self delayMethod1];
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
