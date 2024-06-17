program GetInfoGtin;

uses
  System.StartUpCopy,
  FMX.Forms,
  GetGtin.View.Principal in 'View\GetGtin.View.Principal.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
