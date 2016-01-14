//
//  YouImageTableViewCell.h
//  JChat
//
//  Created by Jana on 1/14/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouImageTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightOfDateLayoutConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *messageImageView;
@end
