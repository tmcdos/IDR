Unit ActiveProcesses;

Interface

Uses Classes, Windows, SysUtils, Controls, StdCtrls, Forms, ComCtrls, PsApi, TlHelp32;

Type
  TFActiveProcesses=class(TForm)
    btnDump:TButton;
    btnCancel:TButton;
    lvProcesses:TListView;
    procedure btnCancelClick(Sender: TObject);
    procedure btnDumpClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure lvProcessesClick(Sender: TObject);
  private
    InstKernel32:THandle;
    InstPSAPI:THandle;
    ProcessesNum:Cardinal;
    ModulesNum:Cardinal;
    ProcessIds:Array of Integer; // 1024
    ModuleHandles:Array Of HModule; // 1024
    lpCreateToolhelp32Snapshot:TCreateToolhelp32Snapshot;
    lpProcess32First:TProcess32First;
    lpProcess32Next:TProcess32Next;
    lpModule32First:TModule32First;
    lpModule32Next:TModule32Next;
    lpEnumProcesses:TEnumProcesses;
    lpEnumProcessModules:TEnumProcessModules;
    lpGetModuleFileNameEx:TGetModuleFileNameEx;
    lpGetModuleInformation:TGetModuleInformation;
    function IsWindows2000OrHigher:Boolean;
    procedure ShowProcesses95;
    procedure ShowProcessesNT;
  public
    procedure ShowProcesses;
    procedure EnumSections(HProcess:THandle; PProcessBase:Pointer; Buffer:PImageSectionHeader; var Secnum:Cardinal);
    procedure DumpProcess(PID:Cardinal; MemStream:TMemoryStream; var BoC, PoC, ImB:Integer);
  end;

Var
  FActiveProcesses:TFActiveProcesses;
  
Implementation

{$R *.DFM}

Uses Main,Dialogs,Def_main;

procedure TFActiveProcesses.FormCreate(Sender: TObject);
begin
  InstPSAPI := 0;
  lpEnumProcesses := Nil;
  lpEnumProcessModules := Nil;

  InstKernel32 := 0;
  lpCreateToolhelp32Snapshot := Nil;
  lpProcess32First := Nil;
  lpProcess32Next := Nil;
  lpModule32First := Nil;
  lpModule32Next := Nil;

  //Load PSAPI
  if IsWindows2000OrHigher then
  begin
    //Supported starting from Windows XP/Server 2003
    InstPSAPI := LoadLibrary('PSAPI.DLL');
    if InstPSAPI<>0 then
    begin
      lpEnumProcesses         := GetProcAddress(InstPSAPI, 'EnumProcesses');
      lpEnumProcessModules    := GetProcAddress(InstPSAPI, 'EnumProcessModules');
      lpGetModuleFileNameEx   := GetProcAddress(InstPSAPI, 'GetModuleFileNameExA');
      lpGetModuleInformation  := GetProcAddress(InstPSAPI, 'GetModuleInformation');
    End;
  end
  else
  begin
    InstKernel32 := LoadLibrary('kernel32.dll');
    if InstKernel32<>0 then
    begin
      lpCreateToolhelp32Snapshot  := GetProcAddress(InstKernel32, 'CreateToolhelp32Snapshot');
      lpProcess32First            := GetProcAddress(InstKernel32, 'Process32First');
      lpProcess32Next             := GetProcAddress(InstKernel32, 'Process32Next');
      lpModule32First             := GetProcAddress(InstKernel32, 'Module32First');
      lpModule32Next              := GetProcAddress(InstKernel32, 'Module32Next');
    End;
  End;
  SetLength(ProcessIds,1024);
  SetLength(ModuleHandles,1024);
end;

procedure TFActiveProcesses.FormDestroy(Sender: TObject);
begin
  if InstPSAPI<>0 then FreeLibrary(InstPSAPI);
  if InstKernel32<>0 then FreeLibrary(InstKernel32);
  SetLength(ProcessIds,0);
  SetLength(ModuleHandles,0);
end;

Procedure TFActiveProcesses.ShowProcesses95;
var
  _hSnapshot, _hSnapshotM:THandle;
  _ppe:PROCESSENTRY32;
  _pme:MODULEENTRY32;
Begin
  FillMemory(@_ppe,SizeOf(_ppe),0);
  FillMemory(@_pme,SizeOf(_pme),0);
  lvProcesses.Items.BeginUpdate;
  lvProcesses.Clear;

  _hSnapshot := lpCreateToolhelp32Snapshot(TH32CS_SNAPALL, GetCurrentProcessId);
  if _hSnapshot <> INVALID_HANDLE_VALUE then
  try
    _ppe.dwSize := sizeof(PROCESSENTRY32);
    _pme.dwSize := sizeof(MODULEENTRY32);
    lpProcess32First(_hSnapshot, _ppe);
    Repeat
      _hSnapshotM := lpCreateToolhelp32Snapshot(TH32CS_SNAPMODULE, _ppe.th32ProcessID);
      if _hSnapshotM = INVALID_HANDLE_VALUE then continue;
      if lpModule32First(_hSnapshotM, _pme) then
        With lvProcesses.Items.Add do
        begin
          Caption := IntToHex(_ppe.th32ProcessID, 4);
          SubItems.Add(ExtractFileName(_ppe.szExeFile));
          SubItems.Add(IntToHex(_pme.modBaseSize, 8));
          SubItems.Add('-');
          SubItems.Add(IntToHex(Integer(_pme.modBaseAddr), 8));
        End;
      CloseHandle(_hSnapshotM);
    Until not lpProcess32Next(_hSnapshot, _ppe);

    CloseHandle(_hSnapshot);
  Finally
    lvProcesses.Items.EndUpdate;
  End;
end;

Function TFActiveProcesses.IsWindows2000OrHigher:Boolean;
var
  osvi:OSVERSIONINFO;
Begin
  FillMemory(@osvi,SizeOf(osvi),0);
  osvi.dwOSVersionInfoSize := sizeof(OSVERSIONINFO);
  GetVersionEx(osvi);
  //https://msdn.microsoft.com/en-us/library/windows/desktop/ms724834%28v=vs.85%29.aspx
  Result:=osvi.dwMajorVersion >= 5; //win XP+
end;

Procedure TFActiveProcesses.ShowProcesses;
Begin
  if Not IsWindows2000OrHigher then ShowProcesses95
    else ShowProcessesNT;
end;

Procedure TFActiveProcesses.ShowProcessesNT;
var
  n, _len, _pos:Integer;
  _moduleName:AnsiString;
  _hProcess:THandle;
  _moduleInfo:TModuleInfo;
  _buf:Array[0..511] of Char;
Begin
  lpEnumProcesses(@ProcessIds[0], sizeof(ProcessIds), ProcessesNum);
  ProcessesNum := ProcessesNum div sizeof(Integer);

  lvProcesses.Items.BeginUpdate;
  lvProcesses.Clear;
  try
    for n := 0 To ProcessesNum-1 do
      if ProcessIds[n]<>0 then
      begin
        _hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, ProcessIds[n]);
        if _hProcess<>0 then
        begin
          if lpEnumProcessModules(_hProcess, @ModuleHandles[0], sizeof(ModuleHandles), ModulesNum) then
          begin
            ModulesNum := ModulesNum Div sizeof(Integer);
            _len := lpGetModuleFileNameEx(_hProcess, ModuleHandles[0], @_buf[0], sizeof(_buf));
            SetLength(_moduleName,_len);
            StrLCopy(@_moduleName[1],_buf,_len);
            lpGetModuleInformation(_hProcess, ModuleHandles[0], @_moduleInfo, sizeof(_moduleInfo));
            if _moduleName <> '' then
            begin
              _pos := LastDelimiter('\',_moduleName);
              if _pos<>0 then _moduleName := Copy(_moduleName,_pos + 1, _len);
              With lvProcesses.Items.Add Do
              begin
                Caption := IntToHex(ProcessIds[n], 4);
                SubItems.Add(_moduleName);
                SubItems.Add(IntToHex(_moduleInfo.SizeOfImage, 8));
                SubItems.Add(IntToHex(Integer(_moduleInfo.EntryPoint), 8));
              End;
            End;
          End;
          CloseHandle(_hProcess);
        End;
      end;
  Finally
    lvProcesses.Items.EndUpdate;
  End;
end;

procedure TFActiveProcesses.btnCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TFActiveProcesses.FormShow(Sender: TObject);
begin
  btnDump.Enabled:=Assigned(lvProcesses.Selected);
end;

procedure TFActiveProcesses.lvProcessesClick(Sender: TObject);
begin
  btnDump.Enabled:=Assigned(lvProcesses.Selected);
end;

Procedure TFActiveProcesses.EnumSections (HProcess:THandle; PProcessBase:Pointer; Buffer:PImageSectionHeader; var Secnum:Cardinal);
var
  i:Integer;
  _pBuf, _pSection:Pointer;
  _peHdrOffset:Pointer;
  _sz:Cardinal;
  _ntHdr:IMAGE_NT_HEADERS;
  _section:IMAGE_SECTION_HEADER;
Begin
  //Read offset of PE header
  if Not ReadProcessMemory(HProcess, PAnsiChar(PProcessBase)+$3C, @_peHdrOffset, sizeof(_peHdrOffset), _sz) Then Exit;
  //Read IMAGE_NT_HEADERS.OptionalHeader.BaseOfCode
  if not ReadProcessMemory(HProcess, PAnsiChar(PProcessBase) + Cardinal(_peHdrOffset), @_ntHdr, sizeof(_ntHdr), _sz) then Exit;

  _pSection := PAnsiChar(PProcessBase) + Cardinal(_peHdrOffset) + 4 + sizeof(_ntHdr.FileHeader) + _ntHdr.FileHeader.SizeOfOptionalHeader;
  FillMemory(@_section, sizeof(_section),0);

  Secnum := _ntHdr.FileHeader.NumberOfSections;
  _pBuf := Buffer;
  for i := 0 to _ntHdr.FileHeader.NumberOfSections-1 do
  begin
    if Not ReadProcessMemory(HProcess, PAnsiChar(_pSection) + i * sizeof(_section), @_section, sizeof(_section), _sz) then Exit;
    MoveMemory(_pBuf, @_section, sizeof(_section));
    _pBuf:=PAnsiChar(_pBuf)+ sizeof(_section);
  end;
end;

Procedure TFActiveProcesses.DumpProcess (PID:Cardinal; MemStream:TMemoryStream; var BoC, PoC, ImB:Integer);
Var
  secNum:WORD;
  peHdrOffset:Pointer;
  sz, sizeOfCode:Cardinal;
  resPhys, dd:Integer;
  buf:Pointer;
  b:Array[0..7] of Char;
  _hProcess, hSnapshot:THandle;
  _moduleInfo:MODULEINFO;
  ntHdr:IMAGE_NT_HEADERS;
  ppe:PROCESSENTRY32;
  pme:MODULEENTRY32;
  sections:Array [0..63] of IMAGE_SECTION_HEADER;
Begin
  FillMemory(@_moduleInfo,SizeOf(_moduleInfo),0);
  _hProcess := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, PID); //0x1F0FFF
  if _hProcess<>0 then
  begin
    //If Win9x
    if not IsWindows2000OrHigher then
    begin
      hSnapshot := lpCreateToolhelp32Snapshot(TH32CS_SNAPALL, GetCurrentProcessId);
      if hSnapshot <> INVALID_HANDLE_VALUE then
      begin
        ppe.dwSize := sizeof(PROCESSENTRY32);
        pme.dwSize := sizeof(MODULEENTRY32);
        FillMemory(@ppe.szExeFile, SizeOf(ppe.szExeFile),0);
        lpProcess32First(hSnapshot, ppe);
        lpModule32First(hSnapshot, pme);
        while lpProcess32Next(hSnapshot, ppe) do
        begin
          lpModule32Next(hSnapshot, pme);
          if ppe.th32ProcessID = PID then
          begin
            _moduleInfo.lpBaseOfDll := pme.modBaseAddr;
            //_moduleInfo.lpBaseOfDll := $400000;
          end;
        End;
        CloseHandle(hSnapshot);
      end;
    end
    else
    begin
      lpEnumProcessModules(_hProcess, @ModuleHandles[0], sizeof(ModuleHandles), ModulesNum);
      lpGetModuleInformation(_hProcess, ModuleHandles[0], @_moduleInfo, sizeof(_moduleInfo));
    end;
    if not Assigned(_moduleInfo.lpBaseOfDll) then
      Raise Exception.Create('Invalid process, PID: ' + IntToStr(PID));
    ReadProcessMemory(_hProcess, PAnsiChar(_moduleInfo.lpBaseOfDll) + $3C, @peHdrOffset, sizeof(peHdrOffset), sz);
    ReadProcessMemory(_hProcess, PAnsiChar(_moduleInfo.lpBaseOfDll) + Cardinal(peHdrOffset), @ntHdr, sizeof(ntHdr), sz);
    EnumSections(_hProcess, _moduleInfo.lpBaseOfDll, @sections, sz);
    MemStream.Clear;
    //Dump Header
    GetMem(buf,ntHdr.OptionalHeader.SizeOfHeaders);
    ReadProcessMemory(_hProcess, _moduleInfo.lpBaseOfDll, buf, ntHdr.OptionalHeader.SizeOfHeaders, sz);
    MemStream.WriteBuffer(buf, ntHdr.OptionalHeader.SizeOfHeaders);
    FreeMem(buf);
    //!!!! - SizeOfCode is not initialized !!!
    if sizeOfCode < sections[1].Misc.VirtualSize then
      sizeOfCode := sections[1].Misc.VirtualSize
    else
      sizeOfCode := ntHdr.OptionalHeader.SizeOfCode;
    //!!!
    MemStream.Clear;
    GetMem(buf,ntHdr.OptionalHeader.SizeOfImage);
    ReadProcessMemory(_hProcess, _moduleInfo.lpBaseOfDll, buf, ntHdr.OptionalHeader.SizeOfImage, sz);
    MemStream.WriteBuffer(buf, ntHdr.OptionalHeader.SizeOfImage);
    FreeMem(buf);
    //!!!
    {
    //Dump Code
    GetMem(buf,sizeOfCode);
    ReadProcessMemory(_hProcess, _moduleInfo.lpBaseOfDll + ntHdr.OptionalHeader.BaseOfCode, buf, sizeOfCode, sz);
    MemStream.WriteBuffer(buf, sizeOfCode);
    FreeMem(buf);
    }
    //Find EP
    //Dump Resources
    MemStream.Seek(0, soFromEnd);
    resPhys := MemStream.Size;
    {
    GetMem(buf,ntHdr.OptionalHeader.DataDirectory[2].Size);
    ReadProcessMemory(_hProcess, _moduleInfo.lpBaseOfDll + ntHdr.OptionalHeader.DataDirectory[2].VirtualAddress, buf, ntHdr.OptionalHeader.DataDirectory[2].Size, sz);
    MemStream.WriteBuffer(buf, ntHdr.OptionalHeader.DataDirectory[2].Size);
    FreeMem(buf);
    }
    //Correct PE Header
    //Set SectionNum = 2
    MemStream.Seek(6 + Cardinal(peHdrOffset), soFromBeginning);
    secNum := 2;
    MemStream.WriteBuffer(secNum, sizeof(secNum));
    //Set EP
    //Set sections
    MemStream.Seek($F8 + Cardinal(peHdrOffset), soFromBeginning);
    //"CODE"
    FillMemory(@b, SizeOf(b),0);
    b[0] := 'C';
    b[1] := 'O';
    b[2] := 'D';
    b[3] := 'E';
    MemStream.WriteBuffer(b, 8);
    dd := sizeOfCode;
    MemStream.WriteBuffer(dd, 4);//VIRTUAL_SIZE
    dd := ntHdr.OptionalHeader.BaseOfCode;
    MemStream.WriteBuffer(dd, 4);//RVA
    dd := sizeOfCode;
    MemStream.WriteBuffer(dd, 4);//PHYSICAL_SIZE
    dd := ntHdr.OptionalHeader.SizeOfHeaders;
    MemStream.WriteBuffer(dd, 4);//PHYSICAL_OFFSET
    dd := 0;
    MemStream.WriteBuffer(dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(dd, 4);//RELOC_NUM,LINENUM_NUM
    dd := $60000020;
    MemStream.WriteBuffer(dd, 4);//FLAGS
    (*
    //"DATA"
    FillMemory(@_b, SizeOf(_b),0);
    _b[0] := 'D';
    _b[1] := 'A';
    _b[2] := 'T';
    _b[3] := 'A';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $C0000040;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    //"BSS"
    FillMemory(@_b, SizeOf(_b),0);
    _b[0] := 'B';
    _b[1] := 'S';
    _b[2] := 'S';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $C0000040;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    //".idata"
    FillMemory(@_b, SizeOf(_b),0);
    _b[0] := '.';
    _b[1] := 'i';
    _b[2] := 'd';
    _b[3] := 'a';
    _b[4] := 't';
    _b[5] := 'a';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $C0000040;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    //".tls"
    FillMemory(@_b, SizeOf(_b),0);
    _b[0] := '.';
    _b[1] := 't';
    _b[2] := 'l';
    _b[3] := 's';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $C0000000;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    //".rdata"
    FillMemory(@_b, SizeOf(_b),0);
    _b[0] := '.';
    _b[1] := 'r';
    _b[2] := 'd';
    _b[3] := 'a';
    _b[4] := 't';
    _b[5] := 'a';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $50000040;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    //".reloc"
    memset(_b, 0, 8);
    _b[0] := '.';
    _b[1] := 'r';
    _b[2] := 'e';
    _b[3] := 'l';
    _b[4] := 'o';
    _b[5] := 'c';
    MemStream.WriteBuffer(_b, 8);
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//RVA
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_SIZE
    MemStream.WriteBuffer(_dd, 4);//PHYSICAL_OFFSET
    MemStream.WriteBuffer(_dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(_dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(_dd, 4);//RELOC_NUM,LINENUM_NUM
    _dd := $50000040;
    MemStream.WriteBuffer(_dd, 4);//FLAGS
    *)
    //".rsrc"
    FillMemory(@b, SizeOf(b),0);
    b[0] := '.';
    b[1] := 'r';
    b[2] := 's';
    b[3] := 'r';
    b[4] := 'c';
    MemStream.WriteBuffer(b, 8);
    dd := ntHdr.OptionalHeader.DataDirectory[2].Size;
    MemStream.WriteBuffer(dd, 4);//VIRTUAL_SIZE
    dd := ntHdr.OptionalHeader.DataDirectory[2].VirtualAddress;
    MemStream.WriteBuffer(dd, 4);//RVA
    dd := ntHdr.OptionalHeader.DataDirectory[2].Size;
    MemStream.WriteBuffer(dd, 4);//PHYSICAL_SIZE
    dd := resPhys;
    MemStream.WriteBuffer(dd, 4);//PHYSICAL_OFFSET
    dd := 0;
    MemStream.WriteBuffer(dd, 4);//RELOC_PTR
    MemStream.WriteBuffer(dd, 4);//LINENUM_PTR
    MemStream.WriteBuffer(dd, 4);//RELOC_NUM,LINENUM_NUM
    dd := $50000040;
    MemStream.WriteBuffer(dd, 4);//FLAGS
    (*
    //Correct directories
    MemStream.Seek($78 + Cardinal(_peHdrOffset), soFromBeginning);
    //Export table
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VA
    MemStream.WriteBuffer(_dd, 4);//Size
    //Import table
    _dd := 0;
    MemStream.WriteBuffer(_dd, 4);//VA
    MemStream.WriteBuffer(_dd, 4);//Size
    //Resource table
    _dd := _ntHdr.OptionalHeader.SizeOfHeaders;
    MemStream.WriteBuffer(_dd, 4);//RVA
    _dd := _ntHdr.OptionalHeader.DataDirectory[2].Size;
    MemStream.WriteBuffer(_dd, 4);//VIRTUAL_SIZE
    *)
    FMain.EvaluateInitTable(MemStream.Memory, MemStream.Size, ntHdr.OptionalHeader.ImageBase + ntHdr.OptionalHeader.SizeOfHeaders);
    CloseHandle(_hProcess);
  end;
end;

procedure TFActiveProcesses.btnDumpClick(Sender: TObject);
var
  pid, boc, poc, imb:Integer;
  li:TListItem;
  stream:TMemoryStream;
Begin
  if Assigned(lvProcesses.Selected) then
  try
    li := lvProcesses.Selected;
    pid := StrToInt('$' + li.Caption);
    stream := TMemoryStream.Create;
    try
      DumpProcess(pid, stream, boc, poc, imb);
      if stream.Size=0 then Exit;
      stream.SaveToFile('__idrtmp__.exe');
    Finally
      stream.Free;
    End;
    FMain.DoOpenDelphiFile(DELHPI_VERSION_AUTO, '__idrtmp__.exe', false, false);
  except
    on ex:Exception do ShowMessage('Dumper failed: ' + ex.Message);
  End;
  Close;
end;

end.
