Unit Disasm;

Interface

Uses Windows, Def_disasm;

Type
  DisType = (
    distX8616,			  // Intel x86 (16 bit mode)
    distX86,				  // Intel x86 (32 bit mode)
    distMips, 			  // MIPS R-Series
    distAlphaAxp,		  // DEC Alpha AXP
    distPowerPc,		  // Motorola PowerPC
    distPowerMac,		  // Motorola PowerPC in big endian mode
    distOmni, 			  // OMNI VM
    distJava, 			  // Java
    distSh,				    // Hitachi SuperH
    distArm,				  // ARM
    distMips16,			  // MIPS16
    distThumb,			  // Thumb
    distIa64  			  // IA-64
  );

  // Architecture dependent termination type
  TRMTA = (
    trmtaUnknown,      // 0 Block hasn't been analyzed
    trmtaFallThrough,  // 1 Fall into following block
    trmtaTrap,         // 2 Trap, Unconditional
    trmtaTrapCc,       // 3 Trap, Conditional
    trmtaJmpShort,     // 4
    trmtaJmpNear,      // 5
    trmtaJmpFar,       // 6
    trmtaJmpInd,       // 7
    trmtaRet,          // 8
    trmtaIret,         // 9
    trmtaJmpCcShort,   // 10
    trmtaJmpCcNear,    // 11
    trmtaLoop,         // 12
    trmtaJcxz,         // 13
    trmtaCallNear16,   // 14
    trmtaCallNear32,   // 15
    trmtaCallFar,      // 16
    trmtaCallInd       // 17
  );

  REGA = (
    regaEax, // 0
    regaEcx, // 1
    regaEdx, // 2
    regaEbx, // 3
    regaEsp, // 4
    regaEbp, // 5
    regaEsi, // 6
    regaEdi  // 7
  );

  OPREFT = (
    opreftNil,		       // Operand not referenced (e.g. INVLPG)
    opreftRd, 		       // Operand is read
    opreftRw, 		       // Operand is read and written
    opreftWr			       // Operand is written
  );

  OPRNDT = (			       // Operand type
    oprndtNil,		       // No operand
    oprndtAP, 		       // Far address
    oprndtCd, 		       // CRx register from MODRM reg
    oprndtConst,		     // Constant from bValue
    oprndtDd, 		       // DRx register from MODRM reg
    oprndtGvOp,		       // General register (operand size) from opcode
    oprndtGvOp2,		     // General register (operand size) from opcode (2nd byte)
    oprndtIb, 		       // Immediate byte
    oprndtIb2,		       // Immediate byte following word
    oprndtIv, 		       // Immediate operand size value
    oprndtIw, 		       // Immediate word
    oprndtJb, 		       // Relative address byte
    oprndtJv, 		       // Relative address operand size value
    oprndtMmModrm,		   // Memory/MM register references from MODRM (MMX)
    oprndtMmModrmReg, 	 // MM register from MODRM reg (MMX)
    oprndtModrm,		     // Memory/register references from MODRM
    oprndtModrmReg,		   // General register from MODRM reg
    oprndtModrmSReg,		 // Segment register from MODRM reg
    oprndtOffset,		     // Address size immediate offset
    oprndtRb, 		       // General register (byte) from bValue
    oprndtRv, 		       // General register (operand size) from bValue
    oprndtRw, 		       // General register (word) from bValue
    oprndtST, 		       // Floating point top of stack
    oprndtSTi,		       // Floating point register from MODRM reg
    oprndtSw, 		       // Segment register (word) from bValue
    oprndtTd, 		       // TRx register from MODRM reg
    oprndtX,			       // DS:[eSI] for string instruction
    oprndtY,			       // ES:[eDI] for string instruction
    oprndtZ 			       // DS:[eBX] for XLAT
  );

  _OPRND = packed record
    opr_bits:Byte; // 6 MSB = OPRNDT, 2 LSB = OPREFT
    bValue:Byte;
  end;

  _MODRMT	= (		       // MODRM type
    modrmtNo,  	       // Not present
    modrmtYes, 	       // Present
    modrmtMem, 	       // Memory only
    modrmtReg		       // Register only
  );

  _ICB = (		       // Immediate byte count
    icbNil,		       // No immediate value
    icbAP,		       // Far pointer
    icbIb,		       // Immediate byte
    icbIb0A,	       // Immediate byte (must be 0Ah)
    icbIv,		       // Immediate operand size value
    icbIw,		       // Immediate word
    icbIw_Ib,	       // Immediate word and immediate byte
    icbJb,		       // Byte displacement
    icbJv,		       // Address size displacement
    icbO			       // Address size value
  );

  _OPS = record
    modrmt:_MODRMT;
    icb:_ICB;
    rgoprnd:Array[0..2] of _OPRND;
  end;
  _POPS = ^_OPS;

  _OPCD = record
    pvMnemonic:PAnsiChar;
    pops:_POPS;
    trmta:Byte;
  end;
  POPCD = ^_OPCD;

  // C++ __thiscall virtual methods of TDIS
  // Object reference is passed in ECX, arguments are pushed on the stack as __cdecl
  // stack is cleaned by the virtual method, like in "stdcall"
  {
  p_AddrAddress = Function(adr:Integer):Int64 of object; // +$04
  p_AddrJumpTable = Function:Int64 of object; // +$08
  p_AddrOperand = Function(adr:Integer):Int64 of object; // +$0C
  p_AddrTarget = Function:Int64 Of Object; // +$10
  p_Cb = Function:Integer of Object; // +$14
  p_CbDisassemble = Function(adr:Int64;Buf:PAnsiChar;BufLen:Integer):Integer of Object; // +$18
  p_CbGenerateLoadAddress = Function(adr:Integer;Buf:PAnsiChar;BufLen:Integer;idx:Integer=0):Integer Of Object; // +$1C
  p_CbJumpEntry = Function:Integer of Object; // +$20
  p_CbOperand = Function(size:Integer):Integer Of Object; // +$24
  p_CchFormatBytes = Function(Buf:PAnsiChar;BufLen:Integer):Integer of object; // +$28
  p_CchFormatBytesMax = Function:Integer of object; // +$2C
  p_Cinstruction = Function:Integer Of Object; // +$30
  p_Coperand = Function:Integer of Object; // +$34
  p_FormatAddr = Procedure(s:TStream;adr:Int64) of object; // +$38
  p_FormatInstr = Procedure(s:TStream) of object; // +$3C
  p_FSelectInstruction = Function(adr:Integer):Boolean Of object; // +$40
  p_Memreft = Function(adr:Integer):MEMREF of object; // +$44
  p_Trmt = Function:TRM of Object; // +$48
  p_Trmta = Function:TRMA of Object; // +$4C
  p_RegaMax = Function:REGA of object; // +$50
  }

  TDIS = class;
  PFNCCHADDR = Function(obj:TDIS;adr:Int64;Buf:PAnsiChar;BufLen:Integer;ptr:PInt64):Integer; Stdcall;
  PFNCCHCONST = Function(obj:TDIS;Idx:Cardinal;Buf:PAnsiChar;BufLen:Integer):Integer; Stdcall;
  PFNCCHFIXUP = Function(obj:TDIS;adr:Int64;Idx:Integer;Buf:PAnsiChar;BufLen:Integer;ptr:PInt64):Integer; Stdcall;
  PFNCCHREGREL = Function(obj:TDIS;r:REGA;Idx:Cardinal;Buf:PAnsiChar;BufLen:Integer;ptr:PInteger):Integer; Stdcall;
  PFNCCHREG = Function(obj:TDIS;r:REGA;Buf:PAnsiChar;BufLen:Integer):Integer; Stdcall;
  PFNDWGETREG = Function(obj:TDIS;r:REGA):Int64; Stdcall;

  // C++ class from Microsoft Dis-assembler DLL
  TDIS = Class
    // ancestor Protected members
    garbage:Cardinal;                 // +$4
    m_dist:DisType;                   // +$8
    m_pfncchaddr:PFNCCHADDR;          // +$0C
    m_pfncchconst:PFNCCHCONST;        // +$10
    m_pfncchfixup:PFNCCHFIXUP;        // +$14
    m_pfncchregrel:PFNCCHREGREL;      // +$18
    m_pfncchreg:PFNCCHREG;            // +$1C
    m_pfndwgetreg:PFNDWGETREG;        // +$20
    m_pvClient:PAnsiChar;             // +$24
    m_addr:Int64;                     // +$28
    // private members
	  m_pbCur:Pointer;                  // +$30
	  m_cbMax:Integer;                  // +$34
    m_cb:Integer;                     // +$38
	  m_rgbInstr:Array[0..15] Of Byte;  // +$3C
	  m_popcd:POPCD;                    // +$4C
	  m_fAddress32:Boolean;             // +$50
	  m_fOperand32:Boolean;             // +$51
	  m_bSegOverride:Byte;              // +$52
	  m_bPrefix:Byte;                   // +$53
	  m_fAddrOverride:Boolean;          // +$54
	  m_fOperOverride:Boolean;          // +$55
    m_ibOp:Integer;                   // +$58
	  m_ibModrm:Integer;                // +$5C
	  m_cbModrm:Integer;                // +$60
	  m_ibImmed:Integer;                // +$64
	  m_trmta:TRMTA;                    // +$68
	  //m_regmaskRd:REGMASK;
	  //m_regmaskWr:REGMASK;
    procedure Dumm2; virtual; // +$0
    Function AddrAddress(z:Cardinal;obj:TObject;adr:Integer):Int64; Virtual; // +$04
    Function AddrJumpTable(z:Cardinal;obj:TObject):Int64; virtual; // +$08
    function AddrOperand(z:Cardinal;obj:Tobject;adr:Integer):Int64; virtual; // +$0C
    function AddrTarget(z:Cardinal;obj:TObject):Int64; virtual; // +$10
    Function Cb(z:Cardinal;obj:TObject):Integer; virtual; // +$14
    Function CbDisassemble(z:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar;adr:Int64):Integer; virtual; // +$18
    Function CbGenerateLoadAddress(z:Cardinal;obj:TObject;idx:Integer;BufLen:Integer;Buf:PAnsiChar;adr:Integer):Integer; virtual; // +$1C
    Function CbJumpEntry(z:Cardinal;obj:TObject):Integer; virtual; // +$20
    Function CbOperand(z:Cardinal;obj:TObject;size:Integer):Integer; virtual; // +$24
    Function CchFormatBytes(z:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar):Integer; virtual; // +$28
    Function CchFormatBytesMax(z:Cardinal;obj:TObject):Integer; virtual; // +$2C
    Function Cinstruction(z:Cardinal;obj:TObject):Integer; virtual; // +$30
    Function Coperand(z:Cardinal;obj:TObject):Integer; virtual; // +$34
  end;

  TPdisNew = Function (a:Integer):TDIS; Stdcall;
  TCchFormatAddr = Function (z1,z2:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar;Adr:Int64):Integer; // __thiscall
  TCchFormatInstr = Function (z1,z2:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar):Integer; // __thiscall
  //TDist = Function:Integer; Stdcall;

  MDisasm=class
  private
    PDisNew:TPdisNew;
    CChFormatAddr:TCchFormatAddr;
    CChFormatInstr:TCchFormatInstr;
    //Dist:TDist;
    DIS:TDIS;
    Function GetAddressSize:Boolean;
    function GetOperandSize: Boolean;
    Function GetSegPrefix:Byte;
    Function GetRepPrefix:Byte;
    Function GetPostByteMod:Byte;
    function GetPostByteReg: Byte;
    function GetPostByteRm: Byte;
    function GetOpType(const Op:AnsiString): TOperType;
    procedure FormatInstr(DisInfo:PDISINFO; disLine:PAnsiString);
    procedure FormatArg(argno:Integer; cmd, arg:Integer; DisInfo:PDISINFO; disLine:PAnsiString);
    function OutputGeneralRegister(var dst:AnsiString; reg, size:Integer): Integer;
    Function GetAddress:Integer;
    procedure OutputSegPrefix(var dst:AnsiString; DisInfo:PDISINFO);
    Function EvaluateOperandSize:Integer;
    procedure OutputSizePtr(size:Integer; mm:Boolean; DisInfo:PDISINFO; disLine:PAnsiString);
    procedure OutputMemAdr16(argno:Integer; var dst:AnsiString; arg:Integer; f1, f2:Boolean; DisInfo:PDisInfo; disLine:PAnsiString);
    procedure OutputMemAdr32(argno:Integer; var dst:AnsiString; arg:Integer; f1, f2:Boolean; DisInfo:PDisInfo; disLine:PAnsiString);
  Public
    hModule:HINST;
    Destructor Destroy; Override;
    function Init: Boolean;
    function Disassemble(fromAdr:Integer; DisInfo:PDISINFO; disLine:PAnsiString): Integer; overload;
    function Disassemble(from:PAnsiChar; address:Int64; DisInfo:PDISINFO; disLine:PAnsiString): Integer; overload;
    Function GetRegister(reg:PAnsiChar):Integer;
    Function GetOp(mnem:AnsiString):Byte;
    Function GetCop:Byte;
    Function GetCop1:Byte;
    Function GetPostByte:Byte;
    Procedure SetPostByte(b:BYTE);
    Procedure SetOffset(ofs:Integer);
    Procedure GetInstrBytes(dst:PByte);
    function GetSizeString(size:Integer): AnsiString;
  end;

Implementation

Uses SysUtils,Main,Misc,Math;

Destructor MDisasm.Destroy;
Begin
  if hModule<>0 then FreeLibrary(hModule);
end;

Function MDisasm.Init:Boolean;
Begin
  Result:=False;
  hModule := LoadLibrary('dis.dll');
  if hModule=0 then Exit;
  PdisNew := GetProcAddress(hModule, '?PdisNew@DIS@@SGPAV1@W4DIST@1@@Z');
  CchFormatAddr := GetProcAddress(hModule, '?CchFormatAddr@DIS@@QBEI_KPADI@Z');
  CchFormatInstr := GetProcAddress(hModule, '?CchFormatInstr@DIS@@QBEIPADI@Z');
  //Dist := GetProcAddress(hModule, '?Dist@DIS@@QBE?AW4DIST@1@XZ');
  DIS := PdisNew(Ord(distX86));
  Result:=True;
end;

function MDisasm.GetOp(mnem:AnsiString): Byte;
Begin
  if (mnem = 'mov')or(mnem='movsx')or(mnem='movzx') then Result:=OP_MOV
  Else If mnem='movs' then Result:=OP_MOVS
  else if mnem = 'push' then Result:=OP_PUSH
  else if mnem = 'pop' then Result:=OP_POP
  else if mnem = 'jmp' then  Result:= OP_JMP
  else if mnem = 'xor' then  Result:= OP_XOR
  else if mnem = 'cmp' then  Result:= OP_CMP
  else if mnem = 'test' then Result:= OP_TEST
  else if mnem = 'lea' then  Result:= OP_LEA
  else if mnem = 'add' then  Result:= OP_ADD
  else if mnem = 'sub' then  Result:= OP_SUB
  Else if mnem = 'or' then   Result:= OP_OR
  else if mnem = 'and' then  Result:= OP_AND
  else if mnem = 'inc' then  Result:= OP_INC
  else if mnem = 'dec' then  Result:= OP_DEC
  else if mnem = 'mul' then  Result:= OP_MUL
  Else if mnem = 'div' then  Result:= OP_DIV
  Else if mnem = 'imul' then Result:= OP_IMUL
  Else if mnem = 'idiv' then Result:= OP_IDIV
  Else if (mnem = 'shl')or(mnem = 'shld') then  Result:= OP_SHL
  Else if (mnem = 'shr')or(mnem = 'shrd') then  Result:= OP_SHR
  Else if mnem = 'sal' then  Result:= OP_SAL
  else if mnem = 'sar' then  Result:= OP_SAR
  else if mnem = 'neg' then  Result:= OP_NEG
  else if mnem = 'not' then  Result:= OP_NOT
  else if mnem = 'adc' then  Result:= OP_ADC
  else if mnem = 'sbb' then  Result:= OP_SBB
  Else if mnem = 'cdq' then  Result:= OP_CDQ
  else if mnem = 'xchg' then Result:= OP_XCHG
  Else if mnem = 'bt' then   Result:= OP_BT
  Else if mnem = 'btc' then  Result:= OP_BTC
  Else if mnem = 'btr' then  Result:= OP_BTR
  else if mnem = 'bts' then  Result:= OP_BTS
  else if Copy(mnem,1,3) = 'set' then Result:= OP_SET
  Else Result:=OP_UNK;
end;

Function MDisasm.GetOpType(const Op:AnsiString):TOperType;
Begin
  if Op='' then Result:=otUND
  else
  begin
    if Pos('[',Op)<>0 then Result:=otMEM
    else if Op[1] in ['0'..'9','$','+','-'] then Result:=otIMM
    Else if (Op[1] = 's') and (Op[2] = 't') then Result:=otFST
    Else Result:=otREG;
  end;
end;

Function MDisasm.GetRegister(reg:PAnsiChar):Integer;
var
  n:Integer;
Begin
  Result:=-1;
  for n := Low(Reg32Tab) to High(Reg32Tab) do
    if Reg32Tab[n]=reg Then
    Begin
      Result:=n;
      Exit;
    end;
end;

Function MDisasm.Disassemble(fromAdr:Integer; DisInfo:PDISINFO; disLine:PAnsiString):Integer;
var
  a:Integer;
Begin
  CrtSection.Enter;
  a:=Adr2Pos(fromAdr);
  if a<>0 then
    result := Disassemble(Code + a, fromAdr, DisInfo, disLine)
  else REsult:=0;
  CrtSection.Leave;
end;

Function MDisasm.Disassemble(from:PAnsiChar; address:Int64; DisInfo:PDISINFO; disLine:PAnsiString):Integer;
var
	InstrLen:Integer;
Begin
  CrtSection.Enter;
  InstrLen:=DIS.CbDisassemble(0,DIS,100,from,address);

  //If address of structure DISINFO not given, return only instruction length
  if Assigned(DisInfo) then
  begin
    if InstrLen<>0 then
    begin
      FillMemory(DisInfo, sizeof(TDisInfo),0);
      with DisInfo^ do
      begin
        OpRegIdx[0] := -1;
        OpRegIdx[1] := -1;
        OpRegIdx[2] := -1;
        BaseReg := -1;
        IndxReg := -1;
        RepPrefix := -1;
        SegPrefix := -1;
      end;
      FormatInstr(DisInfo, disLine);
      if (DisInfo.IndxReg <> -1) and (DisInfo.Scale=0) then DisInfo.Scale := 1;
      if (DisInfo.Mnem[1] = 'f') or (DisInfo.Mnem = 'wait') then DisInfo.Float := true
      else if DisInfo.Mnem[1] = 'j' then
      begin
        DisInfo.Branch := true;
        if DisInfo.Mnem[2] <> 'm' then DisInfo.Conditional := true;
      end
      else if DisInfo.Mnem= 'call' then DisInfo.Call := true
      else if DisInfo.Mnem= 'ret' then DisInfo.Ret := true;
      Result:= InstrLen;
    end
    else Result:=0;
  end
  else Result:=InstrLen;
  CrtSection.Leave;
end;

Procedure MDisasm.FormatInstr(DisInfo:PDISINFO; disLine:PAnsiString);
var
  repPrefix:Byte;
  OpName, ArgInfo:PAnsiChar;
  i, Bytes:Integer;
  Cmd, Arg:Integer;
Begin
  Bytes:=0;
  if Assigned(disLine) then disLine^ := '';
  repPrefix := GetRepPrefix;
  case repPrefix of
    $F0:
      begin
        if Assigned(disLine) then disLine^:=disLine^+ 'lock ';
        DisInfo.RepPrefix := 0;
        Bytes := 5;
      end;
    $F2:
      begin
        if Assigned(disLine) then disLine^:=disLine^+ 'repne ';
        DisInfo.RepPrefix := 1;
        Bytes := 6;
      end;
    $F3:
      begin
        if (GetCop and $F6) = $A6 then
        begin
          if Assigned(disLine) then disLine^:=disLine^+ 'repe ';
          DisInfo.RepPrefix := 2;
          Bytes := 5;
        end
        else
        begin
          if Assigned(disLine) then disLine^:=disLine^+ 'rep ';
          DisInfo.RepPrefix := 3;
          Bytes := 4;
        End;
      end;
  end;
  OpName:=DIS.m_popcd.pvMnemonic;
  if not GetOperandSize then
  Case GetCop of
    $60: OpName := 'pusha';
    $61: OpName := 'popa';
    $98: OpName := 'cbw';
    $99: OpName := 'cwd';
    $9C: OpName := 'pushf';
    $9D: OpName := 'popf';
    $CF: OpName := 'iret';
  End;
  if not GetAddressSize and (GetCop = $E3) then OpName := 'jcxz';
  if Assigned(disLine) then disLine^:=disLine^+OpName;
  DisInfo.Mnem:=OpName;
  Inc(Bytes,Length(OpName));
  ArgInfo:=PAnsiChar(@DIS.m_popcd.pops.modrmt)+SizeOf(_OPS)+1;
  for i := 0 to 2 do
  begin
    if (ArgInfo=Nil) or (ArgInfo^=#0) then break;
    if Assigned(disLine) then
    begin
      if i=0 then
      begin
        disLine^:=disLine^+StringOfChar(' ',ASMMAXCOPLEN-Bytes);
        Bytes:=ASMMAXCOPLEN;
      end
      else disLine^:=disLine^+',';
    End;
    Cmd:=Byte(ArgInfo^);
    Arg:=PWord(ArgInfo+1)^;
    Inc(ArgInfo,4);
    FormatArg(i, Cmd, Arg, DisInfo, disLine);
    Inc(DisInfo.OpNum);
  End;
end;

Function MDisasm.OutputGeneralRegister(var dst:AnsiString; reg, size:Integer):Integer;
Begin
  if size = 1 then
  begin
    dst:=dst + Reg8Tab[reg];
    Result:=0;
  end
  Else if size = 2 then
  begin
    dst:=dst + Reg16Tab[reg];
    Result:=8;
  end;
  if (size <> 4) And not GetOperandSize then
  begin
    dst:=dst + Reg16Tab[reg];
    Result:=8;
  End
  else
  begin
    dst:=dst + Reg32Tab[reg];
    Result:=16;
  end;
end;

Function MDisasm.GetAddress:Integer;
var
  x:Int64;
Begin
  Result:=0;
  case DIS.m_trmta of
    //0,1,2,3,7,8,9,17: Result:=0;
    trmtaJmpShort,
    trmtaJmpCcShort,
    trmtaLoop,
    trmtaJcxz:
      Begin
        x:=ShortInt(DIS.m_rgbInstr[DIS.m_ibImmed]) + DIS.m_cb + DIS.m_addr;
        if not DIS.m_fOperand32 then x:=x and $FFFF;
        if DIS.m_dist = distX8616 then x:=(x and $FFFF) or (Integer(DIS.m_addr) and $FFFF0000);
        Result:=x;
      end;
    trmtaJmpNear,
    trmtaJmpCcNear,
    trmtaCallNear16,
    trmtaCallNear32:
      Begin
        if DIS.m_fOperand32 Then x:=PInteger(@DIS.m_rgbInstr[DIS.m_ibImmed])^
          Else x:=PSmallInt(@DIS.m_rgbInstr[DIS.m_ibImmed])^;
        Inc(x,DIS.m_cb + DIS.m_addr);
        if not DIS.m_fOperand32 then x:=x and $FFFF;
        if DIS.m_dist = distX8616 then x:=(x and $FFFF) or (Integer(DIS.m_addr) and $FFFF0000);
        Result:=x;
      end;
    trmtaJmpFar,
    trmtaCallFar: Result:=PInteger(@DIS.m_rgbInstr[DIS.m_ibImmed])^;
  end;
end;

Procedure MDisasm.OutputSegPrefix(var dst:AnsiString; DisInfo:PDISINFO);
Var
  sptr:AnsiString;
Begin
  sptr:='';
  Case GetSegPrefix of
    $26:
      begin
        sptr := 'es:';
        DisInfo.SegPrefix := 0;
      End;
    $2E:
      begin
        sptr := 'cs:';
        DisInfo.SegPrefix := 1;
      end;
    $36:
      begin
        sptr := 'ss:';
        DisInfo.SegPrefix := 2;
      end;
    $3E:
      begin
        sptr := 'ds:';
        DisInfo.SegPrefix := 3;
      end;
    $64:
      begin
        sptr := 'fs:';
        DisInfo.SegPrefix := 4;
      end;
    $65:
      begin
        sptr := 'gs:';
        DisInfo.SegPrefix := 5;
      end;
  end;
  if sptr<>'' then dst:=dst + sptr;
end;

Function MDisasm.EvaluateOperandSize:Integer;
var
  OperandSize:Boolean;
  Ofs:Integer;
Begin
  OperandSize := GetOperandSize;
  Ofs:=PInteger(@DIS.m_popcd.pops)^;
  if OperandSize then Result:=4 else Result:=2;
  if (Ofs = $1041BB30) or    //INVLPG, PREFETCH, PREFETCHW
     (Ofs = $1041C370) then     //LEA
     Result:=0
  else if (Ofs = $1041BC38)      //BOUND
    then Result:=2*Result
  Else if (Ofs = $1041BCB0) or    //CALL, JMP
    (Ofs = $1041C3E8) then     //LES, LDS, LSS, LFS, LGS
    Result:=Result + 2
  Else if (Ofs = $1041BC98) or    //FLDENV
    (Ofs = $1041C460) then     //FNSTENV
    if OperandSize then Result:=28 else Result:=14
  else if (Ofs = $1041BCF8) or    //FRSTOR
    (Ofs = $1041C4C0) then     //FNSAVE
    if OperandSize then Result:=108 Else Result:=94;
end;

Function MDisasm.GetSizeString(size:Integer):AnsiString;
Begin
  Result:='';
  Case size of
    1: Result:='byte';
    2: Result:='word';
    4: Result:='dword';
    6: Result:='fword';
    8: Result:='qword';
    10: Result:='tbyte';
  end;
end;

Procedure MDisasm.OutputSizePtr(size:Integer; mm:Boolean; DisInfo:PDISINFO; disLine:PAnsiString);
var
  sptr:AnsiString;
Begin
  sptr:='';
  if size=0 then size := EvaluateOperandSize;
  Case size of
    1: sptr := 'byte';
    2: sptr := 'word';
    4: sptr := 'dword';
    6: sptr := 'fword';
    8: if mm then sptr := 'mmword' Else sptr := 'qword';
    10: sptr := 'tbyte';
    16: if mm then sptr := 'xmmword';
  End;
  if sptr<>'' then
  begin
    if Assigned(disLine) then disLine^:=disLine^ + sptr + ' ptr ';
    DisInfo.MemSize := size;
    DisInfo.sSize:=sptr;
  End;
end;

Procedure MDisasm.OutputMemAdr32(argno:Integer; var dst:AnsiString; arg:Integer; f1, f2:Boolean; DisInfo:PDisInfo; disLine:PAnsiString);
var
  PostByte, _mod, sib, b:Byte;
  _pos:PAnsiChar;
  ofs, ofs1, ib, mm:Boolean;
  ss, index, base, idxofs:Integer;
  offset32:Integer;
Begin
  ss:=1;
  PostByte:=DIS.m_rgbInstr[DIS.m_ibModrm];
  _mod := PostByte and $C0;
  base := PostByte and 7;
  if _mod = $C0 then
  begin
    if not f1 and not f2 then
    begin
      //idxval := PostByte and 7;
      idxofs := OutputGeneralRegister(dst, base, arg);
      DisInfo.OpRegIdx[argno] := idxofs + base;
      Exit;
    End;
    if f2 then dst:=dst + 'xmm' + IntToStr(base);
    Exit;
  End;
  ofs := false;
  index := -1;
  _pos:=@DIS.m_rgbInstr[DIS.m_ibModrm+1];
  if base <> 4 then
  begin
    if (PostByte and $C7) = 5 then //mod=00;r/m=101
    begin
      ofs := true;
      base := -1;
    End;
  end
  else    //sib
  begin
    sib := Byte(_pos^);
    Inc(_pos);
    if ((sib and 7) = 5) and (_mod=0) Then base := - 1
      else base := sib and 7;
    index := (sib shr 3) and 7;
    if index <> 4 then ss := 1 shl (sib shr 6)
      else index := -1;
    if ((sib and 7) = 5) and (_mod=0) then ofs := true;
  End;
  offset32 := 0;
  if _mod = $40 then  //mod=01
  begin
    b := Byte(_pos^);
    offset32 := b;
    if (b and $80) <> 0 then offset32:=offset32 or -256;
  end
  else if _mod = $80 then ofs:=true; //mod=10
  if ofs then offset32 := PInteger(_pos)^;
  mm := f1 or f2;
  OutputSizePtr(arg, mm, DisInfo, disLine);
  OutputSegPrefix(dst, DisInfo);
  ib := (base <> -1) or (index <> -1);
  if (GetSegPrefix=0) And not ib then
  begin
    DisInfo.SegPrefix := 3;
    dst:=dst + 'ds:';
  End;
  dst:=dst + '[';
  ofs1 := offset32 <> 0;
  if ib then
  begin
    if base <> -1 then
    begin
      dst:=dst + Reg32Tab[base];
      DisInfo.BaseReg := base + 16;
    End;
    if index <> -1 then
    begin
      if base <> -1 then dst:=dst + '+';
      dst:=dst + Reg32Tab[index];
      DisInfo.IndxReg := index + 16;
      if ss <> 1 then
      begin
        dst:=dst + '*'+IntToStr(ss);
        DisInfo.Scale := ss;
      End;
    End;
  end
  else ofs1 := true;
  if ofs or ofs1 then
  begin
    DisInfo.Offset := offset32;

    dst:=dst+OutputHex(offset32,True);
  End;
  dst:=dst + ']';
end;

Procedure MDisasm.OutputMemAdr16(argno:Integer; var dst:AnsiString; arg:Integer; f1, f2:Boolean; DisInfo:PDisInfo; disLine:PAnsiString);
var
  PostByte, b,_mod:Byte;
  ofs, mm:Boolean;
  regcomb:AnsiString;
  sign:Char;
  idxofs:Integer;
  offset16, dval:Integer;
Begin
  offset16:=0;
  PostByte:=DIS.m_rgbInstr[DIS.m_ibModrm];
  b := PostByte and 7;
  _mod:=PostByte and $C0;
  if _mod = $C0 then  //mod=11
  begin
    if Not f1 and not f2 then
    begin
      idxofs := OutputGeneralRegister(dst, b, arg);
      DisInfo.OpRegIdx[argno] := idxofs + b;
      Exit;
    end;
    if f2 then dst:=dst + 'xmm' + IntToStr(b);
    Exit;
  end;
  ofs := false;
  regcomb := '';
  if (PostByte and $C7) = 6 then ofs:=true //mod=00;r/m=110
  else
  begin
    regcomb := RegCombTab[b];
    Case b Of
      0,1,7: DisInfo.BaseReg := 11;
      2,3,6: DisInfo.BaseReg := 13;
    End;
    case b of
      0,2,4: DisInfo.IndxReg := 14;
      1,3,5: DisInfo.IndxReg := 15;
    End;
  end;
  sign := #0;
  if _mod = $40 then  //mod=01
  Begin
    offset16:= ShortInt(DIS.m_rgbInstr[DIS.m_ibModrm+1]);
    sign:='+';
    if offset16<0 Then
    Begin
      offset16:= - offset16;
      sign:='-';
    end;
  end
  else if _mod = $80 then ofs:=true; //mod=10
  mm := f1 or f2;
  OutputSizePtr(arg, mm, DisInfo, disLine);
  OutputSegPrefix(dst, DisInfo);
  if (GetSegPrefix=0) and (regcomb='') then
  begin
    dst:=dst + 'ds:';
    DisInfo.SegPrefix := 3;
  end;
  dst:=dst + '[';
  if regcomb<>'' then dst:=dst + regcomb;
  if ofs then
  begin
    if regcomb<>'' then dst:=dst + '+';
    dval:=PWord(@DIS.m_rgbInstr[DIS.m_ibModrm+1])^;
    DisInfo.Offset := dval;
    dst:=dst + OutputHex(dval,False,4);
  end
  else if sign<>#0 then
  begin
    DisInfo.Offset := offset16;
    dst:=dst + OutputHex(offset16,True,0);
  end;
  dst:=dst+']';
end;

Procedure MDisasm.FormatArg(argno:Integer; cmd, arg:Integer; DisInfo:PDISINFO; disLine:PAnsiString);
Var
  dval, adr:Integer;
  idxofs, idxval, stno:Integer;
  Op:AnsiString;
Begin
  Op:='';
  Case cmd of
    1: //segment:offset
      begin
        if GetOperandSize then // 32-bit
        begin
          dval:=PWord(@DIS.m_rgbInstr[Dis.m_ibImmed+4])^;
          Op:='$'+IntToHex(dval,4)+':';
          dval:=PInteger(@DIS.m_rgbInstr[Dis.m_ibImmed])^;
          Op:=Op+IntToHex(dval,8);
        end
        else // 16-bit
        begin
          dval:=PWord(@DIS.m_rgbInstr[DIS.m_ibImmed+2])^;
          Op:='$'+IntToHex(dval,4)+':';
          dval:=PWord(@DIS.m_rgbInstr[DIS.m_ibImmed])^;
          Op:=Op+IntToHex(dval,4);
        end;
      end;
    2: //cr#
      Op:='cr'+IntToStr(GetPostByteReg);
    3: //Integer value (sar, shr)
      begin
        Op:=IntToStr(arg);
        DisInfo.Immediate := arg;
        //DisInfo.ImmPresent := true;
      end;
    4: //dr#
      Op:='dr'+IntToStr(GetPostByteReg);
    5: //General register
      begin
        idxval := GetCop and 7;
        idxofs := OutputGeneralRegister(Op, idxval, arg);
        DisInfo.OpRegIdx[argno] := idxofs + idxval;
      end;
    6: //General register
      begin
        idxval := GetCop1 and 7;
        idxofs := OutputGeneralRegister(Op, idxval, arg);
        DisInfo.OpRegIdx[argno] := idxofs + idxval;
      end;
    7: //Immediate byte
      begin
        if GetCop = $83 then dval:=PShortInt(@DIS.m_rgbInstr[DIS.m_ibImmed])^ // signed
          else dval:=PByte(@DIS.m_rgbInstr[DIS.m_ibImmed])^; // unsigned
        DisInfo.Immediate := dval;
        //DisInfo.ImmPresent := true;
        Op:=OutputHex(dval,Boolean(IfThen(GetCop = $83,1)),2);
      end;
    8: //Immediate byte
      begin
        dval:=PByte(@DIS.m_rgbInstr[DIS.m_ibImmed+2])^;
        DisInfo.Immediate := dval;
        //DisInfo.ImmPresent := true;
        Op:=OutputHex(dval,False,2);
      end;
    9: //Immediate dword
      begin
        if GetOperandSize then dval:=PInteger(@DIS.m_rgbInstr[DIS.m_ibImmed])^ // 32-bit
          else dval:=PSmallInt(@DIS.m_rgbInstr[DIS.m_ibImmed])^; // 16-bit
        DisInfo.Immediate := dval;
        //DisInfo.ImmPresent := true;
        Op:=OutputHex(dval,Boolean(IfThen(GetOp(DisInfo.Mnem)
          in [OP_CMP,OP_ADD,OP_ADC,OP_SUB,OP_SBB,OP_MUL,OP_IMUL,OP_DIV,OP_IDIV],1)));
      end;
    10: //Immediate word (ret)
      begin
        dval:=PWord(@DIS.m_rgbInstr[DIS.m_ibImmed])^;
        DisInfo.Immediate := dval;
        //DisInfo.ImmPresent := true;
        Op:=OutputHex(dval,False);
      end;
    11,12: //Address (jmp, jcond, call)
      begin
        adr := GetAddress;
        DisInfo.Immediate := adr;
        //DisInfo.ImmPresent := true;
        Op:=OutputHex(adr,False,8);
      end;
    13,15,27: //Memory
        if GetAddressSize then
          OutputMemAdr32(argno, Op, arg, cmd = 13, cmd = 27, DisInfo, disLine)
        else
          OutputMemAdr16(argno, Op, arg, cmd = 13, cmd = 27, DisInfo, disLine);
    14: //mm#
      Op:='mm'+IntToStr(GetPostByteReg);
    16: //General register
      begin
        idxval := GetPostByteReg;
        idxofs := OutputGeneralRegister(Op, idxval, arg);
        DisInfo.OpRegIdx[argno] := idxofs + idxval;
      end;
    17: //Segment register
      begin
        idxval := GetPostByteReg;
        DisInfo.OpRegIdx[argno] := idxval + 24;
        Op:=SegRegTab[idxval];
      end;
    18: //sreg:memory
      begin
        OutputSegPrefix(Op, DisInfo);
        if GetAddressSize then dval:=PInteger(@DIS.m_rgbInstr[DIS.m_ibImmed])^ // 32-bit
          else dval:=PWord(@DIS.m_rgbInstr[DIS.m_ibImmed])^; // 16-bit
        Op:='['+OutputHex(dval,False)+']';
        DisInfo.Offset := dval;    //!
      end;
    19: //8-bit register
      begin
        Op:=Reg8Tab[arg];
        DisInfo.OpRegIdx[argno] := arg;
      end;
    20: //General register
      begin
        idxval := arg;
        idxofs := OutputGeneralRegister(Op, idxval, 0);
        DisInfo.OpRegIdx[argno] := idxofs + idxval;
      end;
    21: //8-bit register
      begin
        Op:=Reg8Tab[arg];
        DisInfo.OpRegIdx[argno] := arg;
      end;
    22: //st
      begin
        Op:='st';
        DisInfo.OpRegIdx[argno] := 30;
      end;
    23: //st(#)
      begin
        stno := GetPostByteRm;
        Op:='st('+IntToStr(stno)+')';
        DisInfo.OpRegIdx[argno] := stno + 30;
      end;
    24: //Segment register
      begin
        Op:=SegRegTab[arg];
        DisInfo.OpRegIdx[argno] := arg + 24;
      end;
    25: //tr#
      Op:='tr'+IntToStr(GetPostByteReg);
    26: //[esi] or [si]
      begin
        OutputSizePtr(arg, false, DisInfo, disLine);
        OutputSegPrefix(Op, DisInfo);
        if GetAddressSize then
        begin
          DisInfo.BaseReg := 22;
          Op:='[esi]';
        end
        else
        begin
          DisInfo.BaseReg := 14;
          Op:='[si]';
        end;
      end;
    28: //xmm#
      Op:='xmm'+IntToStr(GetPostByteReg);
    29: //[edi] or es:[di]
      begin
        OutputSizePtr(arg, false, DisInfo, disLine);
        if GetAddressSize then
        begin
          DisInfo.BaseReg := 23;
          Op:='[edi]';
        end
        else
        begin
          DisInfo.SegPrefix := 0;
          DisInfo.BaseReg := 15;
          Op:='es:[di]';
        End;
      end;
    30: //[ebx] or [bx]
      begin
        OutputSizePtr(1, false, DisInfo, disLine);
        OutputSegPrefix(Op, DisInfo);
        if GetAddressSize then
        begin
          DisInfo.BaseReg := 19;
          Op:='[ebx]';
        end
        else
        begin
          DisInfo.BaseReg := 11;
          Op:='[bx]';
        End;
      end;
  End;
  if argno = 0 then
  begin
    DisInfo.Op1:=Op;
    DisInfo.OpType[0] := GetOpType(Op);
  end
  else if argno = 1 then
  begin
    //DisInfo.Op2:=Op;
    DisInfo.OpType[1] := GetOpType(Op);
  end
  else
  begin
    //DisInfo.Op3:=Op;
    DisInfo.OpType[2] := GetOpType(Op);
  end;
  if Assigned(disLine) then disLine^:=disLine^+Op;
end;

Function Mdisasm.GetAddressSize:Boolean;
Begin
  Result:=DIS.m_fAddress32;
end;

Function Mdisasm.GetOperandSize:Boolean;
Begin
  Result:=DIS.m_fOperand32;
end;

Function MDisasm.GetSegPrefix:Byte;
Begin
  Result:=DIS.m_bSegOverride;
end;

Function MDisasm.GetRepPrefix:Byte;
Begin
  Result:=DIS.m_bPrefix;
end;

Function MDisasm.GetCop:Byte;
Begin
  Result:=DIS.m_rgbInstr[DIS.m_ibOp];
end;

Function MDisasm.GetCop1:Byte;
Begin
  Result:=DIS.m_rgbInstr[DIS.m_ibOp+1];
end;

Function MDisasm.GetPostByte:Byte;
Begin
  Result:=DIS.m_rgbInstr[DIS.m_ibModrm];
end;

Procedure MDisasm.SetPostByte(b:BYTE);
Begin
  DIS.m_rgbInstr[DIS.m_ibModrm]:=b;
end;

Function MDisasm.GetPostByteMod:Byte;
Begin
  Result:=DIS.m_rgbInstr[DIS.m_ibModrm] and $C0;
end;

Function MDisasm.GetPostByteReg:Byte;
Begin
  Result:=(DIS.m_rgbInstr[DIS.m_ibModrm] Shr 3) and 7;
end;

Function MDisasm.GetPostByteRm:Byte;
Begin
  Result:=DIS.m_rgbInstr[DIS.m_ibModrm] and 7;
end;

Procedure MDisasm.SetOffset(ofs:Integer);
Begin
  if GetAddressSize then PInteger(@DIS.m_rgbInstr[DIS.m_ibImmed])^:=ofs
    else PWord(@DIS.m_rgbInstr[DIS.m_ibImmed])^:=ofs;
end;

Procedure MDisasm.GetInstrBytes(dst:PByte);
Begin
  MoveMemory(dst,@DIS.m_rgbInstr[0],DIS.m_cb);
end;

Procedure TDIS.Dumm2;
Begin
  //
end;

Function TDIS.AddrAddress (z:Cardinal;obj:TObject;adr:Integer):Int64;
Begin
  Result:=0;
end;

Function TDIS.AddrJumpTable (z:Cardinal;obj:TObject):Int64;
Begin
  Result:=0;
end;

Function TDIS.AddrOperand (z:Cardinal;obj:Tobject;adr:Integer):Int64;
Begin
  Result:=0;
end;

Function TDIS.AddrTarget (z:Cardinal;obj:TObject):Int64;
Begin
  Result:=0;
end;

Function TDIS.Cb (z:Cardinal;obj:TObject):Integer;
Begin
  Result:=0;
end;

Function TDIS.CbDisassemble (z:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar;adr:Int64):Integer;
Begin
  Result:=0;
end;

Function TDIS.CbGenerateLoadAddress (z:Cardinal;obj:TObject;idx:Integer;BufLen:Integer;Buf:PAnsiChar;adr:Integer):Integer;
Begin
  Result:=0;
end;

Function TDIS.CbJumpEntry (z:Cardinal;obj:TObject):Integer;
Begin
  Result:=0;
end;

Function TDIS.CbOperand (z:Cardinal;obj:TObject;size:Integer):Integer;
Begin
  Result:=0;
end;

Function TDIS.CchFormatBytes (z:Cardinal;obj:TObject;BufLen:Integer;Buf:PAnsiChar):Integer;
Begin
  Result:=0;
end;

Function TDIS.CchFormatBytesMax (z:Cardinal;obj:TObject):Integer;
Begin
  Result:=0;
end;

Function TDIS.Cinstruction (z:Cardinal;obj:TObject):Integer;
Begin
  Result:=0;
end;

Function TDIS.Coperand (z:Cardinal;obj:TObject):Integer;
Begin
  Result:=0;
end;

End.
