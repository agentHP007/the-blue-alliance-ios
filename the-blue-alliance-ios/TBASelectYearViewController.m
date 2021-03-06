//
//  TBAYearSelectViewController.m
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 3/27/15.
//  Copyright (c) 2015 The Blue Alliance. All rights reserved.
//

#import "TBASelectYearViewController.h"
#import "TBASelectViewController.h"
#import "TBANavigationController.h"

@implementation TBASelectYearViewController

#pragma mark - Class Methods

+ (NSNumber *)currentYear {
    // TODO: Look for year + 1 as well when data starts coming in
    return @([[NSCalendar currentCalendar] component:NSCalendarUnitYear fromDate:[NSDate date]]);
}

+ (NSArray *)yearsBetweenStartYear:(NSInteger)startYear endYear:(NSInteger)endYear {
    NSMutableArray *years = [[NSMutableArray alloc] init];
    for (NSInteger i = endYear; i >= startYear; i--) {
        [years addObject:[NSNumber numberWithInteger:i]];
    }
    return years;
}

#pragma mark - Properities

- (NSNumber *)currentYear {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[self currentYearUserDefaultsString]];
}

- (void)setCurrentYear:(NSNumber *)currentYear {
    [[NSUserDefaults standardUserDefaults] setObject:currentYear forKey:[self currentYearUserDefaultsString]];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateYearInterface];
    });
}

#pragma mark - View Lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupTapGesture];
    [self updateYearInterface];
}

#pragma mark - Interface Methods

- (void)setupTapGesture {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectYearButtonTapped:)];
    [self.navigationItem.titleView addGestureRecognizer:tapGesture];
}

- (void)updateYearInterface {
    self.navigationTitleLabel.text = self.navigationItem.title;
    if (self.currentYear == 0) {
        self.navigationSubtitleLabel.text = @"---";
    } else {
        self.navigationSubtitleLabel.text = [NSString stringWithFormat:@"▾ %@", self.currentYear];
    }
}

- (void)selectYearButtonTapped:(id)sender {
    if (self.currentYear == 0) {
        return;
    }

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];

    TBANavigationController *navigationController = (TBANavigationController *)[storyboard instantiateViewControllerWithIdentifier:@"TBASelectNavigationController"];
    TBASelectViewController *selectViewController = navigationController.viewControllers.firstObject;
    selectViewController.selectType = TBASelectTypeYear;
    selectViewController.currentNumber = self.currentYear;
    selectViewController.numbers = self.years;
    if (self.yearSelected) {
        selectViewController.numberSelected = self.yearSelected;
    }
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - Private Methods

- (NSString *)currentYearUserDefaultsString {
    NSString *classString = NSStringFromClass([self class]);
    return [NSString stringWithFormat:@"%@.currentYear", classString];
}

@end
