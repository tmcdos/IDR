unit Def_disasm;

interface

Uses SysUtils;

Const
  ASMMAXCOPLEN  = 12;

  OP_RESET =  $80;
  OP_A2    =  $40;    //2 or 3 operands

  OP_UNK	 =	0;
  OP_ADC   =  $81;    //1 OP_RESET
  OP_ADD	 =	$C2;    //2 OP_RESET OP_A2
  OP_AND	 =	$C3;    //3 OP_RESET OP_A2
  OP_BT    =  $44;    //4 OP_A2
  OP_BTC   =  $45;    //5 OP_A2
  OP_BTR   =  $46;    //6 OP_A2
  OP_BTS   =  $47;    //7 OP_A2
  OP_CDQ	 =	$88;    //8 OP_RESET
  OP_CMP	 =	$49;    //9 OP_A2
  OP_DEC	 =	$8A;    //A OP_RESET
  OP_DIV   =  $8B;    //B OP_RESET
  OP_IDIV	 =	$CC;    //C OP_RESET OP_A2
  OP_IMUL	 =	$CD;    //D OP_RESET OP_A2
  OP_INC	 =	$8E;    //E OP_RESET
  OP_JMP	 =	$8F;    //F OP_RESET
  OP_LEA	 =	$D0;    //10 OP_RESET OP_A2
  OP_MOV	 =	$D1;    //11 OP_RESET OP_A2
  OP_MOVS	 =	$92;    //12 OP_RESET
  OP_MUL   =  $93;    //13 OP_RESET
  OP_NEG   =  $94;    //14 OP_RESET
  OP_OR		 =  $D5;    //15 OP_RESET OP_A2
  OP_POP	 =	$96;    //16 OP_RESET
  OP_PUSH	 =	$97;    //17 OP_RESET
  OP_SAR   =  $98;    //18 OP_RESET
  OP_SBB   =  $99;    //19 OP_RESET
  OP_SET   =  $9A;    //1A OP_RESET
  OP_SUB	 =	$9B;    //1B OP_RESET
  OP_TEST	 =	$5C;    //1C OP_A2
  OP_XCHG	 =	$DD;    //1D OP_RESET OP_A2
  OP_XOR	 =  $DE;    //1E OP_RESET OP_A2
  OP_SHR   =  $9F;    //1F OP_RESET
  OP_SAL   =  $A0;    //20 OP_RESET
  OP_SHL   =  $A1;    //21 OP_RESET
  OP_NOT   =  $A2;    //22 OP_RESET

  Reg8Tab:Array[0..7] of AnsiString =
  (
    //0     1     2     3     4     5     6     7
    'al', 'cl', 'dl', 'bl', 'ah', 'ch', 'dh', 'bh'
  );
  Reg16Tab:Array[0..7] of AnsiString =
  (
    //8     9    10    11    12    13    14    15
    'ax', 'cx', 'dx', 'bx', 'sp', 'bp', 'si', 'di'
  );
  Reg32Tab:Array[0..7] of AnsiString =
  (
    //16     17     18     19     20     21     22     23
    'eax', 'ecx', 'edx', 'ebx', 'esp', 'ebp', 'esi', 'edi'
  );
  SegRegTab:Array[0..7] of AnsiString =
  (
    //24   25    26    27    28    29    30    31
    'es', 'cs', 'ss', 'ds', 'fs', 'gs', '??', '??'
  );
  RegCombTab:Array[0..7] of AnsiString =
  (
    'bx+si', 'bx+di', 'bp+si', 'bp+di', 'si', 'di', 'bp', 'bx'
  );
  RepPrefixTab:Array[0..3] of AnsiString =
  (
    'lock', 'repne', 'repe', 'rep'
  );

Type
  TOperType = (otUND, otIMM, otREG, otMEM, otFST);

  TDisInfo = record
	  Mnem:String[32];
    Op1:String[64];
	  //Op2:Array [0..63] of Char;
	  //Op3:Array [0..63] of Char;
    //InstrType:Byte;
    Float:Boolean;
	  Call:Boolean;
	  Branch:Boolean;
	  Conditional:Boolean;
    Ret:Boolean;
    //Register indexes, used as operands
    OpRegIdx:Array[0..2] of Integer;
    //[BaseReg + IndxReg*Scale + Offset]
    BaseReg:Integer;
    IndxReg:Integer;
    Scale:Integer;
    Offset:Integer;
    //ImmPresent:Boolean;
    Immediate:Integer;
	  MemSize:Integer;
    sSize:String[32];
	  RepPrefix:Integer;
    SegPrefix:Integer;
	  OpNum:Byte;
    OpType:Array [0..2] of TOperType;
  End;
  PDisInfo = ^TDisInfo;

implementation

end.
