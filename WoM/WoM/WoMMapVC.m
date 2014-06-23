//
//  WoMMapVC.m
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import "WoMMapVC.h"
#import "WoMTotalManager.h"
#import "WoMCallOutView.h"
#import "WoMAnnotationView.h"

#define LYON 45.764043, 4.835658999999964

#define ZOOM 0.01

#define TOTAL_API_RADIUS 100 //kilometers
#define TOTAL_MAX_SHOP 50

@interface WoMMapVC () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIToolbar *exploreButton;
@property (weak, nonatomic) IBOutlet UIToolbar *routeButton;

@property (nonatomic) CLLocationCoordinate2D center;
@property (weak, nonatomic) IBOutlet UIToolbar *explorerView;

@property (strong, nonatomic) NSArray *shopsInfo;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation WoMMapVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self registerTapRecognizer];
    
    self.mapView.delegate = self;
    
    self.center = CLLocationCoordinate2DMake(LYON);
    
    [self fetchShopsFromTotal];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)registerTapRecognizer
{
    UITapGestureRecognizer *mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapHandler)];
    [self.mapView addGestureRecognizer:mapTapGesture];
}

- (void)mapTapHandler
{
    [self.searchTextField resignFirstResponder];
}

- (IBAction)explorerButtonHandler:(id)sender
{
    self.explorerView.hidden = !self.explorerView.hidden;
}

#pragma mark - MapView

- (void)setCenter:(CLLocationCoordinate2D)center
{
    _center = center;
    [self setMapCenter:center];
}

- (void)setMapCenter:(CLLocationCoordinate2D)coordinate
{
    MKCoordinateSpan span = MKCoordinateSpanMake(ZOOM, ZOOM);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region animated:YES];
}

- (void)updateShopAnnotations
{
    NSMutableArray *tempAnnotations = [[NSMutableArray alloc] init];
    for (NSDictionary *shopInfo in self.shopsInfo) {
        MKPointAnnotation *shopAnnotation = [[MKPointAnnotation alloc] init];
        CGFloat latitude = [[shopInfo objectForKey:@"latitude"] floatValue];;
        CGFloat longitude = [[shopInfo objectForKey:@"longitude"] floatValue];
        CLLocationCoordinate2D shopLocation = CLLocationCoordinate2DMake(latitude, longitude);
        shopAnnotation.coordinate = shopLocation;
        shopAnnotation.title = shopInfo[@"name"];
        shopAnnotation.subtitle = shopInfo[@"address"];
        [tempAnnotations addObject:shopAnnotation];
    }
    [self.mapView addAnnotations:tempAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        WoMAnnotationView *pinView = (WoMAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"totalAnnotation"];
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[WoMAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"totalAnnotation"];
            pinView.canShowCallout = NO;
            pinView.image = [UIImage imageNamed:@"total.png"];
        } else {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
    self.center = [view.annotation coordinate];
    
    if(![view.annotation isKindOfClass:[MKAnnotationView class]]) {
        WoMCallOutView *calloutView = [WoMCallOutView newView];
        CGRect calloutViewFrame = calloutView.frame;
        calloutViewFrame.origin = CGPointMake(-calloutViewFrame.size.width/2 + 10, -calloutViewFrame.size.height + 5);
        calloutView.frame = calloutViewFrame;
        calloutView.annotationView = view;
        [calloutView.playButton addTarget:self action:@selector(playButtonHandler) forControlEvents:UIControlEventAllEvents];
        [view addSubview:calloutView];
    }
}

-(void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    for (UIView *subview in view.subviews ){
        [subview removeFromSuperview];
    }
}

- (void)playButtonHandler
{
    
}

#pragma mark - Total API

- (void)fetchShopsFromTotal
{
    CLLocation *location = [[CLLocation alloc] initWithLatitude:self.center.latitude longitude:self.center.longitude];
    [WoMTotalManager getShopsAroundLocation:location withLimit:TOTAL_MAX_SHOP andRadius:TOTAL_API_RADIUS success:^(NSURLSessionDataTask *task, id responseObject) {
        [self totalHandlerSuccess:task responseObject:responseObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self totalHandlerFailure:task error:error];
    }];
}

- (void)totalHandlerSuccess:(NSURLSessionDataTask *)task responseObject:(id)responseObject
{
    self.shopsInfo = [responseObject objectForKey:@"shops"];
    NSLog(@"%ld", (unsigned long)[self.shopsInfo count]);
    
    [self updateShopAnnotations];
}

- (void)totalHandlerFailure:(NSURLSessionDataTask *)task error:(NSError *)error
{
    NSLog(@"%@", error);
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.4 animations:^{
        CGPoint center = self.explorerView.center;
        self.explorerView.center = CGPointMake(center.x, center.y - 156);
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.2 animations:^{
        CGPoint center = self.explorerView.center;
        self.explorerView.center = CGPointMake(center.x, center.y + 156);
    }];
}

@end
