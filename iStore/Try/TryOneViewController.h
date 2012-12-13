#import <UIKit/UIKit.h>
#import "VideoCaptureViewController.h"

#define USE_HOG_TRAIN

@interface TryOneViewController : VideoCaptureViewController <UIPageViewControllerDelegate, UIScrollViewDelegate>
{
    NSOperationQueue *operationQueue;
    
#ifdef USE_HOG_TRAIN
    cv::HOGDescriptor _hogDescriptor;
#else
    cv::CascadeClassifier _faceCascade;
#endif
    
    //shoes layer
    UIScrollView        *_shoesScrollView;
    UIPageControl       *_shoesPageControl;
    NSInteger           _index;
    NSInteger           _countShoes;
    
    UIScrollView        *_shoescurrentScrollView;//可以不要
    UIImageView         *_imageWearShoes;
    UIImageView         *_imageWearCentorShoes;
    
    UIImageView         *_imageCurrentView;
    UIImageView         *_imageFrontView;
    UIImageView         *_imageBackView;
    float               _imageScrollScale;
}

@property (nonatomic, strong) UIScrollView *_shoesScrollView;

- (void)initDataAndView;
- (void)freeDataAndView;

- (void)setSamllImageShoesScrollView;
- (void)setWearShoesScrollView:(CGRect) frameShoes;

- (IBAction)toggleFps:(id)sender;
- (IBAction)toggleTorch:(id)sender;
- (IBAction)toggleCamera:(id)sender;

- (void)getARTrainShose;
- (void)getARTrainShoseCallBack;

@end
