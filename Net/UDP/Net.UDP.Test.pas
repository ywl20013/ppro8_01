unit Net.UDP.Test;

interface

uses
  System.SysUtils,
  System.Classes,
  IdBaseComponent,
  IdComponent,
  IdUDPBase,
  Vcl.ExtCtrls,
  IdUDPClient;

type
  TdmProviderUDPTest = class( TDataModule )
    Timer1: TTimer;
    IdUDPClient1: TIdUDPClient;
    procedure Timer1Timer( Sender: TObject );
  private
    FPort: Word;
    function GetActive: Boolean;
    procedure SetActive( const Value: Boolean );
    { Private declarations }
  public
    property Active: Boolean read GetActive write SetActive;
    property Port  : Word read FPort write FPort;

    procedure Send( data: string );
  end;

var
  dmProviderUDPTest: TdmProviderUDPTest;

implementation

uses
  Models.L2;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

{ TdmProviderUDP }

function TdmProviderUDPTest.GetActive: Boolean;
begin
  Result := self.Timer1.Enabled;
end;

procedure TdmProviderUDPTest.Send( data: string );
begin
  self.IdUDPClient1.Host := '127.0.0.1';
  self.IdUDPClient1.Port := self.FPort;
  self.IdUDPClient1.Send( data );
end;

procedure TdmProviderUDPTest.SetActive( const Value: Boolean );
begin
  self.IdUDPClient1.Host := '127.0.0.1';
  self.IdUDPClient1.Port := self.FPort;
  Timer1.Enabled         := Value;
end;

procedure TdmProviderUDPTest.Timer1Timer( Sender: TObject );
var
  L2: TL2Line;
begin
  L2                := TL2Line.Create;
  L2.LocalTime      := Now;
  L2.MarketTime     := Now;
  L2.Mmid           := 'ANON';
  L2.Side           := 'B';
  L2.Price          := 1.65;
  L2.Volume         := 100;
  L2.Depth          := 1;
  L2.SequenceNumber := 27003;
  try
    self.IdUDPClient1.Send( L2.ToCSVString( ) + #13#10 );

    L2.LocalTime  := Now;
    L2.MarketTime := Now;
    L2.Side       := 'A';
    L2.Price      := 1.66;
    L2.Volume     := 200;
    self.IdUDPClient1.Send( L2.ToCSVString + #13#10 );
  finally
    L2.Free;
  end;
end;

end.
