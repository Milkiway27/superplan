program EditorD2009;

uses
  Forms,
  MFEditor in 'MFEditor.pas' {FEditor},
  f_PageProperty in '..\f_PageProperty.pas' {FPageProperty};
	tako tako tako
{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFEditor, FEditor);
  Application.CreateForm(TFPageProperty, FPageProperty);
  Application.Run;
  //taka dodatkowa informacja:)
  //jednak jeszcze jedna dodatkowa informacja
end.
