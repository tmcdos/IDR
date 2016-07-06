unit Def_decomp;

interface

Type
  TDecomIflag = (
    IF_ARG,          // 1;
    IF_VAR,          // 2;
    IF_STACK_PTR,    // 4;
    IF_CALL_RESULT,  // 8;
    IF_VMT_ADR,      // 16;
    IF_CYCLE_VAR,    // 32;
    IF_FIELD,        // 64;
    IF_ARRAY_PTR,    // 128;
    IF_INTVAL,       // 256;
    IF_INTERFACE,    // 512;
    IF_EXTERN_VAR    // 1024; // Used for embedded procedures
  );
  TDecomIset = Set of TDecomIflag;

  TDecomCflag = (
    CF_CONSTRUCTOR,   // 1;
    CF_DESTRUCTOR,    // 2;
    CF_FINALLY,       // 4;
    CF_EXCEPT,        // 8;
    CF_LOOP,          // 16;
    CF_BJL,           // 32;
    CF_ELSE           // 64;
  );
  TDecomCset = Set Of TDecomCflag;

Const
  //Precedence of operations
  PRECEDENCE_ATOM  = 8;
  PRECEDENCE_NOT   = 4;   //@,not
  PRECEDENCE_MULT  = 3;   //*,/,div, mod,and,shl,shr,as
  PRECEDENCE_ADD   = 2;   //+,-,or,xor
  PRECEDENCE_CMP   = 1;   //=,<>,<,>,<=,>=,in,is
  PRECEDENCE_NONE  = 0;

  TAB_SIZE         = 2;

  CMP_FAILED       = 0;
  CMP_BRANCH       = 1;
  CMP_SET          = 2;

  //BJL
  MAXSEQNUM        = 1024;

  BJL_USED         = -1;
  BJL_EMPTY        = 0;
  BJL_BRANCH  		 = 1;
  BJL_JUMP			   = 2;
  BJL_LOC				   = 3;
  BJL_SKIP_BRANCH  = 4;  //branches for IntOver, BoundErr,...

  itUNK  = 0;
  itREG  = 1;
  itLVAR = 2;
  itGVAR = 3;

Type
  TBJLInfo = record
    state:Char;          //'U' not defined; 'B' branch; 'J' jump; '@' label; 'R' return; 'S' switch
    bcnt:Integer;        //branches to... count
    address:Integer;
    dExpr:AnsiString;    //condition of direct expression
    iExpr:AnsiString;    //condition of inverse expression
    result:AnsiString;
  end;
  PBJLInfo = ^TBJLInfo;

  TBJL = record
	  branch:Boolean;
	  loc:Boolean;
    _type:Integer;
    address:Integer;
    idx:Integer;		//IDX in BJLseq
  end;
  PBJL = ^TBJL;

  TCmpItem = record
    L:AnsiString;
    O:Char;
    R:AnsiString;
  End;
  PCmpItem = ^TCmpItem;

  TItem = record
    Precedence:Byte;
    Size:Integer;       //Size in bytes
    Offset:Integer;     //Offset from beginning of type
    IntValue:Integer;   //For array element size calculation
    Flags:TDecomIset;
    Value:AnsiString;
    Value1:AnsiString;  //For various purposes
    _Type:AnsiString;
    Name:AnsiString;
  End;
  PItem = ^TItem;
  PItemArr = Array of TItem;

  WHAT = record
    Value:AnsiString;
    Name:AnsiString;
  End;
  PWHAT = ^WHAT;

  IdxInfo = record
    IdxType:Byte;
    IdxValue:Integer;
    IdxStr:AnsiString;
  End;
  PIdxInfo = ^IdxInfo;

//cmpStack Format: "XYYYYYYY^ZZZZ" (== YYYYYY X ZZZZ)
//'A'-JO;'B'-JNO;'C'-JB;'D'-'JNB';'E'-JZ;'F'-JNZ;'G'-JBE;'H'-JA;
//'I'-'JS';'J'-JNS;'K'-JP;'L'-JNP;'M'-JL;'N'-JGE;'O'-JLE;'P'-JG

  //Only registers eax, ecx, edx, ebx, esp, ebp, esi, edi
  Regs = Array [0..7] of TItem;

  PCaseTreeNode = ^TCaseTreeNode;
  TCaseTreeNode = record
    LNode,RNode:PCaseTreeNode;
    ZProc:Integer;
    FromVal:Integer;
    ToVal:Integer;
  end;

  //structure for saving context of all registers
  DContext = record
    adr:Integer;
    gregs:Regs;  //general registers
    fregs:Regs;  //float point registers
  End;
  PDContext = ^DContext;

Const
  //'A'-JO;'B'-JNO;'C'-JB;'D'-JNB;'E'-JZ;'F'-JNZ;'G'-JBE;'H'-JA;
  //'I'-JS;'J'-JNS;'K'-JP;'L'-JNP;'M'-JL;'N'-JGE;'O'-JLE;'P'-JG
  //'Q'-in;'R'-not in;'S'-is
  DirectConditions:Array[0..18] of AnsiString = (
    '', '', '<', '>=', '=', '<>', '<=', '>', '', '', '', '', '<', '>=', '<=', '>', 'not in', 'in', 'is');
  InvertConditions:Array[0..18] of AnsiString = (
    '', '', '>=', '<', '<>', '=', '>', '<=', '', '', '', '', '>=', '<', '>', '<=', 'in', 'not in', 'is not');

implementation

end.
