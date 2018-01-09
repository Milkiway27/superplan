{

 This is an example of basic WYSIWYG editor.

 This demo shows how to:
 - define page zoom, paper size and margins;
 - create vertical menu (in the bottom right corner, searches in document);
 - create horizontal menu (in the bottom left corner, switches document views);
 - customize TSRVToolWindow.

}

unit MFEditor;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms,
  Dialogs, RVScroll, RVEdit, ExtCtrls, SclRView, RVStyle, Menus, RVRulerBase, RVRuler,
  SclRVRuler, StdCtrls, Printers, ComCtrls, ToolWin, Buttons, SRVToolBar,
  ImgList, CRVFData, SRVToolWindow, RVTable, RVMisc, RichView,
  RVItem;

type
  TFEditor = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    ListZoom: TComboBox;
    btnPrint: TButton;
    btnNewPage: TButton;
    ListFormat: TComboBox;
    btnLoadRVF: TButton;
    btnSaveRVF: TButton;
    Panel3: TPanel;
    SclRVRuler1: TSclRVRuler;
    Panel4: TPanel;
    Panel5: TPanel;
    SRichViewEdit1: TSRichViewEdit;
    SclRVRuler2: TSclRVRuler;
    btnPageSetup: TButton;
    RVRulerItemSelector1: TRVRulerItemSelector;
    cbPreviewMode: TCheckBox;
    cbShowTextArea: TCheckBox;
    stat1: TStatusBar;
    ImageList2: TImageList;
    ImageList1: TImageList;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    PrintDialog1: TPrintDialog;
    PopupMenu1: TPopupMenu;
    mitCopy: TMenuItem;
    mitCut: TMenuItem;
    mitPaste: TMenuItem;
    mitSelectAll: TMenuItem;
    fd: TFindDialog;
    rd: TReplaceDialog;
    srvtlwndw1: TSRVToolWindow;
    ImageList3: TImageList;
    ListUnits: TComboBox;
    RichViewEdit1: TRichViewEdit;
    RVStyle1: TRVStyle;
    Button1: TButton;
    Button2: TButton;
    procedure ListZoomChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure btnNewPageClick(Sender: TObject);
    procedure ListFormatChange(Sender: TObject);
    procedure btnLoadRVFClick(Sender: TObject);
    procedure btnSaveRVFClick(Sender: TObject);
    procedure btnPageSetupClick(Sender: TObject);
    procedure SclRVRuler1MarginDblClick(Sender: TObject; Margin: TMarginType);
    procedure SRichViewEdit1PageCountChanged(Sender: TObject);
    procedure SRichViewEdit1CurrentPageChange(Sender: TObject);
    procedure SRichViewEdit1PageScrolled(Sender: TObject);
    procedure SRichViewEdit1CaretMove(Sender: TObject);
    procedure cbPreviewModeClick(Sender: TObject);
    procedure cbShowTextAreaClick(Sender: TObject);
    procedure SRichViewEdit1HMenuClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure SRichViewEdit1VMenuClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure srvtlwndw1ClickButton(Sender: TObject;
      ToolButton: TSRVToolButton);
    procedure fdFind(Sender: TObject);
    procedure ListUnitsChange(Sender: TObject);
    procedure mitCutClick(Sender: TObject);
    procedure mitCopyClick(Sender: TObject);
    procedure mitPasteClick(Sender: TObject);
    procedure mitSelectAllClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FEditor:                  TFEditor;
  HToolButton, VToolButton: TSRVToolButton;
  RememberZoomMode:         TRVZoomMode;
  RememberZoomPercent:      Single;

implementation

uses Math, f_PageProperty;

{$R *.dfm}

{------------------------------------------------------------------------------}
procedure ShowInfo(const msg, cpt: String);
begin
  Application.MessageBox(PChar(msg), PChar(cpt), MB_OK or MB_ICONINFORMATION);
end;

{------------------------------------------------------------------------------}
// Normal view mode (as one long page)
procedure OnePageMode(srve: TSRichViewEdit);
begin
  srve.PageProperty.AutoWidth := False;
  srve.PageProperty.PageFormat := srvfmA4;
  srve.PageProperty.PageViewMode := False;
  srve.PageProperty.BoundLeftRight := 0;
  srve.PageProperty.MinPageBreakHeight := 0;
  srve.PageProperty.MaxPageBreakHeight := 0;
  srve.PageProperty.BorderPen.Style := psClear;
  srve.BackgroundProperty.Visible := False;
  srve.Color := clWhite;
  srve.ViewProperty.ShowScrollHint := True;
  srve.ViewProperty.AlignPageH := srvaphLeft;
  srve.ViewProperty.AlignPageV := srvapvTop;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
  srve.ViewProperty.ZoomMode := RememberZoomMode;
end;

// Web view mode
procedure WebMode(srve: TSRichViewEdit);
begin
  RememberZoomPercent := srve.ViewProperty.ZoomPercent;
  RememberZoomMode := srve.ViewProperty.ZoomMode;
  srve.PageProperty.PageViewMode := False;
  srve.ViewProperty.ShowScrollHint := False;
  srve.BackgroundProperty.Visible := False;
  srve.Color := clWhite;
  srve.PageProperty.BoundLeftRight := 0;
  srve.PageProperty.MinPageBreakHeight := 0;
  srve.PageProperty.MaxPageBreakHeight := 0;
  srve.ViewProperty.AlignPageH := srvaphLeft;
  srve.ViewProperty.AlignPageV := srvapvTop;
  srve.PageProperty.BorderPen.Style := psClear;
  srve.PageProperty.AutoWidth := True;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
end;

// Page view mode
procedure MultiPageMode(srve: TSRichViewEdit);
begin
  srve.PageProperty.AutoWidth := False;
  srve.PageProperty.PageViewMode := True;
  srve.PageProperty.PageFormat := srvfmA4;
  srve.ViewProperty.ShowScrollHint := True;
  srve.BackgroundProperty.Visible := True;
  srve.Color := $0099A8AC;
  srve.PageProperty.BoundLeftRight := 20;
  srve.PageProperty.MinPageBreakHeight := 5;
  srve.PageProperty.MaxPageBreakHeight := 25;
  srve.PageProperty.BorderPen.Style := psSolid;
  srve.ViewProperty.AlignPageH := srvaphCenter;
  srve.ViewProperty.AlignPageV := srvapvCenter;
  srve.ViewProperty.ZoomPercent := RememberZoomPercent;
  srve.ViewProperty.ZoomMode := RememberZoomMode;
end;

{------------------------------------------------------------------------------}
procedure TFEditor.FormCreate(Sender: TObject);
begin
  VToolButton := nil;
  ListZoom.ItemIndex := ListZoom.Items.IndexOf('PageWidth');
  ListFormat.ItemIndex := ListFormat.Items.IndexOf('A4');
  ListUnits.ItemIndex := ListUnits.Items.IndexOf('cm');
  ListZoomChange(nil);
  ListFormatChange(nil);
  ListUnitsChange(nil);
  //SRichViewEdit1.ActiveEditor.
end;

{------------------------------------------------------------------------------}
{ Popup menu commands }
// Copy
procedure TFEditor.mitCopyClick(Sender: TObject);
begin
  SRichViewEdit1.Copy;
end;

// Cut
procedure TFEditor.mitCutClick(Sender: TObject);
begin
  SRichViewEdit1.Cut;
end;

// Paste
procedure TFEditor.mitPasteClick(Sender: TObject);
begin
  SRichViewEdit1.Paste;
end;

// Select All
procedure TFEditor.mitSelectAllClick(Sender: TObject);
begin
  SRichViewEdit1.SelectAll;
end;

{------------------------------------------------------------------------------}
{ Events on selecting in combo boxes }
// Applying zoom mode
procedure TFEditor.ListZoomChange(Sender: TObject);
var
  procent: Integer;
begin
  procent := StrToIntDef(ListZoom.Text, 0);
  if procent > 0 then
    SRichViewEdit1.ViewProperty.ZoomPercent := procent
  else if ListZoom.Text = 'PageWidth' then
    SRichViewEdit1.ViewProperty.ZoomMode := rvzmPageWidth
  else if ListZoom.Text = 'FullPage' then
    SRichViewEdit1.ViewProperty.ZoomMode := rvzmFullPage;
  RememberZoomMode := SRichViewEdit1.ViewProperty.ZoomMode;
  RememberZoomPercent := SRichViewEdit1.ViewProperty.ZoomPercent;
end;

// Applying page format
procedure TFEditor.ListFormatChange(Sender: TObject);
var
  Text: String;
begin
  Text := trim(ListFormat.Text);
  if Text = 'A0' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA0;
  if Text = 'A1' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA1;
  if Text = 'A2' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA2;
  if Text = 'A3' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA3;
  if Text = 'A4' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA4;
  if Text = 'A5' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA5;
  if Text = 'A6' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmA6;
  if Text = 'Letter' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmLetter;
  if Text = 'Legal' then
    SRichViewEdit1.PageProperty.PageFormat := srvfmLegal;
end;

// Applying measurement units
procedure TFEditor.ListUnitsChange(Sender: TObject);
var
  RulerUnit: TRulerUnits;
  SRVUnit:   TRVUnits;
begin
  case ListUnits.ItemIndex of
    1:
      begin
        RulerUnit := ruMillimeters;
        SRVUnit := rvuMillimeters;
      end;
    2:
      begin
        RulerUnit := ruCentimeters;
        SRVUnit := rvuCentimeters;
      end;
    3:
      begin
        RulerUnit := ruPicas;
        SRVUnit := rvuPicas;
      end;
    4:
      begin
        RulerUnit := ruPixels;
        SRVUnit := rvuPixels;
      end;
    5:
      begin
        RulerUnit := ruPoints;
        SRVUnit := rvuPoints;
      end;
    else
      begin
        RulerUnit := ruInches;
        SRVUnit := rvuInches;
      end;
  end;
  SRichViewEdit1.UnitsProgram := SRVUnit;
  SclRVRuler1.UnitsDisplay := RulerUnit;
  SclRVRuler2.UnitsDisplay := RulerUnit;
end;

{------------------------------------------------------------------------------}
{ Button click: inserting page break }
procedure TFEditor.btnNewPageClick(Sender: TObject);
begin
  SRichViewEdit1.InsertPageBreak;
  SRichViewEdit1.SetFocus;
end;

{------------------------------------------------------------------------------}
{ Button click: printing }
procedure TFEditor.btnPrintClick(Sender: TObject);
begin
  if PrintDialog1.Execute then
  begin
    if HToolButton <> nil then
    begin
      SRichViewEdit1.CanUpdate := False;
      MultiPageMode(SRichViewEdit1);
      SRichViewEdit1.PrintAll;
      SRichViewEdit1HMenuClickButton(SRichViewEdit1, HToolButton);
    end
    else
      SRichViewEdit1.PrintAll;
  end;
end;

{------------------------------------------------------------------------------}
{ Button click: page setup }
procedure TFEditor.btnPageSetupClick(Sender: TObject);
begin
  SRichViewEdit1.CanUpdate := False;

  With FPageProperty do
  begin
    PageLeft.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.LeftMargin *
      100) * 0.01);
    PageRight.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.RightMargin *
      100) * 0.01);

    PageTop.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.TopMargin *
      100) * 0.01);
    PageBottom.Text := FloatToStr(Round(SRichViewEdit1.PageProperty.BottomMargin
      * 100) * 0.01);

    if SRichViewEdit1.PageProperty.Orientation = poPortrait then
    begin
      RadioGroup1.ItemIndex := 0;
    end
    else
    begin
      RadioGroup1.ItemIndex := 1;
    end;

    case SRichViewEdit1.PageProperty.PageFormat of
      srvfmA4:
        ListPaper.ItemIndex := 0;
      srvfmA5:
        ListPaper.ItemIndex := 1;
      else
        ListPaper.ItemIndex := 0;
    end;
  end;

  if FPageProperty.ShowModal = mrOK then
  begin
    With FPageProperty do
    begin
      SRichViewEdit1.SetMarginUnit(StrToFloat(trim(PageLeft.Text)),
        StrToFloat(trim(PageTop.Text)), StrToFloat(trim(PageRight.Text)),
        StrToFloat(trim(PageBottom.Text)));
      {          SRichViewEdit1.SetMarginMM(Round(PageLeft.Value),
        Round(PageTop.Value),
       Round(PageRight.Value),
       Round(PageBottom.Value));}
      SclRVRuler1.Scrolled;
      SclRVRuler2.Scrolled;

      if RadioGroup1.ItemIndex = 0 then
      begin
        if SRichViewEdit1.PageProperty.Orientation <> poPortrait then
          SRichViewEdit1.PageProperty.Orientation := poPortrait;
      end
      else
      begin
        if SRichViewEdit1.PageProperty.Orientation <> poLandscape then
          SRichViewEdit1.PageProperty.Orientation := poLandscape;
      end;

      case ListPaper.ItemIndex of
        0:
          if SRichViewEdit1.PageProperty.PageFormat <> srvfmA4 then
            SRichViewEdit1.PageProperty.PageFormat := srvfmA4;
        1:
          if SRichViewEdit1.PageProperty.PageFormat <> srvfmA5 then
            SRichViewEdit1.PageProperty.PageFormat := srvfmA5;
      end;
    end;
  end;
  SRichViewEdit1.CanUpdate := True;
end;

{------------------------------------------------------------------------------}
{ Returns paper format name }
function GetPaperFormatName(PaperFormat: TSRVPageFormat): String;
begin
  case PaperFormat of
    srvfmA0:
      Result := 'A0';
    srvfmA1:
      Result := 'A1';
    srvfmA2:
      Result := 'A2';
    srvfmA3:
      Result := 'A3';
    srvfmA4:
      Result := 'A4';
    srvfmA5:
      Result := 'A5';
    srvfmA6:
      Result := 'A6';
    srvfmLetter:
      Result := 'Letter';
    srvfmLegal:
      Result := 'Legal';
    else
      Result := '';
  end;
end;

{------------------------------------------------------------------------------}
{ Returns name for measurement units}
function GetUnitsName(Units: TRVUnits): String;
begin
  case Units of
    rvuMillimeters:
      Result := 'mm';
    rvuCentimeters:
      Result := 'cm';
    rvuPicas:
      Result := 'picas';
    rvuPixels:
      Result := 'pixels';
    rvuPoints:
      Result := 'points';
    rvuInches:
      Result := 'inch';
    else
      Result := '';
  end;
end;

{------------------------------------------------------------------------------}
{ Button click: loading RVF file }
procedure TFEditor.btnLoadRVFClick(Sender: TObject);
begin
  if not OpenDialog1.Execute then
    exit;

  SRichViewEdit1.LoadRVF(OpenDialog1.FileName);

  // The file may contain page properties. Updating user interface

  case SRichViewEdit1.ViewProperty.ZoomMode of
    rvzmPageWidth:
      ListZoom.ItemIndex := ListZoom.Items.IndexOf('PageWidth');
    rvzmFullPage:
      ListZoom.ItemIndex := ListZoom.Items.IndexOf('FullPage');
    rvzmCustom:
      ListZoom.ItemIndex := ListZoom.Items.IndexOf
        (IntToStr(Round(SRichViewEdit1.ViewProperty.ZoomPercent)));
  end;

  ListFormat.ItemIndex := ListFormat.Items.IndexOf
    (GetPaperFormatName(SRichViewEdit1.PageProperty.PageFormat));

  ListUnits.ItemIndex := ListUnits.Items.IndexOf
    (GetUnitsName(SRichViewEdit1.UnitsProgram));

  SclRVRuler1.UnitsDisplay := TRulerUnits(SRichViewEdit1.UnitsProgram);
  SclRVRuler2.UnitsDisplay := TRulerUnits(SRichViewEdit1.UnitsProgram);

end;

{------------------------------------------------------------------------------}
{ Button click: saving RVF file }
procedure TFEditor.btnSaveRVFClick(Sender: TObject);
begin
  if SaveDialog1.Execute then
    SRichViewEdit1.RichViewEdit.SaveRVF(SaveDialog1.FileName, False);
end;

{------------------------------------------------------------------------------}
{ Checkbox: edit mode / view mode }
procedure TFEditor.cbPreviewModeClick(Sender: TObject);
begin
  if cbPreviewMode.Checked then
    SRichViewEdit1.ViewProperty.ViewMode := srvvmPreviewMode
  else
    SRichViewEdit1.ViewProperty.ViewMode := srvvmEditMode;
end;

{------------------------------------------------------------------------------}
{ Checkbox: hiding/showing a rectangle around the document area on pages }
procedure TFEditor.cbShowTextAreaClick(Sender: TObject);
begin
  SRichViewEdit1.ViewProperty.MarginsRectVisible := cbShowTextArea.Checked;
end;

{------------------------------------------------------------------------------}
{ Double clicking on the rulers' margins shows the page setup dialog }
procedure TFEditor.SclRVRuler1MarginDblClick(Sender: TObject;
  Margin: TMarginType);
begin
  btnPageSetupClick(nil);
end;

{------------------------------------------------------------------------------}
{ Event, occurs when page count is changed }
procedure TFEditor.SRichViewEdit1PageCountChanged(Sender: TObject);
begin
  SRichViewEdit1CurrentPageChange(nil);
end;

{------------------------------------------------------------------------------}
{ Event, occurs when caret moves to another page }
procedure TFEditor.SRichViewEdit1CurrentPageChange(Sender: TObject);
begin
  if Assigned(stat1) then
    stat1.Panels.Items[1].Text := IntToStr(SRichViewEdit1.CurrentPage) + '/' +
      IntToStr(SRichViewEdit1.PageCount);
end;

{------------------------------------------------------------------------------}
{ Event, occurs on scrolling, when another page is displayed }
procedure TFEditor.SRichViewEdit1PageScrolled(Sender: TObject);
begin
  if Assigned(stat1) then
    stat1.Panels.Items[0].Text := 'Page ' +
      IntToStr(SRichViewEdit1.ScrolledPage);
end;

{------------------------------------------------------------------------------}
{ Event, occurs when caret moves }
procedure TFEditor.SRichViewEdit1CaretMove(Sender: TObject);
var
  Line, Column: Integer;
begin
  if Assigned(stat1) then
  begin
    SRichViewEdit1.GetCurrentLineCol(Line, Column);
    stat1.Panels.Items[3].Text := 'Line ' + IntToStr(Line);
    stat1.Panels.Items[4].Text := 'Col ' + IntToStr(Column);
  end;
end;

{------------------------------------------------------------------------------}
{ Event, occurs when button on horizontal scrollbar is clicked }
{ In this application, these buttons switch view mode: normal / web / page view }
procedure TFEditor.SRichViewEdit1HMenuClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
begin
  HToolButton := ToolButton;
  if ToolButton = nil then
    exit;
  SRichViewEdit1.CanUpdate := False;
  case (ToolButton.Index) of
    0:
      OnePageMode(SRichViewEdit1);
    1:
      WebMode(SRichViewEdit1);
    2:
      MultiPageMode(SRichViewEdit1);
  end;
  SRichViewEdit1.CanUpdate := True;
end;

{------------------------------------------------------------------------------}
{ Event, occurs when button on vertical scrollbar is clicked }
procedure TFEditor.SRichViewEdit1VMenuClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
var
  sbX, sbY: Integer;
  p:        TPoint;
begin
  if ToolButton = nil then
    exit;
  case ToolButton.Index of
    0: // "Up arrows" button, performs search to the top
      begin
        if VToolButton = nil then
          SRichViewEdit1.PriorCurPage
        else
          case VToolButton.Index of
            0:
              SRichViewEdit1.PriorCurPage;
            1:
              SRichViewEdit1.PriorCurItem([rvsTable]);
            2:
              SRichViewEdit1.PriorCurItem([rvsPicture, rvsHotspot,
                rvsHotPicture]);
            3:
              SRichViewEdit1.PriorCurItem([rvsHeading]);
            4:
              SRichViewEdit1.PriorCurHyperlink;
            6:
              begin
                fd.Options := fd.Options - [frDown];
                fdFind(nil);
              end;
          end;
      end;
    1: // "Circle" button, shows tool window
      begin
        sbX := SRichViewEdit1.MenuVertical.SRVToolBar.Width;
        sbY := SRichViewEdit1.MenuVertical.SRVToolBar.Height div 3;

        p := SRichViewEdit1.MenuVertical.SRVToolBar.ClientToScreen(Point(0, 0));
        p.Y := p.Y + sbY;

        srvtlwndw1.Execute(Bounds(p.x, p.Y, sbX, sbY));
      end;
    2: // "Down arrows" button, performs search to the bottom
      begin
        if VToolButton = nil then
          SRichViewEdit1.NextCurPage
        else
          case VToolButton.Index of
            0:
              SRichViewEdit1.NextCurPage;
            1:
              SRichViewEdit1.NextCurItem([rvsTable]);
            2:
              SRichViewEdit1.NextCurItem([rvsPicture, rvsHotspot,
                rvsHotPicture]);
            3:
              SRichViewEdit1.NextCurItem([rvsHeading]);
            4:
              SRichViewEdit1.NextCurHyperlink;
            6:
              begin
                fd.Options := fd.Options + [frDown];
                fdFind(nil);
              end;
          end;
      end;
  end;
end;

{------------------------------------------------------------------------------}
{ Event, occurs when button in the tool window is clicked }
procedure TFEditor.srvtlwndw1ClickButton(Sender: TObject;
  ToolButton: TSRVToolButton);
var
  s:     String;
  posit: Integer;
begin
  VToolButton := ToolButton;
  if ToolButton.Index = 6 then // starting text search
  begin
    SRichViewEdit1.SetFocus;
    fd.CloseDialog;
    if SRichViewEdit1.RichViewEdit.SelectionExists then
    begin
      s := SRichViewEdit1.RichViewEdit.GetSelText;
      posit := Pos(#13, s);
      if posit <> 0 then
        s := Copy(s, 1, posit - 1);
      fd.FindText := s;
    end;
    fd.Execute;
  end
  else // starting search
    SRichViewEdit1VMenuClickButton(Sender,
      TSRVToolButton(SRichViewEdit1.MenuVButtons.Items[2]));
end;

{------------------------------------------------------------------------------}
{ Text search }
procedure TFEditor.fdFind(Sender: TObject);
begin
  if not SRichViewEdit1.RichViewEdit.SearchText(fd.FindText,
    GetRVESearchOptions(fd.Options)) then
    ShowInfo('String not found', 'Search and Replace');
  SRichViewEdit1.ScrollToCaret;
end;

procedure TFEditor.Button1Click(Sender: TObject);
var
  table: TRVTableItemInfo;
begin                         //przycisk na dodawanie tabelki
  table := TRVTableItemInfo.CreateEx(3, 3, SRichViewEdit1.RichViewEdit.RVData);
  table.BorderWidth := 1;
  table.CellBorderWidth := 1;
  table.Color := clWhite;
  //table.Rows.Add(2);
  //SRichViewEdit1.RichViewEdit.ItemCount
  //RichViewTableAutoAddRow := False;
  SRichViewEdit1.RichViewEdit.AddItem('lalala', table);
  SRichViewEdit1.RichViewEdit.format;
end;

procedure TFEditor.Button2Click(Sender: TObject);
var
  Item: TCustomRVItemInfo;
  rv: TCustomRichViewEdit;
  table: TRVTableItemInfo;
begin
  SRichViewEdit1.RichViewEdit.SetSelectionBounds(0, SRichViewEdit1.RichViewEdit.GetOffsBeforeItem(0), 0, SRichViewEdit1.RichViewEdit.GetOffsBeforeItem(0));
  SRichViewEdit1.RichViewEdit.SearchText('<#>', [rvseoDown]);
  table := nil;
  if SRichViewEdit1.RichViewEdit.GetCurrentItemEx(TRVTableItemInfo, rv, item) then begin
    table := TRVTableItemInfo(Item);
    if not assigned(table) then exit;
    table.Rows.Add(table.ColCount);
    table.Rows.Add(table.ColCount);
    SRichViewEdit1.RichViewEdit.Format;
  end;
end;

end.
