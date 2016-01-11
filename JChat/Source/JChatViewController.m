//
//  JChatViewController.m
//  JChat
//
//  Created by Jana on 1/11/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "JChatViewController.h"
#import "UITextView+Placeholder.h"
#import "JMessageTypeText.h"
#import "MeTableViewCell.h"
#import "YouTableViewCell.h"

@interface JChatViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) NSString *senderID;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UITextView *typeAMessageTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accessoryLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *keyboardControlLayoutConstraint;
@end

@implementation JChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //Tracking tap
    UITapGestureRecognizer *tapInScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInScreen)];
    [self.view addGestureRecognizer:tapInScreen];
    
    self.typeAMessageTextView.placeholder = @"Type a message";
    self.typeAMessageTextView.showsVerticalScrollIndicator = NO;
    
    //Config me:
    self.senderID = @"me";
    
    JMessageTypeText *textMe = [[JMessageTypeText alloc] init];
    textMe.senderID = @"me";
    textMe.senderDisplayName = @"Khắc";
    textMe.textMessage = @"Hello Jana";
    
    JMessageTypeText *textYou = [[JMessageTypeText alloc] init];
    textYou.senderID = @"khacvv";
    textYou.senderDisplayName = @"Jana";
    textYou.textMessage = @"Hello Khắc";
    
    self.messagesArray = [[NSMutableArray alloc] initWithObjects:textMe, textMe, textYou, nil];
    
    if (self.messagesArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    self.keyboardControlLayoutConstraint.constant = keyboardSize.height;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardControlLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Tracking tap
- (void)tapInScreen {
    [self.typeAMessageTextView resignFirstResponder];
}

#pragma mark - TabbleViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierMe = @"MeCell";
    static NSString *identifierYou = @"YouCell";
    
    if ([[(JMessageTypeText *)self.messagesArray[indexPath.row] senderID] isEqualToString:self.senderID]) {
        MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierMe];
        
        cell.contentMessage.text = [(JMessageTypeText *)self.messagesArray[indexPath.row] textMessage];
        
        return cell;
    } else {
        YouTableViewCell *cell = (YouTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierYou];
        
        cell.contentMessage.text = [(JMessageTypeText *)self.messagesArray[indexPath.row] textMessage];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    float rawLineNumber = (textView.contentSize.height - textView.textContainerInset.top - textView.textContainerInset.bottom) / textView.font.lineHeight;
    int finalLineNumber = round(rawLineNumber);
    if (finalLineNumber <= 5) {
        self.accessoryLayoutConstraint.constant = finalLineNumber*16.707031 + 43.292969;
    } else {
        self.accessoryLayoutConstraint.constant = 5*16.707031 + 43.292969;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
