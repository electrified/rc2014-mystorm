; doke &h8224,&hc000
; print usr(0)
org $0000
  DEFC data_port = $2500
setup:
  ld a, (data_port)
  jp setup
