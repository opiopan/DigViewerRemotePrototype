//
//  ViewController.m
//  DigViewerRemotePrototype
//
//  Created by Hiroshi Murayama on 2015/09/04.
//  Copyright (c) 2015年 opiopan. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>

@interface ViewController ()
@property IBOutlet MKMapView* mapView;
@end

@implementation ViewController{
    DVRemoteClient* _client;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mapView.mapType = MKMapTypeStandard;
    _mapView.showsBuildings = YES;
    _mapView.pitchEnabled = YES;
    
    _client = [DVRemoteClient new];
    _client.delegate = self;
    [_client searchServers];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-----------------------------------------------------------------------------------------
- (void)dvrClient:(DVRemoteClient*)client didFindServers:(NSArray*)servers
{
    if (servers && servers.count > 0){
        [client connectToServer:servers[0]];
    }else{
        [self performSelector:@selector(researchServers) withObject:nil afterDelay:2.0];
    }
}

- (void)dvrClient:(DVRemoteClient *)client hasBeenDisconnectedByError:(NSError *)error
{
    [client disconnect];
    [self performSelector:@selector(researchServers) withObject:nil afterDelay:2.0];
}

- (void)researchServers
{
    [_client searchServers];
}

- (void)dvrClient:(DVRemoteClient *)client didRecieveMeta:(NSDictionary *)meta
{
    CLLocationCoordinate2D centerCoordinate =
        CLLocationCoordinate2DMake([[meta valueForKey:DVRCNMETA_VIEW_LATITUDE] doubleValue],
                                   [[meta valueForKey:DVRCNMETA_VIEW_LONGITUDE] doubleValue]);
    CLLocationCoordinate2D fromEyeCoordinate =
        CLLocationCoordinate2DMake([[meta valueForKey:DVRCNMETA_LATITUDE] doubleValue],
                                   [[meta valueForKey:DVRCNMETA_LONGITUDE] doubleValue]);
    CLLocationDistance eyeAltitude = 50.0;
    MKMapCamera *camera = [MKMapCamera cameraLookingAtCenterCoordinate:centerCoordinate
                                                     fromEyeCoordinate:fromEyeCoordinate
                                                           eyeAltitude:eyeAltitude];
    _mapView.camera = camera;
    _mapView.showsBuildings = YES;
}

@end
