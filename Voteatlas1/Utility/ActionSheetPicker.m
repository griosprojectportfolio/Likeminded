//
//  ActionSheetPicker.m
//  Spent
//
//  Created by Tim Cinel on 3/01/11.
//  Copyright 2011 Thunderous Playground. All rights reserved.
//

#import "ActionSheetPicker.h"
#import "QuartzCore/QuartzCore.h"

@implementation ActionSheetPicker

@synthesize delegate;
@synthesize view = _view;

@synthesize data = _data;
@synthesize selectedIndex = _selectedIndex;
@synthesize title = _title;

@synthesize selectedDate = _selectedDate;
@synthesize datePickerMode = _datePickerMode;

@synthesize target = _target;
@synthesize action = _action;

@synthesize actionSheet = _actionSheet;
@synthesize popOverController = _popOverController;
@synthesize pickerView = _pickerView;
@synthesize datePickerView = _datePickerView;
@synthesize pickerPosition = _pickerPosition;
@synthesize vwActionSheet;
@synthesize componentWidth;
@synthesize viewSize;

#pragma mark -
#pragma mark NSObject

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title withDelegate:(id)delegate_ width:(float)widthComponent{
}

+ (void)displayActionPickerWithView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title width:(float)widthComponent {
    
    ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDataWithContainingView:aView data:data selectedIndex:selectedIndex target:target action:action title:title width:widthComponent];
	[actionSheetPicker showActionPicker];
}

+ (void)displayActionPickerWithView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title {

    ActionSheetPicker *actionSheetPicker = [[ActionSheetPicker alloc] initForDateWithContainingView:aView datePickerMode:datePickerMode selectedDate:selectedDate target:target action:action title:title];
	[actionSheetPicker showActionPicker];
}

- (id)initWithContainingView:(UIView *)aView target:(id)target action:(SEL)action {
	
    if ((self = [super init]) != nil) {
		
        self.view = aView;
		self.target = target;
		self.action = action;

        viewSize = aView.frame.size;
	}
	return self;
}

- (id)initForDataWithContainingView:(UIView *)aView data:(NSArray *)data selectedIndex:(NSInteger)selectedIndex target:(id)target action:(SEL)action title:(NSString *)title width:(float)widthComponent {

    if ((self = [super init]) != nil) {
        if ([self initWithContainingView:aView target:target action:action] != nil) {
            self.data = data;
            self.componentWidth = widthComponent;
            self.selectedIndex = selectedIndex;
            self.title = title;
        }
    }
    return self;
}

- (id)initForDateWithContainingView:(UIView *)aView datePickerMode:(UIDatePickerMode)datePickerMode selectedDate:(NSDate *)selectedDate target:(id)target action:(SEL)action title:(NSString *)title {

    if ((self = [super init]) != nil) {
        if ([self initWithContainingView:aView target:target action:action] != nil) {
            self.datePickerMode = datePickerMode;
            self.selectedDate = selectedDate;
            self.title = title;
        }
    }
	return self;
}

#pragma mark -
#pragma mark Implementation

- (void)showActionPicker {
	
    [self retain];
	
    //view on whole screen
    self.vwActionSheet = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, viewSize.width, self.view.frame.size.height)] autorelease];
    [self.vwActionSheet setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.6]];
    
	//create the new view
	UIView *view = [[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, self.viewSize.width, 260)] autorelease];
	[view setBackgroundColor:[UIColor whiteColor]];
    [self.vwActionSheet addSubview:view];
    
	if (nil != self.data) {
		//show data picker
		[self showDataPicker];
		[view addSubview:self.pickerView];
	} else {
		//show date picker
		[self showDatePicker];
		[view addSubview:self.datePickerView];
	}
	
	CGRect frame = CGRectMake(0, 0, self.viewSize.width, 44);
	UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:frame];
	pickerDateToolbar.barStyle = UIBarStyleDefault;
	
	NSMutableArray *barItems = [[NSMutableArray alloc] init];
	
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(actionPickerCancel)];
	//[barItems addObject:cancelBtn];
	[cancelBtn release];
	
	UIBarButtonItem *flexSpace = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil] autorelease];
	//[barItems addObject:flexSpace];
	
	//Add tool bar title label
	if (nil != self.title){
		UILabel *toolBarItemlabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 240,30)];
		[toolBarItemlabel setTextAlignment:NSTextAlignmentLeft];
		[toolBarItemlabel setTextColor:[UIColor colorWithRed:0/255.0f green:135/255.0f blue:255/255.0f alpha:1.0]];	
		[toolBarItemlabel setFont:[UIFont boldSystemFontOfSize:15]];
		[toolBarItemlabel setBackgroundColor:[UIColor clearColor]];
		toolBarItemlabel.text = self.title;	
		
		UIBarButtonItem *buttonLabel =[[UIBarButtonItem alloc]initWithCustomView:toolBarItemlabel];
		//[toolBarItemlabel release];
		[barItems addObject:buttonLabel];	
		[buttonLabel release];	
		
		[barItems addObject:flexSpace];
	}
	
	//add "Done" button
	UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(actionPickerDone)];
	[barItems addObject:barButton];
	[barButton release];
	
	[pickerDateToolbar setItems:barItems animated:YES];
	[barItems release];
	
	[view addSubview:pickerDateToolbar];
	[pickerDateToolbar release];
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {

        [UIView animateWithDuration:0.5 animations:^(void) {
            
            [self.view addSubview:self.vwActionSheet];
            [self.vwActionSheet setFrame:CGRectMake(0, 0, viewSize.width, self.view.frame.size.height)];
        }];
        return;

        //spawn popovercontroller
		UIViewController *viewController = [[[UIViewController alloc] initWithNibName:nil bundle:nil] autorelease];
		viewController.view = view;
		viewController.contentSizeForViewInPopover = viewController.view.frame.size;
		_popOverController = [[UIPopoverController alloc] initWithContentViewController:viewController];
		[self.popOverController presentPopoverFromRect:self.view.frame inView:self.view.superview?:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
	} else {
        
        [UIView animateWithDuration:0.5 animations:^(void) {
            
            [self.view addSubview:self.vwActionSheet];
            [self.vwActionSheet setFrame:CGRectMake(0, 0, viewSize.width, self.view.frame.size.height)];
        }];
        
		//spawn actionsheet
		//_actionSheet = [[UIActionSheet alloc] initWithTitle:[self isViewPortrait]?@"":@"\n\n\n" delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        //[self.actionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
		//[self.actionSheet addSubview:view];
         
		//[self.actionSheet showInView:self.view];
		//self.actionSheet.bounds = CGRectMake(0, 0, self.viewSize.width, self.viewSize.height+5);
	}
}

- (void)showDataPicker {
    
	//spawn pickerview
	CGRect pickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
	_pickerView = [[UIPickerView alloc] initWithFrame:pickerFrame];
	
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	self.pickerView.showsSelectionIndicator = YES;
	[self.pickerView selectRow:self.selectedIndex inComponent:0 animated:NO];
}

- (void)showDatePicker {
    
	//spawn datepickerview
	CGRect datePickerFrame = CGRectMake(0, 40, self.viewSize.width, 216);
	_datePickerView = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
	self.datePickerView.datePickerMode = self.datePickerMode;
	[self.datePickerView setMinuteInterval:1];
	[self.datePickerView setBackgroundColor:[UIColor whiteColor]];
	[self.datePickerView setDate:self.selectedDate animated:NO];
	[self.datePickerView addTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
}

- (void)actionPickerDone {
    
    [UIView animateWithDuration:0.5 animations:^(void) {
        
        [self.vwActionSheet setFrame:CGRectMake(0, self.view.frame.size.height, viewSize.width, 240)];
        [self.view addSubview:self.vwActionSheet];
        
    }];
	
    NSLog(@"%@", [NSNumber numberWithInteger:self.selectedIndex]);
    
	if (nil != self.data) {
		//send data picker message
		[self.target performSelector:self.action withObject:[NSNumber numberWithInteger:self.selectedIndex] withObject:self.view];
	} else {
		//send date picker message
		[self.target performSelector:self.action withObject:self.selectedDate withObject:self.view];
	}
    
	//[self release];
}

- (void)actionPickerCancel {
    
	if (self.actionSheet) {
		[self.actionSheet dismissWithClickedButtonIndex:0 animated:YES];
	} else {
		[self.popOverController dismissPopoverAnimated:YES];
	}
    
	//[self release];
}

- (BOOL) isViewPortrait {
	
    return UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation);
}

//- (CGSize) viewSize {
//	
//    CGSize size = CGSizeMake(320, 480);
//	if (![self isViewPortrait]) {
//		size = CGSizeMake(480, 320);
//	}
//	return size;
//}

#pragma mark -
#pragma mark Callbacks 

- (void)eventForDatePicker:(id)sender {
	
    UIDatePicker *datePicker = (UIDatePicker *)sender;
	self.selectedDate = datePicker.date;
}

#pragma mark -
#pragma mark UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
	self.selectedIndex = row;
}

#pragma mark -
#pragma mark UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	
    return self.data.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    return self.componentWidth;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 37)];
    label.text = [NSString stringWithFormat:@"%@",[self.data objectAtIndex:row]];
    label.font=[UIFont boldSystemFontOfSize:23];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor clearColor];
    [label autorelease];
    return label;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return [self.data objectAtIndex:row];
}

#pragma mark -
#pragma mark Memory Management

- (void)dealloc {
	//	NSLog(@"ActionSheet Dealloc");
	self.actionSheet = nil;
	self.popOverController = nil;

	self.data = nil;
	self.pickerView.delegate = nil;
	self.pickerView.dataSource = nil;
	self.pickerView = nil;

	[self.datePickerView removeTarget:self action:@selector(eventForDatePicker:) forControlEvents:UIControlEventValueChanged];
	self.datePickerView = nil;
	self.selectedDate = nil;

	self.view = nil;
	self.target = nil;
    [super release];
	[super dealloc];
}

@end
