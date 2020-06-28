#include <Wire.h>

unsigned char start[] = {0xfb, 0x02};
unsigned char id_arr[] = {0xf0, 0x00, 0x01, 0x04, 0x03, 0x03, 0x02, 0x03, 0x00};
unsigned char dt_arr[] = {0x78, 0x00, 0x01, 0x02, 0x03, 0x02, 0x02, 0x03, 0x01, 0x00, 0x00, 0x03, 0x02, 0x03, 0x01, 0x01, 0x01};
uint8_t tmp = 0x00;
int i, j, flag1, flag2;

void setup(){
	
	Wire.begin(); // Initiate the Wire library
	delay(100);
}

void loop() {

	Wire.beginTransmission(0x38);
	flag1 = Wire.write(dt_arr, 17);
	flag2 = Wire.endTransmission();
	
	Wire.beginTransmission(0x38);
	flag1 = Wire.write(id_arr, 9);
	flag2 = Wire.endTransmission();
	
	Wire.beginTransmission(0x38);
	flag1 = Wire.write(start, 2);
	flag2 = Wire.endTransmission();
    
    delay(100);
	
}
	
