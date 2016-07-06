unit Def_info;

interface

type
  //procflags
  TProcFlag = (
    pf_1,pf_2,pf_3,pf_4,pf_5,pf_6,pf_7,pf_8,
    pf_9,pf_10,pf_11,pf_12,pf_13,pf_14,pf_15,pf_16,
    pf_17,pf_18,pf_19,pf_20,
    PF_PUBLISHED, // $00100000; //published
    PF_METHOD,    // $00200000; //is method of class (other than virtual, dynamic or event)
    PF_ARGSIZEL,  // $00400000; //If delta between retN and total arguments size < 0
    PF_ARGSIZEG,  // $00800000; //If delta between retN and total arguments size > 0
    PF_BPBASED,   // $01000000;
    PF_KBPROTO,		// $02000000;	//if prototype for kb was got
    PF_OUTEAX,    // $04000000;
    PF_EVENT,     // $08000000;
    PF_DYNAMIC,   // $10000000;
    PF_VIRTUAL,   // $20000000;
    PF_EMBED,     // $40000000;
    PF_MAYBEEMBED // $80000000;
  );
  TProcFlagSet = Set of TProcFlag;

Const
  PF_ALLMETHODS = [PF_METHOD, PF_VIRTUAL, PF_DYNAMIC, PF_EVENT];

  //Information about class fields (look VmtSelfPtr)
  FIELD_PRIVATE   = 9;
  FIELD_PROTECTED = 10;
  FIELD_PUBLIC    = 11;
  FIELD_PUBLISHED = 12;

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
