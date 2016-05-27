//
//  YSPhotosViewController.m
//  
//
//  Created by yunseo shin on 2016. 5. 23..
//
//

#import "YSPhotosViewController.h"
#import "YSPhotoCell.h"
#import "YSDetailViewController.h"
#import <SimpleAuth/SimpleAuth.h>

@interface YSPhotosViewController ()  <UIViewControllerTransitioningDelegate>

@property (nonatomic) NSString *accessToken;
@property (nonatomic) NSArray *photos;

@end

@implementation YSPhotosViewController

static NSString * const reuseIdentifier = @"Cell";

- (instancetype)init {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(106.0, 106.0);
    layout.minimumInteritemSpacing = 1.0;
    layout.minimumLineSpacing = 1.0;
    
    return (self = [super initWithCollectionViewLayout:layout]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Instgram Photo";
    
    [self.collectionView registerClass:[YSPhotoCell class] forCellWithReuseIdentifier:@"photo"];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    self.accessToken = [userDefaults objectForKey:@"accessToken"];
    NSLog(@"accessToken: %@", _accessToken);
    if (self.accessToken == nil) {
        [SimpleAuth authorize:@"instagram" options:@{@"scope": @[@"likes"]} completion:^(NSDictionary *responseObject, NSError *error) {
            
            self.accessToken = responseObject[@"credentials"][@"token"];
            
            [userDefaults setObject:self.accessToken forKey:@"accessToken"];
            [userDefaults synchronize];
            
            [self refresh];
        }];
    } else {
        [self refresh];
    }
}

- (void) refresh {
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@", self.accessToken];

    
    NSLog(@"urlString: %@", urlString);
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        
        
        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //json photos url : data.images.standard_resolution.url
        self.photos = [responseDictionary valueForKeyPath:@"data"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
        
        //        //whole json
        //        NSLog(@"responseDictionary: %@", responseDictionary);
        //
        //
        //        NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
        //        NSLog(@"text: %@", text);
        //        //NSLog(@"response: %@", response);
    }];
    [task resume];
    
}

//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    self.accessToken = [userDefaults objectForKey:@"accessToken"];
//
//    if (self.accessToken == nil) {
//        [SimpleAuth authorize:@"instagram" completion:^(NSDictionary *responseObject, NSError *error) {
//
//            NSString *accessToken = responseObject[@"credentials"][@"token"];
//
//            [userDefaults setObject:accessToken forKey:@"accessToken"];
//            [userDefaults synchronize];
//        }];
//    } else {
//        NSURLSession *session = [NSURLSession sharedSession];
//        NSString *urlString = [[NSString alloc] initWithFormat:@"https://api.instagram.com/v1/tags/photobomb/media/recent?access_token=%@", self.accessToken];
//
//         NSLog(@"urlString: %@", urlString);
//
//        NSURL *url = [[NSURL alloc] initWithString:urlString];
//        NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//        NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//            NSString *text = [[NSString alloc] initWithContentsOfURL:location encoding:NSUTF8StringEncoding error:nil];
//            NSLog(@"text: %@", text);
//        }];
//        [task resume];
//    }
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YSPhotoCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    //    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photo" forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor lightGrayColor];
    cell.photo = self.photos[indexPath.row];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *photo = self.photos[indexPath.row];
    YSDetailViewController *viewController = [[YSDetailViewController alloc] init];
    
    
    viewController.modalPresentationStyle = UIModalPresentationCustom; //to use a custom transition for a given view controller
    viewController.transitioningDelegate = self;
    viewController.photo = photo;
    
    [self presentViewController:viewController animated:YES completion:nil];
}

//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    return [[YSPresentDetailTransition alloc] init];
//}


//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    return [[YSPresentDetailTransition alloc] init];
//}



@end














