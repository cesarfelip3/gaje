//
//  UploadController.m
//  Gaje
//
//  Created by hello on 14-5-14.
//  Copyright (c) 2014年 AppDesignVault. All rights reserved.
//

#import "UploadController.h"
#import "ThemeController.h"
#import "Image+ImageApi.h"

@interface UploadController ()

@end

@implementation UploadController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)setup
{
    UIImageView *titleImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"navigation-title"]];
    self.navigationItem.titleView = titleImageV;
    
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancel setFrame:CGRectMake(0, 0, 30, 30)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancel];
    [cancel addTarget:self action:@selector(onTopbarButtonTouched:) forControlEvents:UIControlEventTouchDown];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Default"]]];
    
#if false
    UIButton *choose = [UIButton buttonWithType:UIButtonTypeSystem];
    choose.frame = CGRectMake(0, 0, 30, 30);
    [choose setBackgroundImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];        [self.chooseButton setCustomView:choose];
    [choose addTarget:self action:@selector(onBottombarButtonTouched:) forControlEvents:UIControlEventTouchDown];
#endif
    
    [self.progressBar setProgress:0];
    self.photo = [[Image alloc] init];
    
    //
    
    self.themeArray = [[NSMutableArray alloc] init];
    
    self.themeController = [[ThemeController alloc] initWithStyle:UITableViewStylePlain];
    self.tableViewThemeList.delegate = self.themeController;
    self.tableViewThemeList.dataSource = self.themeController;
    self.themeController.view = self.tableViewThemeList;
    self.themeController.tableView = self.tableViewThemeList;
    self.themeController.themeArray = self.themeArray;
    [self.themeController viewDidLoad];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTopbarButtonTouched:(id)sender
{
    NSLog(@"choose");
    
    NSLog(@"name = %@", self.photo.name);
    NSLog(@"description = %@", self.photo.description);
    
    if (self.photo.name == nil || [self.photo.name isEqualToString:@""]) {
#if false
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pleast give your photo a name at least" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
#endif
        
        self.photo.name = @"";
    }
    
    
    
    NSString *themes = @"";
    
    for (Theme *theme in self.themeArray) {
        
        NSLog(@"selected = %d", theme.selected);
        if (theme.selected) {
            themes = [themes stringByAppendingString:[NSString stringWithFormat:@"%@,", theme.themeUUID]];
        }
    }
    
    NSLog(@"themes = %@", themes);
    
    if ([themes isEqualToString:@""]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Select at least one theme for your image" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Image Source"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Camera", @"Photo album", nil];
    
    [sheet showInView:self.view];
    return;
}

- (IBAction)onBottombarButtonTouched:(id)sender
{
    
    NSLog(@"choose");
    
    NSLog(@"name = %@", self.photo.name);
    NSLog(@"description = %@", self.photo.description);
    
    if (self.photo.name == nil || [self.photo.name isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Pleast give your photo a name at least" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        return;
    }
    
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Select Image Source"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Camera", @"Photo album", nil];
    
    [sheet showInView:self.view];
    return;
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 0) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hint" message:@"Your device didn't support camera." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alert show];
            
            return;
        }
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [imagePicker setDelegate:self];
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        imagePicker.allowsEditing = NO;
        imagePicker.showsCameraControls = YES;
        
        NSLog(@"navigation controller = %@", self.navigationController);
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
    if (buttonIndex == 1) {
        //https://developer.apple.com/library/ios/documentation/AudioVideo/Conceptual/CameraAndPhotoLib_TopicsForIOS/Articles/PickinganItemfromthePhotoLibrary.html
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [imagePicker setDelegate:self];
        imagePicker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        imagePicker.allowsEditing = NO;
        [self.navigationController presentViewController:imagePicker animated:YES completion:nil];
    }
    
    if (buttonIndex == 2) {
        
    }
}

- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToUse;
    
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToUse = editedImage;
        } else {
            imageToUse = originalImage;
        }
    } else {
        return;
    }
    
#if false
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
    }
#endif
    
    self.image = [self fixOrientation:imageToUse];
    
#if true
    [self filesAreReady:^{
        
        DiskCache *cache = [DiskCache getInstance];
        
        NSString *filePath = [cache getImagePath:self.photo.fileName];
        AppConfig *config = [AppConfig getInstance];
        
        if (self.photo.description == nil) {
            self.photo.description = @"";
        }
        
        if (self.photo.name == nil) {
            //
            self.photo.name = @"";
        }
        
        NSString *themes = @"";
        
        for (Theme *theme in self.themeArray) {
            
            if (theme.selected) {
                themes = [themes stringByAppendingString:[NSString stringWithFormat:@"%@,", theme.themeUUID]];
            }
        }
        
        NSDictionary *data = @{@"file_path":filePath, @"file_name":self.photo.fileName, @"name":self.photo.name, @"description":self.photo.description, @"user_uuid":config.uuid, @"theme_array":themes};
        
        self.photo.delegate = self;
        [self.photo upload:data ProgressBar:self.progressBar];
        
    }];
#endif
    
    //DiskCache *cache = [DiskCache getInstance];
    //[cache saveImageN:self.photo fileName:nil Queue:self.queue];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)fixOrientation:(UIImage *)image {
    
    // No-op if the orientation is already correct
    if (image.imageOrientation == UIImageOrientationUp) return image;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)filesAreReady:(void (^)(void))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        DiskCache *cache = [DiskCache getInstance];
        
        if (!self.image) {
            return;
        }
        
        if (self.image) {
            NSString *fileName = [[NSUUID UUID] UUIDString];
            fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
            
            self.photo.fileName = fileName;
            [cache addImage:self.image fileName:fileName];
            
        }
        
        if (completion) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }
    });
}

- (BOOL)onCallback:(NSInteger)type
{
    
    NSString *message = @"Your photo is uploaded successfully";
    self.photo.delegate = nil;
    
    if (type > 0) {
        message = self.photo.errorMessage;
    }
#if true
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
#endif
    
    //[[iToast makeText:message] show];
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self.navigationController popViewControllerAnimated:YES];
}

//==============================
//
//==============================

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    textField.text = @"";
    [textField setTextColor:[UIColor blackColor]];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    self.photo.name = textField.text;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    self.photo.name = textField.text;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    [textView setTextColor:[UIColor blackColor]];
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    self.photo.description = textView.text;
    [textView resignFirstResponder];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    self.photo.description = textView.text;
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
