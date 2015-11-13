//
//  TBAEventsViewController.h
//  the-blue-alliance-ios
//
//  Created by Zach Orr on 6/8/15.
//  Copyright (c) 2015 The Blue Alliance. All rights reserved.
//

#import "TBATableViewController.h"

@class District, Event;

@interface TBAEventsViewController : TBATableViewController <TBATableViewControllerDelegate>

@property (nonatomic, strong) District *district;
@property (nonatomic, strong) NSPredicate *predicate;

@property (nonatomic, copy) void (^eventSelected)(Event *event);

@end