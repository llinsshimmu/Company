#import <UIKit/UIKit.h>
#import "VideoCaptureViewController.h"

#define USE_HOG_TRAIN
#define PAGE_SHOES_COUNT    10

@interface TryViewController : VideoCaptureViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSOperationQueue *operationQueue;
    
#ifdef USE_HOG_TRAIN
    cv::HOGDescriptor _hogDescriptor;
#else
    cv::CascadeClassifier _faceCascade;
#endif
    UITableView         *_mTableView;
    NSMutableArray      *_listItemArray;
    NSInteger           _curShoesPage;          //当前鞋子第几页
    NSInteger           _TotalShosePage;        //鞋子总页数
    NSInteger           _upDownPageType;        //0非上下页,1上一页,2下一页
    
    UIScrollView        *_shoesCurScrollView;
    UIImageView         *_imageWearShoes;
    UIImageView         *_imageWearCentorShoes;

    UIImageView         *_imageCurrentView;
    UIImageView         *_imageFrontView;
    UIImageView         *_imageBackView;
    float               _imageScrollScale;
}

@property (nonatomic, strong) UITableView *_mTableView;
@property (nonatomic, strong) NSMutableArray *_listItemArray;

- (void)initDataAndView;

- (void)setWearShoesFrame:(CGRect) frameShoes;
- (void)setWearShoesImage:(NSInteger) indexShoes;

- (IBAction)toggleFps:(id)sender;
- (IBAction)toggleTorch:(id)sender;
- (IBAction)toggleCamera:(id)sender;

- (void)getARTrainShose:(NSInteger)pageIndex;

@end
