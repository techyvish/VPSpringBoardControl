//
//  ViewController.m
//  VPSpringBoardControl
//
//  Created by vishal patel on 2/14/13.
//  Copyright (c) 2013 vishal patel. All rights reserved.
//

#import "ViewController.h"
#import "VPProxyView.h"
#import "VPIconLayer.h"
#import "VPIconData.h"
#import "VPSpriteManager.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize arrayOfServices;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.arrayOfServices     = [NSArray arrayWithObjects:@"Transfer", @"Pay Anyone",@"Bill Pay",@"Donations", @"Pay Mobile",@"Uncollected",nil];
    NSArray *imageArray      = [NSArray arrayWithObjects:@"transfer_ico", @"PayAnyone_ico",@"Bpay_ico",@"donate_ico", @"P2M_ico",@"uncollected_ico", nil];
    NSArray *arr             = [NSArray arrayWithObjects:@"Transfer", @"Pay Anyone",@"Pay a Bill",@"Donate", @"Pay to Mobile",@"Uncollected",nil];
    CGRect bounds = [[UIScreen mainScreen]bounds];
    NSMutableArray  *servicesArray = [[NSMutableArray alloc] initWithCapacity: 20];
    for ( int i = 0 ; i < 6 ; i++ ) {
        VPIconData    *iconData = [[VPIconData alloc]init];
        iconData.iconName = [arr objectAtIndex:i];
        iconData.iconImage = [VPSpriteManager getDonationImageNamed:[imageArray objectAtIndex:i]]; //[UIImage imageNamed:[imageArray objectAtIndex:i]];
        iconData.type = i ;
        [servicesArray addObject:iconData];
    }
    VPProxyView   *proxy = [[VPProxyView alloc] initWithFrame:bounds andIcons:servicesArray];
    self.view = proxy ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
