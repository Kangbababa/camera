// Copyright 2015 Google Inc. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import <AssertMacros.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreImage/CoreImage.h>
#import <ImageIO/ImageIO.h>
#import "CameraExampleViewController.h"
#import <ifaddrs.h>
#import <net/if.h>
#import <SystemConfiguration/CaptiveNetwork.h>



#include <sys/time.h>
#include <sys/param.h>
#include <sys/mount.h> 
#include "tensorflow_utils.h"
#include "UIImage+Rotate.h"
#include "PRSettingsViewController.h"

#define boundary @"asdfasdfas"
#define Access_Token @"2.00LvxxAE33dQxBcfde5ce726QdVfB"
#define kMusicFile @"xiaojie"
#define kMusiceExt @"mp3"
// If you have your own model, modify this to the file name, and make sure
// you've added the file to your app resources too.
static NSString* model_file_name = @"opt_frozen_har_no";
static NSString* model_file_type = @"pb";
// This controls whether we'll be loading a plain GraphDef proto, or a
// file created by the convert_graphdef_memmapped_format utility that wraps a
// GraphDef and parameter file that can be mapped into memory from file to
// reduce overall memory usage.
const bool model_uses_memory_mapping = false;
// If you have your own model, point this to the labels file.
static NSString* labels_file_name = @"imagenet_comp_graph_label_strings";
static NSString* labels_file_type = @"txt";
// These dimensions need to match those the model was trained with.
const int wanted_input_width = 227;
const int wanted_input_height = 227;
const int wanted_input_channels = 3;
const float input_mean = 117.0f;
const float input_std = 1.0f;
const std::string input_layer_name = "in/X";
const std::string output_layer_name = "out/Softmax";
//const NSString Hx_Main_heard_API=@"haha";
//const NSString IMAGE_UPLOAD_URL_API=@"dade";
static int badCount=0;
static bool audioAlert=false;
static void *AVCaptureStillImageIsCapturingStillImageContext =
&AVCaptureStillImageIsCapturingStillImageContext;
AVAudioPlayer *audioPlayer;
NSTimer *timer;
@interface CameraExampleViewController (InternalMethods)
- (void)setupAVCapture;
- (void)teardownAVCapture;
@end



@implementation CameraExampleViewController

- (void)setupAVCapture {
    NSError *error = nil;
    
    session = [AVCaptureSession new];
    if ([[UIDevice currentDevice] userInterfaceIdiom] ==
        UIUserInterfaceIdiomPhone)
        [session setSessionPreset:AVCaptureSessionPreset640x480];
    else
        [session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    AVCaptureDevice *device =
    [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *deviceInput =
    [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    assert(error == nil);
    
    isUsingFrontFacingCamera = NO;
    if ([session canAddInput:deviceInput]) [session addInput:deviceInput];
    
    stillImageOutput = [AVCaptureStillImageOutput new];
    [stillImageOutput
     addObserver:self
     forKeyPath:@"capturingStillImage"
     options:NSKeyValueObservingOptionNew
     context:(void *)(AVCaptureStillImageIsCapturingStillImageContext)];
    if ([session canAddOutput:stillImageOutput])
        [session addOutput:stillImageOutput];
    
    videoDataOutput = [AVCaptureVideoDataOutput new];
    
    NSDictionary *rgbOutputSettings = [NSDictionary
                                       dictionaryWithObject:[NSNumber numberWithInt:kCMPixelFormat_32BGRA]
                                       forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    videoDataOutputQueue =
    dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ([session canAddOutput:videoDataOutput])
        [session addOutput:videoDataOutput];
    [[videoDataOutput connectionWithMediaType:AVMediaTypeVideo] setEnabled:YES];
   
    
    
    previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    CALayer *rootLayer = [previewView layer];
    [rootLayer setMasksToBounds:YES];
    [previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:previewLayer];
    [session startRunning];
    
    if (error) {
        NSString *title = [NSString stringWithFormat:@"Failed with error %d", (int)[error code]];
        UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:title
                                            message:[error localizedDescription]
                                     preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *dismiss =
        [UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:dismiss];
        [self presentViewController:alertController animated:YES completion:nil];
        [self teardownAVCapture];
    }
}

- (void)teardownAVCapture {
    [stillImageOutput removeObserver:self forKeyPath:@"isCapturingStillImage"];
    [previewLayer removeFromSuperlayer];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if (context == AVCaptureStillImageIsCapturingStillImageContext) {
        BOOL isCapturingStillImage =
        [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if (isCapturingStillImage) {
            // do flash bulb like animation
            flashView = [[UIView alloc] initWithFrame:[previewView frame]];
            [flashView setBackgroundColor:[UIColor whiteColor]];
            [flashView setAlpha:0.f];
            [[[self view] window] addSubview:flashView];
            
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:1.f];
                             }];
        } else {
            [UIView animateWithDuration:.4f
                             animations:^{
                                 [flashView setAlpha:0.f];
                             }
                             completion:^(BOOL finished) {
                                 [flashView removeFromSuperview];
                                 flashView = nil;
                             }];
        }
    }
}

- (AVCaptureVideoOrientation)avOrientationForDeviceOrientation:
(UIDeviceOrientation)deviceOrientation {
    AVCaptureVideoOrientation result =
    (AVCaptureVideoOrientation)(deviceOrientation);
    if (deviceOrientation == UIDeviceOrientationLandscapeLeft)
        result = AVCaptureVideoOrientationLandscapeRight;
    else if (deviceOrientation == UIDeviceOrientationLandscapeRight)
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (IBAction)takePicture:(id)sender {
     NSLog(@"takePicture:");
    if ([session isRunning]) {
        [session stopRunning];
        [sender setTitle:@"重新开始" forState:UIControlStateNormal];
        
        flashView = [[UIView alloc] initWithFrame:[previewView frame]];
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [flashView setAlpha:0.f];
        [[[self view] window] addSubview:flashView];
        
        [UIView animateWithDuration:.2f
                         animations:^{
                             [flashView setAlpha:1.f];
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:.2f
                                              animations:^{
                                                  [flashView setAlpha:0.f];
                                              }
                                              completion:^(BOOL finished) {
                                                  [flashView removeFromSuperview];
                                                  flashView = nil;
                                              }];
                         }];
        
    } else {
        [session startRunning];
         audioAlert=false;
        [sender setTitle:@"停止检测" forState:UIControlStateNormal];
    }
}
- (IBAction)settingPage:(id)sender {
    
   
    if ([session isRunning]) {
        [session stopRunning];
        
    }
    UIStoryboard *settingsStoryboard = [UIStoryboard storyboardWithName:@"Settings" bundle:nil];
    UIViewController *settingsviewController = [settingsStoryboard instantiateViewControllerWithIdentifier:@"PRSettingsViewController"];
    settingsviewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:settingsviewController];
    [self presentViewController:nav animated:YES completion:nil];

  
  
  
    
//    if ([session isRunning]) {
//        [session stopRunning];
//        [sender setTitle:@"重新开始" forState:UIControlStateNormal];
//
//        flashView = [[UIView alloc] initWithFrame:[previewView frame]];
//        [flashView setBackgroundColor:[UIColor whiteColor]];
//        [flashView setAlpha:0.f];
//        [[[self view] window] addSubview:flashView];
//
//        [UIView animateWithDuration:.2f
//                         animations:^{
//                             [flashView setAlpha:1.f];
//                         }
//                         completion:^(BOOL finished) {
//                             [UIView animateWithDuration:.2f
//                                              animations:^{
//                                                  [flashView setAlpha:0.f];
//                                              }
//                                              completion:^(BOOL finished) {
//                                                  [flashView removeFromSuperview];
//                                                  flashView = nil;
//                                              }];
//                         }];
//
//    } else {
//        [session startRunning];
//        audioAlert=false;
//        [sender setTitle:@"停止检测" forState:UIControlStateNormal];
//    }
}

+ (CGRect)videoPreviewBoxForGravity:(NSString *)gravity
                          frameSize:(CGSize)frameSize
                       apertureSize:(CGSize)apertureSize {
    CGFloat apertureRatio = apertureSize.height / apertureSize.width;
    CGFloat viewRatio = frameSize.width / frameSize.height;
    
    CGSize size = CGSizeZero;
    if ([gravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (viewRatio > apertureRatio) {
            size.width = frameSize.width;
            size.height =
            apertureSize.width * (frameSize.width / apertureSize.height);
        } else {
            size.width =
            apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResizeAspect]) {
        if (viewRatio > apertureRatio) {
            size.width =
            apertureSize.height * (frameSize.height / apertureSize.width);
            size.height = frameSize.height;
        } else {
            size.width = frameSize.width;
            size.height =
            apertureSize.width * (frameSize.width / apertureSize.height);
        }
    } else if ([gravity isEqualToString:AVLayerVideoGravityResize]) {
        size.width = frameSize.width;
        size.height = frameSize.height;
    }
    
    CGRect videoBox;
    videoBox.size = size;
    if (size.width < frameSize.width)
        videoBox.origin.x = (frameSize.width - size.width) / 2;
    else
        videoBox.origin.x = (size.width - frameSize.width) / 2;
    
    if (size.height < frameSize.height)
        videoBox.origin.y = (frameSize.height - size.height) / 2;
    else
        videoBox.origin.y = (size.height - frameSize.height) / 2;
    
    return videoBox;
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection {
    
    if(!audioAlert){
    CVPixelBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
   
    CFRetain(pixelBuffer);
    //NSString *theImagePath = [[NSBundle mainBundle] pathForResource:@"2-13" ofType:@"jpg"];
    //[self uploadPhoto:theImagePath  withfileName:@"lala.jpg"];
     //   [self upLoadDocumentsPathAllFiles];
    [self runCNNOnFrame:pixelBuffer];
    
    //UIImage *img=[self imageFromSampleBuffer:pixelBuffer];
    //[self saveImageToPhotos:img];
    CFRelease(pixelBuffer);
       
    }
    else{
        //LOG(INFO) << "audioAlert=true!:"<< audioAlert;
    }
}


- (void)saveImageToPhotos:(UIImage*)savedImage
{
    LOG(INFO) << "size free="<< [self freeDiskSpaceInMB];
    
    savedImage=[savedImage rotate:UIImageOrientationRight];
    
    //UIImageWriteToSavedPhotosAlbum(savedImage, nil, nil, nil);
    //LOG(INFO) << "UIImageWriteToSavedPhotosAlbum! ";
    //UIImageJPEGRepresentation(savedImage, 0.7f);
    
   
//    ////////if 200 ok delete the file from document
//    NSString *documentsPath = [self getDocumentsPath];
//    NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
//    //2. 利用时间戳当做图片名字
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    formatter.dateFormat = @"yyyyMMddHHmmss";
//    NSString *imageName = [formatter stringFromDate:[NSDate date]];
//    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];
//
//    NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:fileName];
//
//    bool result=[UIImageJPEGRepresentation(savedImage, 0.7f) writeToFile: atomically:YES];
//
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);

    //2. 利用时间戳当做图片名字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *imageName = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg",imageName];


    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:fileName]];
    // 保存文件的名称
    LOG(INFO) << "UIImageWriteToSavedNSDocumentDirectory filePath: "<<filePath;
    bool result=[UIImageJPEGRepresentation(savedImage, 0.7f) writeToFile:filePath atomically:YES];
    // 保存成功会返回YES
     LOG(INFO) << "UIImageWriteToSavedNSDocumentDirectory! result "<<result;

}
// Create a UIImage from sample buffer data
- (UIImage *) imageFromSampleBuffer:(CVImageBufferRef) imageBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    //CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    

    return (image);
}
- (void)runCNNOnFrame:(CVPixelBufferRef)pixelBuffer {
    assert(pixelBuffer != NULL);
    
    OSType sourcePixelFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    int doReverseChannels;
    if (kCVPixelFormatType_32ARGB == sourcePixelFormat) {
        doReverseChannels = 1;
    } else if (kCVPixelFormatType_32BGRA == sourcePixelFormat) {
        doReverseChannels = 0;
    } else {
        assert(false);  // Unknown source format
    }
    
    const int sourceRowBytes = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    const int image_width = (int)CVPixelBufferGetWidth(pixelBuffer);
    const int fullHeight = (int)CVPixelBufferGetHeight(pixelBuffer);
    
    CVPixelBufferLockFlags unlockFlags = kNilOptions;
    CVPixelBufferLockBaseAddress(pixelBuffer, unlockFlags);
    
    unsigned char *sourceBaseAddr =
    (unsigned char *)(CVPixelBufferGetBaseAddress(pixelBuffer));
    int image_height;
    unsigned char *sourceStartAddr;
    if (fullHeight <= image_width) {
        image_height = fullHeight;
        sourceStartAddr = sourceBaseAddr;
    } else {
        image_height = image_width;
        const int marginY = ((fullHeight - image_width) / 2);
        sourceStartAddr = (sourceBaseAddr + (marginY * sourceRowBytes));
    }
    const int image_channels = 4;
    
    assert(image_channels >= wanted_input_channels);
    tensorflow::Tensor image_tensor(
                                    tensorflow::DT_FLOAT,
                                    tensorflow::TensorShape(
                                                            {1, wanted_input_height, wanted_input_width, wanted_input_channels}));
    auto image_tensor_mapped = image_tensor.tensor<float, 4>();
    tensorflow::uint8 *in = sourceStartAddr;
    float *out = image_tensor_mapped.data();
    
    
//    for (int y = 0; y < wanted_input_height; ++y) {
//        float *out_row = out + (y * wanted_input_width * wanted_input_channels); //0+height
//        for (int x = 0; x < wanted_input_width; ++x) {
//            const int in_x = (y * image_width) / wanted_input_width;
//            const int in_y = (x * image_height) / wanted_input_height;
//            tensorflow::uint8 *in_pixel =
//            in + (in_y * image_width * image_channels) + (in_x * image_channels);
//            float *out_pixel = out_row + (x * wanted_input_channels);
//            for (int c = 0; c < wanted_input_channels; ++c) {
//                out_pixel[c] = (in_pixel[c] - input_mean) / input_std;
//            }
//        }
//    }
    for (int y = 0; y < wanted_input_width; ++y) {
        float *out_row = out + (y * wanted_input_width * wanted_input_channels); //0+height
        for (int x = 0; x < wanted_input_height; ++x) {
            const int in_x = (y * image_width) / wanted_input_width;
            const int in_y =image_height - (x * image_height) / wanted_input_height;
            tensorflow::uint8 *in_pixel =
            in + (in_y * image_width * image_channels) + (in_x * image_channels);
            float *out_pixel = out_row + (x * wanted_input_channels);
            for (int c = 0; c < wanted_input_channels; ++c) {
                out_pixel[c] = (in_pixel[c] - input_mean) / input_std;
            }
        }
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, unlockFlags);
    
    if (tf_session.get()) {
        std::vector<tensorflow::Tensor> outputs;
        tensorflow::Status run_status = tf_session->Run(
                                                        {{input_layer_name, image_tensor}}, {output_layer_name}, {}, &outputs);
        if (!run_status.ok()) {
            LOG(ERROR) << "Running model failed:" << run_status;
        } else {
            tensorflow::Tensor *output = &outputs[0];
            //1分钟连续姿势不正，给出语音提示
            
            if([self badPosition: output pos:3]||[self badPosition: output pos:1]){
                badCount++;
                 LOG(INFO) << "badCount++:" << badCount;
            }else{
                badCount=0;
                 LOG(INFO) << "badCount++:" << badCount;
            }
            if(badCount==60){
                //audio alert
                [self.audioPlayer play];
                //for debugs stop upload
                //[self upLoadDocumentsPathAllFiles];
                if(timer==Nil){
                NSTimer *timer = [NSTimer timerWithTimeInterval:300 target:self selector:@selector(AudioUpdateStatus) userInfo:nil repeats:YES];
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                }
                badCount=0;
                audioAlert=true;
            }
            if([self getMaxPredictionValue:output]<=0.8){
                //for debugs to stop save pic
                //UIImage *img=[self imageFromSampleBuffer:pixelBuffer];
                //[self saveImageToPhotos:img];
            }
             //display in frame
            auto predictions = output->flat<float>();
            NSMutableDictionary *newValues = [NSMutableDictionary dictionary];
            for (int index = 0; index < predictions.size(); index += 1) {
                const float predictionValue = predictions(index);
                if (predictionValue > 0.05f) {
                    std::string label = labels[index % predictions.size()];
                    NSString *labelObject = [NSString stringWithUTF8String:label.c_str()];
                    NSNumber *valueObject = [NSNumber numberWithFloat:predictionValue];
                    [newValues setObject:valueObject forKey:labelObject];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [self setPredictionValues:newValues];
            });
        }
    }
    CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
}

/**
 *  创建播放器
 *
 *  @return 音频播放器
 */
-(AVAudioPlayer *)audioPlayer{
    if (!audioPlayer) {
        NSString *urlStr=[[NSBundle mainBundle]pathForResource:kMusicFile ofType:kMusiceExt];
        NSURL *url=[NSURL fileURLWithPath:urlStr];
        NSError *error=nil;
        //初始化播放器，注意这里的Url参数只能时文件路径，不支持HTTP Url
        audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        //设置播放器属性
        audioPlayer.numberOfLoops=0;//设置为0不循环
        [audioPlayer prepareToPlay];//加载音频文件到缓存
        if(error){
            NSLog(@"初始化播放器过程发生错误,错误信息:%@",error.localizedDescription);
            return nil;
        }
    }
    return audioPlayer;
}

-(void)AudioUpdateStatus{
    audioAlert=false;
     LOG(INFO) << "Timer update audioAlert=false:" << audioAlert;
}


-(float)getMaxPredictionValue:( tensorflow::Tensor *) output{
      auto predictions = output->flat<float>();
    
    float max = predictions(0);
    for (int index = 0; index< predictions.size(); index += 1) {
        if (predictions(index) > max) {
            max =predictions(index);
        }
    }
    
    return max;
}

-(BOOL)badPosition:( tensorflow::Tensor *) output
pos:(int)pos
{
                    auto predictions = output->flat<float>();
                      bool max=true;
                    for (int index = 0; index < predictions.size(); index += 1) {
                        if (predictions(pos) < predictions(index)) {
                            max=false;
                            break;
                        }
                    }
                      return max;
}



- (void)dealloc {
    [self teardownAVCapture];
}

// use front/back camera
- (IBAction)switchCameras:(id)sender {
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for (AVCaptureDevice *d in
         [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            [[previewLayer session] beginConfiguration];
            AVCaptureDeviceInput *input =
            [AVCaptureDeviceInput deviceInputWithDevice:d error:nil];
            for (AVCaptureInput *oldInput in [[previewLayer session] inputs]) {
                [[previewLayer session] removeInput:oldInput];
            }
            [[previewLayer session] addInput:input];
            [[previewLayer session] commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    square = [UIImage imageNamed:@"squarePNG"];
    synth = [[AVSpeechSynthesizer alloc] init];
    labelLayers = [[NSMutableArray alloc] init];
    oldPredictionValues = [[NSMutableDictionary alloc] init];
    
    tensorflow::Status load_status;
    if (model_uses_memory_mapping) {
        load_status = LoadMemoryMappedModel(
                                            model_file_name, model_file_type, &tf_session, &tf_memmapped_env);
    } else {
        load_status = LoadModel(model_file_name, model_file_type, &tf_session);
    }
    if (!load_status.ok()) {
        LOG(FATAL) << "Couldn't load model: " << load_status;
    }
    
    tensorflow::Status labels_status =
    LoadLabels(labels_file_name, labels_file_type, &labels);
    if (!labels_status.ok()) {
        LOG(FATAL) << "Couldn't load labels: " << labels_status;
    }
    [self setupAVCapture];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:
(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)setPredictionValues:(NSDictionary *)newValues {
    const float decayValue = 0.75f;
    const float updateValue = 0.25f;
    const float minimumThreshold = 0.01f;
    
    NSMutableDictionary *decayedPredictionValues =
    [[NSMutableDictionary alloc] init];
    for (NSString *label in oldPredictionValues) {
        NSNumber *oldPredictionValueObject =
        [oldPredictionValues objectForKey:label];
        const float oldPredictionValue = [oldPredictionValueObject floatValue];
        const float decayedPredictionValue = (oldPredictionValue * decayValue);
        if (decayedPredictionValue > minimumThreshold) {
            NSNumber *decayedPredictionValueObject =
            [NSNumber numberWithFloat:decayedPredictionValue];
            [decayedPredictionValues setObject:decayedPredictionValueObject
                                        forKey:label];
        }
    }
    oldPredictionValues = decayedPredictionValues;
    
    for (NSString *label in newValues) {
        NSNumber *newPredictionValueObject = [newValues objectForKey:label];
        NSNumber *oldPredictionValueObject =
        [oldPredictionValues objectForKey:label];
        if (!oldPredictionValueObject) {
            oldPredictionValueObject = [NSNumber numberWithFloat:0.0f];
        }
        const float newPredictionValue = [newPredictionValueObject floatValue];
        const float oldPredictionValue = [oldPredictionValueObject floatValue];
        const float updatedPredictionValue =
        (oldPredictionValue + (newPredictionValue * updateValue));
        NSNumber *updatedPredictionValueObject =
        [NSNumber numberWithFloat:updatedPredictionValue];
        [oldPredictionValues setObject:updatedPredictionValueObject forKey:label];
    }
    NSArray *candidateLabels = [NSMutableArray array];
    for (NSString *label in oldPredictionValues) {
        NSNumber *oldPredictionValueObject =
        [oldPredictionValues objectForKey:label];
        const float oldPredictionValue = [oldPredictionValueObject floatValue];
        if (oldPredictionValue > 0.05f) {
            NSDictionary *entry = @{
                                    @"label" : label,
                                    @"value" : oldPredictionValueObject
                                    };
            candidateLabels = [candidateLabels arrayByAddingObject:entry];
        }
    }
    NSSortDescriptor *sort =
    [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:NO];
    NSArray *sortedLabels = [candidateLabels
                             sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    
    const float leftMargin = 10.0f;
    const float topMargin = 300.0f;
    
    const float valueWidth = 48.0f;
    const float valueHeight = 26.0f;
    
    const float labelWidth = 246.0f;
    const float labelHeight = 26.0f;
    
    const float labelMarginX = 5.0f;
    const float labelMarginY = 5.0f;
    
    [self removeAllLabelLayers];
    
    int labelCount = 0;
    for (NSDictionary *entry in sortedLabels) {
        NSString *label = [entry objectForKey:@"label"];
        NSNumber *valueObject = [entry objectForKey:@"value"];
        const float value = [valueObject floatValue];
        
        const float originY =
        (topMargin + ((labelHeight + labelMarginY) * labelCount));
        
        const int valuePercentage = (int)roundf(value * 100.0f);
        
        const float valueOriginX = leftMargin;
        NSString *valueText = [NSString stringWithFormat:@"%d%%", valuePercentage];
        
        [self addLabelLayerWithText:valueText
                            originX:valueOriginX
                            originY:originY
                              width:valueWidth
                             height:valueHeight
                          alignment:kCAAlignmentRight];
        
        const float labelOriginX = (leftMargin + valueWidth + labelMarginX);
        
        [self addLabelLayerWithText:[label capitalizedString]
                            originX:labelOriginX
                            originY:originY
                              width:labelWidth
                             height:labelHeight
                          alignment:kCAAlignmentLeft];
        
        if ((labelCount == 0) && (value > 0.5f)) {
            //[self speak:[label capitalizedString]];
        }
        
        labelCount += 1;
        if (labelCount > 4) {
            break;
        }
    }
}

- (void)removeAllLabelLayers {
    for (CATextLayer *layer in labelLayers) {
        [layer removeFromSuperlayer];
    }
    [labelLayers removeAllObjects];
}

- (void)addLabelLayerWithText:(NSString *)text
                      originX:(float)originX
                      originY:(float)originY
                        width:(float)width
                       height:(float)height
                    alignment:(NSString *)alignment {
    CFTypeRef font = (CFTypeRef) @"Menlo-Regular";
    const float fontSize = 20.0f;
    
    const float marginSizeX = 5.0f;
    const float marginSizeY = 2.0f;
    
    const CGRect backgroundBounds = CGRectMake(originX, originY, width, height);
    
    const CGRect textBounds =
    CGRectMake((originX + marginSizeX), (originY + marginSizeY),
               (width - (marginSizeX * 2)), (height - (marginSizeY * 2)));
    
    CATextLayer *background = [CATextLayer layer];
    [background setBackgroundColor:[UIColor blackColor].CGColor];
    [background setOpacity:0.5f];
    [background setFrame:backgroundBounds];
    background.cornerRadius = 5.0f;
    
    [[self.view layer] addSublayer:background];
    [labelLayers addObject:background];
    
    CATextLayer *layer = [CATextLayer layer];
    [layer setForegroundColor:[UIColor whiteColor].CGColor];
    [layer setFrame:textBounds];
    [layer setAlignmentMode:alignment];
    [layer setWrapped:YES];
    [layer setFont:font];
    [layer setFontSize:fontSize];
    layer.contentsScale = [[UIScreen mainScreen] scale];
    [layer setString:text];
    
    [[self.view layer] addSublayer:layer];
    [labelLayers addObject:layer];
}

- (void)setPredictionText:(NSString *)text withDuration:(float)duration {
    if (duration > 0.0) {
        CABasicAnimation *colorAnimation =
        [CABasicAnimation animationWithKeyPath:@"foregroundColor"];
        colorAnimation.duration = duration;
        colorAnimation.fillMode = kCAFillModeForwards;
        colorAnimation.removedOnCompletion = NO;
        colorAnimation.fromValue = (id)[UIColor darkGrayColor].CGColor;
        colorAnimation.toValue = (id)[UIColor whiteColor].CGColor;
        colorAnimation.timingFunction =
        [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.predictionTextLayer addAnimation:colorAnimation
                                        forKey:@"colorAnimation"];
    } else {
        self.predictionTextLayer.foregroundColor = [UIColor whiteColor].CGColor;
    }
    
    [self.predictionTextLayer removeFromSuperlayer];
    [[self.view layer] addSublayer:self.predictionTextLayer];
    [self.predictionTextLayer setString:text];
}

- (void)speak:(NSString *)words {
    if ([synth isSpeaking]) {
        return;
    }
    AVSpeechUtterance *utterance =
    [AVSpeechUtterance speechUtteranceWithString:words];
    utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
    utterance.rate = 0.75 * AVSpeechUtteranceDefaultSpeechRate;
    [synth speakUtterance:utterance];
}
- (BOOL) isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    struct ifaddrs *interfaces;
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next)
        {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                [cset addObject:[NSString stringWithUTF8String:interface->ifa_name]];
            }
        }
    }
    return [cset countForObject:@"awdl0"] > 1 ? YES : NO;
}
-(float)freeDiskSpaceInMB{
//    struct statfs buf;
//    long freespace = -1;
//    if(statfs("/var", &buf) >= 0){
//        freespace = (long long)(buf.f_bsize * buf.f_bfree);
//    }
//    return freespace/1024/1024;
    /// 总大小
    float totalsize = 0.0;
    /// 剩余大小
    float freesize = 0.0;
    /// 是否登录
    NSError *error = nil;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSDictionary *dictionary = [[NSFileManager defaultManager] attributesOfFileSystemForPath:[paths lastObject] error: &error];
    if (dictionary)
    {
        NSNumber *_free = [dictionary objectForKey:NSFileSystemFreeSize];
        freesize = [_free unsignedLongLongValue]*1.0/(1024);
        
        NSNumber *_total = [dictionary objectForKey:NSFileSystemSize];
        totalsize = [_total unsignedLongLongValue]*1.0/(1024);
    } else
    {
        NSLog(@"Error Obtaining System Memory Info: Domain = %@, Code = %ld", [error domain], (long)[error code]);
    }
    NSLog(@"totalsize = %.2f, freesize = %f",totalsize/1024, freesize/1024);
    return  freesize/1024;
   
}

//:NSURL fileURLWithPath  fileName    (UIImage*)image AndFinish:(void (^)(NSDictionary *, NSError *))finish
-(void)uploadPhoto:(NSString *) theImagePath withfileName:(NSString *) fileName{
    //NSString *theImagePath = [[NSBundle mainBundle] pathForResource:@"2-13" ofType:@"jpg"];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://wipos.cn/iface/body/upload.na" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:theImagePath] name:@"imgFile" fileName:fileName  mimeType:@"image/jpeg" error:nil];
    } error:nil];
    request.timeoutInterval = 10;
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    NSURLSessionUploadTask *uploadTask;

    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          //[progressView setProgress:uploadProgress.fractionCompleted];
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
//

                                if ([responseObject isKindOfClass:[NSArray class]]) {
                                    NSArray *responseArray = responseObject;
                              /* do something with responseArray */
                                }
                                else if ([responseObject isKindOfClass:[NSDictionary class]])
                                {
                                    NSDictionary *responseDict = responseObject;
                                    /* do something with responseDict */
                              
                                    NSString *value = responseDict.description;
                                    NSArray *aArray = [value componentsSeparatedByString:@";"];
                                    NSString *filename;
                                    NSString *arrayString;
                                    
                                    for(NSInteger i=0;i<[aArray count];i++)
                                    {
                                        arrayString=aArray[i];
                                        // NSLog(@"%@", arrayString);
                                  
                                  
                                        if([arrayString containsString:@"oldFileNames"] )
                                        {
                                            //NSLog(@"%@",aArray[i]);
                                            filename=[arrayString substringWithRange:NSMakeRange(21, 18)];//aArray[i].substring(16,aArray[i].count-1);
                                            //filename=[
                                            NSLog(@"%@",filename);
                                            break;
                                            
                                        }

                                    }
                                        ////////if 200 ok delete the file from document
                                        NSString *documentsPath = [self getDocumentsPath];
                                        NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
                                        NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:filename];
                                        // 如果该路径下文件已经存在，就要先将其移除
                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                        if ([fileManager fileExistsAtPath:[fileURL path] isDirectory:NULL]) {

                                            [fileManager removeItemAtURL:fileURL error:NULL];
                                            NSLog(@"delete file:%@",fileURL);
                                        }
                                        ////////
                              }
                          
                       
                          //NSLog(@"%@ %@", response, responseObject);
                          
                         
                      }
                  }];
   

    [uploadTask resume];
  LOG(INFO) << "uploadTask end!" ;

    
}
- (void)upLoadDocumentsPathAllFiles {
////////////////////
NSString *docsDir = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
NSFileManager *fileManager = [NSFileManager defaultManager];
NSDirectoryEnumerator *dirEnum = [fileManager enumeratorAtPath:docsDir];
NSString *fileNameindoc;

while (fileNameindoc = [dirEnum nextObject]) {
    //NSLog(@"----------FielName : %@" , fileNameindoc);
    //NSLog(@"-----------------FileFullPath : %@" , [docsDir stringByAppendingPathComponent:fileNameindoc]) ;
    
    [self uploadPhoto:[docsDir stringByAppendingPathComponent:fileNameindoc]  withfileName:fileNameindoc];
}
}
////////////////////////
/* 获取Documents文件夹的路径 */
- (NSString *)getDocumentsPath {
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = documents[0];
    return documentsPath;
}
@end
