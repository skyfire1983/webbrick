Define CONF_WORD = 0x3314






Define CLOCK_FREQUENCY = 4

TRISIO.1 = 1
TRISIO.2 = 0
TRISIO.5 = 0

Define ADC_CLOCK = 3
Define ADC_SAMPLEUS = 50
AllDigital
Dim sig As Word
Dim pta As Word
Dim i As Byte
Dim l As Byte
Dim p As Byte
Dim pt As Word

'ADCON0 = %1100000
ANSEL = 8

PWMon 1, 9
Gosub eefill

OPTION_REG = %10001111
start:
ASM:        clrwdt
pta = 0
GPIO.5 = 0
WaitMs 10
ASM:        clrwdt
For l = 0 To 7
	Adcin 3, pt
pta = pta + pt
Next l
GPIO.5 = 1
pt = pta / 8
If pt < 456 Then pt = 456
If pt > 651 Then pt = 651
p = pt - 456  '(0 To 196)
Read p, i
PWMduty 1, i
ASM:        clrwdt
WaitMs 255
ASM:        clrwdt
Goto start
End                                               
eefill:
EEPROM 0, 0
EEPROM 1, 1
EEPROM 2, 2
EEPROM 3, 3
EEPROM 4, 4
EEPROM 5, 4
EEPROM 6, 5
EEPROM 7, 6
EEPROM 8, 7
EEPROM 9, 8
EEPROM 10, 8
EEPROM 11, 9
EEPROM 12, 10
EEPROM 13, 11
EEPROM 14, 12
EEPROM 15, 13
EEPROM 16, 13
EEPROM 17, 14
EEPROM 18, 15
EEPROM 19, 16
EEPROM 20, 17
EEPROM 21, 18
EEPROM 22, 19
EEPROM 23, 20
EEPROM 24, 20
EEPROM 25, 21
EEPROM 26, 22
EEPROM 27, 23
EEPROM 28, 24
EEPROM 29, 26
EEPROM 30, 27
EEPROM 31, 28
EEPROM 32, 29
EEPROM 33, 29
EEPROM 34, 30
EEPROM 35, 31
EEPROM 36, 32
EEPROM 37, 33
EEPROM 38, 34
EEPROM 39, 35
EEPROM 40, 36
EEPROM 41, 37
EEPROM 42, 38
EEPROM 43, 39
EEPROM 44, 40
EEPROM 45, 41
EEPROM 46, 42
EEPROM 47, 43
EEPROM 48, 44
EEPROM 49, 45
EEPROM 50, 46
EEPROM 51, 47
EEPROM 52, 48
EEPROM 53, 49
EEPROM 54, 50
EEPROM 55, 51
EEPROM 56, 52
EEPROM 57, 53
EEPROM 58, 54
EEPROM 59, 55
EEPROM 60, 56
EEPROM 61, 57
EEPROM 62, 58
EEPROM 63, 59
EEPROM 64, 60
EEPROM 65, 61
EEPROM 66, 62
EEPROM 67, 63
EEPROM 68, 64
EEPROM 69, 65
EEPROM 70, 66
EEPROM 71, 67
EEPROM 72, 68
EEPROM 73, 69
EEPROM 74, 70
EEPROM 75, 71
EEPROM 76, 72
EEPROM 77, 74
EEPROM 78, 75
EEPROM 79, 77
EEPROM 80, 78
EEPROM 81, 79
EEPROM 82, 80
EEPROM 83, 81
EEPROM 84, 82
EEPROM 85, 84
EEPROM 86, 85
EEPROM 87, 86
EEPROM 88, 87
EEPROM 89, 88
EEPROM 90, 89
EEPROM 91, 90
EEPROM 92, 91
EEPROM 93, 93
EEPROM 94, 94
EEPROM 95, 95
EEPROM 96, 96
EEPROM 97, 97
EEPROM 98, 99
EEPROM 99, 100
EEPROM 100, 101
EEPROM 101, 102
EEPROM 102, 104
EEPROM 103, 105
EEPROM 104, 106
EEPROM 105, 107
EEPROM 106, 109
EEPROM 107, 110
EEPROM 108, 111
EEPROM 109, 112
EEPROM 110, 114
EEPROM 111, 115
EEPROM 112, 116
EEPROM 113, 118
EEPROM 114, 119
EEPROM 115, 120
EEPROM 116, 121
EEPROM 117, 123
EEPROM 118, 124
EEPROM 119, 125
EEPROM 120, 128
EEPROM 121, 129
EEPROM 122, 130
EEPROM 123, 132
EEPROM 124, 133
EEPROM 125, 135
EEPROM 126, 136
EEPROM 127, 137
EEPROM 128, 139
EEPROM 129, 140
EEPROM 130, 141
EEPROM 131, 143
EEPROM 132, 144
EEPROM 133, 146
EEPROM 134, 147
EEPROM 135, 149
EEPROM 136, 150
EEPROM 137, 152
EEPROM 138, 153
EEPROM 139, 154
EEPROM 140, 156
EEPROM 141, 157
EEPROM 142, 159
EEPROM 143, 160
EEPROM 144, 162
EEPROM 145, 163
EEPROM 146, 165
EEPROM 147, 167
EEPROM 148, 168
EEPROM 149, 170
EEPROM 150, 171
EEPROM 151, 173
EEPROM 152, 174
EEPROM 153, 176
EEPROM 154, 177
EEPROM 155, 180
EEPROM 156, 182
EEPROM 157, 183
EEPROM 158, 185
EEPROM 159, 187
EEPROM 160, 188
EEPROM 161, 190
EEPROM 162, 192
EEPROM 163, 193
EEPROM 164, 195
EEPROM 165, 197
EEPROM 166, 198
EEPROM 167, 200
EEPROM 168, 202
EEPROM 169, 203
EEPROM 170, 205
EEPROM 171, 207
EEPROM 172, 209
EEPROM 173, 210
EEPROM 174, 212
EEPROM 175, 214
EEPROM 176, 216
EEPROM 177, 218
EEPROM 178, 219
EEPROM 179, 221
EEPROM 180, 223
EEPROM 181, 225
EEPROM 182, 227
EEPROM 183, 230
EEPROM 184, 231
EEPROM 185, 233
EEPROM 186, 235
EEPROM 187, 237
EEPROM 188, 239
EEPROM 189, 241
EEPROM 190, 243
EEPROM 191, 245
EEPROM 192, 247
EEPROM 193, 249
EEPROM 194, 251
EEPROM 195, 253
EEPROM 196, 255



Return                                            