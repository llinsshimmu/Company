#import "UIImage+OpenCV.h"
#import "TryViewController.h"
#import "JsonParseOperation.h"
#import <fstream.h>


using namespace std;

// Name of face cascade resource file without xml extension
NSString * const kFaceCascadeFilename = @"haarcascade_frontalface_alt2";
NSString * const KShoesCascadeFilename = @"testShoes";

// Options for cv::CascadeClassifier::detectMultiScale
const int kHaarOptions =  CV_HAAR_FIND_BIGGEST_OBJECT | CV_HAAR_DO_ROUGH_SEARCH;

@interface TryViewController ()
- (void)displayFaces:(const std::vector<cv::Rect> &)faces 
       forVideoRect:(CGRect)rect 
    videoOrientation:(AVCaptureVideoOrientation)videoOrientation;
@end

@implementation TryViewController

@synthesize _mTableView;
@synthesize _listItemArray;

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
    [self getARTrainShose:1];
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
    NSArray *sublayers = [NSArray arrayWithArray:[_shoesCurScrollView.layer sublayers]];
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
    NSArray *views = [_shoesCurScrollView subviews];
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
                [self setWearShoesFrame:faceRect];
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
            [_shoesCurScrollView.layer addSublayer:featureLayer];
#else
			[self.view.layer addSublayer:featureLayer];
#endif
		}
        
        featureLayer.frame = faceRect;
    }
    
    [CATransaction commit];
}

- (void)initDataAndView
{
    operationQueue = [[NSOperationQueue alloc]init];
    _curShoesPage = 1;
    _TotalShosePage = 1;
    _upDownPageType = 0;
    
    if (nil == _shoesCurScrollView) {
        _shoesCurScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 400.0f)];
        [_shoesCurScrollView setBackgroundColor:[UIColor clearColor]];
        _shoesCurScrollView.scrollEnabled = NO;
        [self.view addSubview:_shoesCurScrollView];
    }
    
    //up arrow
    UIButton *upArrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(255.0, 20.0f, 30.0f, 30.0f)];
    [upArrowBtn addTarget:self action:@selector(upArrowBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    [upArrowBtn setBackgroundColor:[UIColor redColor]];
    [upArrowBtn setImage:[UIImage imageNamed:@"up_arrow.png"] forState:UIControlStateNormal];
    [_shoesCurScrollView addSubview:upArrowBtn];
    
    //tableView
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(240.0f, 50.0f,60.0f, 270.0f) style:UITableViewStylePlain];
    _mTableView.showsVerticalScrollIndicator = NO;
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    [_mTableView setBackgroundColor:[UIColor greenColor]];
    [_shoesCurScrollView addSubview:_mTableView];
    
    //dow arrow
    UIButton *downArrowBtn = [[UIButton alloc]initWithFrame:CGRectMake(255.0f, 320.0f, 30.0f, 30.0f)];
    [downArrowBtn addTarget:self action:@selector(downArrowBtnDo:) forControlEvents:UIControlEventTouchUpInside];
    [downArrowBtn setBackgroundColor:[UIColor greenColor]];
    [downArrowBtn setImage:[UIImage imageNamed:@"down_arrow.png"] forState:UIControlStateNormal];
    [_shoesCurScrollView addSubview:downArrowBtn];
    
    if (nil == _imageWearCentorShoes) {
        _imageWearCentorShoes = [[UIImageView alloc]initWithFrame:CGRectMake((320.0f - 80.0f)/2, (400.0f - 160.0f)/2, 80, 160)];
        [_shoesCurScrollView addSubview:_imageWearCentorShoes];
    }
    
    if (nil == _imageWearShoes) {
        _imageWearShoes = [[UIImageView alloc]init];
        [_shoesCurScrollView addSubview:_imageWearShoes];
    }
    
    if (nil == _listItemArray) {
        _listItemArray = [[NSMutableArray alloc]init];
    }
}


#pragma mark - Method
- (void)getARTrainShose:(NSInteger)pageIndex
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *sessionID = [ud stringForKey:@"sessionid"];
    NSString *userID = [ud stringForKey:@"userid"];
    NSString *urlStr =@"http://api.tengchen.com:90/Product/remoteProductArPicLists.do";

    NSArray *arShosePostArray = [NSArray arrayWithObjects:
                               [NSDictionary dictionaryWithObjectsAndKeys:@"sessionid", @"key", sessionID, @"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"userid", @"key", userID, @"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"pageSize", @"key", [NSString stringWithFormat:@"%d", PAGE_SHOES_COUNT], @"value", nil],
                               [NSDictionary dictionaryWithObjectsAndKeys:@"pageIndex", @"key", [NSString stringWithFormat:@"%d", pageIndex], @"value", nil], nil];
    
    JsonParseOperation *jsonParseOperation = [[JsonParseOperation alloc] initWithObject:self callBackMethod:@selector(getARShoseResult:) withURL:urlStr withPostKeyValue:arShosePostArray];
    
    [operationQueue addOperation:jsonParseOperation];

}

- (void)getARShoseResult:(NSDictionary *)returnDic
{
    NSLog(@"%@",[returnDic objectForKey:@"msg"]);
    
    NSInteger productTotal = [[returnDic objectForKey:@"producttotal"] intValue];
    NSInteger remainderCount = productTotal % PAGE_SHOES_COUNT;
    _TotalShosePage = productTotal / PAGE_SHOES_COUNT;
    if (remainderCount > 0) {
        _TotalShosePage ++;
    }
    
    if ([[returnDic objectForKey:@"status"] integerValue] == 1) {
        if (_upDownPageType == 0) {
            _curShoesPage = 1;
        }else if (_upDownPageType == 1) {
            _curShoesPage --;
        }else if (_upDownPageType == 2){
            _curShoesPage ++;
        }
        [_listItemArray removeAllObjects];
        [_listItemArray addObjectsFromArray:[returnDic objectForKey:@"productlists"]];
        [_mTableView reloadData];
        [self setWearShoesImage:0];
    }
    
    NSLog(@"productTotal[%d];productCur[%d];_TotalShosePage[%d];_curShoesPage[%d]", productTotal, [_listItemArray count], _TotalShosePage, _curShoesPage);
}

- (void)setWearShoesFrame:(CGRect) frameShoes
{
    _imageWearShoes.hidden = NO;
    [_imageWearShoes setFrame:frameShoes];
}

- (void)setWearShoesImage:(NSInteger) indexShoes
{
    NSDictionary *itemDic = [_listItemArray objectAtIndex:indexShoes];
    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"productar"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    
    [_imageWearShoes setImage:image];
    [_imageWearCentorShoes setImage:image];
}

- (void)upArrowBtnDo:(id)sender
{
    _upDownPageType = 1;
    if (_curShoesPage <= 1) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前页,为第一页!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        return;
    }
    
    [self getARTrainShose:_curShoesPage - 1];
}

- (void)downArrowBtnDo:(id)sender
{
    _upDownPageType = 2;
    if (_curShoesPage >= _TotalShosePage) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"当前页,为最后页!" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        alert = nil;
        return;
    }
    
    [self getARTrainShose:_curShoesPage + 1];
}

#pragma - mark UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_listItemArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"tryViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    //image
    NSDictionary *itemDic = [_listItemArray objectAtIndex:indexPath.row];
    NSURL *imageUrl = [NSURL URLWithString:[itemDic objectForKey:@"productsmall"]];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    cell.imageView.image = image;

    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 80, 55)];
    [imageView setImage:image];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

#pragma - mark UITableViewDeletage
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self setWearShoesImage:indexPath.row];
}

@end
