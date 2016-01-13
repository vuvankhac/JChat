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
#import <AssetsLibrary/AssetsLibrary.h>

@interface JChatViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSMutableArray *messagesArray;
@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderDisplayName;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) UIView *accessoryBackgroundView;
@property (strong, nonatomic) UIScrollView *extendScrollView;
@property (weak, nonatomic) IBOutlet UIView *backgroundExtendView;
@property (weak, nonatomic) IBOutlet UITableView *chatTableView;
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UITextView *typeAMessageTextView;
@property (weak, nonatomic) IBOutlet UIButton *textOption;
@property (weak, nonatomic) IBOutlet UIButton *imageOption;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //Tracking tap
    UITapGestureRecognizer *tapInScreen = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapInScreen)];
    [self.chatTableView addGestureRecognizer:tapInScreen];
    tapInScreen.cancelsTouchesInView = YES;
    
    self.typeAMessageTextView.placeholder = @"Type a message";
    self.typeAMessageTextView.showsVerticalScrollIndicator = NO;
    self.typeAMessageTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    self.sendButton.enabled = NO;
    self.chatTableView.rowHeight = UITableViewAutomaticDimension;
    self.chatTableView.estimatedRowHeight = 50;
    
    //Config me:
    self.senderID = @"me";
    self.senderDisplayName = @"Vũ Văn Khắc";
    
    JMessageTypeText *textMe = [[JMessageTypeText alloc] init];
    textMe.senderID = self.senderID;
    textMe.senderDisplayName = self.senderDisplayName;
    textMe.textMessage = @"Hello Jana, welcome to vietnam. I really like you.";
    
    JMessageTypeText *textYou = [[JMessageTypeText alloc] init];
    textYou.senderID = @"khacvv";
    textYou.senderDisplayName = @"Jana";
    textYou.textMessage = @"Hello, can you speak english. hihihihihihi.";
    
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

#pragma mark - Notification
- (void)keyboardWillShow:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if (!self.textOption.isSelected) {
        self.keyboardControlLayoutConstraint.constant = keyboardSize.height;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (!self.textOption.isSelected) {
        self.keyboardControlLayoutConstraint.constant = 0;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (void)keyboardWillChangeFrame:(NSNotification *)notification {
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if (self.typeAMessageTextView.isEditable) {
        self.keyboardControlLayoutConstraint.constant = keyboardSize.height;
    }
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Tracking tap
- (void)tapInScreen {
    [self.typeAMessageTextView resignFirstResponder];
    
    [self.textOption setSelected:NO];
    [self.imageOption setSelected:NO];
    
    self.typeAMessageTextView.hidden = NO;
    self.sendButton.hidden = NO;
    self.accessoryLayoutConstraint.constant = 75;
    [self accessoryViewDidChange];
    self.keyboardControlLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - TabbleViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifierMe = @"MeCell";
    static NSString *identifierYou = @"YouCell";
    
    if ([[(JMessageTypeText *)self.messagesArray[indexPath.row] senderID] isEqualToString:self.senderID]) {
        MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierMe forIndexPath:indexPath];
        
        cell.contentMessage.text = [(JMessageTypeText *)self.messagesArray[indexPath.row] textMessage];
        
        JMessageTypeText *messages;
        if (indexPath.row < 1) {
            messages = [self.messagesArray objectAtIndex:indexPath.row];
        } else {
            messages = [self.messagesArray objectAtIndex:indexPath.row - 1];
        }
        
        if (messages.senderID == [[self.messagesArray objectAtIndex:indexPath.row] senderID] && indexPath.row != 0) {
            cell.heightOfDateLayoutConstraint.constant = 0;
        } else {
            cell.heightOfDateLayoutConstraint.constant = 15;
        }
        
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        return cell;
    } else {
        YouTableViewCell *cell = (YouTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierYou forIndexPath:indexPath];
        
        cell.contentMessage.text = [(JMessageTypeText *)self.messagesArray[indexPath.row] textMessage];
        
        JMessageTypeText *messages;
        if (indexPath.row < 1) {
            messages = [self.messagesArray objectAtIndex:indexPath.row];
        } else {
            messages = [self.messagesArray objectAtIndex:indexPath.row - 1];
        }
        
        if (messages.senderID == [[self.messagesArray objectAtIndex:indexPath.row] senderID] && indexPath.row != 0) {
            cell.heightOfDateLayoutConstraint.constant = 0;
        } else {
            cell.heightOfDateLayoutConstraint.constant = 15;
        }
        
        cell.avatarImageView.hidden = NO;
        if (indexPath.row < self.messagesArray.count - 1) {
            if ([[self.messagesArray objectAtIndex:indexPath.row] senderID] == [[self.messagesArray objectAtIndex:indexPath.row + 1] senderID]) {
                cell.avatarImageView.hidden = YES;
            }
        }
        
        cell.layer.shouldRasterize = YES;
        cell.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == ([tableView numberOfSections] - 1)) {
        [self tableViewWillFinishLoading:tableView];
    }
    return [UIView new];
}

- (void)tableViewWillFinishLoading:(UITableView *)tableView {
    if (self.messagesArray.count > 0) {
        [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - TextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if (self.typeAMessageTextView.text.length > 0) {
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
    
    [self accessoryViewDidChange];
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.textOption setSelected:YES];
    [self.imageOption setSelected:NO];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.textOption setSelected:NO];
}

#pragma mark - Other
- (void)accessoryViewDidChange {
    float rawLineNumber = (self.typeAMessageTextView.contentSize.height - self.typeAMessageTextView.textContainerInset.top - self.typeAMessageTextView.textContainerInset.bottom) / self.typeAMessageTextView.font.lineHeight;
    int finalLineNumber = round(rawLineNumber);
    if (finalLineNumber <= 5) {
        self.accessoryLayoutConstraint.constant = finalLineNumber*16.707031 + 58.292969;
    } else {
        self.accessoryLayoutConstraint.constant = 5*16.707031 + 58.292969;
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

#pragma mark - Action Methods
- (IBAction)sendAction:(id)sender {
    JMessageTypeText *sendMessage = [[JMessageTypeText alloc] initWithSenderID:self.senderID displayName:self.senderDisplayName textMessage:self.typeAMessageTextView.text];
    
    [self.messagesArray addObject:sendMessage];
    self.typeAMessageTextView.text = @"";
    self.sendButton.enabled = NO;
    
    [self accessoryViewDidChange];
    
    [self.chatTableView beginUpdates];
    [self.chatTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [self.chatTableView endUpdates];
    
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)textOptionAction:(id)sender {
    [self.typeAMessageTextView becomeFirstResponder];
    
    [self.textOption setSelected:YES];
    [self.imageOption setSelected:NO];
    
    self.typeAMessageTextView.hidden = NO;
    self.sendButton.hidden = NO;
    self.accessoryLayoutConstraint.constant = 75;
    [self accessoryViewDidChange];
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    }];
}

- (IBAction)imageOptionAction:(id)sender {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
    if (!self.extendScrollView) {
        self.extendScrollView = [[UIScrollView alloc] initWithFrame:self.backgroundExtendView.bounds];
        [self.backgroundExtendView addSubview:self.extendScrollView];
    }
    
    if (self.assets.count == 0) {
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.assets insertObject:result atIndex:0];
            }
            
            if (index == NSNotFound) {
                [self reloadImageData];
            }
        };
        
        ALAssetsLibraryGroupsEnumerationResultsBlock listGroupBlock = ^(ALAssetsGroup *group, BOOL *stop) {
            ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
            [group setAssetsFilter:onlyPhotosFilter];
            if ([group numberOfAssets] > 0) {
                if ([[group valueForProperty:ALAssetsGroupPropertyType] intValue] == ALAssetsGroupSavedPhotos) {
                    [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
                }
            }
        };
        
        [self.assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:listGroupBlock failureBlock:^(NSError *error) {
            NSLog(@"Load Photos Error: %@", error);
        }];
    }
    
    [self.textOption setSelected:NO];
    [self.imageOption setSelected:YES];
    
    self.typeAMessageTextView.hidden = YES;
    self.sendButton.hidden = YES;
    self.accessoryLayoutConstraint.constant = 40;
    self.keyboardControlLayoutConstraint.constant = 216;
    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - Get image from iPhone
- (void)selectedImageAccessory:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.isSelected) {
        [button setSelected:NO];
    } else {
        [button setSelected:YES];
    }
}

- (void)reloadImageData {
    [self.extendScrollView setContentSize:CGSizeMake(216*self.assets.count, 216)];
    
    for (int i = 0; i < self.assets.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*216, 0, 216, 216)];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *image = [UIImage imageWithCGImage:[[self.assets[i] defaultRepresentation] fullScreenImage]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imageView setImage:image];
            });
        });
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.masksToBounds = YES;
        imageView.userInteractionEnabled = YES;
        [self.extendScrollView addSubview:imageView];
        
        UIButton *selectImageButton = [[UIButton alloc] initWithFrame:CGRectMake(216/2 - 56/2, 216/2 - 56/2, 56, 56)];
        [selectImageButton setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [selectImageButton addTarget:self action:@selector(selectedImageAccessory:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:selectImageButton];
    }
}

- (NSMutableArray *)assets {
    if (_assets == nil) {
        _assets = [[NSMutableArray alloc] init];
    }
    return _assets;
}

- (ALAssetsLibrary *)assetsLibrary {
    if (_assetsLibrary == nil) {
        _assetsLibrary = [[ALAssetsLibrary alloc] init];
    }
    return _assetsLibrary;
}

#pragma mark - Rotate
- (void)viewWillLayoutSubviews {
    self.extendScrollView.frame = self.backgroundExtendView.bounds;
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
