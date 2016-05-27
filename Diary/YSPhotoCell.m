//
//  YSPhotoCell.m
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSPhotoCell.h"
#import "YSPhotoController.h"

@implementation YSPhotoCell

-(void)setPhoto:(NSDictionary *)photo{
    
    _photo = photo;
    [YSPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    //NSURL *url = [[NSURL alloc]initWithString:_photo[@"images"][@"thumbnail"][@"url"]]; //[@"standard_resolution"]
    
    //[self downloadPhotoWithURL:url];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        //        self.imageView.image = [UIImage imageNamed:@"no image"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.imageView];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds;
}

////instagram download + cache
//-(void)downloadPhotoWithURL:(NSURL *)url{
//
//    NSString *key = [[NSString alloc]initWithFormat:@"%@-thumbnail",self.photo[@"id"]];
//    UIImage *photo = [[SAMCache sharedCache] imageForKey:key];
//
//    if (photo){
//        self.imageView.image = photo;
//        return;
//
//    }
//
//    NSURLSession *session = [NSURLSession sharedSession];
//    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
//    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//
//        NSData *data = [[NSData alloc] initWithContentsOfURL:location];
//        UIImage *image = [[UIImage alloc] initWithData:data];
//        [[SAMCache sharedCache] setImage:image forKey:key];
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.imageView.image = image;
//        });
//    }];
//    [task resume];
//}

-(void)like{
    
    NSLog(@"Link : %@", self.photo[@"link"]);
    NSURLSession *session = [NSURLSession sharedSession];
    NSString *accessToken = [[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://api.instagram.com/v1/media/%@/likes?access_token=%@", self.photo[@"id"], accessToken];
    
    NSURL *url = [[NSURL alloc] initWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.HTTPMethod =@"POST";
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        
        //        NSLog(@"response : %@", response);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self showLikeCompletion];
        });
    }];
    [task resume];
    
}


-(void) showLikeCompletion{
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Liked!" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    [alert show];
    
    double delayInseconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInseconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [alert dismissWithClickedButtonIndex:0 animated:YES];
        
    });
}




@end
