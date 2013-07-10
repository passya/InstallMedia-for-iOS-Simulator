//
//  ViewController.m
//  InstallMedia
//
//  Created by 박정수 on 13. 7. 10..
//  Copyright (c) 2013년 박정수. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface ViewController () {
    NSFileManager* _fm;
    NSString* _findPath;
    NSDirectoryEnumerator* _enumrator;
    NSString* _saveFilePath;
    ALAssetsLibrary *_assetLibrary;
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _fm = [[NSFileManager alloc] init];
    _findPath = @"/Users/jspark/Pictures";
    _enumrator = [_fm enumeratorAtPath:_findPath];
    _assetLibrary = [[ALAssetsLibrary alloc] init];
    [self nextSaveMedia];
}


- (void)nextSaveMedia {
    while ( nil != (_saveFilePath = [_enumrator nextObject]) ) {
        NSString* fileExtension = [[_saveFilePath pathExtension] lowercaseString];
        if ([fileExtension isEqualToString:@"jpg"] ||
            [fileExtension isEqualToString:@"png"]) {
            
            
            NSURL* fileUrl = [NSURL fileURLWithPath:[_findPath stringByAppendingPathComponent:_saveFilePath]];
            CGImageSourceRef imageSourceRef = CGImageSourceCreateWithURL((__bridge CFURLRef)fileUrl, nil);
            CFDictionaryRef dicMetaDataRef = CGImageSourceCopyPropertiesAtIndex(imageSourceRef, 0, nil);
            NSDictionary* metaData = CFBridgingRelease(dicMetaDataRef);
            
            UIImage* image = [UIImage imageWithContentsOfFile:fileUrl.path];
            [_assetLibrary writeImageToSavedPhotosAlbum:image.CGImage
                                         metadata:metaData
                                  completionBlock:^(NSURL *assetURL, NSError *error) {
                                      [self didFinishSavingWithError:error];
                                  }];
            
            CFRelease(imageSourceRef);
            return;
        }
        else if ([fileExtension isEqualToString:@"mov"]) {
            UISaveVideoAtPathToSavedPhotosAlbum([_findPath stringByAppendingPathComponent:_saveFilePath], self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
            return;
        }
    }
    NSLog(@"Finished");
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self didFinishSavingWithError:error];
}



- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self didFinishSavingWithError:error];
}


- (void)didFinishSavingWithError:(NSError*)error {
    if (error != nil) {
        NSLog(@"Failed: %@, %@", _saveFilePath, error);
    }
    else {
        NSLog(@"Saved: %@", _saveFilePath);
    }
    [self nextSaveMedia];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
