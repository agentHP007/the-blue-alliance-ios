//
//  EventAlliancesViewController.m
//  the-blue-alliance
//
//  Created by Zach Orr on 4/24/16.
//  Copyright © 2016 The Blue Alliance. All rights reserved.
//

#import "EventAlliancesViewController.h"
#import "TBAAlliancesViewController.h"
#import "Event.h"

static NSString *const AlliancesViewControllerEmbed = @"AlliancesViewControllerEmbed";

@interface EventAlliancesViewController ()

@property (nonatomic, strong) TBAAlliancesViewController *alliancesViewController;
@property (nonatomic, strong) IBOutlet UIView *alliancesView;

@end

@implementation EventAlliancesViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshViewControllers = @[self.alliancesViewController];
    self.containerViews = @[self.alliancesView];
    
    [self styleInterface];
}

#pragma mark - Interface Methods

- (void)styleInterface {
    self.navigationTitleLabel.text = @"Alliances";
    self.navigationSubtitleLabel.text = [NSString stringWithFormat:@"@ %@", [self.event friendlyNameWithYear:YES]];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:AlliancesViewControllerEmbed]) {
        self.alliancesViewController = segue.destinationViewController;
        self.alliancesViewController.event = self.event;
    }
}

@end
