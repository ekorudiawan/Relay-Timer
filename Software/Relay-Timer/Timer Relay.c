/*****************************************************
PROSEDUR PENGGUNAAN
SECARA DEFAULT TAMPILAN LCD AKAN MENAMPILKAN JAM DAN TANGGAL
UNTUK MELAKUKAN PENGATURAN WAKTU NYALA/MATI SETIAP BEBAN DAPAT MENEKAN TOMBOL PUSHBUTTON
SETELAH TOMBOL DITEKAN ANDA AKAN DIMINTA UNTUK MEMASUKKAN WAKTU ON DAN WAKTU OFF MELALUI KEYPAD
PADA SAAT DI LCD MUNCUL TULISAN TIMER ON KETIK JAM YANG AKAN DIMASUKKAN KE SETTINGAN
FORMAT DATA YANG DIMASUKKAN ADALAH SEBAGAI BERIKUT 
CONTOH : 
08*15 
KEMUDIAN DIAKHIRI DENGAN MENEKAN #
FORMAT JAM ADALAH 24 JAM
SETINGAN JAM AKAN OTOMATIS DIMASUKKAN KE EEPROM
ANDA BISA MELIHAT SETTINGAN NYALA/MATI SETIAP BEBAN DENGAN MENEKAN HURUF 'A' 'B' 'C' ATAU 'D' PADA KEYPAD, PADA SAAT LCD MENAMPILKAN JAM DAN TANGGAL
*****************************************************/

#include <mega8535.h>
#include <delay.h>
#include <stdio.h>

// I2C Bus functions
#asm
   .equ __i2c_port=0x15 ;PORTC
   .equ __sda_bit=1
   .equ __scl_bit=0
#endasm
#include <i2c.h>

// DS1307 Real Time Clock functions
#include <ds1307.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define  SW_BEBAN1   PINB.0
#define  SW_BEBAN2   PINB.1
#define  SW_BEBAN3   PINB.2
#define  SW_BEBAN4   PINB.3

#define  BEBAN1      PORTC.4
#define  BEBAN2      PORTC.5
#define  BEBAN3      PORTC.6
#define  BEBAN4      PORTC.7

#define  DDR_KEYPAD  DDRD
#define  KEYPAD_OUT  PORTD
#define  KEYPAD_IN   PIND

unsigned char jam, menit, detik;
unsigned char x, tanggal, bulan, tahun;

unsigned char jamTimerOn[4], menitTimerOn[4], jamTimerOff[4], menitTimerOff[4];
eeprom unsigned char _jamTimerOn[4], _menitTimerOn[4], _jamTimerOff[4], _menitTimerOff[4];

char dataKeypad[16];
char bufferLcd1[16], bufferLcd2[16];    

void bacaRTC() {
   rtc_get_time(&jam,&menit,&detik);  
   rtc_get_date(&x,&tanggal,&bulan,&tahun);
}            

void clearDataKeypad() {
   int i;
   for(i=0;i<16;i++) {
      dataKeypad[i]=0;
   }
}

void scanKeypad(char limiter, int display, unsigned char startX, unsigned char startY) {    
   unsigned char counter=0;  
   bit selesai = 0;     
   clearDataKeypad();
   while(!selesai) {
      lcd_gotoxy(startX,startY);
      KEYPAD_OUT=0b01111111;  
      delay_ms(30);  
      if(KEYPAD_IN.0==0) {      
         if(limiter=='*') {
            selesai = 1;
         }
         else {                              
            dataKeypad[counter]='*';   
            if(display) {       
               lcd_gotoxy(counter+startX,startY);        
               lcd_putchar(dataKeypad[counter]);  
            }
            counter++;     
         }
         delay_ms(200);   
      }
      if(KEYPAD_IN.1==0) {   
         if(limiter=='7') {
            selesai = 1;
         }
         else {         
            dataKeypad[counter]='7';    
            if(display) {
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]); 
            } 
            counter++;    
         }           
         delay_ms(200);  
      }
      if(KEYPAD_IN.2==0) {  
         if(limiter=='4') {
            selesai = 1;
         }
         else {   
            dataKeypad[counter]='4';   
            if(display) {    
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]); 
            } 
            counter++; 
         }     
         delay_ms(200);
      }
      if(KEYPAD_IN.3==0) {      
         if(limiter=='1') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='1';  
            if(display) {   
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]);    
            }
            counter++;  
         }
         delay_ms(200);  
      }              
      KEYPAD_OUT=0b10111111;  
      delay_ms(30);  
      if(KEYPAD_IN.0==0) {    
         if(limiter=='0') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='0';    
            if(display) {
               lcd_gotoxy(counter+startX,startY);         
               lcd_putchar(dataKeypad[counter]);  
            } 
            counter++; 
         }    
         delay_ms(200);    
      }
      if(KEYPAD_IN.1==0) {    
         if(limiter=='8') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='8';   
            if(display) {
               lcd_gotoxy(counter+startX,startY);     
               lcd_putchar(dataKeypad[counter]);     
            }
            counter++; 
         }    
         delay_ms(200);      
      }
      if(KEYPAD_IN.2==0) {   
         if(limiter=='5') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='5'; 
            if(display) {
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]);  
            }  
            counter++;  
         }
         delay_ms(200); 
      }
      if(KEYPAD_IN.3==0) {     
         if(limiter=='2') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='2';    
            if(display) { 
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]); 
            }  
            counter++; 
         }    
         delay_ms(200);  
      }      
      KEYPAD_OUT=0b11011111;  
      delay_ms(30);  
      if(KEYPAD_IN.0==0) {  
         if(limiter=='#') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='#';   
            if(display) {  
               lcd_gotoxy(counter+startX,startY);     
               lcd_putchar(dataKeypad[counter]); 
            } 
            counter++; 
         }    
         delay_ms(200);  
      }
      if(KEYPAD_IN.1==0) {   
         if(limiter=='9') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='9';   
            if(display) {
               lcd_gotoxy(counter+startX,startY);     
               lcd_putchar(dataKeypad[counter]); 
            } 
            counter++;    
         }
         delay_ms(100); 
      }
      if(KEYPAD_IN.2==0) {     
         if(limiter=='6') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='6';  
            if(display) {
               lcd_gotoxy(counter+startX,startY);  
               lcd_putchar(dataKeypad[counter]);  
            }
            counter++;  
         }
         delay_ms(200);  
      }
      if(KEYPAD_IN.3==0) {    
         if(limiter=='3') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='3';  
            if(display) {
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]); 
            }   
            counter++;      
         }
         delay_ms(200); 
      }  
      KEYPAD_OUT=0b11101111;  
      delay_ms(30);  
      if(KEYPAD_IN.0==0) {     
         if(limiter=='D') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='D';
            if(display) {   
               lcd_gotoxy(counter+startX,startY);      
               lcd_putchar(dataKeypad[counter]);   
            } 
            counter++;  
         }
         delay_ms(200);  
      }
      if(KEYPAD_IN.1==0) { 
         if(limiter=='C') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='C';    
            if(display) {
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]);  
            }
            counter++; 
         }   
         delay_ms(200);  
      }
      if(KEYPAD_IN.2==0) {    
         if(limiter=='B') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='B'; 
            if(display) {    
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]); 
            } 
            counter++;   
         }
         delay_ms(200); 
      }
      if(KEYPAD_IN.3==0) {      
         if(limiter=='A') {
            selesai = 1;
         }
         else {
            dataKeypad[counter]='A';  
            if(display) {    
               lcd_gotoxy(counter+startX,startY); 
               lcd_putchar(dataKeypad[counter]);    
            }
            counter++;  
         }
         delay_ms(200); 
      } 
   }                      
}        

void menuSetting1() {
   char jOn[3], dOn[3], jOff[3], dOff[3];   
   bit inputSalah = 0; 
   int i;         
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Beban1");  
   delay_ms(1000);            
   
   for(i=0;i<3;i++) {
      jOn[i]=0;
      dOn[i]=0;
      jOff[i]=0;
      dOff[i]=0;
   }   
     
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer On    ");
   scanKeypad('#',1,0,1);       
   jOn[0]=dataKeypad[0];
   jOn[1]=dataKeypad[1];
   dOn[0]=dataKeypad[3];
   dOn[1]=dataKeypad[4]; 
   sscanf(jOn,"%d",&jamTimerOn[0]);
   sscanf(dOn,"%d",&menitTimerOn[0]);    
   // SIMPAN KE EEPROM
   _jamTimerOn[0] = jamTimerOn[0];
   _menitTimerOn[0] = menitTimerOn[0];
       
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Off   ");
   scanKeypad('#',1,0,1);   
     
   jOff[0]=dataKeypad[0];
   jOff[1]=dataKeypad[1];
   dOff[0]=dataKeypad[3];
   dOff[1]=dataKeypad[4];  
      
   sscanf(jOff,"%d",&jamTimerOff[0]);             
   sscanf(dOff,"%d",&menitTimerOff[0]); 
    
   // SIMPAN KE EEPROM
   _jamTimerOff[0] = jamTimerOff[0];
   _menitTimerOff[0] = menitTimerOff[0];
            
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Setting Finish  ");  
   delay_ms(1000); 
}

void menuSetting2() {
   char jOn[3], dOn[3], jOff[3], dOff[3];   
   bit inputSalah = 0; 
   int i;         
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Beban2");  
   delay_ms(1000);            
   
   for(i=0;i<3;i++) {
      jOn[i]=0;
      dOn[i]=0;
      jOff[i]=0;
      dOff[i]=0;
   }   
     
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer On    ");
   scanKeypad('#',1,0,1);       
   jOn[0]=dataKeypad[0];
   jOn[1]=dataKeypad[1];
   dOn[0]=dataKeypad[3];
   dOn[1]=dataKeypad[4]; 
   sscanf(jOn,"%d",&jamTimerOn[1]);
   sscanf(dOn,"%d",&menitTimerOn[1]);    
   
   // SIMPAN KE EEPROM
   _jamTimerOn[1] = jamTimerOn[1];
   _menitTimerOn[1] = menitTimerOn[1];
        
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Off   ");
   scanKeypad('#',1,0,1);   
     
   jOff[0]=dataKeypad[0];
   jOff[1]=dataKeypad[1];
   dOff[0]=dataKeypad[3];
   dOff[1]=dataKeypad[4];  
      
   sscanf(jOff,"%d",&jamTimerOff[1]);             
   sscanf(dOff,"%d",&menitTimerOff[1]);
   
   // SIMPAN KE EEPROM
   _jamTimerOff[1] = jamTimerOff[1];
   _menitTimerOff[1] = menitTimerOff[1];
            
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Setting Finish  ");  
   delay_ms(1000); 
}

void menuSetting3() {
   char jOn[3], dOn[3], jOff[3], dOff[3];   
   bit inputSalah = 0; 
   int i;         
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Beban3");  
   delay_ms(1000);            
   
   for(i=0;i<3;i++) {
      jOn[i]=0;
      dOn[i]=0;
      jOff[i]=0;
      dOff[i]=0;
   }   
     
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer On    ");
   scanKeypad('#',1,0,1);       
   jOn[0]=dataKeypad[0];
   jOn[1]=dataKeypad[1];
   dOn[0]=dataKeypad[3];
   dOn[1]=dataKeypad[4]; 
   sscanf(jOn,"%d",&jamTimerOn[2]);
   sscanf(dOn,"%d",&menitTimerOn[2]);   
    
   // SIMPAN KE EEPROM
   _jamTimerOn[2] = jamTimerOn[2];
   _menitTimerOn[2] = menitTimerOn[2];     
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Off   ");
   scanKeypad('#',1,0,1);   
     
   jOff[0]=dataKeypad[0];
   jOff[1]=dataKeypad[1];
   dOff[0]=dataKeypad[3];
   dOff[1]=dataKeypad[4];  
      
   sscanf(jOff,"%d",&jamTimerOff[2]);             
   sscanf(dOff,"%d",&menitTimerOff[2]); 
   
   // SIMPAN KE EEPROM
   _jamTimerOff[2] = jamTimerOff[2];
   _menitTimerOff[2] = menitTimerOff[2]; 
            
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Setting Finish  ");  
   delay_ms(1000); 
}

void menuSetting4() {
   char jOn[3], dOn[3], jOff[3], dOff[3];   
   bit inputSalah = 0; 
   int i;         
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Beban4");  
   delay_ms(1000);            
   
   for(i=0;i<3;i++) {
      jOn[i]=0;
      dOn[i]=0;
      jOff[i]=0;
      dOff[i]=0;
   }   
     
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer On    ");
   scanKeypad('#',1,0,1);       
   jOn[0]=dataKeypad[0];
   jOn[1]=dataKeypad[1];
   dOn[0]=dataKeypad[3];
   dOn[1]=dataKeypad[4]; 
   sscanf(jOn,"%d",&jamTimerOn[3]);
   sscanf(dOn,"%d",&menitTimerOn[3]);   
   
   // SIMPAN KE EEPROM
   _jamTimerOn[3] = jamTimerOn[3];
   _menitTimerOn[3] = menitTimerOn[3]; 
         
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Set Timer Off   ");
   scanKeypad('#',1,0,1);   
     
   jOff[0]=dataKeypad[0];
   jOff[1]=dataKeypad[1];
   dOff[0]=dataKeypad[3];
   dOff[1]=dataKeypad[4];  
      
   sscanf(jOff,"%d",&jamTimerOff[3]);             
   sscanf(dOff,"%d",&menitTimerOff[3]);  
   
   // SIMPAN KE EEPROM
   _jamTimerOff[3] = jamTimerOff[3];
   _menitTimerOff[3] = menitTimerOff[3]; 
           
   lcd_clear();
   lcd_gotoxy(0,0);
   lcd_puts("Setting Finish  ");  
   delay_ms(1000); 
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=P State2=P State1=P State0=P 
PORTB=0x0F;
DDRB=0x00;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=1 State6=1 State5=1 State4=1 State3=T State2=T State1=T State0=T 
PORTC=0xF0;
DDRC=0xF0;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=P State6=P State5=P State4=P State3=0 State2=0 State1=0 State0=0 
PORTD=0xFF;
DDRD=0xF0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// I2C Bus initialization
i2c_init();

// DS1307 Real Time Clock initialization
// Square wave output on pin SQW/OUT: Off
// SQW/OUT pin state: 0
rtc_init(0,0,0);

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTA Bit 0
// RD - PORTA Bit 1
// EN - PORTA Bit 2
// D4 - PORTA Bit 4
// D5 - PORTA Bit 5
// D6 - PORTA Bit 6
// D7 - PORTA Bit 7
// Characters/line: 16
lcd_init(16);
lcd_clear();
lcd_gotoxy(0,0);

// UNCOMMENT BARIS INI JIKA INGIN SETTING RTC
//rtc_set_time(21,27,0);
//rtc_set_date(3,22,3,13);


// MATIKAN SEMUA RELAY
BEBAN1=0;
BEBAN2=0;
BEBAN3=0;
BEBAN4=0;

// AMBIL DATA DARI EEPROM
jamTimerOn[0] = _jamTimerOn[0];
menitTimerOn[0] = _menitTimerOn[0];
jamTimerOff[0] = _jamTimerOff[0];
menitTimerOff[0] = _menitTimerOff[0]; 
jamTimerOn[1] = _jamTimerOn[1];
menitTimerOn[1] = _menitTimerOn[1];
jamTimerOff[1] = _jamTimerOff[1];
menitTimerOff[1] = _menitTimerOff[1]; 
jamTimerOn[2] = _jamTimerOn[2];
menitTimerOn[2] = _menitTimerOn[2];
jamTimerOff[2] = _jamTimerOff[2];
menitTimerOff[2] = _menitTimerOff[2]; 
jamTimerOn[3] = _jamTimerOn[3];
menitTimerOn[3] = _menitTimerOn[3];
jamTimerOff[3] = _jamTimerOff[3];
menitTimerOff[3] = _menitTimerOff[3];           

while (1) {  
   char key = 0;       
   KEYPAD_OUT=0b11101111;  
   delay_ms(30);  
   if(KEYPAD_IN.0==0) {           
      // AMBIL DATA DARI EEPROM     
      jamTimerOn[3] = _jamTimerOn[3];
      menitTimerOn[3] = _menitTimerOn[3];
      jamTimerOff[3] = _jamTimerOff[3];
      menitTimerOff[3] = _menitTimerOff[3];   
      sprintf(bufferLcd1,"T4 On  > %2d:%2d ",jamTimerOn[3],menitTimerOn[3]);
      sprintf(bufferLcd2,"T4 Off > %2d:%2d ",jamTimerOff[3],menitTimerOff[3]);   
      lcd_clear();    
      lcd_gotoxy(0,0);
      lcd_puts(bufferLcd1);
      lcd_gotoxy(0,1);
      lcd_puts(bufferLcd2);
      delay_ms(2000);  
   }
   else if(KEYPAD_IN.1==0) {  
      // AMBIL DATA DARI EEPROM 
      jamTimerOn[2] = _jamTimerOn[2];
      menitTimerOn[2] = _menitTimerOn[2];
      jamTimerOff[2] = _jamTimerOff[2];
      menitTimerOff[2] = _menitTimerOff[2]; 
      sprintf(bufferLcd1,"T3 On  > %2d:%2d ",jamTimerOn[2],menitTimerOn[2]);
      sprintf(bufferLcd2,"T3 Off > %2d:%2d ",jamTimerOff[2],menitTimerOff[2]);   
      lcd_clear();     
      lcd_gotoxy(0,0);
      lcd_puts(bufferLcd1);
      lcd_gotoxy(0,1);
      lcd_puts(bufferLcd2);
      delay_ms(2000);    
   }
   else if(KEYPAD_IN.2==0) {    
      // AMBIL DATA DARI EEPROM
      jamTimerOn[1] = _jamTimerOn[1];
      menitTimerOn[1] = _menitTimerOn[1];
      jamTimerOff[1] = _jamTimerOff[1];
      menitTimerOff[1] = _menitTimerOff[1];
      sprintf(bufferLcd1,"T2 On  > %2d:%2d ",jamTimerOn[1],menitTimerOn[1]);
      sprintf(bufferLcd2,"T2 Off > %2d:%2d ",jamTimerOff[1],menitTimerOff[1]);   
      lcd_clear();     
      lcd_gotoxy(0,0);
      lcd_puts(bufferLcd1);
      lcd_gotoxy(0,1);
      lcd_puts(bufferLcd2);
      delay_ms(2000); 
   }       
   else if(KEYPAD_IN.3==0) {   
      // AMBIL DATA DARI EEPROM   
      jamTimerOn[0] = _jamTimerOn[0];
      menitTimerOn[0] = _menitTimerOn[0];
      jamTimerOff[0] = _jamTimerOff[0];
      menitTimerOff[0] = _menitTimerOff[0];
      sprintf(bufferLcd1,"T1 On  > %2d:%2d ",jamTimerOn[0],menitTimerOn[0]);
      sprintf(bufferLcd2,"T1 Off > %2d:%2d ",jamTimerOff[0],menitTimerOff[0]);   
      lcd_clear();  
      lcd_gotoxy(0,0);
      lcd_puts(bufferLcd1);
      lcd_gotoxy(0,1);
      lcd_puts(bufferLcd2);
      delay_ms(2000);    
   } 
   if(!SW_BEBAN1) {
      menuSetting1();
   }
   else if(!SW_BEBAN2) {
      menuSetting2();
   } 
   else if(!SW_BEBAN3) {
      menuSetting3();
   }
   else if(!SW_BEBAN4) {
      menuSetting4();
   }    
   else{ 
      lcd_clear();
      bacaRTC();
      sprintf(bufferLcd1,"Jam => %2d:%2d:%2d ",jam,menit,detik);  
      lcd_gotoxy(0,0);          
      lcd_puts(bufferLcd1); 
      sprintf(bufferLcd2,"Tgl => %2d/%2d/%2d ",tanggal,bulan,tahun);  
      lcd_gotoxy(0,1);          
      lcd_puts(bufferLcd2);    
         
      // AMBIL DATA DARI EEPROM     
      jamTimerOn[0] = _jamTimerOn[0];
      menitTimerOn[0] = _menitTimerOn[0];
      jamTimerOff[0] = _jamTimerOff[0];
      menitTimerOff[0] = _menitTimerOff[0];
               
      if(jam==jamTimerOn[0]&&menit==menitTimerOn[0]) {
         BEBAN1 = 1;
      }     
      else if(jam==jamTimerOff[0]&&menit==menitTimerOff[0]) {
         BEBAN1 = 0;
      }    
               
      // AMBIL DATA DARI EEPROM    
      jamTimerOn[1] = _jamTimerOn[1];
      menitTimerOn[1] = _menitTimerOn[1];
      jamTimerOff[1] = _jamTimerOff[1];
      menitTimerOff[1] = _menitTimerOff[1];  
               
      if(jam==jamTimerOn[1]&&menit==menitTimerOn[1]) {
         BEBAN2 = 1;
      }     
      else if(jam==jamTimerOff[1]&&menit==menitTimerOff[1]){
         BEBAN2 = 0;
      }
               
      // AMBIL DATA DARI EEPROM     
      jamTimerOn[2] = _jamTimerOn[2];
      menitTimerOn[2] = _menitTimerOn[2];
      jamTimerOff[2] = _jamTimerOff[2];
      menitTimerOff[2] = _menitTimerOff[2];   
      if(jam==jamTimerOn[2]&&menit==_menitTimerOn[2]) {
         BEBAN3 = 1;
      }     
      else if(jam==jamTimerOff[2]&&menit==_menitTimerOff[2]){
         BEBAN3 = 0;
      }   
               
      // AMBIL DATA DARI EEPROM    
      jamTimerOn[3] = _jamTimerOn[3];
      menitTimerOn[3] = _menitTimerOn[3];
      jamTimerOff[3] = _jamTimerOff[3];
      menitTimerOff[3] = _menitTimerOff[3];    
               
      if(jam==jamTimerOn[3]&&menit==menitTimerOn[3]) {
         BEBAN4 = 1;
      }     
      else if(jam==jamTimerOff[3]&&menit==menitTimerOff[3]) {
         BEBAN4 = 0;
      } 
   }                                  
   delay_ms(500);     
}
}
