//
//  YSPhotoCell.m
//  instaPhoto
//
//  Created by yunseo shin on 2016. 5. 22..
//  Copyright © 2016년 yunseo. All rights reserved.
//

#import "YSPhotoCell.h"
#import "YSPhotoController.h"
#import <SAMCache/SAMCache.h>

@implementation YSPhotoCell

-(void)setPhoto:(NSDictionary *)photo{
    
    _photo = photo;
    [YSPhotoController imageForPhoto:_photo size:@"thumbnail" completion:^(UIImage *image) {
        self.imageView.image = image;
    }];
    NSURL *url = [[NSURL alloc]initWithString:_photo[@"images"][@"thumbnail"][@"url"]]; //[@"standard_resolution"]
    
//    [self downloadPhotoWithURL:url];
    
//    NSLog(@"setPhoto url = %@",url); //all thumbnail images
    
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(like)];
        tap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tap];
        
        [self.contentView addSubview:self.imageView];
        
        
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = self.contentView.bounds; //add all thumnails
    
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




@end
