//
//  SendImageCollectionViewCell.h
//  JChat
//
//  Created by Jana on 1/14/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CellDelegate <NSObject>
- (void)didClickOnCellAtIndex:(NSInteger)cellIndex withImage:(UIImage *)image;
@end

@interface SendImageCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) id<CellDelegate> delegate;
@property (assign, nonatomic) NSInteger cellIndex;
@property (weak, nonatomic) IBOutlet UIImageView *tempImageView;
@property (weak, nonatomic) IBOutlet UIButton *tempButton;
@end
