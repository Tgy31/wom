//
//  WoMCallOutView.h
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface WoMCallOutView : UIView

@property (strong, nonatomic) MKAnnotationView *annotationView;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (nonatomic) BOOL isPlaying;

+ (instancetype)newView;

@end
