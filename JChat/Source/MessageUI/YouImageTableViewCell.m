//
//  YouImageTableViewCell.m
//  JChat
//
//  Created by Jana on 1/14/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "YouImageTableViewCell.h"

@implementation YouImageTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.messageImageView.layer.borderColor = [UIColor colorWithRed:170/255.0 green:170/255.0 blue:170/255.0 alpha:1.0].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
