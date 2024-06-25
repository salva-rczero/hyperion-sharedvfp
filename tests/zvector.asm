         title 'zVector tests'
*- zVector-------------------------------------------------------------
*
*   zVector - FEATURE_129_ZVECTOR_FACILITY
*
*   PLEASE NOTE that this test only performs the simplest most basic
*   tests. 
*
*----------------------------------------------------------------------
         print off
         copy  'satk.mac'
         yregs
         archlvl mnote=NO
page0    asaload region=CODE
prevorg  equ   *
         org   page0+x'1a0'
         pswz  0,0,0,0,x'200',64  <sys>,<key>,<mwp>,<prg>,<addr>[,amode]
         org   prevorg
         asaipl ia=zvector
         print on

*- Housekeeping -------------------------------------------------------
         using zvector,r12
         using zvector+4096,r13
zvector  balr  r12,0                Get base addr+2
         lay   r12,-2(,r12)         Load base addr
         lay   r13,4096(,r12)       Load base addr++4096
         j     runtests
success  dwaitend load=YES          Normal completion
failure  dwait load=YES,code=BAD    Abnormal termination

*- Constant data ------------------------------------------------------
         ltorg
cr0vop   dc    0d'0',xl8'0000000000060000'    cr0afp+vop bits
zeroes   dc    x'00000000000000000000000000000000'
pattern  dc    x'0123456789abcdeffedcba9876543210'
numbers  dc    c'0123456789012345'
double1  dc    x'3f393ee5eedcc20d'            dh'0.013976'
double2  dc    x'3fdd15f02c4d65e4'            dh'0.053976'
altbits  dc    128x'55'
*- Run the tests ------------------------------------------------------
runtests ds    0h
         lctlg cr0,cr0,cr0vop       Enable vector+afp
*- (VA) Vector Add ----------------------------------------------------
test000  vlm   v0,v9,data000
         vab   v10,v0,v1
         vah   v11,v2,v3
         vaf   v12,v4,v5
         vag   v13,v6,v7
         vaq   v14,v8,v9
         vstm  v10,v14,have000
         clc   have000,must000
         jne   failure
         j     test001
         ds    0d
data000  dc    x'0001020304050607',x'7F808190C0D0EDFF'
         dc    x'0001020304050607',x'7F808190C0D0EDFF'
         dc    h'0',h'40',h'32768',h'-1',h'0',h'0',h'0',h'0'
         dc    h'0',h'40',h'32768',h'-1',h'0',h'0',h'0',h'0'
         dc    f'0',f'2147483648',f'-1',f'-2147483647'
         dc    f'80',f'10',f'2',f'-2'
         dc    fl8'16',fl8'9223372036854775808'
         dc    fl8'9223372036854775808',fl8'-1'
         dc    x'0000000000000000',x'ffffffffffffffff'
         dc    x'0000000000000000',x'0000000000000001'
have000  ds    xl80
must000  dc    x'00020406080a0c0e',x'fe00022080a0dafe'
         dc    x'000000500000fffe',x'0000000000000000'
         dc    x'000000508000000a',x'000000017fffffff'
         dc    x'8000000000000010',x'7fffffffffffffff'
         dc    x'0000000000000001',x'0000000000000000'
*- (VACC) Vector Add Compute Carry ------------------------------------
test001  vlm   v0,v9,data001
         vaccb v10,v0,v1
         vacch v11,v2,v3
         vaccf v12,v4,v5
         vaccg v13,v6,v7
         vaccq v14,v8,v9
         vstm  v10,v14,have001
         clc   have001,must001
         jne   failure
         j     test002
         ds    0d
data001  dc    x'0001020304050607',x'7F808190C0D0EDFF'
         dc    x'0001020304050607',x'7F808190C0D0EDFF'
         dc    h'0',h'40',h'32768',h'-1',h'0',h'0',h'0',h'0'
         dc    h'0',h'40',h'32768',h'-1',h'0',h'0',h'0',h'0'
         dc    f'0',f'2147483648',f'-1',f'-2147483647'
         dc    f'80',f'10',f'2',f'-2'
         dc    fl8'16',fl8'9223372036854775808'
         dc    fl8'9223372036854775808',fl8'-1'
         dc    x'ffffffffffffffff',x'ffffffffffffffff'
         dc    x'0000000000000000',x'0000000000000001'
have001  ds    xl80
must001  dc    x'0000000000000000',x'0001010101010101'
         dc    x'0000000000010001',x'0000000000000000'
         dc    x'0000000000000000',x'0000000100000001'
         dc    x'0000000000000000',x'0000000000000001'
         dc    x'0000000000000000',x'0000000000000001'
*- (VAC) Vector Add With Carry ----------------------------------------
test002  vlm   v2,v7,data002
         vacq  v10,v2,v3,v4
         vacq  v11,v5,v6,v7
         vstm  v10,v11,have002
         clc   have002,must002
         jne   failure
         j     test003
         ds    0d
data002  dc    x'0000000000000000',x'0000000000000032'
         dc    x'0000000000000000',x'0000000000000032'
         dc    x'ffffffffffffffff',x'ffffffffffffffff'
         dc    x'7fffffffffffffff',x'ffffffffffffffff'
         dc    x'8000000000000000',x'0000000000000000'
         dc    x'0000000000000000',x'0000000000000000'
have002  ds    xl32
must002  dc    x'0000000000000000',x'0000000000000065'
         dc    x'ffffffffffffffff',x'ffffffffffffffff'
*- (VACCC) Vector Add With Carry Compute Carry ------------------------
test003  vlm   v2,v7,data003
         vacccq v10,v2,v3,v4
         vacccq v11,v5,v6,v7
         vstm  v10,v11,have003
         clc   have003,must003
         jne   failure
         j     test004
         ds    0d
data003  dc    x'0000000000000000',x'0000000000000032'
         dc    x'0000000000000000',x'0000000000000032'
         dc    x'ffffffffffffffff',x'ffffffffffffffff'
         dc    x'7fffffffffffffff',x'ffffffffffffffff'
         dc    x'8000000000000000',x'0000000000000000'
         dc    x'0000000000000000',x'0000000000000001'
have003  ds    xl32
must003  dc    x'0000000000000000',x'0000000000000000'
         dc    x'0000000000000000',x'0000000000000001'
*- (VCEQ) Vector Compare Equal -----------------------------------------
test004  vlm   v2,v9,data004
         vceqbs v10,v2,v3
         vceqhs v11,v4,v5
         vceqfs v12,v6,v7
         vceqgs v13,v8,v9
         vstm  v10,v13,have004
         clc   have004,must004
         jne   failure
         j     test01
         ds    0d
data004  dc    x'0000000000000000',x'0000000000000032'
         dc    x'0000000000000000',x'0000000000000000'
         dc    x'0001000200030004',x'8001800280038004'
         dc    x'0001000200030004',x'0001000200030004'
         dc    x'0000000100000002',x'0000000300000004'
         dc    x'0000000100000002',x'0000000300000004'
         dc    x'0123456789abcdef',x'0000000000000000'
         dc    x'0000000000000000',x'0123456789abcdef'
have004  ds    xl64
must004  dc    x'ffffffffffffffff',x'ffffffffffffff00'
         dc    x'ffffffffffffffff',x'0000000000000000'
         dc    x'ffffffffffffffff',x'ffffffffffffffff'
         dc    x'0000000000000000',x'0000000000000000'
*- VL/VLR/VST ---------------------------------------------------------
test01   vl    v0,pattern
         vl    v1,altbits
         vlr   v2,v1
         vst   v1,have01
         vst   v0,have01+16
         vst   v2,have01+32
         clc   have01,must01
         jne   failure
         j     test02
have01   ds    xl48
must01   dc    16x'55',x'0123456789abcdeffedcba9876543210',16x'55'
*- VLM/VSTM -----------------------------------------------------------
test02   vlm   v15,v17,altbits
         vstm  v15,v17,have02
         clc   have02,must02
         jne   failure
         j     test03
have02   ds    xl48
must02   dc    48x'55'
*- VLGV ---------------------------------------------------------------
test03   vl    v17,pattern
         lmg   r4,r7,altbits
         vlgvb r4,v17,10
         vlgvh r5,v17,0
         vlgvf r6,v17,1
         vlgvg r7,v17,1
         stmg  r4,r7,have03
         clc   have03,must03
         jne   failure
         j     test04
have03   ds    xl32
must03   dc    xl8'ba',xl8'0123',xl8'89abcdef',xl8'fedcba9876543210'
*- VLL ----------------------------------------------------------------
test04   la    r5,7
         vll   v31,r5,pattern
         vst   v31,have04
         la    r6,4095
         vll   v20,r6,pattern
         vst   v20,have04+16
         clc   have04,must04
         jne   failure
         j     test05
have04   ds    xl32
must04   dc    x'0123456789abcdef0000000000000000'
         dc    x'0123456789abcdeffedcba9876543210'
*- VN -----------------------------------------------------------------
test05   vl    v7,pattern
         vl    v17,altbits
         vn    v23,v17,v7
         vst   v23,have05
         clc   have05,must05
         jne   failure
         j     test06
have05   ds    xl16
must05   dc    x'01014545010145455454101054541010'
*- VGBM ---------------------------------------------------------------
test06   vgbm  v8,b'0101010101010101'
         vgbm  v9,b'1111111100000000'
         vgbm  v10,b'0000000000000000'
         vgbm  v11,b'0000000000000001'
         vgbm  v12,8
         vstm  v8,v12,have06
         clc   have06,must06
         jne   failure
         j     test07
have06   ds    xl80
must06   dc    x'00ff00ff00ff00ff00ff00ff00ff00ff'
         dc    x'ffffffffffffffff0000000000000000'
         dc    x'00000000000000000000000000000000'
         dc    x'000000000000000000000000000000ff'
         dc    x'000000000000000000000000ff000000'
*- VFAE ---------------------------------------------------------------
test07   vl    v0,pattern
         vl    v1,data07
         vl    v2,numbers
         vfae  v0,v1,v2,0,0 
         vst   v0,have07
         vfae  v0,v1,v2,0,8
         vst   v0,have07+16 
         vfae  v0,v1,v2,0,12
         vst   v0,have07+32 
         clc   have07,must07
         jne   failure
         j     test08
data07   dc    c'78jlo vzh-world!'
have07   ds    xl48
must07   dc    x'00000000000000000000000000000000'
         dc    x'00000000000000020000000000000000'
         dc    x'0000ffffffffffffffffffffffffffff'
*- VGM ----------------------------------------------------------------
test08   vgmb  v8,0,7
         vgmb  v9,8,8
         vgmb  v10,7,0
         vgmb  v11,13,3
         vgmh  v12,7,6
         vgmh  v13,12,8
         vgmh  v14,31,1
         vgmh  v15,63,32
         vgmf  v16,7,15
         vgmf  v17,33,2
         vgmf  v18,50,60
         vgmf  v19,84,22
         vgmg  v20,3,13
         vgmg  v21,30,4
         vgmg  v22,20,25
         vgmg  v23,96,12
         vstm  v8,v23,have08
         clc   have08,must08
         jne   failure
         j     test09
have08   ds    xl256
must08   dc    x'ffffffffffffffffffffffffffffffff'
         dc    x'80808080808080808080808080808080'
         dc    x'81818181818181818181818181818181'
         dc    x'f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7f7'
         dc    x'ffffffffffffffffffffffffffffffff'
         dc    x'ff8fff8fff8fff8fff8fff8fff8fff8f'
         dc    x'c001c001c001c001c001c001c001c001'
         dc    x'80018001800180018001800180018001'
         dc    x'01ff000001ff000001ff000001ff0000'
         dc    x'60000000600000006000000060000000'
         dc    x'00003ff800003ff800003ff800003ff8'
         dc    x'00000e0000000e0000000e0000000e00'
         dc    x'1ffc0000000000001ffc000000000000'
         dc    x'f8000003fffffffff8000003ffffffff'
         dc    x'00000fc00000000000000fc000000000'
         dc    x'fff80000fffffffffff80000ffffffff'
*- VREP/VREPI ---------------------------------------------------------
test09   vl    v0,pattern
         vrepb v1,v0,5
         vrepib v2,-2
         vrepf v3,v0,0
         vrepig v4,x'345'
         vstm  v1,v4,have09
         clc   have09,must09
         jne   failure
         j     test10
have09   ds    xl64
must09   dc    x'abababababababababababababababab'
         dc    x'fefefefefefefefefefefefefefefefe'
         dc    x'01234567012345670123456701234567'
         dc    x'00000000000003450000000000000345'
*- VML ----------------------------------------------------------------
test10   vlm   v2,v5,data10
         vml   v6,v2,v3,0
         vml   v7,v4,v5,2
         vstm  v6,v7,have10
         clc   have10,must10
         jne   failure
         j     test11
data10   dc    x'027F0207100000000000000000000000'
         dc    x'FF7F0480100000000000000000000000'
         dc    x'0000745f',x'000003c1',x'0000001f',x'00000001'
         dc    x'c63a0acd',x'3890e77d',x'18740aea',x'e4aa2ee0'
have10   ds    xl32
must10   dc    x'FE010880000000000000000000000000'
         dc    x'DC6EE613',x'57F4FC3D',x'F60D5256',x'e4aa2ee0'
*- VSUMQ --------------------------------------------------------------
test11   vl    v2,data11
         vl    v3,data11_1
         vsumq v1,v2,v3,2
         vstm  v1,v1,have11
         clc   have11,must11
         jne   failure
         j     test12
data11   dc    f'32',f'32',f'32',f'32'
data11_1 dc    f'0',f'0',f'0',f'32'
have11   ds    xl16
must11   dc    x'000000000000000000000000000000A0'
*- VGFM ---------------------------------------------------------------
test12   vl    v2,data12
         vl    v3,data12_1
         vgfm  v1,v2,v3,3
         vstm  v1,v1,have12
         vl    v2,data12_2
         vgfm  v1,v2,v3,3
         vstm  v1,v1,have12_1
         clc   have12,must12
         jne   failure
         clc   have12_1,must12_1
         jne   failure
         j     test13
data12   dc    x'31002004010202010000000000000000'
data12_1 dc    x'ffffffffffffffff0000000000000000'
data12_2 dc    x'F0F0F0F0F0F0F0F00000000000000000'
have12   ds    xl16
have12_1 ds    xl16
must12   dc    x'10FFE003FF01FE00EF001FFC00FE01FF'
must12_1 dc    x'50505050505050505050505050505050'
*- VGFMA --------------------------------------------------------------
test13   vl    v2,data13
         vl    v3,data13_1
         vl    v4,data13_2
         vgfma  v1,v2,v3,v4,3
         vstm  v1,v1,have13
         clc   have13,must13
         jne   failure
         j     test15
data13   dc    x'31002004010202010000000000000000'
data13_1 dc    x'ffffffffffffffff0000000000000000'
data13_2 dc    x'ffffffffffffffffffffffffffffffff'
have13   ds    xl16
must13   dc    x'ef001ffc00fe01ff10ffe003ff01fe00'
*- VUPLL --------------------------------------------------------------
test15   vl    v1,data15
         vupll v1,v1,0
         vstm  v1,v1,have15
         clc   have15,must15
         jne   failure
         j     test16
data15   dc    x'000102030405060708090a0b0c0d0e0f'
have15   ds    xl16
must15   dc    x'00080009000a000b000c000d000e000f'
*- VSTRC --------------------------------------------------------------
test16   vlm   v16,v18,data16
         vstrc v1,v16,v17,v18,1,1
         vst   v1,have16
         clc   have16,must16
         jne   failure
         vlm   v16,v18,data16_2
         vstrc v1,v16,v17,v18,1,4
         vst   v1,have16_2
         clc   have16_2,must16_2
         jne   failure
         j     test17
data16   dc    x'00660069006c00650000000000000000'
         dc    x'00ff00ff000000000000000000000000'
         dc    x'20002000000000000000000000000000'
have16   ds    xl16
must16   dc    x'00000000000000100000000000000000'
data16_2 dc    x'00440069006c00650000000000000000'
         dc    x'0041005a00c000d600d800de00000000'
         dc    x'a000c000a000c000a000c00000000000'
have16_2 ds    xl16
must16_2 dc    x'ffff0000000000000000000000000000'
*- VFEE ---------------------------------------------------------------
test17   vlm   v2,v3,data17_1
         vfee  v1,v2,v3,1,1
         vstm  v1,v1,have17_1
         clc   have17_1,must17_1
         jne   failure
         vl    v2,data17_2
         vfee  v1,v2,v3,1,1
         vstm  v1,v1,have17_2
         clc   have17_2,must17_2
         jne   failure
         j     test18
data17_1 dc    x'0063006100740038002f006c00690062'
data17_v dc    x'00000000000000000000000000000000'
data17_2 dc    x'002f007500730072002f006c00000000'
have17_1 ds    xl16
have17_2 ds    xl16
must17_1 dc    x'00000000000000100000000000000000'
must17_2 dc    x'000000000000000c0000000000000000'
*- VSTL ---------------------------------------------------------------
test18   vl    v1,data18
         la    r3,7
         vstl  v1,r3,have18
         clc   have18,must18
         jne   failure
         j     test19
data18   dc    x'0123456789abcdeffedcba9876543210'
have18   dc    x'00000000000000000000000000000000'
must18   dc    x'0123456789abcdef0000000000000000'
*- VCEQ ---------------------------------------------------------------
test19   vlm   v2,v3,data19
         vceq  v1,v2,v3,1,1
         vst   v1,have19
         clc   have19,must19
         jne   failure
         j     test20
data19   dc    x'0123456789abcdeffedcba9876543210'
         dc    x'0123456789bbcdeffedcba9876543210'
have19   ds    xl16
must19   dc    x'FFFFFFFF0000FFFFFFFFFFFFFFFFFFFF'
*- VSEL ---------------------------------------------------------------
test20   vlm   v2,v4,data20
         vsel  v2,v2,v3,v4
         vst   v2,have20
         clc   have20,must20
         jne   failure
         j     test21
data20   dc    x'00860089008c00850020002000200020'
         dc    x'00660069006c00650000000000000000'
         dc    x'00000000000000000000000000000000'
have20   ds    xl16
must20   dc    x'00660069006c00650000000000000000'
*- VPKLS --------------------------------------------------------------
test21   vlm   v2,v3,data21
         vpkls v2,v2,v3,1,0
         vst   v2,have21
         clc   have21,must21
         jne   failure
         j     test22
data21   dc    x'006e0069006f00000000000000000000'
         dc    x'ae37a476e0c234716eeb0e6b02b28019'
have21   ds    xl16
must21   dc    x'6e696f0000000000ffffffffffffffff'
*- VSTRL --------------------------------------------------------------
test22   vl    v2,data22
         vstrl v2,have22,15
         clc   have22,must22
         jne   failure
         j     test23
data22   dc    x'ae37a476e0c234716eeb0e6b02b28019'
have22   ds    xl16
must22   dc    x'ae37a476e0c234716eeb0e6b02b28019'
*- VMSL ---------------------------------------------------------------
test23   vlm   v2,v4,data23
         vmsl  v1,v2,v3,v4,3,0
         vst   v1,have23
         clc   have23,must23
         jne   failure
         j     test24
data23   dc    x'0000000000000000',x'0000000000000002'
         dc    x'0000000000000000',x'0000000000000004'
         dc    x'0000000000000000',x'ffffffffffffffff'
have23   ds    xl16
must23   dc    x'0000000000000001',x'0000000000000007'
*- VSLDB --------------------------------------------------------------
test24   vl    v16,data24_1
         vl    v18,data24_2
         vsldb v16,v18,v16,9
         vst   v16,have24
         clc   have24,must24
         jne   failure
         j     test25
data24_1 dc    x'00000000005fc59c',x'216764b52cb34057'
data24_2 dc    x'0000000000000000',x'0000000000000000'
have24   ds    xl16
must24   dc    x'0000000000000000',x'000000005fc59c21'
*- VSLD ---------------------------------------------------------------
test25   vlm   v2,v3,data25
         vsld  v1,v2,v3,4
         vst   v1,have25
         clc   have25,must25
         jne   failure
         j     test26
data25   dc    x'0123456789abcdef',x'fedcba9876543210'
         dc    x'f0e1d2c3b4a59687',x'78695a4b3c2d1e0a'
have25   ds    xl16
must25   dc    x'123456789abcdeff',x'edcba9876543210f'
*- VSLR ---------------------------------------------------------------
test26   vlm   v2,v3,data26
         vsrd  v1,v2,v3,4
         vst   v1,have26
         clc   have26,must26
         jne   failure
         j     test27
data26   dc    x'0123456789abcdef',x'fedcba9876543210'
         dc    x'f0e1d2c3b4a59687',x'78695a4b3c2d1e0a'
have26   ds    xl16
must26   dc    x'0f0e1d2c3b4a5968',x'778695a4b3c2d1e0'
*- VSTRS --------------------------------------------------------------
test27   vlm   v2,v7,data27
         vstrsb v1,v2,v3,v4
         vst   v1,have27
         vstrszb v1,v5,v6,v7
         vst   v1,have27+16
         clc   have27,must27
         jne   failure
         j     test28
data27   dc    cl16'zvector hercules'
         dc    cl16'hercules'
         dc    x'0000000000000008',x'78695a4b3c2d1e0a'
         dc    cl16'vector hercules'
         dc    cl8'hercules',x'008695a4b3c2d1e'
         dc    x'00000000000000FF',x'78695a4b3c2d1e0a'
have27   ds    xl32
must27   dc    x'0000000000000008',x'0000000000000000'
         dc    x'0000000000000007',x'0000000000000000'
*- VLEI* --------------------------------------------------------------
test28   vlm   v0,v3,data28
         vleib v0,-3,7
         vleih v1,-3,3
         vleif v2,-3,1
         vleig v3,-3,0
         vstm  v0,v3,have28
         clc   have28,must28
         jne   failure
         j     success
data28   dc    x'0000000000000008',x'0000000000000000'
         dc    x'0100000000000008',x'0000000000000000'
         dc    x'0200000000000008',x'0000000000000000'
         dc    x'0300000000000008',x'0000000000000000'
have28   ds    xl64
must28   dc    x'00000000000000fd',x'0000000000000000'
         dc    x'010000000000fffd',x'0000000000000000'
         dc    x'02000000fffffffd',x'0000000000000000'
         dc    x'fffffffffffffffd',x'0000000000000000'
*----------------------------------------------------------------------
         end
