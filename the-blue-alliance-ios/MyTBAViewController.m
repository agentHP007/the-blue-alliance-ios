//
//  MyTBAViewController.m
//  the-blue-alliance
//
//  Created by Zach Orr on 5/5/16.
//  Copyright © 2016 The Blue Alliance. All rights reserved.
//

#import "MyTBAViewController.h"
#import "MyTBASignInViewController.h"
#import "TBAFavoritesViewController.h"
#import "TBASubscriptionsViewController.h"
#import "TBANotificationsViewController.h"
#import "MyTBAService.h"
#import "MyTBAAuthViewController.h"
#import "MyTBAAuthenticaion.h"

static NSString *const MyTBASignInEmbed = @"MyTBASignInEmbed";

static NSString *const MyTBAAuthSegue   = @"MyTBAAuthSegue";

@interface MyTBAViewController ()

@property (nonatomic, strong) MyTBASignInViewController *signInViewController;
@property (nonatomic, strong) IBOutlet UIView *signInView;

@property (nonatomic, strong) TBAFavoritesViewController *favoritesViewController;
@property (nonatomic, strong) IBOutlet UIView *favoritesView;

@property (nonatomic, strong) TBASubscriptionsViewController *subscriptionsViewController;
@property (nonatomic, strong) IBOutlet UIView *subscriptionsView;

@property (nonatomic, strong) TBANotificationsViewController *recentNotificationsViewController;
@property (nonatomic, strong) IBOutlet UIView *recentNotificationsView;

@property (nonatomic, strong) UIBarButtonItem *signOutBarButtonItem;

@end

@implementation MyTBAViewController

#pragma mark - Properities

- (UIBarButtonItem *)signOutBarButtonItem {
    if (!_signOutBarButtonItem) {
        _signOutBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Sign Out" style:UIBarButtonItemStylePlain target:self action:@selector(signOutTapped:)];
    }
    return _signOutBarButtonItem;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self styleInterface];
    [self updateInterface];
}

#pragma mark - Interface Actions

- (void)styleInterface {
    self.navigationItem.title = @"myTBA";
}

- (void)updateInterface {
    if ([MyTBAService sharedService].authentication) {
        self.signInView.hidden = YES;
        self.navigationItem.rightBarButtonItem = self.signOutBarButtonItem;
        [[MyTBAService sharedService] fetchFavorites:^(NSArray<TBAFavorite *> *favorites, NSError *error) {
            NSLog(@"Error: %@", error);
            NSLog(@"Favories: %@", favorites);
        }];
    } else {
        self.signInView.hidden = NO;
        [self.view bringSubviewToFront:self.signInView];
        self.navigationItem.rightBarButtonItem = nil;
    }
}

#pragma mark - IB Actions

- (IBAction)signOutTapped:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Sign Out?" message:@"Are you sure you want to sign out of myTBA?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *signOutAction = [UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[MyTBAService sharedService] removeAuthentication];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateInterface];
        });
    }];
    [alertController addAction:signOutAction];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertController animated:YES completion:nil];
    });
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    __weak typeof(self) weakSelf = self;
    if ([segue.identifier isEqualToString:MyTBASignInEmbed]) {
        self.signInViewController = segue.destinationViewController;
        self.signInViewController.signIn = ^() {
            [weakSelf performSegueWithIdentifier:@"MyTBAAuthSegue" sender:nil];
        };
    } else if ([segue.identifier isEqualToString:@"MyTBAAuthSegue"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        MyTBAAuthViewController *authViewController = navigationController.viewControllers.firstObject;
        
        authViewController.authSucceeded = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self updateInterface];
            });
        };
        
        authViewController.authFailed = ^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *okayAction = [UIAlertAction actionWithTitle:@"Okay" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okayAction];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertController animated:YES completion:nil];
            });
        };
    }
}

@end
