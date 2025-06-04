unit 上门龙婿.Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Winapi.WebView2, Winapi.ActiveX, Vcl.Edge, Vcl.StdCtrls,
  HTMLp.HTMLParser, HTMLp.DOMCore, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  Tfrm上门龙婿 = class(TForm)
    StatusBar: TStatusBar;
    Panel1: TPanel;
    btnStart: TButton;
    Panel2: TPanel;
    EdgeBrowser1: TEdgeBrowser;
    btnFixFile: TButton;
    procedure btnStartClick(Sender: TObject);
    procedure EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
      IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnFixFileClick(Sender: TObject);
  private
    { Private declarations }
    FHTMLBody, FNextChapterURL: string;
    FFetched: Boolean;
    FHTMLParser: THTMLParser;
    procedure DoDataAvailable;
    procedure UpdateStatus(const AStatus: string);
  protected
  const
    CDivAlign: string = '<div align="center"><a href="javascript:posterror();" style="text-align:center;color:red;">章节错误,点此举报(免注册)我们会尽快处理.</a>举报后请耐心等待,并刷新页面。</div>';
    CSiteName: string = '　　请记住本书首发域名：www.biqvkk.cc。笔趣阁手机版阅读网址：m.biqvkk.cc';
  public
    { Public declarations }
  end;

var
  Form1: Tfrm上门龙婿;

implementation

uses
  System.JSON, Vcl.AxCtrls, System.IOUtils, dotenv, EdgeBrowser.Utils,
  System.StrUtils, HTMLp.NodeUtils, System.Net.URLClient, HTMLp.Enumerators,
  System.RegularExpressions;

{$R *.dfm}

procedure Tfrm上门龙婿.FormCreate(Sender: TObject);
begin
  FNextChapterURL := 'https://www.biqvkk.cc/55_55278/24377671.html'; //'https://www.biqvkk.cc/55_55278/24380031.html';
  FHTMLParser := THTMLParser.Create;
  StatusBar.SimplePanel := True;
end;

procedure Tfrm上门龙婿.FormDestroy(Sender: TObject);
begin
  FHTMLParser.Free;
end;

procedure Tfrm上门龙婿.UpdateStatus(const AStatus: string);
begin
  if TThread.CurrentThread.ThreadID = MainThreadID then
    begin
      StatusBar.SimpleText := AStatus;
      Application.ProcessMessages;
    end else
    begin
      TThread.ForceQueue(nil, procedure
      begin
        StatusBar.SimpleText := AStatus;
      end);
    end;
end;

procedure Tfrm上门龙婿.btnFixFileClick(Sender: TObject);
var
  LContent: string;
begin
  var LFileName := '上门龙婿.txt';
  LContent := TFile.ReadAllText(LFileName);
  LContent := StringReplace(LContent, CDivAlign, '', [rfReplaceAll]);
  LContent := StringReplace(LContent, CSiteName, '', [rfReplaceAll]);
  var LRegex := '\(https://.*html\)';
  LContent := TRegEx.Replace(LContent, LRegex, '');
  TFile.Delete(LFileName);
  TFile.WriteAllText(LFileName, LContent, TEncoding.UTF8);
end;

procedure Tfrm上门龙婿.btnStartClick(Sender: TObject);
begin
  var LURL := FNextChapterURL;
  StatusBar.SimpleText := Format('Loading %s', [LURL]);
  EdgeBrowser1.Navigate(LURL);
  Application.ProcessMessages;
end;

{
  <a href="/55_55278/">上门龙婿叶辰萧初然</a> &gt; 第1章 受尽屈辱
}
procedure Tfrm上门龙婿.DoDataAvailable;
var
  LHTMLBody, LChapterName, LNextChapterURL: string;
  LDocument: TDocument;
  LBodyElem, LContentElem, LNavigationList: TElement;
  LAnchorList, LLinkList: TNodeList;
  LLines: TArray<string>;
begin
  UpdateStatus(Format('Loaded: %s', [FNextChapterURL]));
  FFetched := False;
  LHTMLBody := FHTMLBody;
  LDocument := FHTMLParser.ParseString(LHTMLBody);
  try
    LBodyElem := LDocument.Body;
    LAnchorList := LBodyElem.GetElementsByTagName('h1');
    try
      if LAnchorList.Count > 0 then
        LChapterName := LAnchorList[0].Value;
      LContentElem := LBodyElem.GetElementByClass('showtxt');
      if Assigned(LContentElem) then
        begin
          var LFileName := '上门龙婿.txt';
          LChapterName := LChapterName + #13#10#13#10;
          var LContent := LContentElem.innerHTML + #13#10;
          LContent := StringReplace(LContent, '<br></br>', #13#10, [rfReplaceAll]);
          LContent := StringReplace(LContent, CDivAlign, '', []);
          LContent := StringReplace(LContent, CSiteName, '', []);
          var LRegex := '\(https://.*html\)';
          LContent := TRegEx.Replace(LContent, LRegex, '');
          TFile.AppendAllText(LFileName, LChapterName, TEncoding.UTF8);
          TFile.AppendAllText(LFileName, LContent, TEncoding.UTF8);
        end;
      LNavigationList := LBodyElem.GetElementByClass('page_chapter');
      LLinkList := LNavigationList.GetElementsByTagName('a');
      try
        for var LLink in LLinkList do
          if LLink.Value = '下一章' then
            begin
              var href := LLink.getAttribute('href');
              if href = '/55_55278/' then
                begin
                  UpdateStatus('Completed.');
                  Break;
                end;
              LNextChapterURL := 'https://www.biqvkk.cc' + href;
              FNextChapterURL := LNextChapterURL;
              TThread.ForceQueue(nil, procedure
              begin
                btnStart.Click;
              end);
              Break;
            end;
      finally
        LLinkList.Free;
      end;
    finally
      LAnchorList.Free;
    end;
  finally
    LDocument.Free;
  end;
end;

procedure Tfrm上门龙婿.EdgeBrowser1NavigationCompleted(Sender: TCustomEdgeBrowser;
  IsSuccess: Boolean; WebErrorStatus: COREWEBVIEW2_WEB_ERROR_STATUS);
const
  CDocument = 'document.body.outerHTML';
begin
  Sender.DefaultInterface.ExecuteScript(CDocument,
    Callback<HResult, PWideChar>.CreateAs<ICoreWebView2ExecuteScriptCompletedHandler>(
      function (errorCode: HResult; resultObjectAsJson: PWideChar): HResult stdcall
      var
        LHTMLBodyJSON: TJSONValue;
      begin
        LHTMLBodyJSON := TJSONValue.ParseJSONValue(string(resultObjectAsJson));
        try
          FHTMLBody := LHTMLBodyJSON.AsType<string>;
          Result := S_OK;
          FFetched := True;
        finally
          LHTMLBodyJSON.Free;
        end;
        DoDataAvailable;
      end
    )
  );
end;

end.
