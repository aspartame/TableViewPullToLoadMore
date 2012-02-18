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


typedef enum{
	EGOOPullRefreshPulling = 0,
	EGOOPullRefreshNormal,
	EGOOPullRefreshLoading,	
} EGOPullRefreshState;

@interface EGORefreshTableHeaderView : UIView {
	
	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	
	EGOPullRefreshState _state;

@protected
    CGRect _lastUpdatedLabelFrame;
    CGRect _statusLabelFrame;
    CGRect _arrowImageFrame;
    CGRect _activityViewFrame;
    
    CATransform3D _arrowPullingTransform;
    CATransform3D _arrowNormalTransform;
    
    NSString *_releaseLabelText;
    NSString *_pullingLabelText;
    NSString *_loadingLabelText;
    
    NSString *_userDefaultsKey;
}

@property(nonatomic,assign) EGOPullRefreshState state;
@property(nonatomic,retain) NSString *releaseLabelText;
@property(nonatomic,retain) NSString *pullingLabelText;
@property(nonatomic,retain) NSString *loadingLabelText;

- (void)setCurrentDate;
- (void)setState:(EGOPullRefreshState)aState;
- (void)setup:(CGRect)frame;

@end
