//
//  SendImageCollectionViewCell.m
//  JChat
//
//  Created by Jana on 1/14/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "SendImageCollectionViewCell.h"

@implementation SendImageCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)sendImageAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(didClickOnCellAtIndex:withImage:)]) {
        [self.delegate didClickOnCellAtIndex:_cellIndex withImage:self.tempImageView.image];
    }
}

@end
