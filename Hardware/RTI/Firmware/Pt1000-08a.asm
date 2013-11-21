	list p=12f683
	#include <p12f683.inc>
	radix dec
; Begin
	R0L EQU 0x20
	R0H EQU 0x21
	R1L EQU 0x22
	R1H EQU 0x23
	R2L EQU 0x24
	R2H EQU 0x25
	R3L EQU 0x26
	R3H EQU 0x27
	R4L EQU 0x28
	R4H EQU 0x29
	R5L EQU 0x2A
	R5H EQU 0x2B
	ORG 0x0000
	BCF PCLATH,3
	BCF PCLATH,4
	GOTO L0003
	ORG 0x0004
	RETFIE
L0003:
; 1: Define CONF_WORD = 0x3314
; 2: 
; 3: 
; 4: 
; 5: 
; 6: 
; 7: 
; 8: Define CLOCK_FREQUENCY = 4
; 9: 
; 10: TRISIO.1 = 1
	BSF STATUS,RP0
	BSF 0x05,1
; 11: TRISIO.2 = 0
	BCF 0x05,2
; 12: TRISIO.5 = 0
	BCF 0x05,5
; 13: 
; 14: Define ADC_CLOCK = 3
; 15: Define ADC_SAMPLEUS = 50
; 16: AllDigital
	CLRF 0x1F
	BCF STATUS,RP0
	MOVLW 0x07
	MOVWF 0x19
; 17: Dim sig As Word
;       The address of 'sig' is 0x2C
	sig EQU 0x2C
; 18: Dim pta As Word
;       The address of 'pta' is 0x2E
	pta EQU 0x2E
; 19: Dim i As Byte
;       The address of 'i' is 0x30
	i EQU 0x30
; 20: Dim l As Byte
;       The address of 'l' is 0x31
	l EQU 0x31
; 21: Dim p As Byte
;       The address of 'p' is 0x32
	p EQU 0x32
; 22: Dim pt As Word
;       The address of 'pt' is 0x33
	pt EQU 0x33
; 23: 
; 24:  'ADCON0 = %1100000
; 25: ANSEL = 8
	BSF STATUS,RP0
	MOVLW 0x08
	MOVWF 0x1F
; 26: 
	BCF STATUS,RP0
; 27: PWMon 1, 9
	MOVLW 0x3F
	BSF STATUS,RP0
	MOVWF PR2
	BCF TRISIO,2
	BCF STATUS,RP0
	CLRF CCPR1L
	BCF CCP1CON,DC1B1
	BCF CCP1CON,DC1B0
	BCF T2CON,T2CKPS0
	BCF T2CON,T2CKPS1
	BSF T2CON,TMR2ON
	MOVLW 0x0C
	IORWF CCP1CON,F
; 28: Gosub eefill
	CALL L0002
; 29: 
; 30: OPTION_REG = %10001111
	BSF STATUS,RP0
	MOVLW 0x8F
	MOVWF 0x01
	BCF STATUS,RP0
; 31: start: 
L0001:
; 32: ASM:        clrwdt
	       clrwdt
; 33: pta = 0
	CLRF 0x2E
	CLRF 0x2F
; 34: GPIO.5 = 0
	BCF 0x05,5
; 35: WaitMs 10
	MOVLW 0x0A
	MOVWF R0L
	CLRF R0H
	CALL W001
; 36: ASM:        clrwdt
	       clrwdt
; 37: For l = 0 To 7
	CLRF 0x31
L0004:
	MOVF 0x31,W
	SUBLW 0x07
	BTFSS STATUS,C
	GOTO L0005
; 38: Adcin 3, pt
	BSF ADCON0,ADFM
	BSF STATUS,RP0
	MOVLW 0x30
	IORWF ANSEL,F
	MOVLW 0x03
	BCF STATUS,RP0
	MOVWF R0L
	CALL A001
	BSF STATUS,RP0
	MOVF ADRESL,W
	BCF STATUS,RP0
	MOVWF 0x33
	MOVF ADRESH,W
	MOVWF 0x34
; 39: pta = pta + pt
	MOVF 0x2E,W
	ADDWF 0x33,W
	MOVWF 0x2E
	MOVF 0x2F,W
	BTFSC STATUS,C
	ADDLW 0x01
	ADDWF 0x34,W
	MOVWF 0x2F
; 40: Next l
	MOVLW 0x01
	ADDWF 0x31,F
	BTFSS STATUS,C
	GOTO L0004
L0005:	MOVLW 0x1F
	ANDWF STATUS,F
; 41: GPIO.5 = 1
	BSF 0x05,5
; 42: pt = pta / 8
	MOVF 0x2E,W
	MOVWF R0L
	MOVF 0x2F,W
	MOVWF R0H
	MOVLW 0x08
	MOVWF R1L
	CLRF R1H
	CALL D001
	MOVWF 0x33
	MOVF R0H,W
	MOVWF 0x34
; 43: If pt < 456 Then pt = 456
	MOVF 0x33,W
	MOVWF R0L
	MOVF 0x34,W
	MOVWF R0H
	MOVLW 0x01
	MOVWF R1H
	MOVLW 0xC8
	CALL C004
	BTFSS STATUS,Z
	GOTO L0006
	MOVLW 0xC8
	MOVWF 0x33
	MOVLW 0x01
	MOVWF 0x34
L0006:	MOVLW 0x1F
	ANDWF STATUS,F
; 44: If pt > 651 Then pt = 651
	MOVF 0x33,W
	MOVWF R0L
	MOVF 0x34,W
	MOVWF R0H
	MOVLW 0x02
	MOVWF R1H
	MOVLW 0x8B
	CALL C003
	BTFSS STATUS,Z
	GOTO L0007
	MOVLW 0x8B
	MOVWF 0x33
	MOVLW 0x02
	MOVWF 0x34
L0007:	MOVLW 0x1F
	ANDWF STATUS,F
; 45: p = pt - 456 '(0 To 196)
;       The address of 'oshonsoft_temp_1' is 0x35
	oshonsoft_temp_1 EQU 0x35
	MOVLW 0xC8
	SUBWF 0x33,W
	MOVWF 0x35
	MOVLW 0x01
	BTFSS STATUS,C
	ADDLW 0x01
	SUBWF 0x34,W
	MOVWF 0x36
	MOVF 0x35,W
	MOVWF 0x32
; 46: Read p, i
	MOVF 0x32,W
	BSF STATUS,RP0
	MOVWF EEADR
	BSF EECON1,RD
	NOP
	MOVF EEDATA,W
	BCF STATUS,RP0
	MOVWF 0x30
; 47: PWMduty 1, i
	MOVF 0x30,W
	MOVWF R0L
	BTFSC R0L,0
	BSF CCP1CON,DC1B0
	BTFSS R0L,0
	BCF CCP1CON,DC1B0
	BTFSC R0L,1
	BSF CCP1CON,DC1B1
	BTFSS R0L,1
	BCF CCP1CON,DC1B1
	BCF STATUS,C
	RRF R0L,F
	BCF STATUS,C
	RRF R0L,W
	MOVWF CCPR1L
; 48: ASM:        clrwdt
	       clrwdt
; 49: WaitMs 255
	MOVLW 0xFF
	MOVWF R0L
	CLRF R0H
	CALL W001
; 50: ASM:        clrwdt
	       clrwdt
; 51: Goto start
	GOTO L0001
; 52: End
L0008:	GOTO L0008
; 53: eefill: 
L0002:
; 54: EEPROM 0, 0
; 55: EEPROM 1, 1
; 56: EEPROM 2, 2
; 57: EEPROM 3, 3
; 58: EEPROM 4, 4
; 59: EEPROM 5, 4
; 60: EEPROM 6, 5
; 61: EEPROM 7, 6
; 62: EEPROM 8, 7
; 63: EEPROM 9, 8
; 64: EEPROM 10, 8
; 65: EEPROM 11, 9
; 66: EEPROM 12, 10
; 67: EEPROM 13, 11
; 68: EEPROM 14, 12
; 69: EEPROM 15, 13
; 70: EEPROM 16, 13
; 71: EEPROM 17, 14
; 72: EEPROM 18, 15
; 73: EEPROM 19, 16
; 74: EEPROM 20, 17
; 75: EEPROM 21, 18
; 76: EEPROM 22, 19
; 77: EEPROM 23, 20
; 78: EEPROM 24, 20
; 79: EEPROM 25, 21
; 80: EEPROM 26, 22
; 81: EEPROM 27, 23
; 82: EEPROM 28, 24
; 83: EEPROM 29, 26
; 84: EEPROM 30, 27
; 85: EEPROM 31, 28
; 86: EEPROM 32, 29
; 87: EEPROM 33, 29
; 88: EEPROM 34, 30
; 89: EEPROM 35, 31
; 90: EEPROM 36, 32
; 91: EEPROM 37, 33
; 92: EEPROM 38, 34
; 93: EEPROM 39, 35
; 94: EEPROM 40, 36
; 95: EEPROM 41, 37
; 96: EEPROM 42, 38
; 97: EEPROM 43, 39
; 98: EEPROM 44, 40
; 99: EEPROM 45, 41
; 100: EEPROM 46, 42
; 101: EEPROM 47, 43
; 102: EEPROM 48, 44
; 103: EEPROM 49, 45
; 104: EEPROM 50, 46
; 105: EEPROM 51, 47
; 106: EEPROM 52, 48
; 107: EEPROM 53, 49
; 108: EEPROM 54, 50
; 109: EEPROM 55, 51
; 110: EEPROM 56, 52
; 111: EEPROM 57, 53
; 112: EEPROM 58, 54
; 113: EEPROM 59, 55
; 114: EEPROM 60, 56
; 115: EEPROM 61, 57
; 116: EEPROM 62, 58
; 117: EEPROM 63, 59
; 118: EEPROM 64, 60
; 119: EEPROM 65, 61
; 120: EEPROM 66, 62
; 121: EEPROM 67, 63
; 122: EEPROM 68, 64
; 123: EEPROM 69, 65
; 124: EEPROM 70, 66
; 125: EEPROM 71, 67
; 126: EEPROM 72, 68
; 127: EEPROM 73, 69
; 128: EEPROM 74, 70
; 129: EEPROM 75, 71
; 130: EEPROM 76, 72
; 131: EEPROM 77, 74
; 132: EEPROM 78, 75
; 133: EEPROM 79, 77
; 134: EEPROM 80, 78
; 135: EEPROM 81, 79
; 136: EEPROM 82, 80
; 137: EEPROM 83, 81
; 138: EEPROM 84, 82
; 139: EEPROM 85, 84
; 140: EEPROM 86, 85
; 141: EEPROM 87, 86
; 142: EEPROM 88, 87
; 143: EEPROM 89, 88
; 144: EEPROM 90, 89
; 145: EEPROM 91, 90
; 146: EEPROM 92, 91
; 147: EEPROM 93, 93
; 148: EEPROM 94, 94
; 149: EEPROM 95, 95
; 150: EEPROM 96, 96
; 151: EEPROM 97, 97
; 152: EEPROM 98, 99
; 153: EEPROM 99, 100
; 154: EEPROM 100, 101
; 155: EEPROM 101, 102
; 156: EEPROM 102, 104
; 157: EEPROM 103, 105
; 158: EEPROM 104, 106
; 159: EEPROM 105, 107
; 160: EEPROM 106, 109
; 161: EEPROM 107, 110
; 162: EEPROM 108, 111
; 163: EEPROM 109, 112
; 164: EEPROM 110, 114
; 165: EEPROM 111, 115
; 166: EEPROM 112, 116
; 167: EEPROM 113, 118
; 168: EEPROM 114, 119
; 169: EEPROM 115, 120
; 170: EEPROM 116, 121
; 171: EEPROM 117, 123
; 172: EEPROM 118, 124
; 173: EEPROM 119, 125
; 174: EEPROM 120, 128
; 175: EEPROM 121, 129
; 176: EEPROM 122, 130
; 177: EEPROM 123, 132
; 178: EEPROM 124, 133
; 179: EEPROM 125, 135
; 180: EEPROM 126, 136
; 181: EEPROM 127, 137
; 182: EEPROM 128, 139
; 183: EEPROM 129, 140
; 184: EEPROM 130, 141
; 185: EEPROM 131, 143
; 186: EEPROM 132, 144
; 187: EEPROM 133, 146
; 188: EEPROM 134, 147
; 189: EEPROM 135, 149
; 190: EEPROM 136, 150
; 191: EEPROM 137, 152
; 192: EEPROM 138, 153
; 193: EEPROM 139, 154
; 194: EEPROM 140, 156
; 195: EEPROM 141, 157
; 196: EEPROM 142, 159
; 197: EEPROM 143, 160
; 198: EEPROM 144, 162
; 199: EEPROM 145, 163
; 200: EEPROM 146, 165
; 201: EEPROM 147, 167
; 202: EEPROM 148, 168
; 203: EEPROM 149, 170
; 204: EEPROM 150, 171
; 205: EEPROM 151, 173
; 206: EEPROM 152, 174
; 207: EEPROM 153, 176
; 208: EEPROM 154, 177
; 209: EEPROM 155, 180
; 210: EEPROM 156, 182
; 211: EEPROM 157, 183
; 212: EEPROM 158, 185
; 213: EEPROM 159, 187
; 214: EEPROM 160, 188
; 215: EEPROM 161, 190
; 216: EEPROM 162, 192
; 217: EEPROM 163, 193
; 218: EEPROM 164, 195
; 219: EEPROM 165, 197
; 220: EEPROM 166, 198
; 221: EEPROM 167, 200
; 222: EEPROM 168, 202
; 223: EEPROM 169, 203
; 224: EEPROM 170, 205
; 225: EEPROM 171, 207
; 226: EEPROM 172, 209
; 227: EEPROM 173, 210
; 228: EEPROM 174, 212
; 229: EEPROM 175, 214
; 230: EEPROM 176, 216
; 231: EEPROM 177, 218
; 232: EEPROM 178, 219
; 233: EEPROM 179, 221
; 234: EEPROM 180, 223
; 235: EEPROM 181, 225
; 236: EEPROM 182, 227
; 237: EEPROM 183, 230
; 238: EEPROM 184, 231
; 239: EEPROM 185, 233
; 240: EEPROM 186, 235
; 241: EEPROM 187, 237
; 242: EEPROM 188, 239
; 243: EEPROM 189, 241
; 244: EEPROM 190, 243
; 245: EEPROM 191, 245
; 246: EEPROM 192, 247
; 247: EEPROM 193, 249
; 248: EEPROM 194, 251
; 249: EEPROM 195, 253
; 250: EEPROM 196, 255
; 251: 
; 252: 
; 253: 
; 254: Return
	RETURN
; End of program
L0009:	GOTO L0009
; Division Routine
D001:	MOVLW 0x10
	MOVWF R3L
	CLRF R2H
	CLRF R2L
D002:	RLF R0H,W
	RLF R2L,F
	RLF R2H,F
	MOVF R1L,W
	SUBWF R2L,F
	MOVF R1H,W
	BTFSS STATUS,C
	INCFSZ R1H,W
	SUBWF R2H,F
	BTFSC STATUS,C
	GOTO D003
	MOVF R1L,W
	ADDWF R2L,F
	MOVF R1H,W
	BTFSC STATUS,C
	INCFSZ R1H,W
	ADDWF R2H,F
	BCF STATUS,C
D003:	RLF R0L,F
	RLF R0H,F
	DECFSZ R3L,F
	GOTO D002
	MOVF R0L,W
	RETURN
; Comparison Routine
C001:	MOVWF R1L
	MOVLW 0x05
	GOTO C007
C002:	MOVWF R1L
	MOVLW 0x02
	GOTO C007
C003:	MOVWF R1L
	MOVLW 0x06
	GOTO C007
C004:	MOVWF R1L
	MOVLW 0x03
	GOTO C007
C005:	MOVWF R1L
	MOVLW 0x04
	GOTO C007
C006:	MOVWF R1L
	MOVLW 0x01
	GOTO C007
C007:	MOVWF R4L
	MOVF R1H,W
	SUBWF R0H,W
	BTFSS STATUS,Z
	GOTO C008
	MOVF R1L,W
	SUBWF R0L,W
C008:	MOVLW 0x04
	BTFSC STATUS,C
	MOVLW 0x01
	BTFSC STATUS,Z
	MOVLW 0x02
	ANDWF R4L,W
	BTFSS STATUS,Z
	MOVLW 0xFF
	RETURN
; Waitms Routine
W001:	MOVF R0L,F
	BTFSC STATUS,Z
	GOTO W002
	CALL W003
	DECF R0L,F
	NOP
	NOP
	NOP
	NOP
	NOP
	GOTO W001
W002:	MOVF R0H,F
	BTFSC STATUS,Z
	RETURN
	CALL W003
	DECF R0H,F
	DECF R0L,F
	GOTO W001
W003:	MOVLW 0x0C
	MOVWF R2H
W004:	DECFSZ R2H,F
	GOTO W004
	NOP
	NOP
	MOVLW 0x12
	MOVWF R1L
W005:	DECFSZ R1L,F
	GOTO W006
	CALL W007
	CALL W007
	NOP
	NOP
	RETURN
W006:	CALL W007
	GOTO W005
W007:	MOVLW 0x0D
	MOVWF R2L
W008:	DECFSZ R2L,F
	GOTO W008
	NOP
	RETURN
; Waitus Routine - Byte Argument
X001:	MOVLW 0x0A
	SUBWF R4L,F
	BTFSS STATUS,C
	RETURN
	GOTO X002
X002:	MOVLW 0x06
	SUBWF R4L,F
	BTFSS STATUS,C
	RETURN
	GOTO X002
; Adcin Routine
A001:	RLF R0L,F
	RLF R0L,F
	MOVLW 0x3C
	ANDWF R0L,F
	MOVLW 0xC0
	ANDWF ADCON0,F
	MOVF R0L,W
	IORWF ADCON0,F
	BSF ADCON0,ADON
	MOVLW 0x32
	MOVWF R4L
	CALL X001
	BSF ADCON0,GO
A002:	BTFSC ADCON0,GO
	GOTO A002
	BCF PIR1,ADIF
	BCF ADCON0,ADON
	RETURN
; Configuration word settings
	ORG 0x2007
	DW 0x3314
; EEPROM data
	ORG 0x2100
	DW 0x00
	DW 0x01
	DW 0x02
	DW 0x03
	DW 0x04
	DW 0x04
	DW 0x05
	DW 0x06
	DW 0x07
	DW 0x08
	DW 0x08
	DW 0x09
	DW 0x0A
	DW 0x0B
	DW 0x0C
	DW 0x0D
	DW 0x0D
	DW 0x0E
	DW 0x0F
	DW 0x10
	DW 0x11
	DW 0x12
	DW 0x13
	DW 0x14
	DW 0x14
	DW 0x15
	DW 0x16
	DW 0x17
	DW 0x18
	DW 0x1A
	DW 0x1B
	DW 0x1C
	DW 0x1D
	DW 0x1D
	DW 0x1E
	DW 0x1F
	DW 0x20
	DW 0x21
	DW 0x22
	DW 0x23
	DW 0x24
	DW 0x25
	DW 0x26
	DW 0x27
	DW 0x28
	DW 0x29
	DW 0x2A
	DW 0x2B
	DW 0x2C
	DW 0x2D
	DW 0x2E
	DW 0x2F
	DW 0x30
	DW 0x31
	DW 0x32
	DW 0x33
	DW 0x34
	DW 0x35
	DW 0x36
	DW 0x37
	DW 0x38
	DW 0x39
	DW 0x3A
	DW 0x3B
	DW 0x3C
	DW 0x3D
	DW 0x3E
	DW 0x3F
	DW 0x40
	DW 0x41
	DW 0x42
	DW 0x43
	DW 0x44
	DW 0x45
	DW 0x46
	DW 0x47
	DW 0x48
	DW 0x4A
	DW 0x4B
	DW 0x4D
	DW 0x4E
	DW 0x4F
	DW 0x50
	DW 0x51
	DW 0x52
	DW 0x54
	DW 0x55
	DW 0x56
	DW 0x57
	DW 0x58
	DW 0x59
	DW 0x5A
	DW 0x5B
	DW 0x5D
	DW 0x5E
	DW 0x5F
	DW 0x60
	DW 0x61
	DW 0x63
	DW 0x64
	DW 0x65
	DW 0x66
	DW 0x68
	DW 0x69
	DW 0x6A
	DW 0x6B
	DW 0x6D
	DW 0x6E
	DW 0x6F
	DW 0x70
	DW 0x72
	DW 0x73
	DW 0x74
	DW 0x76
	DW 0x77
	DW 0x78
	DW 0x79
	DW 0x7B
	DW 0x7C
	DW 0x7D
	DW 0x80
	DW 0x81
	DW 0x82
	DW 0x84
	DW 0x85
	DW 0x87
	DW 0x88
	DW 0x89
	DW 0x8B
	DW 0x8C
	DW 0x8D
	DW 0x8F
	DW 0x90
	DW 0x92
	DW 0x93
	DW 0x95
	DW 0x96
	DW 0x98
	DW 0x99
	DW 0x9A
	DW 0x9C
	DW 0x9D
	DW 0x9F
	DW 0xA0
	DW 0xA2
	DW 0xA3
	DW 0xA5
	DW 0xA7
	DW 0xA8
	DW 0xAA
	DW 0xAB
	DW 0xAD
	DW 0xAE
	DW 0xB0
	DW 0xB1
	DW 0xB4
	DW 0xB6
	DW 0xB7
	DW 0xB9
	DW 0xBB
	DW 0xBC
	DW 0xBE
	DW 0xC0
	DW 0xC1
	DW 0xC3
	DW 0xC5
	DW 0xC6
	DW 0xC8
	DW 0xCA
	DW 0xCB
	DW 0xCD
	DW 0xCF
	DW 0xD1
	DW 0xD2
	DW 0xD4
	DW 0xD6
	DW 0xD8
	DW 0xDA
	DW 0xDB
	DW 0xDD
	DW 0xDF
	DW 0xE1
	DW 0xE3
	DW 0xE6
	DW 0xE7
	DW 0xE9
	DW 0xEB
	DW 0xED
	DW 0xEF
	DW 0xF1
	DW 0xF3
	DW 0xF5
	DW 0xF7
	DW 0xF9
	DW 0xFB
	DW 0xFD
; End of listing
	END
