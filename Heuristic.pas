unit Heuristic;

interface

Uses Windows,Decompiler,Def_know;

Function BranchGetPrevInstructionType (fromAdr:Integer; Var jmpAdr:Integer; loopInfo:TLoopInfo):Integer;
Function IsBplByExport (Const bpl:AnsiString):Boolean;
Function IsInitStackViaLoop (fromAdr, toAdr:Integer):Integer;
Function IsBoundErr (fromAdr:Integer):Integer;
Function IsConnected (fromAdr, toAdr:Integer):Boolean;
Function IsExit (fromAdr:Integer):Boolean;
Function IsGeneralCase (fromAdr:Integer; retAdr:Integer):Integer;
Function IsXorMayBeSkipped (fromAdr:Integer):Boolean;
Function IsAbs (fromAdr:Integer):Integer;
Function IsIntOver (fromAdr:Integer):Integer;
Function IsInlineLengthTest (fromAdr:Integer):Integer;
Function IsInlineLengthCmp (fromAdr:Integer):Integer;
Function IsInlineDiv (fromAdr:Integer; Var _Div:Integer):Integer;
Function IsInlineMod (fromAdr:Integer; Var _Mod:Integer):Integer;
Function MatchCode (code:PAnsiChar; pInfo:PMProcInfo):Boolean;
Function IsTryBegin (fromAdr:Integer; Var endAdr:Integer):Integer;
Function IsTryBegin0 (fromAdr:Integer; Var endAdr:Integer):Integer;
Function IsTryEndPush (fromAdr:Integer; Var endAdr:Integer):Integer;
Function IsTryEndJump (fromAdr:Integer; Var endAdr:Integer):Integer;
Function ProcessInt64Equality (fromAdr:Integer; Var maxAdr:Integer):Integer;
Function ProcessInt64NotEquality (fromAdr:Integer; Var maxAdr:Integer):Integer;
Function ProcessInt64Comparison (fromAdr:Integer; Var maxAdr:Integer):Integer;
Function ProcessInt64ComparisonViaStack1 (fromAdr:Integer; Var maxAdr:Integer):Integer;
Function ProcessInt64ComparisonViaStack2 (fromAdr:Integer; Var maxAdr:Integer):Integer;
Function IsInt64Equality (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
Function IsInt64NotEquality (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
Function IsInt64Comparison (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
Function IsInt64ComparisonViaStack1 (fromAdr:Integer; Var skip1:Integer; Var simEnd:Integer):Integer;
Function IsInt64ComparisonViaStack2 (fromAdr:Integer; Var skip1, skip2:Integer; Var simEnd:Integer):Integer;
Function IsInt64Shr (fromAdr:Integer):Integer;
Function IsInt64Shl (fromAdr:Integer):Integer;

implementation

Uses Def_disasm,Misc,Main,Def_main,Types,Infos;

//-1 - error
//0 - simple if
//1 - jcc down
//2 - jcc up
//3 - jmp down
//4 - jump up
Function BranchGetPrevInstructionType (fromAdr:Integer; Var jmpAdr:Integer; loopInfo:TLoopInfo):Integer;
var
  p:Integer;
  disInfo:TDisInfo;
Begin
  jmpAdr := 0;
  p := GetNearestUpInstruction(Adr2Pos(fromAdr));
  if p= -1 then
  Begin
    Result:= -1;
    Exit;
  end;
  frmDisasm.Disassemble(Pos2Adr(p), @disInfo, Nil);
  if disInfo.Branch then
  begin
    if disInfo.Conditional then
    begin
      if disInfo.Immediate > Integer(CodeBase) + p then
      begin
        if Assigned(loopInfo) and (loopInfo.BreakAdr = disInfo.Immediate) then Result:=0
          Else Result:=1;
      End
      else Result:=2;
    End
    Else
    begin
      //if (IsExit(_disInfo.Immediate)) return 0;
      if disInfo.Immediate > Integer(CodeBase) + p then
      begin
        jmpAdr := disInfo.Immediate;
        Result:=3;
      End
      Else
      begin
        //jmp after jmp @HandleFinally
        if IsFlagSet(cfFinally, p) then
        begin
          p := GetNearestUpInstruction(Adr2Pos(disInfo.Immediate));
          //push Adr
          frmDisasm.Disassemble(Pos2Adr(p), @disInfo, Nil);
          if disInfo.Immediate = fromAdr Then Result:=0
          Else
          begin
            jmpAdr := disInfo.Immediate;
            Result:=3;
          End;
        End
        else Result:=4;
      End;
    End;
  End
  else Result:=0;
end;

Function IsBplByExport (Const bpl:AnsiString):Boolean;
var
	pHeader:PImageNtHeaders;
	pExport:PImageExportDirectory;
	pFuncNames:TIntegerDynArray;
	pFuncOrdinals:TWordDynArray;
	pFuncAddr:PInteger;
	pName:Integer;
	imageBase:PAnsiChar;
	szDll:PAnsiChar;
  hLib:THandle;
  curFunc:AnsiString;
  i,j,index:Integer;
  haveInitializeFunc, haveFinalizeFunc, haveGetPackageInfoTableFunc:Boolean;
Begin
  Result:=False;
	pHeader:=Nil;
	pExport:=Nil;
	pFuncNames:=Nil;
	pFuncOrdinals:=Nil;
	pFuncAddr:=Nil;
	pName:=0;
	imageBase:=Nil;
	szDll:=Nil;
  haveInitializeFunc:=False;
  haveFinalizeFunc:=False;
  haveGetPackageInfoTableFunc:=False;
	hLib := LoadLibraryEx(PAnsiChar(bpl), 0, LOAD_LIBRARY_AS_DATAFILE);
	imageBase := Pointer(hLib);
	if hLib<>0 then
  begin
		pHeader := PImageNtHeaders(hLib);
		if Assigned(pHeader) and (pHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress<>0)
      and (pHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].Size<>0) then
		begin
			pExport := PImageExportDirectory(pHeader.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress + imageBase);
			szDll := PAnsiChar(imageBase + pExport.Name);
			pFuncOrdinals	:= TWordDynArray(imageBase + Integer(pExport.AddressOfNameOrdinals));
			pFuncNames := TIntegerDynArray(imageBase + Integer(pExport.AddressOfNames));
			pFuncAddr	:= PInteger(imageBase + Integer(pExport.AddressOfFunctions));
			for i := 0 to pExport.NumberOfFunctions-1 do
			begin
				index := -1;
				for j := 0 to pExport.NumberOfNames-1 do
				begin
					if pFuncOrdinals[j] = i then
          begin
						index := j;
						break;
					end;
				end;
				if index <> -1 then
				begin
          pName := pFuncNames[index];
          curFunc := PAnsiChar(imageBase + pName);
          //Every BPL has a function called @GetPackageInfoTable, Initialize and Finalize.
          //lets catch it!
          if not haveInitializeFunc then haveInitializeFunc := (curFunc = 'Initialize');
          if not haveFinalizeFunc then haveFinalizeFunc := (curFunc = 'Finalize');
          if not haveGetPackageInfoTableFunc then
            haveGetPackageInfoTableFunc := (curFunc = '@GetPackageInfoTable');
				end;
        if haveInitializeFunc and haveFinalizeFunc and haveGetPackageInfoTableFunc then break;
			end;
			result := haveInitializeFunc and haveFinalizeFunc;
		End;
		FreeLibrary(hLib);
	end;
end;

//toAdr:dec reg
Function IsInitStackViaLoop (fromAdr, toAdr:Integer):Integer;
var
  stackSize:Integer;
  curAdr:Integer;
  instrLen:Integer;
  disInfo:TDisInfo;
Begin
  REsult:=0;
  stackSize:=0;
  curAdr := fromAdr;
  while curAdr <= toAdr do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    //if (!instrLen) return 0;
    if instrLen=0 then Inc(curAdr)
    //push ...
    else if disInfo.Mnem = 'push' then
    begin
      Inc(stackSize, 4);
      Inc(curAdr, instrLen);
    end
    //add esp, ...
    Else if (disInfo.Mnem = 'add') and (disInfo.OpType[0] = otREG)
      and (disInfo.OpRegIdx[0] = 20) and (disInfo.OpType[1] = otIMM) then
    begin
      if disInfo.Immediate < 0 then Dec(stackSize, disInfo.Immediate);
      Inc(curAdr, instrLen);
    end
    //sub esp, ...
    else if (disInfo.Mnem = 'sub') and (disInfo.OpType[0] = otREG)
      and (disInfo.OpRegIdx[0] = 20) and (disInfo.OpType[1] = otIMM) then
    begin
      if disInfo.Immediate > 0 then Inc(stackSize, disInfo.Immediate);
      Inc(curAdr, instrLen);
    end
    //dec
    Else
    begin
      if disInfo.Mnem= 'dec' then
      begin
        Inc(curAdr, instrLen);
        if curAdr= toAdr then
        Begin
          Result:=stackSize;
          Exit;
        end;
      end;
      break;
    End;
  end;
end;

//Check that fromAdr is BoundErr sequence
Function IsBoundErr (fromAdr:Integer):Integer;
var
  _pos, instrLen:Integer;
  adr:Integer;
  recN:InfoRec;
  disInfo:TDisInfo;
Begin
  REsult:=0;
  _pos := Adr2Pos(fromAdr);
  adr := fromAdr;
  while IsFlagSet(cfSkip, _pos) do
  begin
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
    Inc(adr, instrLen);
    if (disInfo.Call) and IsValidImageAdr(disInfo.Immediate) then
    begin
      recN := GetInfoRec(disInfo.Immediate);
      if recN.SameName('@BoundErr') Then
      Begin
        Result:=adr - fromAdr;
        Exit;
      End;
    end;
    Inc(_pos, instrLen);
  end;
end;

Function IsConnected (fromAdr, toAdr:Integer):Boolean;
var
  n, _pos, instrLen:Integer;
  adr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=False;
  _pos := Adr2Pos(fromAdr);
  adr := fromAdr;
  for n := 0 to 31 do
  begin
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
    if (disInfo.Conditional) and (disInfo.Immediate = toAdr) Then
    begin
      Result:=true;
      Exit;
    end;
    Inc(_pos, instrLen);
    Inc(adr, instrLen);
  end;
end;

//Check that fromAdr points to Exit
Function IsExit (fromAdr:Integer):Boolean;
var
  op:BYTE;
  _pos, instrLen:Integer;
  adr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=False;
  if not IsValidCodeAdr(fromAdr) then Exit;
  _pos := Adr2Pos(fromAdr);
  adr := fromAdr;
  while true do
  begin
    if not IsFlagSet(cfFinally or cfExcept, _pos) then break;
    Inc(_pos, 8);
    Inc(adr, 8);
    {_instrLen :=} frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    if (op = OP_PUSH) or (op = OP_JMP) then
    begin
      adr := disInfo.Immediate;
      _pos := Adr2Pos(adr);
    end
    else Exit;
  end;
  while true do
  begin
    instrLen := frmDisasm.Disassemble(Code + _pos, adr, @disInfo, Nil);
    if disInfo.Ret Then
    Begin
      Result:=true;
      Exit;
    end;
    op := frmDisasm.GetOp(disInfo.Mnem);
    if not ((op = OP_POP) or
      ((op = OP_MOV) and (disInfo.OpType[0] = otREG) and
        (IsSameRegister(disInfo.OpRegIdx[0], 16)
        or IsSameRegister(disInfo.OpRegIdx[0], 20)))) then Break;
    Inc(_pos, instrLen);
    Inc(adr, instrLen);
  end;
end;

Function IsGeneralCase (fromAdr:Integer; retAdr:Integer):Integer;
Var
  regIdx, _pos:Integer;
  curAdr,jmpAdr:Integer;
  curPos:Integer;
  len, num1:Integer;
  disInfo:TDisInfo;
Begin
  regIdx:=-1;
  curAdr := fromAdr;
  jmpAdr := 0;
  curPos := Adr2Pos(fromAdr);
  num1 := 0;
  Result:=0;
  if not IsValidCodeAdr(fromAdr) then Exit;
  while true do
  begin
    len := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    //Switch at current address
    if IsFlagSet(cfSwitch, curPos) then
    begin
      frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if disInfo.Mnem= 'ja' then
      begin
        if IsValidCodeAdr(disInfo.Immediate) then
          REsult:=disInfo.Immediate;
        Exit;
      End;
    End;
    //Switch at next address
    if IsFlagSet(cfSwitch, curPos + len) then
    begin
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if disInfo.Mnem= 'ja' then
      begin
        if IsValidCodeAdr(disInfo.Immediate) then
          Result:=disInfo.Immediate;
        Exit;
      End;
    End;
    //cmp reg, imm
    if (disInfo.Mnem = 'cmp') and (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM) then
    begin
      regIdx := disInfo.OpRegIdx[0];
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if (disInfo.Mnem = 'jb') or (disInfo.Mnem = 'jg') or (disInfo.Mnem = 'jge') then
      begin
        if IsGeneralCase(disInfo.Immediate, retAdr)<>0 then
        begin
          Inc(curAdr,len);
          Inc(curPos,len);
          len := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          if (disInfo.Mnem = 'jz') or (disInfo.Mnem = 'je') then
          begin
            Inc(curAdr,len);
            Inc(curPos,len);
            //continue;
          end;
          continue;
        End;
        break;
      End;
    End
    //sub reg, imm; dec reg
    else if ((disInfo.Mnem = 'sub') and (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM))
      or ((disInfo.Mnem = 'dec') and (disInfo.OpType[0] = otREG)) then
    begin
      Inc(num1);
      if regIdx = -1 then regIdx := disInfo.OpRegIdx[0]
      else if not IsSameRegister(regIdx, disInfo.OpRegIdx[0]) Then break;
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if (disInfo.Mnem = 'sub') and IsSameRegister(regIdx, disInfo.OpRegIdx[0]) then
        len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if disInfo.Mnem= 'jb' then
      begin
        Inc(curAdr,len);
        Inc(curPos,len);
        len := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        if (disInfo.Mnem= 'jz') or (disInfo.Mnem= 'je') then
        begin
          Inc(curAdr,len);
          Inc(curPos,len);
        End;
        continue;
      End
      else if (disInfo.Mnem= 'jz') or (disInfo.Mnem= 'je') then
      begin
        _pos := GetNearestUpInstruction(Adr2Pos(disInfo.Immediate));
        frmDisasm.Disassemble(Code + _pos, Pos2Adr(_pos), @disInfo, Nil);
        if disInfo.Mnem= 'jmp' then jmpAdr := disInfo.Immediate;
        if disInfo.Ret then jmpAdr := Pos2Adr(GetLastLocPos(retAdr));
        Inc(curAdr,len);
        Inc(curPos,len);
        continue;
      End
      else if (disInfo.Mnem= 'jnz') or (disInfo.Mnem= 'jne') then
      begin
        if jmpAdr=0 then
        begin
          //if only one dec or sub then it is simple if...else construction
          if num1 <> 1 then Result:=disInfo.Immediate;
          Exit;
        End;
        if disInfo.Immediate = jmpAdr then
        Begin
          Result:=jmpAdr;
          Exit;
        end;
      End;
      break;
    end
    //add reg, imm; inc reg
    else if ((disInfo.Mnem= 'add') and (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otIMM))
      or ((disInfo.Mnem= 'inc') and (disInfo.OpType[0] = otREG)) then
    begin
      Inc(num1);
      if regIdx = -1 then regIdx := disInfo.OpRegIdx[0]
      else if not IsSameRegister(regIdx, disInfo.OpRegIdx[0]) then break;
      len:=len + frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
      if disInfo.Mnem= 'sub' then
      begin
        len:=len+ frmDisasm.Disassemble(Code + curPos + len, curAdr + len, @disInfo, Nil);
        if disInfo.Mnem= 'jb' then
        begin
          Inc(curAdr,len);
          Inc(curPos,len);
          continue;
        End;
      End;
      if (disInfo.Mnem= 'jz') or (disInfo.Mnem = 'je') then
      begin
        Inc(curAdr,len);
        Inc(curPos,len);
        continue;
      End;
      break;
    End
    else if disInfo.Mnem = 'jmp' then
    begin
      if IsValidCodeAdr(disInfo.Immediate) then Result:=disInfo.Immediate;
      Exit;
    End;
    break;
  end;
end;

//check
//xor reg, reg
//mov reg,...
Function IsXorMayBeSkipped (fromAdr:Integer):Boolean;
var
  curAdr:Integer;
  instrlen, regIdx:Integer;
  curPos:Integer;
  disInfo:TDisInfo;
Begin
  curAdr:=fromAdr;
  curPos := Adr2Pos(fromAdr);
  Result:=False;
  instrlen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  if (disInfo.Mnem = 'xor') and (disInfo.OpType[0] = otREG) and (disInfo.OpType[1] = otREG)
    and (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1]) then
  begin
    regIdx := disInfo.OpRegIdx[0];
    Inc(curPos,instrlen);
    Inc(curAdr,instrlen);
    frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if (disInfo.Mnem = 'mov') and (disInfo.OpType[0] = otREG)
      and IsSameRegister(disInfo.OpRegIdx[0], regIdx) Then
    begin
      Result:=true;
      Exit;
    end;
  End;
end;

//Check construction (after cdq)
//xor eax, edx
//sub eax, edx
//return bytes to skip, if Abs, else return 0
Function IsAbs (fromAdr:Integer):Integer;
var
  curPos,instrLen,curAdr:Integer;
  disInfo:TDisInfo;
Begin
  REsult:=0;
  curPos:=Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  if (disInfo.Mnem= 'xor') and
    (disInfo.OpType[0] = otREG) and
    (disInfo.OpType[1] = otREG) and
    (disInfo.OpRegIdx[0] = 16) and
    (disInfo.OpRegIdx[1] = 18) then
  begin
    Inc(curPos, instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if (disInfo.Mnem= 'sub') and
      (disInfo.OpType[0] = otREG) and
      (disInfo.OpType[1] = otREG) and
      (disInfo.OpRegIdx[0] = 16) and
      (disInfo.OpRegIdx[1] = 18) then REsult:=curAdr + instrLen - fromAdr;
  End;
end;

//Check construction
//jxx @1
//call @IntOver
//@1:
//return bytes to skip, if @IntOver, else return 0
Function IsIntOver (fromAdr:Integer):Integer;
var
  instrLen, curPos,curAdr:Integer;
  recN:InfoRec;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curPos:=Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  if disInfo.Branch and disInfo.Conditional then
  begin
    Inc(curPos,instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if disInfo.Call then
      if IsValidCodeAdr(disInfo.Immediate) then
      begin
        recN := GetInfoRec(disInfo.Immediate);
        if Assigned(recN) and recN.SameName('@IntOver') then Result:=curAdr + instrLen - fromAdr;
      End;
  end;
end;

//Check construction (test reg, reg)
//test reg, reg
//jz @1
//mov reg, [reg-4]
//or-------------------------------------------------------------------------
//test reg, reg
//jz @1
//sub reg, 4
//mov reg, [reg]
Function IsInlineLengthTest (fromAdr:Integer):Integer;
var
  curPos,instrLen, regIdx:Integer;
  adr,curAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curPos := Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  if (disInfo.Mnem = 'test') and
    (disInfo.OpType[0] = otREG) and
    (disInfo.OpType[1] = otREG) and
    (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1]) then
  begin
    regIdx := disInfo.OpRegIdx[0];
    Inc(curPos,instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if (disInfo.Mnem= 'jz') or (disInfo.Mnem = 'je') then
    begin
      adr := disInfo.Immediate;
      Inc(curPos,instrLen);
      Inc(curAdr,instrLen);
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
      //mov reg, [reg-4]
      if (disInfo.Mnem = 'mov') and
        (disInfo.OpType[0] = otREG) and
        (disInfo.OpType[1] = otMEM) and
        (disInfo.BaseReg = regIdx) and
        (disInfo.IndxReg = -1) and
        (disInfo.Offset = -4) then
      begin
        if adr = curAdr + instrLen then
        Begin
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
      end
      //sub reg, 4
      else if (disInfo.Mnem = 'sub') and
        (disInfo.OpType[0] = otREG) and
        (disInfo.OpType[1] = otIMM) and
        (disInfo.Immediate = 4) then
      begin
        Inc(curPos,instrLen);
        Inc(curAdr,instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        //mov reg, [reg]
        if (disInfo.Mnem = 'mov') and
          (disInfo.OpType[0] = otREG) and
          (disInfo.OpType[1] = otMEM) and
          (disInfo.BaseReg = regIdx) and
          (disInfo.IndxReg = -1) and
          (disInfo.Offset = 0) then
        begin
          if adr = curAdr + instrLen Then
          Begin
            Result:=curAdr + instrLen - fromAdr;
            Exit;
          end;
        end;
      end;
    end;
  end;
end;

//cmp [lvar], 0
//jz @1
//mov reg, [lvar]
//sub reg, 4
//mov reg, [reg]
//mov [lvar], reg
Function IsInlineLengthCmp (fromAdr:Integer):Integer;
var
  op:BYTE;
  curPos,instrLen, regIdx:Integer;
  baseReg, offset:Integer;
  adr, curAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curPos := Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if (op = OP_CMP) and
    (disInfo.OpType[0] = otMEM) and
    (disInfo.OpType[1] = otIMM) and
    (disInfo.Immediate = 0) then
  begin
    baseReg := disInfo.BaseReg;
    offset := disInfo.Offset;
    Inc(curPos,instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if (disInfo.Mnem = 'jz') or (disInfo.Mnem = 'je') then
    begin
      adr := disInfo.Immediate;
      Inc(curPos,instrLen);
      Inc(curAdr,instrLen);
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
      op := frmDisasm.GetOp(disInfo.Mnem);
      //mov reg, [lvar]
      if (op = OP_MOV) and
        (disInfo.OpType[0] = otREG) and
        (disInfo.OpType[1] = otMEM) and
        (disInfo.BaseReg = baseReg) and
        (disInfo.Offset = offset) then
      begin
        regIdx := disInfo.OpRegIdx[0];
        Inc(curPos,instrLen);
        Inc(curAdr,instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        op := frmDisasm.GetOp(disInfo.Mnem);
        //sub reg, 4
        if (op = OP_SUB) and
          (disInfo.OpType[0] = otREG) and
          (disInfo.OpType[1] = otIMM) and
          (disInfo.Immediate = 4) then
        begin
          Inc(curPos,instrLen);
          Inc(curAdr,instrLen);
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          //mov reg, [reg]
          if (op = OP_MOV) and
            (disInfo.OpType[0] = otREG) and
            (disInfo.OpType[1] = otMEM) and
            (disInfo.BaseReg = regIdx) and
            (disInfo.IndxReg = -1) and
            (disInfo.Offset = 0) then
          begin
            Inc(curPos,instrLen);
            Inc(curAdr,instrLen);
            instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
            op := frmDisasm.GetOp(disInfo.Mnem);
            //mov [lvar], reg
            if (op = OP_MOV) and
              (disInfo.OpType[0] = otMEM) and
              (disInfo.OpType[1] = otREG) and
              (disInfo.BaseReg = baseReg) and
              (disInfo.Offset = offset) then
            begin
              if adr = curAdr + instrLen Then
              Begin
                Result:=curAdr + instrLen - fromAdr;
                Exit;
              End;
            end;
          End;
        End;
      End;
    End;
  end;
end;

//test reg, reg
//jns @1
//add reg, (2^k - 1)
//sar reg, k
//@1
Function IsInlineDiv (fromAdr:Integer; Var _Div:Integer):Integer;
Var
  op:BYTE;
  curPos, instrLen, regIdx:Integer;
  curAdr, imm:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curPos := Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if (op = OP_TEST) and
    (disInfo.OpType[0] = otREG) and
    (disInfo.OpType[1] = otREG) and
    (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1]) then
  begin
    regIdx := disInfo.OpRegIdx[0];
    Inc(curPos,instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    //op := frmDisasm.GetOp(disInfo.Mnem);
    if disInfo.Mnem = 'jns' then
    begin
      //adr := disInfo.Immediate;
      Inc(curPos,instrLen);
      Inc(curAdr,instrLen);
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
      op := frmDisasm.GetOp(disInfo.Mnem);
      if (op = OP_ADD) and
        (disInfo.OpType[0] = otREG) and
        (disInfo.OpRegIdx[0] = regIdx) and
        (disInfo.OpType[1] = otIMM) then
      begin
        imm := disInfo.Immediate + 1;
        Inc(curPos,instrLen);
        Inc(curAdr,instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        op := frmDisasm.GetOp(disInfo.Mnem);
        if (op = OP_SAR) and
          (disInfo.OpType[0] = otREG) and
          (disInfo.OpRegIdx[0] = regIdx) and
          (disInfo.OpType[1] = otIMM) then
        begin
          if (1 shl disInfo.Immediate) = imm then
          begin
            _div := imm;
            Result:=curAdr + instrLen - fromAdr;
            Exit;
          end;
        End;
      end;
    End;
  end;
end;

//and reg, imm
//jns @1
//dec reg
//or reg, imm
//inc reg
//@1
Function IsInlineMod (fromAdr:Integer; Var _Mod:Integer):Integer;
var
  op:BYTE;
  curPos, instrLen, regIdx:Integer;
  adr, curAdr, imm:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curPos := Adr2Pos(fromAdr);
  curAdr:=fromAdr;
  instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if (op = OP_AND) and
    (disInfo.OpType[0] = otREG) and
    (disInfo.OpType[1] = otIMM) and
    ((disInfo.Immediate and $80000000) <> 0) then
  begin
    regIdx := disInfo.OpRegIdx[0];
    imm := disInfo.Immediate and $7FFFFFFF;
    Inc(curPos,instrLen);
    Inc(curAdr,instrLen);
    instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
    if disInfo.Mnem = 'jns' then
    begin
      adr := disInfo.Immediate;
      Inc(curPos,instrLen);
      Inc(curAdr,instrLen);
      instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
      op := frmDisasm.GetOp(disInfo.Mnem);
      if (op = OP_DEC) and
        (disInfo.OpType[0] = otREG) and
        (disInfo.OpRegIdx[0] = regIdx) then
      begin
        Inc(curPos,instrLen);
        Inc(curAdr,instrLen);
        instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
        op := frmDisasm.GetOp(disInfo.Mnem);
        if (op = OP_OR) and
          (disInfo.OpType[0] = otREG) and
          (disInfo.OpType[1] = otIMM) and
          (disInfo.OpRegIdx[0] = regIdx) and
          (disInfo.Immediate + imm = -1) then
        begin
          Inc(curPos,instrLen);
          Inc(curAdr,instrLen);
          instrLen := frmDisasm.Disassemble(Code + curPos, curAdr, @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if (op = OP_INC) and
            (disInfo.OpType[0] = otREG) and
            (disInfo.OpRegIdx[0] = regIdx) then
          begin
            if adr = curAdr + instrLen then
            begin
              _mod := imm + 1;
              Result:=curAdr + instrLen - fromAdr;
              Exit;
            end;
          end;
        end;
      end;
    end;
  end;
end;

function MatchCode(code:PAnsiChar; pInfo:PMProcInfo): Boolean;
var
  _dumpSz,n:Integer;
  _dump,_reloc:PAnsiChar;
Begin
  REsult:=False;
	if (code=Nil) or (pInfo=Nil) then Exit;
  _dumpSz := pInfo.DumpSz;
  //ret
  if _dumpSz < 2 then Exit;
  _dump := pInfo.Dump;
  _reloc := _dump + _dumpSz;
  //jmp XXXXXXXX
  if (_dumpSz = 5) and (_dump[0] = #$E9) and (_reloc[1] = #$FF) then Exit;
  //call XXXXXXXX ret
  if (_dumpSz = 6) and (_dump[0] = #$E8) and (_reloc[1] = #$FF) and (_dump[5] = #$C3) then Exit;
  n := 0;
  While n<_dumpSz do
  begin
    //Relos skip
    if _reloc[n] = #$FF then
    begin
      Inc(n, 4);
      continue;
    End;
    if code[n] <> _dump[n] Then Exit;
    Inc(n);
  end;
  Result:=true;
end;

//Check try construction
//xor reg, reg
//push ebp
//push XXXXXXXX
//push fs:[reg]
//mov fs:[reg], esp
Function IsTryBegin (fromAdr:Integer; Var endAdr:Integer):Integer;
var
  op:BYTE;
  n,instrLen:Integer;
  curAdr, _endAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  for n:=1 to 5 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n Of
      1: if Not ((op = OP_XOR) and (disInfo.OpType[0] = disInfo.OpType[1])
        and (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1])) then Exit;
      2: if not ((op = OP_PUSH) and (disInfo.OpRegIdx[0] = 21)) then Exit;
      3:
        begin
          if not ((op = OP_PUSH) and (disInfo.OpType[0] = otIMM)) then Exit;
          _endAdr := disInfo.Immediate;
        End;
      4: if not ((op = OP_PUSH) and (disInfo.OpType[0] = otMEM)
        and (disInfo.SegPrefix = 4) and (disInfo.BaseReg <> -1)) then Exit;
      5:
        begin
          if not ((op = OP_MOV) and (disInfo.OpType[0] = otMEM)
            and (disInfo.SegPrefix = 4) and (disInfo.BaseReg <> -1)) then Exit;
          endAdr := _endAdr;
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
    End;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check try construction (Delphi3:Atlantis.exe at 0x50D676)
//push ebp
//push XXXXXXXX
//push fs:[0]
//mov fs:[0], esp
Function IsTryBegin0 (fromAdr:Integer; Var endAdr:Integer):Integer;
var
  op:BYTE;
  n,instrLen:Integer;
  curAdr, _endAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  for n:=1 to 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    case n of
      1: if not ((op = OP_PUSH) and (disInfo.OpRegIdx[0] = 21)) then Exit;
      2:
        begin
          if not ((op = OP_PUSH) and (disInfo.OpType[0] = otIMM)) then Exit;
          _endAdr := disInfo.Immediate;
        end;
      3: if not ((op = OP_PUSH) and (disInfo.OpType[0] = otMEM) And
        (disInfo.SegPrefix = 4) and (disInfo.BaseReg = -1) and (disInfo.Offset = 0)) Then Exit;
      4:
        begin
          if not ((op = OP_MOV) and (disInfo.OpType[0] = otMEM) and
            (disInfo.SegPrefix = 4) and (disInfo.BaseReg = -1) and (disInfo.Offset = 0)) then Exit;
          endAdr := _endAdr;
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        End;
    End;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check finally construction
//xor reg,reg
//pop reg
//pop reg
//pop reg
//mov fs:[reg],reg
//push XXXXXXXX
Function IsTryEndPush (fromAdr:Integer; Var endAdr:Integer):Integer;
var
  op:BYTE;
  n,instrLen, curAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  for n:=1 to 6 Do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n Of
      1: if not ((op = OP_XOR) and (disInfo.OpType[0] = disInfo.OpType[1])
        and (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1])) then Exit;
      2,3,4: if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then Exit;
      5: if not ((op = OP_MOV) and (disInfo.OpType[0] = otMEM)
        and (disInfo.SegPrefix = 4) and (disInfo.BaseReg <> -1)) Then Exit;
      6:
        begin
          if not ((op = OP_PUSH) and (disInfo.OpType[0] = otIMM)) then Exit;
          endAdr := disInfo.Immediate;
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check finally construction
//xor reg,reg
//pop reg
//pop reg
//pop reg
//mov fs:[reg],reg
//jmp XXXXXXXX
Function IsTryEndJump (fromAdr:Integer; Var endAdr:Integer):Integer;
var
  op:BYTE;
  n,instrLen, curAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  for n:=1 to 6 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    case n Of
      1: if not ((op = OP_XOR) and (disInfo.OpType[0] = disInfo.OpType[1])
        and (disInfo.OpRegIdx[0] = disInfo.OpRegIdx[1])) then Exit;
      2,3,4: if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then Exit;
      5: if not ((op = OP_MOV) and (disInfo.OpType[0] = otMEM)
        and (disInfo.SegPrefix = 4) and (disInfo.BaseReg <> -1)) then Exit;
      6:
        begin
          if not ((op = OP_JMP) and (disInfo.OpType[0] = otIMM)) then Exit;
          endAdr := disInfo.Immediate;
          Result:=curAdr - fromAdr;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction equality ((Int64)val = XXX)
//cmp XXX,XXX -> set cfSkip (_skipAdr1 = address of this instruction)
//jne @1 -> set cfSkip (_skipAdr2 = address of this instruction)
//cmp XXX,XXX
//jne @1
//...
//@1:
Function ProcessInt64Equality (fromAdr:Integer; Var maxAdr:Integer):Integer;
var
  op:BYTE;
  b:Char;
  instrLen, n, curPos:Integer;
  curAdr, adr1, _maxAdr:Integer;
  skipAdr1, skipAdr2:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  curPos := Adr2Pos(curAdr);
  _maxAdr := 0;
  for n := 1 To 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    b := Code[curPos];
    if b = #15 then b := Code[curPos + 1];
    b := Chr((Ord(b) and 15) + Ord('A'));
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n of
      1: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          skipAdr1 := curAdr;
        End;
      2: //jne @1
        begin
          if Not (disInfo.Branch and disInfo.Conditional and (b = 'F')) then Break;
          skipAdr2 := curAdr;
          adr1 := disInfo.Immediate; //@1
          if adr1 > _maxAdr Then _maxAdr := adr1;
        end;
      3: //cmp XXX,XXX
        if op <> OP_CMP then Break;
      4: //jne @1
        begin
          if Not (disInfo.Branch and disInfo.Conditional and (b = 'F') And
            (disInfo.Immediate = adr1)) then break;
          maxAdr := _maxAdr;
          SetFlag(cfSkip, Adr2Pos(skipAdr1));
          SetFlag(cfSkip, Adr2Pos(skipAdr2));
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
    Inc(curPos,instrLen);
  end;
end;

//Check construction not equality ((Int64)val <> XXX)
//cmp XXX,XXX -> set cfSkip (_skipAdr1 = address of this instruction)
//jne @1 -> set cfSkip (_skipAdr2 = address of this instruction)
//cmp XXX,XXX
//je @2
//@1:
Function ProcessInt64NotEquality (fromAdr:Integer; Var maxAdr:Integer):Integer;
var
  op:BYTE;
  b:Char;
  instrLen, n, curPos:Integer;
  curAdr, adr1,adr2, _maxAdr:Integer;
  skipAdr1, skipAdr2:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  curPos := Adr2Pos(curAdr);
  _maxAdr := 0;
  for n := 1 to 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    b := Code[curPos];
    if b = #15 then b := Code[curPos + 1];
    b := Chr((Ord(b) and 15) + Ord('A'));
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n of
      1: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          skipAdr1 := curAdr;
        end;
      2: //jne @1
        begin
          if not (disInfo.Branch and disInfo.Conditional and (b = 'F')) then break;
          skipAdr2 := curAdr;
          adr1 := disInfo.Immediate; //@1
          if adr1 > _maxAdr then _maxAdr := adr1;
        End;
      3: //cmp XXX,XXX
        if op <> OP_CMP then Break;
      4:  //je @2
        begin
          if not (disInfo.Branch and disInfo.Conditional and
            (b = 'E') and (curAdr + instrLen = adr1)) then break;
          adr2 := disInfo.Immediate; //@2
          if adr2 > _maxAdr then _maxAdr := adr2;
          maxAdr := _maxAdr;
          SetFlag(cfSkip, Adr2Pos(skipAdr1));
          SetFlag(cfSkip, Adr2Pos(skipAdr2));
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
    Inc(curPos,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) XXX)
//cmp XXX,XXX -> set cfSkip (_skipAdr1 = address of this instruction)
//jxx @1 -> set cfSkip (_skipAdr2 = address of this instruction)
//cmp XXX,XXX
//jxx @@ -> set cfSkip (_skipAdr3 = address of this instruction)
//jmp @@ set cfSkip (_skipAdr4 = address of this instruction)
//@1:jxx @@
Function ProcessInt64Comparison (fromAdr:Integer; Var maxAdr:Integer):Integer;
var
  op:BYTE;
  n,instrLen:Integer;
  curAdr, adr,adr1, _maxAdr:Integer;
  skipAdr1, skipAdr2, skipAdr3, skipAdr4:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  _maxAdr := 0;
  for n:=1 to 6 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n of
      1: // cmp XXX,XXX
        Begin
          if op <> OP_CMP then Break;
          skipAdr1 := curAdr;
        end;
      2: // jxx @1
        begin
          if not (disInfo.Branch and disInfo.Conditional) then Break;
          skipAdr2 := curAdr;
          adr1 := disInfo.Immediate; //@1
          if adr1 > _maxAdr then _maxAdr := adr1;
        end;
      3: // cmp XXX,XXX
        if op <> OP_CMP then Break;
      4: // jxx @@
        begin
          if not (disInfo.Branch and disInfo.Conditional) then Break;
          skipAdr3 := curAdr;
          adr := disInfo.Immediate; //@@
          if adr > _maxAdr then _maxAdr := adr;
        End;
      5: // jmp @@
        begin
          if not (disInfo.Branch and not disInfo.Conditional) then Break;
          skipAdr4 := curAdr;
          adr := disInfo.Immediate; //@@
          if adr > _maxAdr then _maxAdr := adr;
        end;
      6: // @1:jxx @@
        begin
          if not (disInfo.Branch and disInfo.Conditional and (curAdr = adr1)) then Break;
          adr := disInfo.Immediate; //@@
          if adr > _maxAdr then _maxAdr := adr;
          maxAdr := _maxAdr;
          SetFlag(cfSkip, Adr2Pos(skipAdr1));
          SetFlag(cfSkip, Adr2Pos(skipAdr2));
          SetFlag(cfSkip, Adr2Pos(skipAdr3));
          SetFlag(cfSkip, Adr2Pos(skipAdr4));
          Result:=curAdr + instrLen - fromAdr;
          Exit;
        end;
    End;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) XXX)
//push reg
//push reg
//...
//cmp XXX,[esp+4] (m-th row) set cfSkip (_skipAdr1)
//jxx @1 ->set cfSkip (_skipAdr2)
//cmp XXX,[esp]
//@1:pop reg
//pop reg
//jxx @2
Function ProcessInt64ComparisonViaStack1 (fromAdr:Integer; Var maxAdr:Integer):Integer;
var
  op:BYTE;
  instrLen,n,m,_pos:Integer;
  curAdr, adr1, _maxAdr,pushAdr:Integer;
  skipAdr1, skipAdr2:Integer;
  disInfo:TDisInfo;
Begin
  REsult:=0;
  curAdr := fromAdr;
  m := -1;
  _maxAdr := 0;
  for n := 1 to 1024 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    if n = 1 then
    begin
      //push reg
      if Not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if n = 2 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
      pushAdr := curAdr;
    end
    else if (n >= 3) and (m = -1) and (op = OP_CMP) and (disInfo.OpType[1] = otMEM)
      and (disInfo.BaseReg = 20) and (disInfo.Offset = 4) then
    begin
      //cmp XXX,[esp+4]
      //Find nearest up instruction "push reg"
      _pos := Adr2Pos(curAdr);
      while true do
      begin
        Dec(_pos);
        if _pos = fromAdr then break;
        if IsFlagSet(cfInstruction, _pos) then
        begin
          frmDisasm.Disassemble(Pos2Adr(_pos), @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if op = OP_PUSH then break;
        end;
      end;
      if Pos2Adr(_pos) <> pushAdr then Exit;
      m := n;
      skipAdr1 := curAdr;
    end
    else if (m <> -1) and (n = m + 1) then
    begin
      //jxx @1
      if not (disInfo.Branch and disInfo.Conditional) then break;
      skipAdr2 := curAdr;
      adr1 := disInfo.Immediate; //@1
      if adr1 > _maxAdr then _maxAdr := adr1;
    end
    else if (m <> -1) and (n = m + 2) then
    begin
      //cmp XXX,[esp]
      if not ((op = OP_CMP) and (disInfo.OpType[1] = otMEM)
        and (disInfo.BaseReg = 20) and (disInfo.Offset = 0)) then break;
    end
    else if (m <> -1) and (n = m + 3) then
    begin
      //@1:pop reg
      if Not ((op = OP_POP) and (disInfo.OpType[0] = otREG) and (curAdr = adr1)) then break;
    end
    else if (m <> -1) and (n = m + 4) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 5) then
    begin
      //jxx @2
      if not (disInfo.Branch and disInfo.Conditional) then break;
      maxAdr := _maxAdr;
      SetFlag(cfSkip, Adr2Pos(skipAdr1));
      SetFlag(cfSkip, Adr2Pos(skipAdr2));
      REsult:=curAdr + instrLen - fromAdr;
      Exit;
    end;
    if (m = -1) and (disInfo.Ret or disInfo.Branch) then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) XXX)
//push reg
//push reg
//...
//cmp XXX,[esp+4] (m-th row) set cfSkip (_skipAdr1)
//jxx @1 ->set cfSkip (_skipAdr2)
//cmp XXX,[esp]
//pop reg ->set cfSkip (_skipAdr3)
//pop reg ->set cfSkip (_skipAdr4)
//jxx @@ ->set cfSkip (_skipAdr5)
//jmp @@ ->set cfSkip (_skipAdr6)
//@1:
//pop reg
//pop reg
//jxx @2
Function ProcessInt64ComparisonViaStack2 (fromAdr:Integer; Var maxAdr:Integer):Integer;
Var
  op:BYTE;
  instrLen, n, m, _pos:Integer;
  curAdr, adr, adr1, adr2, _maxAdr, pushAdr:Integer;
  skipAdr1, skipAdr2, skipAdr3, skipAdr4, skipAdr5, skipAdr6:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  m := -1;
  _maxAdr := 0;
  for n := 1 To 1024 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    if n = 1 then
    begin
      //push reg
      if Not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if n = 2 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
      pushAdr := curAdr;
    end
    else if (n >= 3) and (m = -1) and (op = OP_CMP) and (disInfo.OpType[1] = otMEM)
      and (disInfo.BaseReg = 20) and (disInfo.Offset = 4) then
    begin
      //cmp XXX,[esp+4]
      //Find nearest up instruction "push reg"
      _pos := Adr2Pos(curAdr);
      while true do
      begin
        Dec(_pos);
        if _pos = fromAdr then break;
        if IsFlagSet(cfInstruction, _pos) then
        begin
          frmDisasm.Disassemble(Pos2Adr(_pos), @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if op = OP_PUSH then break;
        end;
      end;
      if Pos2Adr(_pos) <> pushAdr then Exit;
      m := n;
      skipAdr1 := curAdr;
    end
    else if (m <> -1) and (n = m + 1) then
    begin
      //jxx @1
      if not (disInfo.Branch and disInfo.Conditional) then break;
      skipAdr2 := curAdr;
      adr1 := disInfo.Immediate; //@1
      if adr1 > _maxAdr then _maxAdr := adr1;
    end
    else if (m <> -1) and (n = m + 2) then
    begin
      //cmp XXX,[esp]
      if not ((op = OP_CMP) and (disInfo.OpType[1] = otMEM)
        and (disInfo.BaseReg = 20) and (disInfo.Offset = 0)) then break;
    end
    else if (m <> -1) and (n = m + 3) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
      skipAdr3 := curAdr;
    end
    else if (m <> -1) and (n = m + 4) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
      skipAdr4 := curAdr;
    end
    else if (m <> -1) and (n = m + 5) then
    begin
      //jxx @@
      if not (disInfo.Branch and disInfo.Conditional) then break;
      skipAdr5 := curAdr;
      adr := disInfo.Immediate; //@3
      if adr > _maxAdr then _maxAdr := adr;
    end
    else if (m <> -1) and (n = m + 6) then
    begin
      //jmp @@
      if not (disInfo.Branch and not disInfo.Conditional) then break;
      skipAdr6 := curAdr;
      adr := disInfo.Immediate; //@2
      if adr > _maxAdr then _maxAdr := adr;
    end
    else if (m <> -1) and (n = m + 7) then
    begin
      //@1:pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG) and (curAdr = adr1)) then break;
    end
    else if (m <> -1) and (n = m + 8) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 9) then
    begin
      //jxx @2
      if not (disInfo.Branch and disInfo.Conditional) then break;
      adr2 := disInfo.Immediate;
      if adr2 > _maxAdr then _maxAdr := adr2;
      maxAdr := _maxAdr;
      SetFlag(cfSkip, Adr2Pos(skipAdr1));
      SetFlag(cfSkip, Adr2Pos(skipAdr2));
      SetFlag(cfSkip, Adr2Pos(skipAdr3));
      SetFlag(cfSkip, Adr2Pos(skipAdr4));
      SetFlag(cfSkip, Adr2Pos(skipAdr5));
      SetFlag(cfSkip, Adr2Pos(skipAdr6));
      Result:=curAdr + instrLen - fromAdr;
    End;
    if (m = -1) and (disInfo.Ret or disInfo.Branch) then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction equality ((Int64)val = XXX)
//cmp XXX,XXX
//jne @1 (_br1Adr = address of this instruction)
//cmp XXX,XXX ->skip1 up to this instruction
//jne @1 -> skip2 up to this instruction, Result = skip2
//...
//@1:... -> delete 1 xRef to this instruction (address = _adr1)
Function IsInt64Equality (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
var
  imm:Boolean;
  op:BYTE;
  b:Char;
  n,instrLen, curPos, skip:Integer;
  curAdr, adr1, br1Adr:Integer;
  disInfo:TDisInfo;
  val1, val2:Int64;
  //recN:InfoRec;
Begin
  Result:=0;
  curAdr := fromAdr;
  curPos := Adr2Pos(curAdr);
  imm := false;
  for n:=1 to 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    b := Code[curPos];
    if b = #15 then b := Code[curPos + 1];
    b := Chr((Ord(b) and 15) + Ord('A'));
    op := frmDisasm.GetOp(disInfo.Mnem);
    case n of
      1: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val1 := disInfo.Immediate;
          end;
        end;
      2: //jne @1
        begin
          if not (disInfo.Branch and disInfo.Conditional and (b = 'F')) then break;
          br1Adr := curAdr;
          adr1 := disInfo.Immediate; //@1
        end;
      3: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          skip1 := curAdr - fromAdr;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val2 := disInfo.Immediate;
          end;
        End;
      4: //jne @1
        begin
          if not (disInfo.Branch and disInfo.Conditional and (b = 'F')
            And (disInfo.Immediate = adr1)) then break;
          skip := curAdr - fromAdr;
          skip2 := skip;
          immVal := imm;
          if imm then Val := (val1 shl 32) or val2;
          Result:=skip;
          Exit;
        End;
    End;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
    Inc(curPos,instrLen);
  end;
end;

//Check construction not equality ((Int64)val <> XXX)
//cmp XXX,XXX
//jne @1 (_br1Adr = address of this instruction)
//cmp XXX,XXX ->skip1 up to this instruction
//je @2 -> skip2 up to this instruction, Result = skip2
//@1:... -> delete 1 xRef to this instruction (address = _adr1)
Function IsInt64NotEquality (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
var
  imm:Boolean;
  op:Byte;
  b:Char;
  instrLen, n, curPos, skip:Integer;
  curAdr, adr1, br1Adr:Integer;
  disInfo:TDisInfo;
  val1, val2:Int64;
  //recN:InfoRec;
Begin
  Result:=0;
  curAdr := fromAdr;
  curPos := Adr2Pos(curAdr);
  imm := false;
  for n := 1 to 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    b := Code[curPos];
    if b = #15 then b := Code[curPos + 1];
    b := Chr((Ord(b) and 15) + Ord('A'));
    op := frmDisasm.GetOp(disInfo.Mnem);
    case n of
      1: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val1 := disInfo.Immediate;
          end;
        end;
      2: //jne @1
        begin
          if not (disInfo.Branch and disInfo.Conditional and (b = 'F')) then break;
          br1Adr := curAdr;
          adr1 := disInfo.Immediate; //@1
        end;
      3: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          skip1 := curAdr - fromAdr;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val2 := disInfo.Immediate;
          End;
        end;
      4: //je @2
        begin
          if not (disInfo.Branch and disInfo.Conditional and (b = 'E') And
             (curAdr + instrLen = adr1)) then break;
          skip := curAdr - fromAdr;
          skip2 := skip;
          immVal := imm;
          if imm then Val := (val1 shl 32) or val2;
          Result:=skip;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
    Inc(curPos,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) XXX)
//cmp XXX,XXX
//jxx @1 (_br1Adr = address of this instruction)
//cmp XXX,XXX ->skip1 up to this instruction
//jxx @@ (_br3Adr = address of this instruction)
//jmp @@ (_br2Adr = address of this instruction)
//@1:jxx @@ (skip2 up to this instruction, Result = skip2)
Function IsInt64Comparison (fromAdr:Integer; Var skip1, skip2:Integer; Var immVal:Boolean; Var Val:Int64):Integer;
var
  imm:Boolean;
  op:Byte;
  instrLen, n, skip:Integer;
  curAdr, adr1, br1Adr, br2Adr, br3Adr:Integer;
  disInfo:TDisInfo;
  val1, val2:Int64;
  //recN:InfoRec;
Begin
  Result:=0;
  curAdr := fromAdr;
  imm := false;
  for n := 1 to 4 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    Case n Of
      1: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Break;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val1 := disInfo.Immediate;
          end;
        End;
      2: //jxx @1
        begin
          if not (disInfo.Branch and disInfo.Conditional) then break;
          br1Adr := curAdr;
          adr1 := disInfo.Immediate; //@1
        end;
      3: //cmp XXX,XXX
        begin
          if op <> OP_CMP then Exit;
          skip1 := curAdr - fromAdr;
          if disInfo.OpType[1] = otIMM then
          begin
            imm := true;
            val2 := disInfo.Immediate;
          end;
        end;
      4: //jxx @@
        begin
          if not (disInfo.Branch and disInfo.Conditional) then break;
          br3Adr := curAdr;
        end;
      5: //jmp @@
        begin
          if not (disInfo.Branch and not disInfo.Conditional) then break;
          br2Adr := curAdr;
        End;
      6: //@1:jxx @@
        begin
          if not (disInfo.Branch and disInfo.Conditional and (curAdr = adr1)) then break;
          skip := curAdr - fromAdr;
          skip2 := skip;
          immVal := imm;
          if imm then Val := (val1 shl 32) or val2;
          Result:=skip;
          Exit;
        end;
    end;
    if disInfo.Ret then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) N)
//push reg
//push reg
//...
//cmp XXX,[esp+4] (m-th row) ->Simulate upto this address
//jxx @1
//cmp XXX,[esp] ->skip1=this position
//@1:pop reg
//pop reg
//jxx @@ ->Result
Function IsInt64ComparisonViaStack1 (fromAdr:Integer; Var skip1:Integer; Var simEnd:Integer):Integer;
var
  op:BYTE;
  instrLen, n, m, _pos:Integer;
  curAdr, adr1, pushAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  skip1 := 0;
  simEnd := 0;
  m := -1;
  for n := 1 to 1024 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    if n = 1 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if n = 2 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
      pushAdr := curAdr;
    end
    else if (n >= 3) and (m = -1) and (op = OP_CMP) and (disInfo.OpType[1] = otMEM)
      and (disInfo.BaseReg = 20) and (disInfo.Offset = 4) then
    begin
      //cmp XXX,[esp+4]
      //Find nearest up instruction "push reg"
      _pos := Adr2Pos(curAdr);
      while true do
      begin
        Dec(_pos);
        if _pos = fromAdr then break;
        if IsFlagSet(cfInstruction, _pos) then
        begin
          frmDisasm.Disassemble(Pos2Adr(_pos), @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if op = OP_PUSH then break;
        end;
      End;
      if Pos2Adr(_pos) <> pushAdr then Exit;
      m := n;
      simEnd := curAdr;
    end
    else if (m <> -1) and (n = m + 1) then
    begin
      //jxx @1
      if not (disInfo.Branch and disInfo.Conditional) then break;
      adr1 := disInfo.Immediate; //@1
    end
    else if (m <> -1) and (n = m + 2) then
    begin
      //cmp XXX,[esp]
      if not ((op = OP_CMP) and (disInfo.OpType[1] = otMEM)
        and (disInfo.BaseReg = 20) and (disInfo.Offset = 0)) then break;
      skip1 := curAdr - fromAdr;
    end
    else if (m <> -1) and (n = m + 3) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG) and (curAdr = adr1)) then break;
    end
    else if (m <> -1) and (n = m + 4) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 5) then
    begin
      //jxx @@
      if not (disInfo.Branch and disInfo.Conditional) then break;
      Result:=curAdr - fromAdr;
      Exit;
    end;
    if (m = -1) and (disInfo.Ret or disInfo.Branch) then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction comparison ((Int64)val >(<) XXX)
//push reg
//push reg
//...
//cmp XXX,[esp+4] (m-th row) ->Simulate upto this address
//jxx @1
//cmp XXX,[esp] ->skip1=this position
//pop reg
//pop reg
//jxx @@ ->skip2
//jmp @@
//@1:
//pop reg
//pop reg
//jxx @@ ->Result
Function IsInt64ComparisonViaStack2 (fromAdr:Integer; Var skip1, skip2:Integer; Var simEnd:Integer):Integer;
var
  op:Byte;
  instrLen, n, m, _pos:Integer;
  curAdr, adr1, pushAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  simEnd := 0;
  m := -1;
  for n := 1 To 1024 do
  begin
    instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
    op := frmDisasm.GetOp(disInfo.Mnem);
    if n = 1 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if n = 2 then
    begin
      //push reg
      if not ((op = OP_PUSH) and (disInfo.OpType[0] = otREG)) then break;
      pushAdr := curAdr;
    end
    else if (n >= 3) and (m = -1) and (op = OP_CMP) and (disInfo.OpType[1] = otMEM)
      and (disInfo.BaseReg = 20) and (disInfo.Offset = 4) then
    begin
      //cmp XXX,[esp+4]
      //Find nearest up instruction "push reg"
      _pos := Adr2Pos(curAdr);
      while true do
      begin
        Dec(_pos);
        if _pos = fromAdr then Break;
        if IsFlagSet(cfInstruction, _pos) then
        begin
          frmDisasm.Disassemble(Pos2Adr(_pos), @disInfo, Nil);
          op := frmDisasm.GetOp(disInfo.Mnem);
          if op = OP_PUSH then break;
        end;
      end;
      if Pos2Adr(_pos) <> pushAdr then Exit;
      m := n;
      simEnd := curAdr;
    end
    else if (m <> -1) and (n = m + 1) then
    begin
      //jxx @1
      if not (disInfo.Branch and disInfo.Conditional) then Break;
      adr1 := disInfo.Immediate; //@1
    end
    else if (m <> -1) and (n = m + 2) then
    begin
      //cmp XXX,[esp]
      if not ((op = OP_CMP) and (disInfo.OpType[1] = otMEM)
        and (disInfo.BaseReg = 20) and (disInfo.Offset = 0)) then break;
      skip1 := curAdr - fromAdr;
    end
    else if (m <> -1) and (n = m + 3) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 4) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 5) then
    begin
      //jxx @@
      if not (disInfo.Branch and disInfo.Conditional) then break;
      skip2 := curAdr - fromAdr;
    end
    else if (m <> -1) and (n = m + 6) then
    begin
      //jmp @@
      if not (disInfo.Branch and not disInfo.Conditional) then break;
    end
    else if (m <> -1) and (n = m + 7) then
    begin
      //@1:pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG) and (curAdr = adr1)) then break;
    end
    else if (m <> -1) and (n = m + 8) then
    begin
      //pop reg
      if not ((op = OP_POP) and (disInfo.OpType[0] = otREG)) then break;
    end
    else if (m <> -1) and (n = m + 9) then
    begin
      //jxx @@
      if not (disInfo.Branch and disInfo.Conditional) then Break;
      REsult:=curAdr - fromAdr;
      Exit;
    end;
    if (m = -1) and (disInfo.Ret or disInfo.Branch) then Exit;
    Inc(curAdr,instrLen);
  end;
end;

//Check construction
//shrd reg1,reg2,N
//shr reg2,N
Function IsInt64Shr (fromAdr:Integer):Integer;
Var
  op:BYTE;
  instrLen, idx, _val:Integer;
  curAdr:Integer;
  disInfo:TDisInfo;
Begin
  REsult:=0;
  curAdr := fromAdr;
  // 1
  instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if not ((op = OP_SHR) and (disInfo.OpNum = 3) and (disInfo.OpType[0] = otREG)
    and (disInfo.OpType[1] = otREG) and (disInfo.OpType[2] = otIMM)) then Exit;
  idx := disInfo.OpRegIdx[1];
  _val := disInfo.Immediate;
  // 2
  Inc(curAdr,instrLen);
  instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if not ((op = OP_SHR) and (disInfo.OpNum = 2) and (disInfo.OpType[0] = otREG)
    And (disInfo.OpType[1] = otIMM) and (disInfo.OpRegIdx[0] = idx)
    and (disInfo.Immediate = _val)) then Exit;
  Result:=curAdr + instrLen - fromAdr;
end;

//Check construction
//shld reg1,reg2,N
//shl reg2,N
Function IsInt64Shl (fromAdr:Integer):Integer;
Var
  op:BYTE;
  instrLen, idx, _val:Integer;
  curAdr:Integer;
  disInfo:TDisInfo;
Begin
  Result:=0;
  curAdr := fromAdr;
  // 1
  instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if not ((op = OP_SHL) and (disInfo.OpNum = 3) and (disInfo.OpType[0] = otREG)
    and (disInfo.OpType[1] = otREG) and (disInfo.OpType[2] = otIMM)) then Exit;
  idx := disInfo.OpRegIdx[1];
  _val := disInfo.Immediate;
  // 2
  Inc(curAdr,instrLen);
  instrLen := frmDisasm.Disassemble(curAdr, @disInfo, Nil);
  op := frmDisasm.GetOp(disInfo.Mnem);
  if not ((op = OP_SHL) and (disInfo.OpNum = 2) and (disInfo.OpType[0] = otREG)
    and (disInfo.OpType[2] = otIMM) and (disInfo.OpRegIdx[0] = idx)
    and (disInfo.Immediate = _val)) then Exit;
  Result:=curAdr + instrLen - fromAdr;
end;

end.
