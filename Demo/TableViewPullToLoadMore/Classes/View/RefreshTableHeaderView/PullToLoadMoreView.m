//
//  PullToLoadMoreView.h
//
//  Originally created by Devin Doty on 16 october 2009.
//  Forked and customized by Linus Karnland on 18 february 2012
//
//  Copyright enormego 2009. All rights reserved.
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
        _statusLabelFrame       = CGRectMake(0.0f, 5.0f, self.frame.size.width, 40.0f);
        _arrowImageFrame        = CGRectMake(35.0f, 5.0f, 30.0f, 40.0f);
        _waitIndicatorFrame     = CGRectMake(40.0f, 16.0f, 20.0f, 20.0f);
        
        _arrowPullingTransform = CATransform3DMakeRotation((M_PI / 180.0f) * -360.0f, 0.0f, 0.0f, 1.0f);
        _arrowNormalTransform  = CATransform3DMakeRotation((M_PI / 180.0f) *  180.0f, 0.0f, 0.0f, 1.0f);
        
        _releaseLabelText = NSLocalizedString(@"Release to load more...", @"Release to load more");
        _pullingLabelText = NSLocalizedString(@"Pull up to load more...", @"Pull up to load more");
        _loadingLabelText = NSLocalizedString(@"Loading more...", @"Loading Status");
 
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        // Init status text label
		_statusLabel = [[UILabel alloc] initWithFrame:_statusLabelFrame];
        
		_statusLabel.autoresizingMask   = UIViewAutoresizingFlexibleWidth;
		_statusLabel.font               = [UIFont boldSystemFontOfSize:PTLMFontSize];
		_statusLabel.textColor          = PTLMTextColor;
		_statusLabel.shadowColor        = PTLMShadowColor;
		_statusLabel.shadowOffset       = PTLMShadowOffset;
		_statusLabel.backgroundColor    = [UIColor clearColor];
		_statusLabel.textAlignment      = UITextAlignmentCenter;
        
        [self addSubview:_statusLabel];
		
        // Add arrow as layer
		_arrowImage = [[CALayer alloc] init];
        
		_arrowImage.frame           = _arrowImageFrame;
		_arrowImage.contentsGravity = kCAGravityResizeAspect;
		_arrowImage.contents        = (id) [UIImage imageNamed:@"grayArrow.png"].CGImage;
		
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
			_arrowImage.contentsScale = [[UIScreen mainScreen] scale];
		}
        
        [[self layer] addSublayer:_arrowImage];
		
        // Add loading indicator
		_waitIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
		_waitIndicatorView.frame = _waitIndicatorFrame;
        
		[self addSubview:_waitIndicatorView];
		
        // Set initial state to normal
		[self setState:StateNormal];
    }
    
    return self;
}

- (void) setState:(State) newState
{
	switch (newState) {
            
		case StatePulling:
			
			_statusLabel.text = _releaseLabelText;
            
			[CATransaction begin];
			[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
			_arrowImage.transform = _arrowPullingTransform;
			[CATransaction commit];
			
			break;
            
		case StateNormal:
			
			if (_state == StatePulling) {
				[CATransaction begin];
				[CATransaction setAnimationDuration:FLIP_ANIMATION_DURATION];
				_arrowImage.transform = CATransform3DIdentity;
				[CATransaction commit];
			}
			
			_statusLabel.text = _pullingLabelText;
			[_waitIndicatorView stopAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = NO;
			_arrowImage.transform = _arrowNormalTransform;
			[CATransaction commit];
			
			break;
            
		case StateLoading:
			
			_statusLabel.text = _loadingLabelText;
			[_waitIndicatorView startAnimating];
            
			[CATransaction begin];
			[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions]; 
			_arrowImage.hidden = YES;
			[CATransaction commit];
			
			break;
            
		default:
			break;
	}
	
	_state = newState;
}

- (void) dealloc 
{
	[_waitIndicatorView release];
	[_statusLabel release];
	[_arrowImage release];
    
    _waitIndicatorView = nil;
    _statusLabel = nil;
    _arrowImage = nil;
    
    self.releaseLabelText = nil;
    self.pullingLabelText = nil;
    self.loadingLabelText = nil;
    
    [super dealloc];
}


@end
