//
//  InteractiveView.m
//  JChat
//
//  Created by Jana on 1/27/16.
//  Copyright © 2016 khacvv. All rights reserved.
//

#import "InteractiveView.h"

static void *InteractiveContext = &InteractiveContext;

@interface InteractiveView()

@property (nonatomic, assign, getter=isObserverAdded) BOOL observerAdded;

@end

@implementation InteractiveView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

#pragma mark - Object Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc {
    if(_observerAdded) {
        [self.superview removeObserver:self forKeyPath:@"frame" context:InteractiveContext];
        [self.superview removeObserver:self forKeyPath:@"center" context:InteractiveContext];
    }
}

#pragma mark - Setters & Getters
- (CGRect)inputAcesssorySuperviewFrame {
    return self.superview.frame;
}

#pragma mark - Overwritten Methods
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if(self.isObserverAdded) {
        [self.superview removeObserver:self forKeyPath:@"frame" context:InteractiveContext];
        [self.superview removeObserver:self forKeyPath:@"center" context:InteractiveContext];
    }
    
    [newSuperview addObserver:self forKeyPath:@"frame" options:0 context:InteractiveContext];
    [newSuperview addObserver:self forKeyPath:@"center" options:0 context:InteractiveContext];
    self.observerAdded = YES;
    
    [super willMoveToSuperview:newSuperview];
}

#pragma mark - Observation
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (object == self.superview && ([keyPath isEqualToString:@"frame"] || [keyPath isEqualToString:@"center"])) {
        if (self.inputAcessoryViewFrameChangedBlock) {
            CGRect frame = self.superview.frame;
            self.inputAcessoryViewFrameChangedBlock(frame);
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect frame = self.superview.frame;
    self.inputAcessoryViewFrameChangedBlock(frame);
}

@end
