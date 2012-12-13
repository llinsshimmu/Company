#import "UIImage+OpenCV.h"
#import "TryOneViewController.h"
#import "JsonParseOperation.h"
#import <fstream.h>


using namespace std;

// Name of face cascade resource file without xml extension
NSString * const kFaceCascadeFilename = @"haarcascade_frontalface_alt2";
NSString * const KShoesCascadeFilename = @"testShoes";

// Options for cv::CascadeClassifier::detectMultiScale
const int kHaarOptions =  CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;

@interface TryOneViewController ()
- (void)displayFaces:(const std::vector<cv::Rect> &)faces 
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
@end

@implementation TryOneViewController

@synthesize _shoesScrollView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITabBarItem *tab = [[UITabBarItem alloc]
                             initWithTitle:@""
                             image:[UIImage imageNamed:@"try_tab.png"]
                             tag:2];
        self.tabBarItem = tab;
        self.navigationItem.title = @"试一下";

        self.captureGrayscale = YES;
        self.qualityPreset = AVCaptureSessionPresetMedium;
    }
    return self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
#ifdef USE_HOG_TRAIN
    [self initDataAndView];
#endif
    
    [super viewDidLoad];
    
#ifdef USE_HOG_TRAIN
//    cv::HOGDescriptor hog(cv::Size(64,128), cv::Size(16,16), cv::Size(8,8), cv::Size(8,8), 9);

    vector<float> detector;
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:@"hogSVMDetector-peopleFlow" ofType:@"txt"];
	ifstream detector_data([faceCascadePath UTF8String], ios::in);
	int count = 0;
	string buf;
	float tmpFlaot;
	while(!detector_data.eof())
	{
		detector_data >> tmpFlaot;
		detector.push_back(tmpFlaot);
		count ++;
	}
	_hogDescriptor.setSVMDetector(detector);
#else
    // Load the face Haar cascade from resources
    NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:kFaceCascadeFilename ofType:@"xml"];
    if (!_faceCascade.load([faceCascadePath UTF8String])) {
        NSLog(@"Could not load face cascade: %@", faceCascadePath);
    }
#endif
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// MARK: IBActions

// Toggles display of FPS
- (IBAction)toggleFps:(id)sender
{
    self.showDebugInfo = !self.showDebugInfo;
}

// Turn torch on and off
- (IBAction)toggleTorch:(id)sender
{
    self.torchOn = !self.torchOn;
}
  
// Switch between front and back camera
- (IBAction)toggleCamera:(id)sender
    {
    if (self.camera == 1) {
        self.camera = 0;
    }
    else
    {
        self.camera = 1;
    }
}

// MARK: VideoCaptureViewController overrides

- (void)processFrame:(cv::Mat &)mat videoRect:(CGRect)rect videoOrientation:(AVCaptureVideoOrientation)videOrientation
{
    // Shrink video frame to 320X240
    cv::resize(mat, mat, cv::Size(), 0.5f, 0.5f, CV_INTER_LINEAR);
    rect.size.width /= 2.0f;
    rect.size.height /= 2.0f;
    
    // Rotate video frame by 90deg to portrait by combining a transpose and a flip
    // Note that AVCaptureVideoDataOutput connection does NOT support hardware-accelerated
    // rotation and mirroring via videoOrientation and setVideoMirrored properties so we
    // need to do the rotation in software here.
    cv::transpose(mat, mat);
    CGFloat temp = rect.size.width;
    rect.size.width = rect.size.height;
    rect.size.height = temp;
    
    if (videOrientation == AVCaptureVideoOrientationLandscapeRight)
    {
        // flip around y axis for back camera
        cv::flip(mat, mat, 1);
    }
    else {
        // Front camera output needs to be mirrored to match preview layer so no flip is required here
    }
       
    videOrientation = AVCaptureVideoOrientationPortrait;
    
    // Detect faces
    std::vector<cv::Rect> faces;
#ifdef USE_HOG_TRAIN
    _hogDescriptor.detectMultiScale(mat, faces, 0, cv::Size(8,8), cv::Size(0,0), 1.05, 2);  
#else
    _faceCascade.detectMultiScale(mat, faces, 1.1, 2, kHaarOptions, cv::Size(60, 60));
#endif
    
    // Dispatch updating of face markers to main queue
    dispatch_sync(dispatch_get_main_queue(), ^{
        [self displayFaces:faces
             forVideoRect:rect
          videoOrientation:videOrientation];    
    });
}

// Update face markers given vector of face rectangles
- (void)displayFaces:(const std::vector<cv::Rect> &)faces 
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation
{
#ifdef USE_HOG_TRAIN
    NSArray *sublayers = [NSArray arrayWithArray:[_shoesScrollView.layer sublayers]];
#else
    NSArray *sublayers = [NSArray arrayWithArray:[self.view.layer sublayers]];
#endif
    int sublayersCount = [sublayers count];
    int currentSublayer = 0;
    
	[CATransaction begin];
	[CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
	
	// hide all the face layers
	for (CALayer *layer in sublayers) {
        NSString *layerName = [layer name];
		if ([layerName isEqualToString:@"FaceLayer"])
			[layer setHidden:YES];
	}
	
#ifdef USE_HOG_TRAIN
    NSArray *views = [_shoescurrentScrollView subviews];
    for (UIView *view in views) {
        if (view == _imageWearShoes) {
            _imageWearShoes.hidden = YES;
        }
    }
#endif
    
    // Create transform to convert from vide frame coordinate space to view coordinate space
    CGAffineTransform t = [self affineTransformForVideoFrame:rect orientation:videoOrientation];
    
    if (faces.size() <= 0) {
        _imageWearCentorShoes.hidden = NO;
    }else {
        _imageWearCentorShoes.hidden = YES;
    }

    for (int i = 0; i < faces.size(); i++) {
  
        CGRect faceRect;
        faceRect.origin.x = faces[i].x;
        faceRect.origin.y = faces[i].y;
        faceRect.size.width = faces[i].width;
        faceRect.size.height = faces[i].height;
        
        NSLog(@"x[%f] y[%f] w[%f] h[%f]", faceRect.origin.x, faceRect.origin.y,  faceRect.size.width,  faceRect.size.height);
    
        faceRect = CGRectApplyAffineTransform(faceRect, t);
        
        CALayer *featureLayer = nil;
        
        while (!featureLayer && (currentSublayer < sublayersCount)) {
			CALayer *currentLayer = [sublayers objectAtIndex:currentSublayer++];
			if ([[currentLayer name] isEqualToString:@"FaceLayer"]) {
#ifdef USE_HOG_TRAIN
                [self setWearShoesScrollView:faceRect];
#endif 
				featureLayer = currentLayer;
                [currentLayer setHidden:NO];
			}
		}
        
        if (!featureLayer) {
            // Create a new feature marker layer
			featureLayer = [[CALayer alloc] init];
            featureLayer.name = @"FaceLayer";
            featureLayer.borderColor = [[UIColor redColor] CGColor];
            featureLayer.borderWidth = 3;
#ifdef USE_HOG_TRAIN
            [_shoesScrollView.layer addSublayer:featureLayer];
#else
			[self.view.layer addSublayer:featureLayer];
#endif
			[featureLayer release];
		}
        
        featureLayer.frame = faceRect;
    }
    
    [CATransaction commit];
}

- (void)initDataAndView
{
    operationQueue = [[NSOperationQueue alloc]init];
    _countShoes = 5;//todo
    _index = 0;
    if (nil == _shoesScrollView) {
        self._shoesScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:_shoesScrollView];
        [_shoesScrollView setContentSize:CGSizeMake(self.view.frame.size.width * _countShoes, self.view.frame.size.height)];
        [_shoesScrollView setBackgroundColor:[UIColor clearColor]];
        _shoesScrollView.pagingEnabled = YES;
        _shoesScrollView.showsHorizontalScrollIndicator = YES;
        _shoesScrollView.showsVerticalScrollIndicator = YES;
        _shoesScrollView.bounces = NO;
        _shoesScrollView.alwaysBounceHorizontal = YES;
        _shoesScrollView.delegate = self;
    }
    if (nil == _shoesPageControl) {
        _shoesPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 20)];
        [self.view addSubview:_shoesPageControl];
        [_shoesPageControl setBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
        _shoesPageControl.numberOfPages = _countShoes;
        [_shoesPageControl setCurrentPage:0];
    }

    if (nil == _shoescurrentScrollView) {
        _shoescurrentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,_shoesScrollView.frame.size.width, _shoesScrollView.frame.size.height)];
        _shoescurrentScrollView.scrollEnabled = NO;
        [_shoesScrollView addSubview:_shoescurrentScrollView];
    }
    
    if (nil == _imageWearCentorShoes) {
        _imageWearCentorShoes = [[UIImageView alloc]initWithFrame:CGRectMake((320.0f - 80.0f)/2, (460.0f - 160.0f)/2, 80, 160)];
        [_shoescurrentScrollView addSubview:_imageWearCentorShoes];
    }
    
//    if (nil == _shoesFrontScrollView) {
//        _shoesFrontScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,_shoesScrollView.frame.size.width, _shoesScrollView.frame.size.height)];
//        [_shoesScrollView addSubview:_shoesFrontScrollView];
//    }
//    
//    if (nil == _shoesBackScrollView) {
//        _shoesBackScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f,_shoesScrollView.frame.size.width, _shoesScrollView.frame.size.height)];
//        [_shoesScrollView addSubview:_shoesBackScrollView];
//    }
    
//    if (nil == _imageCurrentView) {
//        _imageCurrentView = [[UIImageView alloc]initWithFrame:CGRectMake(20.0f, 30.0f, 30.0f, 30.0f)];
//        [_shoescurrentScrollView addSubview:_imageCurrentView];
//    }
    
    if (nil == _imageWearShoes) {
        _imageWearShoes = [[UIImageView alloc]init];
        [_shoescurrentScrollView addSubview:_imageWearShoes];
    }
    
//    if (nil == _imageFrontView) {
//        _imageFrontView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _shoesScrollView.frame.size.width/4, _shoesScrollView.frame.size.height/4)];
//        [_shoesFrontScrollView addSubview:_imageFrontView];
//
//    }
    
//    if (nil == _imageBackView) {
//        _imageBackView = [[UIImageView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, _shoesScrollView.frame.size.width/4, _shoesScrollView.frame.size.height/4)];
//        [_shoesBackScrollView addSubview:_imageBackView];
//
//    }

//    _imageScrollScale;
    
    NSInteger pageIndex = _shoesPageControl.currentPage;
    [_imageWearShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
    [_imageWearCentorShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];

}

- (void)freeDataAndView
{
//    _shoesScrollView = ;
//    _shoesPageControl;
//    _imageCropperView;
//    _index;
//    _countShoes;
//    
//    _shoescurrentScrollView;
//    _shoesFrontScrollView;
//    _shoesBackScrollView;
//    _imageCurrentView;
//    _imageFrontView;
//    _imageBackView;
//    _imageScrollScale; 
}

#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == _shoesScrollView){
        CGPoint offset = scrollView.contentOffset;
        _shoesPageControl.currentPage = offset.x / (self.view.bounds.size.width); //计算当前的页码
        [_shoesScrollView setContentOffset:CGPointMake(self.view.bounds.size.width * (_shoesPageControl.currentPage), _shoesScrollView.contentOffset.y) animated:YES]; //设置scrollview的显示为当前滑动到的页面
        
        NSInteger pageIndex = _shoesPageControl.currentPage;
        [_imageWearShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
        [_imageWearCentorShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
        
//        [_pageLabel setText:[NSString stringWithFormat:@"(%d/%d)", _shoesPageControl.currentPage + 1, _countShoes]];
        
        [self setSamllImageShoesScrollView];
    }
}

#pragma mark - Method
- (void)setSamllImageShoesScrollView
{
    NSInteger pageIndex = _shoesPageControl.currentPage;
    
    [_shoescurrentScrollView setFrame:CGRectMake(320.0f * pageIndex, 30.0f, 320.0f, 380.0f)];
//    [_imageCurrentView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
}

- (void)setWearShoesScrollView:(CGRect) frameShoes
{
//    NSInteger pageIndex = _shoesPageControl.currentPage;
    _imageWearShoes.hidden = NO;
    [_imageWearShoes setFrame:frameShoes];
//    [_imageWearShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
//    [_imageWearCentorShoes setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%d%d%d.png",pageIndex+1, pageIndex+1, pageIndex+1]]];
}

- (void)getARTrainShose
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [ud stringForKey:@"sessionid"];

    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductARFavoriteLists.do";
//    NSArray *loginPostArray = [NSArray arrayWithObjects:
//                               [NSDictionary dictionaryWithObjectsAndKeys:@"username",@"key",usernameField.text,@"value", nil],
//                               [NSDictionary dictionaryWithObjectsAndKeys:@"password",@"key",pwdField.text,@"value", nil], nil];
//    
//    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(getARTrainShoseCallBack:) withURL:urlStr withPostKeyValue:loginPostArray];
    
//    [operationQueue addOperation:jsonParseOperation];

}

- (void)getARTrainShoseCallBack
{
    
}
@end
