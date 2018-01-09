program Editor;

uses
  Forms,
  MFEditor in 'MFEditor.pas' {FEditor},
  f_PageProperty in '..\f_PageProperty.pas' {FPageProperty};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFEditor, FEditor);
  Application.CreateForm(TFPageProperty, FPageProperty);
  Application.Run;
end.
