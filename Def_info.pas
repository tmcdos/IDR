unit Def_info;

interface

Const

  //Information about class fields (look VmtSelfPtr)
  FIELD_PRIVATE   = 9;
  FIELD_PROTECTED = 10;
  FIELD_PUBLIC    = 11;
  FIELD_PUBLISHED = 12;

  //procflags
  PF_MAYBEEMBED = $80000000;
  PF_EMBED      = $40000000;
  PF_VIRTUAL    = $20000000;
  PF_DYNAMIC    = $10000000;
  PF_EVENT      = $08000000;
  PF_OUTEAX     = $04000000;
  PF_KBPROTO		= $02000000;	//if prototype for kb was got
  PF_BPBASED    = $01000000;
  PF_ARGSIZEG   = $00800000;  //If delta between retN and total arguments size > 0
  PF_ARGSIZEL   = $00400000;  //If delta between retN and total arguments size < 0
  PF_METHOD     = $00200000;  //is method of class (other than virtual, dynamic or event)
  PF_PUBLISHED  = $00100000;  //published

  PF_ALLMETHODS = (PF_METHOD or PF_VIRTUAL or PF_DYNAMIC or PF_EVENT);
  //first 3 bits - call kind (1, 2, 3, 4)

  OP_COMMENT = $10;
  OP_CALL		 = $11;

//---------------------------------------------------------------------------
//lastVar
//vmtAdr
//typeIdx??? - for Type search
//---------------------------------------------------------------------------

Type
  //Class Methods Information
  MethodRec = record
    _abstract:Boolean;//call @AbstractError
    kind:Char;        //'M' - method; 'V' - virtual; 'D' - dynamic
    id:Integer;       //ID (for virtual methods - offset, for dynamics - MsgId)
    address:Integer;    //Call Address
    name:AnsiString;  //Method Name
  End;
  PMethodRec = ^MethodRec;

  //InfoResStringInfo = Array of AnsiString;

  PICODE = record
	  Op:BYTE;		//Operation
    Offset:Integer;     //Field offset or Proc address for OP_CALL
    Name:AnsiString;		//Type name
  End;
  PPICODE = ^PICODE;

implementation

end.
