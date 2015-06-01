//
//  RAYLocationViewController.m
//  RAYLocationView
//
//  Created by richerpay on 15/6/1.
//  Copyright (c) 2015年 richerpay. All rights reserved.
//

#import "RAYLocationViewController.h"
#import <MapKit/MapKit.h>

@interface RAYLocationViewController ()<MKMapViewDelegate,CLLocationManagerDelegate>{
    NSString  *latitude;
    NSString  *longitude;
    
    NSMutableArray *pointArray;
}

@property (nonatomic, strong) MKMapView  *mapView; //高德地图

@property (nonatomic, strong) CLLocationManager *locationManager;  //定位服务管理对象初始化

@end

@implementation RAYLocationViewController

#pragma mark -
#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    pointArray = [NSMutableArray array];
    
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    
    self.mapView.frame = CGRectMake(20, 100, [[UIScreen mainScreen] bounds].size.width - 40 , 500);
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self InitLocationManager];
    [self StartUpdateLocationWithTitle:@"请打开定位服务" message:@"请在\"设置\"->\"隐私\"->\"位置\"->\"定位服务\"中开启\"POS\"的定位权限"];
    
    double delayInSeconds = 1.;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        
        [self displayAnnotationByCoordinate];
    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager  didUpdateToLocation:(CLLocation *)newLocation
               fromLocation:(CLLocation *)oldLocation{
//- (void)locationManager:(CLLocationManager *)manager
//     didUpdateLocations:(NSArray *)locations {

//    CLLocationCoordinate2D loc = [[locations lastObject] coordinate];
    CLLocationCoordinate2D loc = [newLocation coordinate];
    latitude  = [NSString stringWithFormat:@"%3.6f",loc.latitude];
    longitude = [NSString stringWithFormat:@"%3.6f",loc.longitude];
    NSDictionary *dic = @{@"lat":latitude,@"long":longitude};
    
    for (NSDictionary *dictionary in pointArray) {
        if ([dic isEqualToDictionary:dictionary]) {
            [self.locationManager stopUpdatingLocation];
            return;
        }
    }
//    [pointArray  addObject:dic];
    [self.locationManager stopUpdatingLocation];  //停止定位

}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    
    latitude  = nil;
    longitude = nil;
    [self.locationManager stopUpdatingLocation];  //停止定位
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation {
    
    //方法一：using default pin as a PlaceMarker to display on map
    MKPinAnnotationView *newAnnotation = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
    //    newAnnotation.pinColor = MKPinAnnotationColorGreen;
    newAnnotation.animatesDrop = YES;
    //canShowCallout: to display the callout view by touch the pin
    newAnnotation.canShowCallout = YES;
    return newAnnotation;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    // Initialize each view
    for (MKPinAnnotationView *mkaview in views) {
//        NSLog(@"22");
//        for (NSDictionary *mapData in  __dataForMapView) {
//            if ([[mapData valueForKey:Key_Title]isEqualToString:mkaview.annotation.title]) {
//                if ([[mapData valueForKey:Key_Color]isEqualToString:@"green"]) {
                    mkaview.pinColor = MKPinAnnotationColorGreen;
//        mkaview.draggable = YES;
//        mkaview.selected = YES;
//                }
//                else if ([[mapData valueForKey:Key_Color]isEqualToString:@"purple"]) {
//                    mkaview.pinColor = MKPinAnnotationColorPurple;
//                }
//                else if([[mapData valueForKey:Key_Color]isEqualToString:@"red"]) {
//                    mkaview.pinColor = MKPinAnnotationColorRed;
//                }
//            }
//        }
    }
}

#pragma mark - event response

#pragma mark - private methods

- (void) displayAnnotationByCoordinate {
    
    if (self.mapView  != nil) {  //移除地图中已有的注释标注
        for (int index = 0; index < [[_mapView annotations] count]; index ++) {
            [self.mapView  removeAnnotations:[_mapView annotations]];
        }
    }
    

    [pointArray addObject:@{@"lat":@"31.41",@"long":@"121.4801"}];//121.48 31.41
    [pointArray addObject:@{@"lat":@"31.41",@"long":@"121.4819"}];//121.48 31.41
    
    NSUInteger pointCount = [pointArray count];
    
    if (pointCount == 1) {
//        （2）设定经纬度
        CLLocationCoordinate2D theCoordinate;
        theCoordinate.latitude=[[pointArray[0] valueForKey:@"lat" ] doubleValue];
        theCoordinate.longitude=[[pointArray[0] valueForKey:@"long" ] doubleValue];
        
//        （3）设定显示范围
        MKCoordinateSpan theSpan;
        theSpan.latitudeDelta = 0.001;
        theSpan.longitudeDelta = 0.001;
//        （4）设置地图显示的中心及范围
        MKCoordinateRegion theRegion;
        theRegion.center = CLLocationCoordinate2DMake([[pointArray[0] valueForKey:@"lat" ] doubleValue],[[pointArray[0] valueForKey:@"long" ] doubleValue]);
        theRegion.span = theSpan;
        
//        （5）设置地图显示的类型及根据范围进行显示
        [self.mapView setMapType:MKMapTypeStandard];
        [self.mapView setRegion:theRegion animated:YES];//设置显示位置动画
        // 设置地图显示的类型及根据范围进行显示
        [self.mapView regionThatFits:theRegion];
        
        MKCircle *_mCircle = [MKCircle circleWithCenterCoordinate:theRegion.center
                                                           radius:100.0];
        _mCircle.title = @"上海";
        _mCircle.subtitle = @"宝山";
        [self.mapView addAnnotation:_mCircle];

        return;
    }
    else {
        NSArray *array1 = @[@"beijing",@"shanghai",@"guangzhou",@"shenzhen"];
        NSArray *array2 = @[@"daxing",@"hongkou",@"dongguan",@"longkou"];
        CLLocationCoordinate2D pointAry[pointCount];
        
        for (int i = 0; i < pointCount; i++){

            pointAry[i] = CLLocationCoordinate2DMake([[pointArray[i] valueForKey:@"lat" ] doubleValue],[[pointArray[i] valueForKey:@"long" ] doubleValue]);
            MKCircle *_mCircle = [MKCircle circleWithCenterCoordinate:pointAry[i]
                                                           radius:10.0];
            _mCircle.title = array1[i];
            _mCircle.subtitle = array2[i];
            [self.mapView addAnnotation:_mCircle];
            
        }
        MKPolyline *mpline = [MKPolyline polylineWithCoordinates:pointAry count:pointCount];
        [self.mapView setVisibleMapRect:[mpline boundingMapRect]];
        [self.mapView  addOverlay:mpline];
    }
}


- (void)InitLocationManager {
    self.locationManager.delegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.locationManager requestAlwaysAuthorization];  //requestAlwaysAuthorization; requestWhenInUseAuthorization
    }
}

- (void)StartUpdateLocationWithTitle:(NSString *)title message:(NSString *)message {

//    判断手机的定位功能是否开启
//    开启定位：设置 》 隐私 》位置 》定位服务
    if ([CLLocationManager locationServicesEnabled] &&
        ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways
      || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)) {
            //启动位置更新
            //开启位置更新需要雨服务器进行轮训所以会比较耗电 在不需要时用stopUpdateLocation 方法关闭
            [self.locationManager startUpdatingLocation];  //开始定位
    }
    else if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        UIAlertController *alertController = [UIAlertController  alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action =  [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            
        }];
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

#pragma mark - getters and setters
- (MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView  alloc]initWithFrame:CGRectZero];
        _mapView.layer.borderColor = [UIColor grayColor].CGColor;
        _mapView.layer.borderWidth = 2.f;
        _mapView.layer.cornerRadius = 4;

    }
    return _mapView;
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc]init];
        //        kCLLocationAccuracyBestForNavigation;  //导航情况下最高精度
        //        kCLLocationAccuracyBest;               //设备使用电池供电时候最高的精度
        //        kCLLocationAccuracyNearestTenMeters;   //精度10m
        //        kCLLocationAccuracyHundredMeters;      //精度100m
        //        kCLLocationAccuracyKilometer;          //精度1000m
        //        kCLLocationAccuracyThreeKilometers;    //精度3000m
        _locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers; //定位精度
        _locationManager.distanceFilter = 1000.f;    //如果设置为kCLDistanceFilterNone 则每秒更新一次。 //距离过滤器
    }
    return _locationManager;
}


@end
