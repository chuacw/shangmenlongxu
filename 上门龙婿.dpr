program 上门龙婿;

uses
  Vcl.Forms,
  上门龙婿.Main in '上门龙婿.Main.pas' {Form1},
  dotenv in 'dotenv\dotenv.pas',
  EdgeBrowser.Utils in 'EdgeBrowser.Utils\EdgeBrowser.Utils.pas',
  HTMLp.DOMCore in 'HTMLp-modern\HTMLp.DOMCore.pas',
  HTMLp.Entities in 'HTMLp-modern\HTMLp.Entities.pas',
  HTMLp.Enumerators in 'HTMLp-modern\HTMLp.Enumerators.pas',
  HTMLp.Formatter in 'HTMLp-modern\HTMLp.Formatter.pas',
  HTMLp.Helper in 'HTMLp-modern\HTMLp.Helper.pas',
  HTMLp.HTMLParser in 'HTMLp-modern\HTMLp.HTMLParser.pas',
  HTMLp.HTMLReader in 'HTMLp-modern\HTMLp.HTMLReader.pas',
  HTMLp.HTMLTags in 'HTMLp-modern\HTMLp.HTMLTags.pas',
  HTMLp.NodeUtils in 'HTMLp-modern\HTMLp.NodeUtils.pas';

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
