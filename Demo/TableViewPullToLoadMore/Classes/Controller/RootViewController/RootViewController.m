//
//  RootViewController.m
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

#import "RootViewController.h"
#import "PullToLoadMoreView.h"

@interface RootViewController ()
{
    BOOL _loadingInProgress;
}

- (void) setupLoadMoreFooterView;
- (void) didFinishLoadingMoreSampleData;
- (void) loadMoreSampleData;
- (void) repositionLoadMoreFooterView;
- (void) freeUp;
- (CGFloat) tableViewContentHeight;
- (CGFloat) endOfTableView:(UIScrollView *)scrollView;

@end

@implementation RootViewController

#pragma mark - View life cycle

- (void) viewDidLoad 
{
    [super viewDidLoad];
    
    _sampleDataSource = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", nil];
    [self.tableView reloadData];

    if (_loadMoreFooterView == nil) {
        [self setupLoadMoreFooterView];
    }
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    return YES;
}

- (void) viewDidUnload 
{
	[self freeUp];
}

#pragma mark UITableView methods

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return _sampleDataSource.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    static NSString* cellIdentifier = @"Cell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_sampleDataSource objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate methods

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (scrollView.isDragging) {
        CGFloat endOfTable = [self endOfTableView:scrollView];
        
        if (_loadMoreFooterView.state == StatePulling && endOfTable < 0.0f && endOfTable > -60.0f && !_loadingInProgress) {
			[_loadMoreFooterView setState:StateNormal];
            
		} else if (_loadMoreFooterView.state == StateNormal && endOfTable < -60.0f && !_loadingInProgress) {
			[_loadMoreFooterView setState:StatePulling];
		}
	}       
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{	
    if ([self endOfTableView:scrollView] <= -60.0f && !_loadingInProgress) {
        
        // Show loading footer
         _loadingInProgress = YES;
        [_loadMoreFooterView setState:StateLoading];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 55.0f, 0.0f);
        [UIView commitAnimations];
        
        // Load some more data into table, pretend it took 3 seconds to get it
        [self performSelector:@selector(loadMoreSampleData) withObject:nil afterDelay:3.0];
	}
}

#pragma mark - PullToLoadMoreView helper methods

- (void) setupLoadMoreFooterView
{
    CGRect frame = CGRectMake(0.0f, [self tableViewContentHeight], self.view.frame.size.width, 600.0f);
    
    _loadMoreFooterView = [[[PullToLoadMoreView alloc] initWithFrame:frame] autorelease];
    _loadMoreFooterView.backgroundColor = [UIColor clearColor];
    
    [self.tableView addSubview:_loadMoreFooterView];
}

- (void) loadMoreSampleData
{
    // Add five more sample rows
    int next = _sampleDataSource.count + 1;
    
    NSString* first = [NSString stringWithFormat:@"%d", next++];
    NSString* second = [NSString stringWithFormat:@"%d", next++];
    NSString* third = [NSString stringWithFormat:@"%d", next++];
    NSString* fourth = [NSString stringWithFormat:@"%d", next++];
    NSString* fifth = [NSString stringWithFormat:@"%d", next];
    
    NSArray* moreData = [NSArray arrayWithObjects:first, second, third, fourth, fifth, nil];
    [_sampleDataSource addObjectsFromArray:moreData];
    
    // Reload table view data and update position of footer
    [self.tableView reloadData];
    [self repositionLoadMoreFooterView];
    
    // Dismiss loading footer
    [self performSelector:@selector(didFinishLoadingMoreSampleData) withObject:nil];
}

- (void) didFinishLoadingMoreSampleData 
{	
	_loadingInProgress = NO;
    [self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];

    if ([_loadMoreFooterView state] != StateNormal) {
        [_loadMoreFooterView setState:StateNormal];
    }
}

- (CGFloat) tableViewContentHeight 
{
    return self.tableView.contentSize.height;
}

- (CGFloat) endOfTableView:(UIScrollView *)scrollView 
{
    return [self tableViewContentHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}

- (void) repositionLoadMoreFooterView 
{
    _loadMoreFooterView.center = CGPointMake(self.view.frame.size.width / 2, 
                                            [self tableViewContentHeight] + _loadMoreFooterView.frame.size.height / 2);
}

#pragma mark - Memory management and cleanup

- (void) freeUp
{
    _loadMoreFooterView = nil;
    [_sampleDataSource release];
}

- (void) dealloc 
{
    [self freeUp];
    [super dealloc];
}

@end

