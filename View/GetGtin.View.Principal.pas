unit GetGtin.View.Principal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, FMX.Layouts,
  FMX.Objects, FMX.Controls.Presentation, FMX.Edit, FMX.StdCtrls, System.JSON;

type
  TForm1 = class(TForm)
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
    EditDesc: TEdit;
    procedure btnBuscarClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure EditGetinKeyDown(Sender: TObject; var Key: Word;
      var KeyChar: Char; Shift: TShiftState);
  private
    procedure BuscaGtin(Cod: String);
  public
    { Public declarations }
  end;

var
    Form1: TForm1;

const
   TOKEN : String = 'okpyOHC6eYTG4MIhzglsXQ';
   URL   : String = 'https://api.cosmos.bluesoft.com.br';

implementation

uses
  REST.Types;

{$R *.fmx}

{ TForm1 }

procedure TForm1.btnBuscarClick(Sender: TObject);
begin
    if EditGetin.Text <> '' then BuscaGtin(EditGetin.Text);
end;

procedure TForm1.BuscaGtin(Cod: String);
var
    LGtin: String;
    Resp : TJSONObject;
begin
    LGtin := '/gtins/' + trim(Cod);

    RESTClient1.BaseURL := URL + LGtin;

    RESTRequest1.Params.AddHeader('X-Cosmos-Token',TOKEN);
    RESTRequest1.Params.AddHeader('Content-Type', 'application/json;charset=UTF-8' );

    RESTRequest1.Method := TRESTRequestMethod.rmGET;
    RESTRequest1.Execute;

    Resp  := RESTRequest1.Response.JSONValue as TJSONObject;

    EditDesc.Text  := Resp.Values['description'].Value;
    EditNCM.Text   := (Resp.Values['ncm'] as TJSONObject).Values['code'].Value;
end;

procedure TForm1.EditGetinKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
   if (EditGetin.Text <> '') and (Key = 13) then BuscaGtin(EditGetin.Text);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    EditDesc.Text  := '';
    EditNCM.Text   := '';
end;

end.
