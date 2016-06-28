Program Idr;

{$R 'manifest.res' 'manifest.rc'}

uses
  ExceptionLog,
  Forms,
  Classes,
  TypeInfo in 'TypeInfo.pas' {FTypeInfo},
  StringInfo in 'StringInfo.pas' {FStringInfo},
  Main in 'Main.pas' {FMain},
  Explorer in 'Explorer.pas' {FExplorer},
  InputDlg in 'InputDlg.pas' {FInputDlg},
  FindDlg in 'FindDlg.pas' {FindDlg},
  EditFunctionDlg in 'EditFunctionDlg.pas' {FEditFunctionDlg},
  AboutDlg in 'AboutDlg.pas' {FAboutDlg},
  EditFieldsDlg in 'EditFieldsDlg.pas' {FEditFieldsDlg},
  KBViewer in 'KBViewer.pas' {FKBViewer},
  UfrmFormTree in 'UfrmFormTree.pas' {IdrDfmFormTree},
  Legend in 'Legend.pas' {FLegend},
  Hex2Double in 'Hex2Double.pas' {FHex2DoubleDlg},
  Plugins in 'Plugins.pas' {FPlugins},
  Misc in 'Misc.pas',
  ActiveProcesses in 'ActiveProcesses.pas' {FActiveProcesses},
  Def_main in 'Def_main.pas',
  Def_disasm in 'Def_disasm.pas',
  Def_thread in 'Def_thread.pas',
  Def_info in 'Def_info.pas',
  Def_decomp in 'Def_decomp.pas',
  Def_res in 'Def_res.pas',
  Def_know in 'Def_know.pas',
  IDCGen in 'IDCGen.pas',
  Heuristic in 'Heuristic.pas',
  Disasm in 'Disasm.pas',
  Threads in 'Threads.pas',
  Infos in 'Infos.pas',
  Decompiler in 'Decompiler.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title:='Interactive Delphi Reconstructor';
  Application.CreateForm(TFMain, FMain);
  Application.CreateForm(TFExplorer, FExplorer);
  Application.CreateForm(TFTypeInfo, FTypeInfo);
  Application.CreateForm(TFStringInfo, FStringInfo);
  Application.CreateForm(TFInputDlg, FInputDlg);
  Application.CreateForm(TFFindDlg, FFindDlg);
  Application.CreateForm(TFEditFunctionDlg, FEditFunctionDlg);
  Application.CreateForm(TFEditFieldsDlg, FEditFieldsDlg);
  Application.CreateForm(TFAboutDlg, FAboutDlg);
  Application.CreateForm(TFKBViewer, FKBViewer);
  Application.CreateForm(TFLegend, FLegend);
  Application.CreateForm(TFHex2DoubleDlg, FHex2DoubleDlg);
  Application.CreateForm(TFPlugins, FPlugins);
  Application.CreateForm(TFActiveProcesses, FActiveProcesses);
  Application.Run;
end.
