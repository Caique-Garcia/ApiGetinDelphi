unit GetGtin.View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, System.JSON, FMX.Clipboard,
  FMX.ScrollBox, FMX.Platform, FMX.Memo, Winapi.Windows;

type
  TFormPrincipal = class(TForm)
    RESTClient1: TRESTClient;
    RESTRequest1: TRESTRequest;
    RESTResponse1: TRESTResponse;
    Layout1: TLayout;
    Layout2: TLayout;
    Rectangle1: TRectangle;
    EditGetin: TEdit;
    Layout3: TLayout;
    Rectangle2: TRectangle;
    btnBuscar: TSpeedButton;
    Layout4: TLayout;
    Layout5: TLayout;
    Label1: TLabel;
    Layout6: TLayout;
    Label3: TLabel;
    EditNCM: TEdit;
    Layout7: TLayout;
    Layout8: TLayout;
    Rectangle3: TRectangle;
    btnCopiar: TSpeedButton;
    EditDesc: TEdit;
    Layout9: TLayout;
    Label2: TLabel;
    EditPreco: TEdit;
    procedure btnBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditGetinKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
    procedure btnCopiarClick(Sender: TObject);
  private
    Token : String;
    FTextoResp: TStringList;
    procedure BuscaGtin(Cod: String);
    procedure CopiarParaTransf(Texto: String);
  public
    { Public declarations }
  end;

var
    FormPrincipal: TFormPrincipal;

const
   URL   : String = 'https://api.cosmos.bluesoft.com.br';

implementation

uses
  REST.Types;

{$R *.fmx}

{ TForm1 }

procedure TFormPrincipal.btnBuscarClick(Sender: TObject);
begin
    if EditGetin.Text <> '' then BuscaGtin(EditGetin.Text);
end;

procedure TFormPrincipal.btnCopiarClick(Sender: TObject);
begin
    if FTextoResp.Text <> '' then
        CopiarParaTransf(FTextoResp.Text);
end;

procedure TFormPrincipal.BuscaGtin(Cod: String);
var
    LGtin: String;
    Resp : TJSONObject;
    TokenTextFile: TextFile;
    ExePath: string;
begin

    if Token.IsEmpty then
    begin
        ExePath := ExtractFilePath(ParamStr(0));

        if not(InputQuery('Configuração do Token de acesso', 'Token', Token )) then exit;

        AssignFile(TokenTextFile, ExePath + 'token.txt');
        try
          Rewrite(TokenTextFile);
          WriteLn(TokenTextFile, Token);
        finally
          CloseFile(TokenTextFile);
        end;
    end;

    LGtin := '/gtins/' + trim(Cod);

    RESTClient1.BaseURL := URL + LGtin;

    RESTRequest1.Params.AddHeader('X-Cosmos-Token',TOKEN);
    RESTRequest1.Params.AddHeader('Content-Type', 'application/json;charset=UTF-8' );

    RESTRequest1.Method := TRESTRequestMethod.rmGET;
    RESTRequest1.Execute;

    Resp  := RESTRequest1.Response.JSONValue as TJSONObject;

    try
        EditDesc.Text  := Resp.Values['description'].Value;
    except
    end;

    try
        EditNCM.Text   := (Resp.Values['ncm'] as TJSONObject).Values['code'].Value;
    except
        EditNCM.Text   := '';
    end;

    try
        EditPreco.Text := Resp.Values['price'].Value;
    except
    end;

    FTextoResp.Clear;
    FTextoResp.Add(RESTRequest1.Response.Content);
end;

procedure TFormPrincipal.CopiarParaTransf(Texto: String);
var
    Copy : IFMXClipboardService;
begin

   if TPlatformServices.Current.SupportsPlatformService(IFMXClipboardService, Copy) then
      Copy.SetClipboard(Texto);
end;

procedure TFormPrincipal.EditGetinKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if (EditGetin.Text <> '') and (Key = 13) then BuscaGtin(EditGetin.Text);
end;

procedure TFormPrincipal.FormCreate(Sender: TObject);
var
  ExePath: string;
begin
    EditDesc.Text  := '';
    EditNCM.Text   := '';
    FTextoResp := TStringList.Create;

    ExePath := ExtractFilePath(ParamStr(0));

    try
        FTextoResp.LoadFromFile(ExePath + 'token.txt');
        Token := Trim(FTextoResp.Text);
        FTextoResp.Clear;
    except
    end;

end;

procedure TFormPrincipal.FormDestroy(Sender: TObject);
begin
    FTextoResp.DisposeOf;
end;

end.
