Unit UFileDropper;

Interface

Uses Classes,Windows,ShellAPI;

// simple class that allow/disallow drag-drop support for window

Type
  TDragDropHelper=class
  private
    wndHandle:HWND;
  public
    constructor Create(const wnd:HWND);
    destructor Destroy; Override;
  end;

  // simple class that accepts dropped files and stores names + droppoint
  TFileDropper=class
  private
    DropHandle:HDrop;
    function GetFile(Index:Integer):AnsiString;
    function GetFileCount:Integer;
    function GetPoint:TPoint;
  public
    constructor Create(Handle:HDrop);
    destructor Destroy; override;
  public
    property FileCount:Integer read GetFileCount;
    property Files[Index:Integer]:AnsiString read GetFile;
    property DropPoint:TPoint read GetPoint;
  end;

Implementation

Constructor TDragDropHelper.Create (Const wnd:HWND);
Begin
  wndHandle:=wnd;
  DragAcceptFiles(wndHandle,True);
end;

Destructor TDragDropHelper.Destroy;
Begin
  DragAcceptFiles(wndHandle,False);
  Inherited;
end;

Constructor TFileDropper.Create (Handle:HDrop);
Begin
  DropHandle:=Handle;
end;

Destructor TFileDropper.Destroy;
Begin
  DragFinish(DropHandle);
  Inherited;
end;

Function TFileDropper.GetFile (Index:Integer):AnsiString;
Var
  FileNameLength:Integer;
Begin
  FileNameLength:=DragQueryFile(DropHandle,Index,Nil,0);
  SetLength(Result,FileNameLength);
  DragQueryFile(DropHandle,Index,PAnsiChar(Result),FileNameLength);
end;

Function TFileDropper.GetFileCount:Integer;
Begin
  Result:=DragQueryFile(DropHandle,$FFFFFFFF,Nil,0);
end;

Function TFileDropper.GetPoint:TPoint;
Begin
  Result:=Point(0,0);
  DragQueryPoint(DropHandle,Result);
end;

End.
