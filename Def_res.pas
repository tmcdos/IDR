unit Def_res;

interface

Uses Classes;

Const
  FF_INHERITED   = 1;
  FF_HASNOTEBOOK = 2;

Type
  TFindMethodSourceEvent = Procedure (Sender:TObject; ClasName, MethodName:AnsiString) of object;

  EventListItem = record
    CompName:AnsiString;       //Component Name
    EventName:AnsiString;      //Event Name
    Adr:Integer;            //Event Address
  End;
  PEventListItem = ^EventListItem;

  RegClassInfo = Record
    RegClass:TPersistentClass;
    ClasName:PAnsiChar;
  End;
  PRegClassInfo = ^RegClassInfo;

  EventInfo = record
    EventName:AnsiString;      //Event name (OnClose)
    ProcName:AnsiString;       //Event handler name (CloseBtnClick)
  End;
  PEventInfo = ^EventInfo;

  ComponentInfo = record
    Inherit:Boolean;      //Component is inherited
    HasGlyph:Boolean;		  //Component has property "Glyph"
    Name:AnsiString;      //Component name
    ClasName:AnsiString; //Component class
    Events:TList;	        //EventInfo list
  End;
  PComponentInfo = ^ComponentInfo;


implementation

end.
