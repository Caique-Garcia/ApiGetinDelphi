program GetInfoGtin;

uses
  System.StartUpCopy,
  FMX.Forms,
  GetGtin.View.Principal in 'View\GetGtin.View.Principal.pas' {FormPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TFormPrincipal, FormPrincipal);
  Application.Run;
end.
