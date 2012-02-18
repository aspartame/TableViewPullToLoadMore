//
//  EGORefreshTableHeaderView.m
//  Demo
//
//  Created by Devin Doty on 10/14/09.
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

#import "PullToLoadMoreView.h"

@implementation PullToLoadMoreView

@synthesize state = _state;
@synthesize releaseLabelText = _releaseLabelText;
@synthesize pullingLabelText = _pullingLabelText;
@synthesize loadingLabelText = _loadingLabelText;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {		
        _statusLabelFrame      = CGRectMake(0.0f, 5.0f, self.frame.size.width, 40.0f);
        _arrowImageFrame       = CGRectMake(35.0f, 5.0f, 30.0f, 40.0f);
        _waitIndicatorFrame     = CGRectMake(35.0f, 16.0f, 20.0f, 20.0f);
        
        _arrowPullingTransform = CATransform3DMakeRotation((M_PI / 180.0f) * -360.0f, 0.0f, 0.0f, 1.0f);
        _arrowNormalTransform  = CATransform3DMakeRotation((M_PI / 180.0f) *  180.0f, 0.0f, 0.0f, 1.0f);
        
        _releaseLabelText = NSLocalizedString(@"Release to load more...", @"Release to load more");
        _pullingLabelText = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more");
        _loadingLabelText = NSLocalizedString(@"Loading more...", @"Loading Status");
        
        //_userDefaultsKey = @"RefreshTableFooterView_LastRefresh";
        
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Init status text label
		UILabel* label = [[[UILabel alloc] initWithFrame:_statusLabelFrame] autorelease];
        
		label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		label.font = [UIFont boldSystemFontOfSize:PTLMFontSize];
		label.textColor = PTLMTextColor;
		label.shadowColor = PTLMShadowColor;
		label.shadowOffset = PTLMShadowOffset;
		label.backgroundColor = [UIColor clearColor];
		label.textAlignment = UITextAlignmentCenter;
        
		_statusLabel = label;
        [self addSubview:_statusLabel];
		
        // Add arrow as layer
		CALayer *layer = [[[CALayer alloc] init] autorelease];
        
		layer.frame = _arrowImageFrame;
		layer.contentsGravity = kCAGravityResizeAspect;
		layer.contents = (id)[UIImage imageNamed:@"grayArrow.png"].CGImage;
		
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			layer.contentsScale = [[UIScreen mainScreen] scale];
		}
        
		_arrowImage = layer;
        [[self layer] addSublayer:_arrowImage];
		
        // Add loading indicator
		UIActivityIndicatorView* view = 
        [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray] autorelease];
        
		view.frame = _waitIndicatorFrame;
        
        _activityView = view;
		[self addSubview:view];
		
        // Set initial state to normal
		[self setState:PullRefreshNormal];
    }
    
    return self;
}

- (void) setState:(PullRefreshState) aState
{
	
	switch (aState) {
		case PullRefreshPulling:
			
			_statusLabel.text = _releaseLabelText;
            
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = _arrowPullingTransform;
			[CATransaction commit];
			
			break;
            
		case PullRefreshNormal:
			
			if (_state == PullRefreshPulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = _pullingLabelText;
			[_activityView stopAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = _arrowNormalTransform;
			[CATransaction commit];
			
			break;
            
		case PullRefreshLoading:
			
			_statusLabel.text = _loadingLabelText;
			[_activityView startAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
		default:
			break;
	}
	
	_state = aState;
}

- (void) dealloc 
{
	_activityView = nil;
	_statusLabel = nil;
	_arrowImage = nil;
    
    [super dealloc];
}


@end
