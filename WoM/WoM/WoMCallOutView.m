//
//  WoMCallOutView.m
//  WoM
//
//  Created by Tanguy Hélesbeux on 23/06/2014.
//  Copyright (c) 2014 Tanguy Hélesbeux. All rights reserved.
//

#import "WoMCallOutView.h"

@interface WoMCallOutView()
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation WoMCallOutView

+ (instancetype)newView
{
    WoMCallOutView *view = (WoMCallOutView *)[[[NSBundle mainBundle] loadNibNamed:@"WoMCallOutView" owner:nil options:nil] objectAtIndex:0];
    view.backgroundColor = [UIColor clearColor];
    view.userInteractionEnabled = YES;
    view.isPlaying = NO;
    return view;
}

- (void)setAnnotationView:(MKAnnotationView *)annotationView
{
    _annotationView = annotationView;
    self.label.text = [annotationView.annotation title];
    self.addressLabel.text = [annotationView.annotation subtitle];
}

- (IBAction)playButtonHandler:(id)sender
{
    [self setIsPlaying:!self.isPlaying];
}

- (void)setIsPlaying:(BOOL)isPlaying
{
    _isPlaying = isPlaying;
    NSString *imageName = isPlaying ? @"pause.png" : @"play.png";
    UIImage *image = [UIImage imageNamed:imageName];
    [self.playButton setImage:image forState:UIControlStateNormal];
}

@end
