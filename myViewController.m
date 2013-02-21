//
//  myViewController.m
//  sqlitedemo
//
//  Created by sun jianfeng on 2/21/13.
//  Copyright (c) 2013 oo. All rights reserved.
//

#import "myViewController.h"

@interface myViewController ()

@end

@implementation myViewController
@synthesize myImageView;
@synthesize image;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.myImageView setImage:self.image];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
