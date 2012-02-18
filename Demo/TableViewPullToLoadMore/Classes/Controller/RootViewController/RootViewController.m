//
//  RootViewController.m
//  TableViewPull
//
//  Created by Devin Doty on 10/16/09October16.
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
- (void) dataSourceDidFinishLoadingNewData;
- (void) loadMoreSampleData;
- (void) repositionLoadMoreFooterView;
- (void) freeUp;
- (CGFloat) tableViewContentHeight;
- (CGFloat) endOfTableView:(UIScrollView *)scrollView;

@end


@implementation RootViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    
    _sampleDataSource = [[NSMutableArray alloc] initWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
    [self.tableView reloadData];

    if (_loadMoreFooterView == nil) {
        [self setupLoadMoreFooterView];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)viewDidUnload {
	[self freeUp];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sampleDataSource.count;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [_sampleDataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)reloadTableViewDataSource{
	//  should be calling your tableviews model to reload
	//  put here just for demo
	[self performSelector:@selector(doneLoadingTableViewData) withObject:nil afterDelay:3.0];
}


- (void)doneLoadingTableViewData{
	//  model should call this when its done loading
	[self dataSourceDidFinishLoadingNewData];
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if ([_loadMoreFooterView isHidden]) {
        return;
    }
    
	if (scrollView.isDragging) {
        CGFloat endOfTable = [self endOfTableView:scrollView];
        
        if (_loadMoreFooterView.state == PullRefreshPulling && endOfTable < 0.0f && endOfTable > -60.0f && !_loadingInProgress) {
			[_loadMoreFooterView setState:PullRefreshNormal];
            
		} else if (_loadMoreFooterView.state == PullRefreshNormal && endOfTable < -60.0f && !_loadingInProgress) {
			[_loadMoreFooterView setState:PullRefreshPulling];
		}
	}       
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	
	if ([_loadMoreFooterView isHidden]) {
        return;
    }
    
    if ([self endOfTableView:scrollView] <= -60.0f && !_loadingInProgress) {
        _loadingInProgress = YES;
        
        // For demo purposes
        [self performSelector:@selector(loadMoreSampleData) withObject:nil afterDelay:3.0];
        
        [_loadMoreFooterView setState:PullRefreshLoading];
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, 55.0f, 0.0f);
        [UIView commitAnimations];
	}
}

- (void) setupLoadMoreFooterView
{
    CGFloat xCoord = 0.0f;
    CGFloat yCoord = [self tableViewContentHeight];
    CGFloat width = self.view.frame.size.width;
    CGFloat height = 600.0f;
    
    _loadMoreFooterView = [[[PullToLoadMoreView alloc] initWithFrame:CGRectMake(xCoord, yCoord, width, height)] autorelease];
    _loadMoreFooterView.backgroundColor = [UIColor clearColor];
    
    [self.tableView addSubview:_loadMoreFooterView];
}

- (void) loadMoreSampleData
{
    // Cancel loading footer
    [self performSelector:@selector(dataSourceDidFinishLoadingNewData) withObject:nil];
    
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
    
    [self.tableView setContentOffset:CGPointMake(self.tableView.contentOffset.x, self.tableView.contentOffset.y + 55.0f)];
}

- (void) dataSourceDidFinishLoadingNewData 
{	
	_loadingInProgress = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:.3];
	[self.tableView setContentInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[UIView commitAnimations];

    if ([_loadMoreFooterView state] != PullRefreshNormal) {
        [_loadMoreFooterView setState:PullRefreshNormal];
    }
}

- (float)tableViewContentHeight {
    return self.tableView.contentSize.height;
}

- (void) repositionLoadMoreFooterView {
    _loadMoreFooterView.center = CGPointMake(self.view.frame.size.width / 2, 
                                            [self tableViewContentHeight] + _loadMoreFooterView.frame.size.height / 2);

}

- (float)endOfTableView:(UIScrollView *)scrollView {
    return [self tableViewContentHeight] - scrollView.bounds.size.height - scrollView.bounds.origin.y;
}

#pragma mark -
#pragma mark Dealloc

- (void) freeUp
{
    _loadMoreFooterView = nil;
    [_loadMoreFooterView release];
}

- (void)dealloc 
{
    [self freeUp];
    [super dealloc];
}


@end

