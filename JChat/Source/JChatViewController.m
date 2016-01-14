//
//  JChatViewController.m
//  JChat
//
//  Created by Jana on 1/11/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "JChatViewController.h"
#import "UITextView+Placeholder.h"
#import "JMessages.h"
#import "MeTableViewCell.h"
#import "YouTableViewCell.h"
#import "MeImageTableViewCell.h"
#import "YouImageTableViewCell.h"
#import "SendImageCollectionViewCell.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface JChatViewController () <UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, CellDelegate>

@property (strong, nonatomic) NSString *senderID;
@property (strong, nonatomic) NSString *senderDisplayName;
@property (strong, nonatomic) NSMutableArray *assets;
@property (strong, nonatomic) ALAssetsLibrary *assetsLibrary;
@property (strong, nonatomic) UIView *accessoryBackgroundView;
@property (strong, nonatomic) UICollectionView *showImageCollectionView;
@property (strong, nonatomic) NSIndexPath *selectedItemIndexPath;
@property (strong, nonatomic) UIButton *sendInCollectionView;
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
    
    [self loadImageFromiPhone];
}

- (void)loadImageFromiPhone {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.showImageCollectionView = [[UICollectionView alloc] initWithFrame:self.backgroundExtendView.bounds collectionViewLayout:layout];
    self.showImageCollectionView.delegate = self;
    self.showImageCollectionView.dataSource = self;
    [self.showImageCollectionView registerClass:[SendImageCollectionViewCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    UINib *nib = [UINib nibWithNibName:@"SendImageCollectionViewCell" bundle: nil];
    [self.showImageCollectionView registerNib:nib forCellWithReuseIdentifier:@"cellIdentifier"];
    self.showImageCollectionView.backgroundColor = [UIColor clearColor];
    [self.backgroundExtendView addSubview:self.showImageCollectionView];
    
    ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
        if (result) {
            [self.assets insertObject:result atIndex:0];
        }
        
        if (index == NSNotFound) {
            [self.showImageCollectionView reloadData];
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
    [self accessoryViewDidChange];
    self.accessoryLayoutConstraint.constant = 75;
    self.keyboardControlLayoutConstraint.constant = 0;
    [UIView animateWithDuration:0.2 animations:^{
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
    static NSString *identifierMeImage = @"MeImageTableViewCell";
    static NSString *identifierYouImage = @"YouImageTableViewCell";
    
    if ([[(JMessages *)self.messagesArray[indexPath.row] senderID] isEqualToString:self.senderID]) {
        if (![(JMessages *)self.messagesArray[indexPath.row] mediaData]) {
            MeTableViewCell *cell = (MeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierMe forIndexPath:indexPath];
            
            cell.contentMessage.text = [(JMessages *)self.messagesArray[indexPath.row] textMessage];
            cell.dateLabel.text = [self convertDate:[(JMessages *)self.messagesArray[indexPath.row] date]];
            
            JMessages *messages;
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
            MeImageTableViewCell *cell = (MeImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierMeImage forIndexPath:indexPath];
            
            cell.messageImageView.image = [UIImage imageWithData:[(JMessages *)self.messagesArray[indexPath.row] mediaData]];
            cell.dateLabel.text = [self convertDate:[(JMessages *)self.messagesArray[indexPath.row] date]];
            
            JMessages *messages;
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
        }
    } else {
        if (![(JMessages *)self.messagesArray[indexPath.row] mediaData]) {
            YouTableViewCell *cell = (YouTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierYou forIndexPath:indexPath];
            
            cell.contentMessage.text = [(JMessages *)self.messagesArray[indexPath.row] textMessage];
            cell.dateLabel.text = [self convertDate:[(JMessages *)self.messagesArray[indexPath.row] date]];
            
            JMessages *messages;
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
        } else {
            YouImageTableViewCell *cell = (YouImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifierYouImage forIndexPath:indexPath];
            
            cell.messageImageView.image = [UIImage imageWithData:[(JMessages *)self.messagesArray[indexPath.row] mediaData]];
            cell.dateLabel.text = [self convertDate:[(JMessages *)self.messagesArray[indexPath.row] date]];
            
            JMessages *messages;
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
        }
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
    JMessages *sendMessage = [[JMessages alloc] initWithSenderID:self.senderID displayName:self.senderDisplayName createAtDate:[NSDate date] textMessage:self.typeAMessageTextView.text mediaData:nil];
    
    [self.messagesArray addObject:sendMessage];
    self.typeAMessageTextView.text = @"";
    self.sendButton.enabled = NO;
    
    [self accessoryViewDidChange];
    
    [UIView performWithoutAnimation:^{
        [self.chatTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (IBAction)textOptionAction:(id)sender {
    if (self.imageOption.isSelected) {
        [UIView performWithoutAnimation:^{
            [self.typeAMessageTextView becomeFirstResponder];
        }];
    } else {
        [self.typeAMessageTextView becomeFirstResponder];
    }
    
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

#pragma mark - Collection View Delegate - Collection View Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.assets.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SendImageCollectionViewCell *cell = (SendImageCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    
    cell.tempImageView.image = [UIImage imageWithCGImage:[[self.assets[indexPath.row] defaultRepresentation] fullScreenImage]];
    
    cell.delegate = self;
    cell.cellIndex = indexPath.row;
    
    cell.tempButton.hidden = YES;
    if (self.selectedItemIndexPath == indexPath) {
        cell.tempButton.hidden = NO;
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(216, 216);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *indexPaths = [NSMutableArray arrayWithObject:indexPath];
    
    if (self.selectedItemIndexPath) {
        if ([indexPath compare:self.selectedItemIndexPath] == NSOrderedSame) {
            self.selectedItemIndexPath = nil;
        } else {
            [indexPaths addObject:self.selectedItemIndexPath];
            self.selectedItemIndexPath = indexPath;
        }
    } else {
        self.selectedItemIndexPath = indexPath;
    }
    
    [collectionView reloadItemsAtIndexPaths:indexPaths];
}

- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withImage:(UIImage *)image {
    
    NSData *dataImage = UIImagePNGRepresentation(image);
    JMessages *sendMessage = [[JMessages alloc] initWithSenderID:self.senderID displayName:self.senderDisplayName createAtDate:[NSDate date] textMessage:nil mediaData:dataImage];
    [self.messagesArray addObject:sendMessage];
    
    [UIView performWithoutAnimation:^{
        [self.chatTableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    [self.chatTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messagesArray.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}

- (NSString *)convertDate:(NSDate *)date {
    NSString *dateString = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterNoStyle];
    NSString *timeString = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
    return [[dateString stringByAppendingString:@" "] stringByAppendingString:timeString];
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
    self.showImageCollectionView.frame = self.backgroundExtendView.bounds;
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
