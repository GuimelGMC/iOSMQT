//
//  MqttClient.m
//  Mosquitto
//
//  Created by Guimel Moreno on 01/04/17.
//  Copyright © 2017 guimelgmc. All rights reserved.
//

#import "MqttClient.h"
#import "MosquittoClient.h"

#define IP @"192.168.8.1"
#define Topic @"ARDUINODAY"

#define ENC1 @"PRENDE FOCO1"
#define APA1 @"APAGAR FOCO1"

#define ENC2 @"PRENDE FOCO2"
#define APA2 @"APAGAR FOCO2"

@interface MqttClient () <MosquittoClientDelegate> {
    NSInteger dmmr;
}

@property (nonatomic,retain) MosquittoClient *cliente;

@end

@implementation MqttClient

- (void)viewDidLoad {
    [super viewDidLoad];
    [self connectMqtt];
    dmmr = 20;
}

-(void)connectMqtt{
    NSString *clientID = @"iPhone_Guimel";
    
    _cliente= [[MosquittoClient alloc] initWithClientId:clientID];
    [_cliente setDelegate:self];
    [_cliente setPort:1883];
    [_cliente setHost:IP];
    [_cliente connect];
    [_cliente subscribe:Topic withQos:1];
}

-(void)printLogWith:(NSString *)message {
    NSString *log = [NSString stringWithFormat:@"\n%@",message];
    _txtViewLog.text = [_txtViewLog.text stringByAppendingString:log];
    NSRange bottom = NSMakeRange(_txtViewLog.text.length -1, 1);
    [_txtViewLog scrollRangeToVisible:bottom];
}

#pragma mark - IBActions
#pragma mark -
-(IBAction)sendCommand:(id)sender{
    if (![_txtCommand.text isEqualToString:@""]) {
        [_cliente publishString: _txtCommand.text toTopic:Topic withQos:1 retain:NO];
    } else {
        [self printLogWith:@"Comando no válido"];
    }
    
}

-(IBAction)sendDimmer:(id)sender{
    NSInteger dimmer = [[NSNumber numberWithFloat:_sliderDimmer.value] integerValue];
    NSString *cmd = [NSString stringWithFormat:@"DIMMER FOCO2 %ld", (long)dimmer];
    
    if (dimmer != dmmr) {
        dmmr = dimmer;
        NSLog(@"%@", cmd);
        [_cliente publishString:cmd toTopic:Topic withQos:1 retain:NO];
    }
}

- (IBAction)actionFoco1:(id)sender {
    
    if ([[_btnFoco1 titleForState: UIControlStateNormal] isEqualToString:@"PRENDE"]) {
        [_cliente publishString:ENC1 toTopic:Topic withQos:1 retain:NO];
        [_btnFoco1 setTitle:@"APAGA" forState: UIControlStateNormal];
    } else {
        [_cliente publishString:APA1 toTopic:Topic withQos:1 retain:NO];
        [_btnFoco1 setTitle:@"PRENDE" forState: UIControlStateNormal];
    }
    
}

- (IBAction)actionFoco2:(id)sender {
    
    if ([[_btnFoco2 titleForState: UIControlStateNormal] isEqualToString:@"PRENDE"]) {
        [_cliente publishString:ENC2 toTopic:Topic withQos:1 retain:NO];
        [_btnFoco2 setTitle:@"APAGA" forState: UIControlStateNormal];
    } else {
        [_cliente publishString:APA2 toTopic:Topic withQos:1 retain:NO];
        [_btnFoco2 setTitle:@"PRENDE" forState: UIControlStateNormal];
    }
}

#pragma mark - MosquittoClientDelegate
#pragma mark -

-(void)didUnsubscribe:(NSUInteger)messageId{
    
}

-(void)didPublish:(NSUInteger)messageId{
    
}

-(void)didDisconnect{
    [self printLogWith:@"Desconectado de MQTT Server 192.168.8.1"];
}

-(void)didReceiveMessage:(MosquittoMessage *)mosq_msg{
    [self printLogWith:[NSString stringWithFormat:@"TOPIC: %@",mosq_msg.topic]];
    [self printLogWith:[NSString stringWithFormat:@"PAYLOAD: %@",mosq_msg.payload]];
}

-(void)didConnect:(NSUInteger)code{
    [self printLogWith:@"Conectado en MQTT Server 192.168.8.1"];
}

-(void)didSubscribe:(NSUInteger)messageId grantedQos:(NSArray *)qos{
    [self printLogWith:@"Suscrito en Topic ARDUINODAY"];
}
@end
