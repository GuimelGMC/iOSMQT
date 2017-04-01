//
//  MqttClient.h
//  Mosquitto
//
//  Created by Guimel Moreno on 01/04/17.
//  Copyright © 2017 guimelgmc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MqttClient : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtCommand;

@property (weak, nonatomic) IBOutlet UIButton *btnFoco1;
@property (weak, nonatomic) IBOutlet UIButton *btnFoco2;
@property (weak, nonatomic) IBOutlet UISlider *sliderDimmer;
@property (weak, nonatomic) IBOutlet UITextView *txtViewLog;

- (IBAction)sendCommand:(id)sender;
- (IBAction)sendDimmer:(id)sender;
- (IBAction)actionFoco1:(id)sender;
- (IBAction)actionFoco2:(id)sender;

@end
