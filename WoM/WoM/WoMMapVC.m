//
//  WoMMapVC.m
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import "WoMMapVC.h"

#define LYON 45.764043, 4.835658999999964

@interface WoMMapVC ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *exploreButton;
@property (weak, nonatomic) IBOutlet UIToolbar *routeButton;

@end

@implementation WoMMapVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(LYON);
    [self setMapCenter:location];
}

#pragma mark - MapView

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate
{
//    [self.mapView setCenterCoordinate:coordinate animated:YES];
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

@end
