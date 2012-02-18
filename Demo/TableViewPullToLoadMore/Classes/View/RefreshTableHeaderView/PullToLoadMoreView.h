//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define RGB(r, g, b)                [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define PTLMTextColor               RGB(72, 76, 79)
#define PTLMShadowColor             [UIColor whiteColor]
#define PTLMShadowOffset            CGSizeMake(0.0, 1.0)
#define PTLMFontSize                15.0
#define FLIP_ANIMATION_DURATION     0.18f

typedef enum {
	PullRefreshPulling = 0,
	PullRefreshNormal,
	PullRefreshLoading,	
} PullRefreshState;

@interface PullToLoadMoreView : UIView 
{
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	PullRefreshState _state;
    
@protected
    CGRect _statusLabelFrame;
    CGRect _arrowImageFrame;
    CGRect _waitIndicatorFrame;
    
    CATransform3D _arrowPullingTransform;
    CATransform3D _arrowNormalTransform;
    
    NSString *_releaseLabelText;
    NSString *_pullingLabelText;
    NSString *_loadingLabelText;
}

@property(nonatomic,assign) PullRefreshState state;
@property(nonatomic,retain) NSString *releaseLabelText;
@property(nonatomic,retain) NSString *pullingLabelText;
@property(nonatomic,retain) NSString *loadingLabelText;

- (void)setState:(PullRefreshState)aState;

@end
