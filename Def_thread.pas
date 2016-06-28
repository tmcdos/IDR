unit Def_thread;

interface

Const
  LAST_ANALYZE_STEP  = 19;

Type
  ThreadAnalysisOperation =
  (
    taStartPrBar, taUpdatePrBar, taStopPrBar, taUpdateStBar,
    taUpdateUnits, taUpdateRTTIs, taUpdateVmtList, taUpdateStrings, taUpdateCode, taUpdateXrefs,
    taUpdateShortClassViewer, taUpdateClassViewer, taUpdateBeforeClassViewer,
    taFinished
  );

  ThreadAnalysisData = record
    pbSteps:Integer;
    sbText:AnsiString;
  end;
  PThreadAnalysisData = ^ThreadAnalysisData;

  CVPair = record
    height:Integer;
    vmtAdr:Integer;
  end;
  PCVPair = ^CVPair;

implementation

end.
