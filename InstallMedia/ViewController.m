//
//  ViewController.m
//  InstallMedia
//
//  Created by 박정수 on 13. 7. 10..
//  Copyright (c) 2013년 박정수. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () {
    NSFileManager* _fm;
    NSString* _findPath;
    NSDirectoryEnumerator* _enumrator;
    NSString* _saveFilePath;
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
    [self nextSaveMedia];
}


- (void)nextSaveMedia {
    while ( nil != (_saveFilePath = [_enumrator nextObject]) ) {
        NSString* fileExtension = [[_saveFilePath pathExtension] lowercaseString];
        if ([fileExtension isEqualToString:@"jpg"] ||
            [fileExtension isEqualToString:@"png"]) {
            UIImage* image = [UIImage imageWithContentsOfFile:[_findPath stringByAppendingPathComponent:_saveFilePath]];
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
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
