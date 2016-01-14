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
    JMessages *textMe = [[JMessages alloc] initWithSenderID:@"me" displayName:@"Vũ Văn Khắc" createAtDate:[NSDate date] textMessage:@"Hello, how are you?" mediaData:nil];
    
    JMessages *textYou = [[JMessages alloc] initWithSenderID:@"khacvv" displayName:@"Jana Dev" createAtDate:[NSDate date] textMessage:@"Hello, how are you?" mediaData:nil];
    
    self.messagesArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < 50; i++) {
        NSInteger randomNumber = arc4random()%2;
        if (randomNumber == 0) {
            [self.messagesArray addObject:textMe];
        } else {
            [self.messagesArray addObject:textYou];
        }
    }
    
}

- (IBAction)goChatAction:(id)sender {
    JChatViewController *chat = [[UIStoryboard storyboardWithName:@"JChat" bundle:nil] instantiateViewControllerWithIdentifier:@"JChat"];
    chat.messagesArray = self.messagesArray;
    [self.navigationController pushViewController:chat animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
