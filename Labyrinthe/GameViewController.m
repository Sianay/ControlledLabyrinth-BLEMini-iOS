//
//  ViewController.m
//  Labyrinthe
//
//  Created by Anaïs Paillette on 02/12/2014.
//  Copyright (c) 2014 ARLEM. All rights reserved.
//

#import "GameViewController.h"
#import <CoreMotion/CoreMotion.h>
#import "MotionManager.h"
#import "HistoriqueDataHandler.h"
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

/** Radians to Degrees **/
#define radiansToDegrees( radians ) ( ( radians ) * ( 180.0 / M_PI ) )


@interface GameViewController (){
    BOOL authorizeToSend;
    BOOL isPlaying;
    NSDictionary * holeMessages;
}

@property (nonatomic, retain) AVAudioPlayer *theAudio;


@end

@implementation GameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    holeMessages = @{
                     @"1" : @"S'abandonner au désespoir sur la ligne de départ, c'est partir perdant",
                     @"2" : @"Même les yeux fermés, n'importe qui ferait mieux...",
                     @"3" : @"Même ta mère ferait mieux",
                     @"4" : @"Saviez-vous que le but de ce jeu c'est de ne PAS tomber dans le trou ?",
                     @"5" : @"Belle tentative...mais non",
                     @"6" : @"Parfois, il ne vaut mieux même pas essayer",
                     @"7" : @"Vous êtes tomber dans le panneau...euh enfin le trou",
                     @"8" : @"Essayer avec plus de patience la prochaine fois.",
                     @"9" : @"Tomber la, tomber tomber, tomber la baballe",
                     @"10" : @"Le tout c'est de ne pas viser le trou",
                     @"11" : @"Je crois qu'il faut recommencer",
                     @"12" : @"Déshonneur sur ta famille",
                     @"13" : @"Vous êtes trou nul...",
                     @"14" : @"Sûrement une erreur d'inattention",
                     @"15" : @"Je veux pas dire mais ça sent la triche",
                     @"16" : @"La prochaine fois prend au moins le téléphone dans le bon sens",
                     @"17" : @"Il ne suffit pas d'agiter le telephone au hasard",
                     @"18" : @"Belle tentative...mais non",
                     @"19" : @"Vous êtes nul",
                     @"20" : @"Il ne faut pas abandonner à la moitié du chemin",
                     @"21" : @"Je pense qu'il faut que tu te remettes en question",
                     @"22" : @"C'est bête d'abandonner à mi-chemin",
                     @"23" : @"C'est trou pas de chance",
                     @"24" : @"Trou trou trou encore des trous y'en a partout !",
                     @"25" : @"Vous êtes nul",
                     @"26" : @"Vous êtes nul",
                     @"27" : @"Vous êtes nul",
                     @"28" : @"Vous êtes nul",
                     @"29" : @"Vous êtes nul",
                     @"30" : @"Vous avez du en chier pour en arriver là, c'est con.",
                     @"31" : @"Vous êtes nul",
                     @"32" : @"Vous êtes nul",
                     @"33" : @"Respect, à un moment donné c'est pas facile",
                     @"34" : @"Inutile de s'enerver, tu y es presque",
                     @"35" : @"Vous avez prouvé que c'était possible",
                     @"36" : @"C'était presque bien",
                     @"37" : @"Je suis sûr que vous y avez cru",
                     @"38" : @"L'espoir est le privilège des perdants...",
                     @"39" : @"Si prêt du but....et pourtant",
                     @"40" : @"C'est vraiment pas de bol : vous êtes tombé dans le dernier trou avant l'arrivée",
                     
                     };
    
    [self setUpMotionView];
    [self setStopState];
    [self initSphereMenu];
    
    [[BLELabyrinth sharedInstance] didReceiveAuthorizationToWrite:^{
        authorizeToSend = YES;
    } orNumberHole:^(NSString *numberHole) {
        [self eventGameOver:numberHole];
    }];
    
    [[BLELabyrinth sharedInstance] didDisconnectwithCompletionHandler:^{
        
        UIAlertView* dialog = [[UIAlertView alloc] initWithTitle:@"Perte de la connexion"
                                                         message:@"Vous avez été déconnecté de Ble Mini"
                                                        delegate:self
                                               cancelButtonTitle:@"OK"
                                               otherButtonTitles:nil];
        [dialog show];
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

-(void) initSphereMenu{
    UIImage *startImage = [UIImage imageNamed:@"menu"];
    UIImage *image1 = [UIImage imageNamed:@"delete_menu"];
    UIImage *image2 = [UIImage imageNamed:@"score_menu"];
    // UIImage *image3 = [UIImage imageNamed:@"info_menu"];
    NSArray *images = @[image1,image2];
    
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(self.view.center.x, self.view.frame.size.height-28) startImage:startImage submenuImages:images];
    sphereMenu.delegate = self;
    
    [self.view addSubview:sphereMenu];
    
}

- (void)sphereDidSelected:(int)index
{
    NSLog(@"sphere %d selected", index);
    
    switch (index) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            [[BLELabyrinth sharedInstance] endConnection];
            break;
            
        default:
            [self performSegueWithIdentifier:@"histoSegue" sender:self];
            break;
    }
    
    
}

- (void) playSound{
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                         pathForResource:@"fail"
                                         ofType:@"wav"]];
    NSError *error = nil;
    _theAudio = [[AVAudioPlayer alloc]
                                   initWithContentsOfURL:url
                                   error:&error];
    if (error)
    {
        NSLog(@"Error in audioPlayer: %@",[error localizedDescription]);
    }
    else
    {
        [_theAudio play];
    }
}

-(void) eventGameOver :(NSString*)numberHole
{
    if (isPlaying){
        
        isPlaying = NO;

        [self playSound];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
        [[[MotionManager sharedInstance] motionManager] stopDeviceMotionUpdates];
        
        [self performSelector:@selector(stopAction:) withObject:self];
        
        NSString *title = [NSString stringWithFormat:@"Perdu ! Votre Score : %@",numberHole];
        
        
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:title
                                      message:[holeMessages objectForKey:numberHole]
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"ok" style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action) {
                                                       UITextField * textfield = alert.textFields.firstObject;
                                                       
                                                       NSString *username =  [textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
                                                       
                                                       [[HistoriqueDataHandler sharedInstance] writeData:[username isEqualToString:@""]?@"John Doe": username numberHole:numberHole];
                                                       
                                                       if (![username isEqualToString:@""]){
                                                           [defaults setObject:username  forKey:@"username"];
                                                           [defaults synchronize];
                                                       }
                                                       
                                                   }];
        [alert addAction:ok];
        
        
        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
            textField.placeholder = @"Username";
            
            if([defaults objectForKey:@"username"] != nil){
                textField.text = [defaults objectForKey:@"username"];
            }
            
        }];
        
        
        [self presentViewController:alert animated:YES completion:nil];
        
    }
}


- (void) setUpMotionView{
    
    self.motionView.layer.cornerRadius = 50;
    
    UITapGestureRecognizer *touchOnView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchBall)] ;
    
    // Set required taps and number of touches
    [touchOnView setNumberOfTapsRequired:1];
    [touchOnView setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [self.motionView addGestureRecognizer:touchOnView];
}



-(void) viewWillAppear:(BOOL)animated{
}

-(void) touchBall{
    
    //[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(simulationChuteBille:) userInfo:nil repeats:NO];
     
    [self setPlayingState];
    [self startMyMotionDetect];
}

- (void) simulationChuteBille:(id)sender{
    [self eventGameOver:@"3"];
}

- (IBAction)stopAction:(id)sender {
    
    [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
    [[[MotionManager sharedInstance] motionManager] stopDeviceMotionUpdates];
    [self sendAccelerometerDataToBLEMiniX:0 andY:0];
    
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [UIView animateWithDuration:2.0
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.motionView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }
                     completion:^(BOOL finished){
                         [self.view setBackgroundColor:[UIColor whiteColor]];
                         
                         self.motionView.center = self.view.center;
                         self.motionView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                         
                         [self setStopState];
                     }];
}

-(void) setStopState{
    
    authorizeToSend = YES;
    isPlaying = NO;
    
    [self.motionView setUserInteractionEnabled:YES];
    self.startLabel.hidden = NO;
    self.stopButton.hidden = YES;
}

-(void) setPlayingState{
    
    isPlaying = YES;
    [self.motionView setUserInteractionEnabled:NO];
    self.startLabel.hidden = YES;
    self.stopButton.hidden = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self performSelector:@selector(stopAction:) withObject:self];
    
    [[[MotionManager sharedInstance] motionManager] stopAccelerometerUpdates];
    [[[MotionManager sharedInstance] motionManager] stopDeviceMotionUpdates];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)startMyMotionDetect
{
    __block float stepMoveFactor = 15;
    
    [[[MotionManager sharedInstance] motionManager] startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMAccelerometerData *data, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            CGRect rect = self.motionView.frame;
                            
                            float movetoX = rect.origin.x - (data.acceleration.y * stepMoveFactor);
                            float maxX = self.view.frame.size.width - rect.size.width;
                            
                            float movetoY = (rect.origin.y + rect.size.height) - (data.acceleration.x * stepMoveFactor);
                            float maxY = self.view.frame.size.height;
                            
                            if ( movetoX > 0 && movetoX < maxX ) {rect.origin.x -= (data.acceleration.y * stepMoveFactor);};
                            if ( movetoY > rect.size.height && movetoY < maxY ) {rect.origin.y -= (data.acceleration.x * stepMoveFactor);};
                            
                            [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:
                             ^{
                                 self.motionView.frame = rect;
                                 
                             }
                                             completion:nil];
                            
                        });
     }
     ];
    
    
    [[[MotionManager sharedInstance] motionManager] startDeviceMotionUpdatesToQueue:[[NSOperationQueue alloc] init] withHandler:^(CMDeviceMotion *motion, NSError *error)
     {
         
         dispatch_async(dispatch_get_main_queue(),
                        ^{
                            if (authorizeToSend){
                                
                                [self sendAccelerometerDataToBLEMiniX:radiansToDegrees(motion.attitude.roll) andY:radiansToDegrees(motion.attitude.pitch)];
                            }
                            
                        });
     }
     ];
    
}

-(void) sendAccelerometerDataToBLEMiniX:(double) xAcceleration andY:(double) yAcceleration {
    
    NSString *message = [NSString stringWithFormat:@"%d,%d/",(int)xAcceleration, (int)yAcceleration];
    
    NSLog(@"send : %@",message);
    
    [[BLELabyrinth sharedInstance] writeMessage:message];
    
    authorizeToSend = NO;
}

@end
