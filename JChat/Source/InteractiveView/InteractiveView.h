//
//  InteractiveView.h
//  JChat
//
//  Created by Jana on 1/27/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InteractiveView : UIView

@property (nonatomic, copy) void (^inputAcessoryViewFrameChangedBlock)(CGRect frame);
@property (nonatomic, readonly) CGRect inputAcesssorySuperviewFrame;
@end
