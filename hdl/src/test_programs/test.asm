; doke &h8224,&hc000
; print usr(0)
; sigrok-cli --driver saleae-logic16 --config samplerate=25Mhz --channels 0=D0,1=D1,2=D2,3=D3,4=D4,5=D5,6=D6,7=D7,9=RD,10=WR,11=MREQ,13=M1 --samples 1M --output-file z80
org $C000
  DEFC data_port = $2500

setup:
  ld a, (data_port)
  jp setup
