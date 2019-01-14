{******************************************************************************}
{ Projeto: Componente ACBrNFe                                                  }
{  Biblioteca multiplataforma de componentes Delphi para emiss�o de Nota Fiscal}
{ eletr�nica - NFe - http://www.nfe.fazenda.gov.br                             }

{ Direitos Autorais Reservados (c) 2008 Wemerson Souto                         }
{                                       Daniel Simoes de Almeida               }
{                                       Andr� Ferreira de Moraes               }

{ Colaboradores nesse arquivo:                                                 }

{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do Projeto ACBr     }
{ Componentes localizado em http://www.sourceforge.net/projects/acbr           }


{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }

{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }

{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }

{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }

{******************************************************************************}

{$I ACBr.inc}

unit ACBrNFeConfiguracoes;

interface

uses
  Classes, SysUtils, IniFiles,
  ACBrDFeConfiguracoes, pcnConversao, pcnConversaoNFe;

type

  { TGeralConfNFe }

  TGeralConfNFe = class(TGeralConf)
  private
    FModeloDF: TpcnModeloDF;
    FModeloDFCodigo: integer;
    FVersaoDF: TpcnVersaoDF;
    FAtualizarXMLCancelado: Boolean;
    FIdCSC: String;
    FCSC: String;
    FVersaoQRCode: TpcnVersaoQrCode;
    FCamposFatObrigatorios: Boolean;

    procedure SetCSC(const AValue: String);
    procedure SetIdCSC(const AValue: String);
    procedure SetModeloDF(AValue: TpcnModeloDF);
    procedure SetVersaoDF(const Value: TpcnVersaoDF);
  public
    constructor Create(AOwner: TConfiguracoes); override;
    procedure Assign(DeGeralConfNFe: TGeralConfNFe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

  published
    property ModeloDF: TpcnModeloDF read FModeloDF write SetModeloDF default moNFe;
    property ModeloDFCodigo: integer read FModeloDFCodigo;
    property VersaoDF: TpcnVersaoDF read FVersaoDF write SetVersaoDF default ve310;
    property AtualizarXMLCancelado: Boolean
      read FAtualizarXMLCancelado write FAtualizarXMLCancelado default False;
    property IdCSC: String read FIdCSC write SetIdCSC;
    property CSC: String read FCSC write SetCSC;
    property VersaoQRCode: TpcnVersaoQrCode read FVersaoQRCode write FVersaoQRCode default veqr100;
    property CamposFatObrigatorios: Boolean
      read FCamposFatObrigatorios write FCamposFatObrigatorios default True;
  end;

  { TDownloadConfNFe }

  TDownloadConfNFe = class(TPersistent)
  private
    FPathDownload: String;
    FSepararPorNome: Boolean;
  public
    Constructor Create;
    procedure Assign(Source: TPersistent); override;
  published
    property PathDownload: String read FPathDownload write FPathDownload;
    property SepararPorNome: Boolean read FSepararPorNome write FSepararPorNome default False;
  end;

  { TArquivosConfNFe }

  TArquivosConfNFe = class(TArquivosConf)
  private
    FEmissaoPathNFe: boolean;
    FSalvarEvento: boolean;
    FSalvarApenasNFeProcessadas: boolean;
    FNormatizarMunicipios: Boolean;
    FPathNFe: String;
    FPathInu: String;
    FPathEvento: String;
    FPathArquivoMunicipios: String;
    FDownloadNFe: TDownloadConfNFe;
  public
    constructor Create(AOwner: TConfiguracoes); override;
    destructor Destroy; override;
    procedure Assign(DeArquivosConfNFe: TArquivosConfNFe); reintroduce;
    procedure GravarIni(const AIni: TCustomIniFile); override;
    procedure LerIni(const AIni: TCustomIniFile); override;

    function GetPathInu(CNPJ: String = ''): String;
    function GetPathNFe(Data: TDateTime = 0; CNPJ: String = ''; Modelo: Integer = 0): String;
    function GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String = ''; Data: TDateTime = 0): String;
    function GetPathDownload(const xNome: String = ''; CNPJ: String = ''; Data: TDateTime = 0): String;
  published
    property EmissaoPathNFe: boolean read FEmissaoPathNFe
      write FEmissaoPathNFe default False;
    property SalvarEvento: boolean read FSalvarEvento
      write FSalvarEvento default False;
    property SalvarApenasNFeProcessadas: boolean
      read FSalvarApenasNFeProcessadas write FSalvarApenasNFeProcessadas default False;
    property NormatizarMunicipios: boolean
      read FNormatizarMunicipios write FNormatizarMunicipios default False;
    property PathNFe: String read FPathNFe write FPathNFe;
    property PathInu: String read FPathInu write FPathInu;
    property PathEvento: String read FPathEvento write FPathEvento;
    property PathArquivoMunicipios: String read FPathArquivoMunicipios write FPathArquivoMunicipios;
    property DownloadNFe: TDownloadConfNFe read FDownloadNFe write FDownloadNFe;
  end;

  { TConfiguracoesNFe }

  TConfiguracoesNFe = class(TConfiguracoes)
  private
    function GetArquivos: TArquivosConfNFe;
    function GetGeral: TGeralConfNFe;
  protected
    procedure CreateGeralConf; override;
    procedure CreateArquivosConf; override;

  public
    constructor Create(AOwner: TComponent); override;
    procedure Assign(DeConfiguracoesNFe: TConfiguracoesNFe); reintroduce;

  published
    property Geral: TGeralConfNFe read GetGeral;
    property Arquivos: TArquivosConfNFe read GetArquivos;
    property WebServices;
    property Certificados;
  end;

implementation

uses
  ACBrUtil, ACBrNFe,
  DateUtils;

{ TDownloadConfNFe }

constructor TDownloadConfNFe.Create;
begin
  inherited Create;
  FPathDownload := '';
  FSepararPorNome := False;
end;

procedure TDownloadConfNFe.Assign(Source: TPersistent);
begin
  if Source is TDownloadConfNFe then
  begin
    FPathDownload := TDownloadConfNFe(Source).PathDownload;
    FSepararPorNome := TDownloadConfNFe(Source).SepararPorNome;
  end
  else
    inherited Assign(Source);
end;

{ TConfiguracoesNFe }

constructor TConfiguracoesNFe.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  FPSessaoIni := 'NFe';
  WebServices.ResourceName := 'ACBrNFeServicos';
end;

procedure TConfiguracoesNFe.Assign(DeConfiguracoesNFe: TConfiguracoesNFe);
begin
  Geral.Assign(DeConfiguracoesNFe.Geral);
  WebServices.Assign(DeConfiguracoesNFe.WebServices);
  Certificados.Assign(DeConfiguracoesNFe.Certificados);
  Arquivos.Assign(DeConfiguracoesNFe.Arquivos);
end;

function TConfiguracoesNFe.GetArquivos: TArquivosConfNFe;
begin
  Result := TArquivosConfNFe(FPArquivos);
end;

function TConfiguracoesNFe.GetGeral: TGeralConfNFe;
begin
  Result := TGeralConfNFe(FPGeral);
end;

procedure TConfiguracoesNFe.CreateGeralConf;
begin
  FPGeral := TGeralConfNFe.Create(Self);
end;

procedure TConfiguracoesNFe.CreateArquivosConf;
begin
  FPArquivos := TArquivosConfNFe.Create(self);
end;

{ TGeralConfNFe }

constructor TGeralConfNFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FModeloDF := moNFe;
  FModeloDFCodigo := StrToInt(ModeloDFToStr(FModeloDF));
  FVersaoDF := ve310;
  FAtualizarXMLCancelado := False;
  FIdCSC := '';
  FCSC := '';
  FVersaoQRCode := veqr000;
  FCamposFatObrigatorios := True;
end;

procedure TGeralConfNFe.Assign(DeGeralConfNFe: TGeralConfNFe);
begin
  inherited Assign(DeGeralConfNFe);

  ModeloDF := DeGeralConfNFe.ModeloDF;
  VersaoDF := DeGeralConfNFe.VersaoDF;
  AtualizarXMLCancelado := DeGeralConfNFe.AtualizarXMLCancelado;
  IdCSC    := DeGeralConfNFe.IdCSC;
  CSC      := DeGeralConfNFe.CSC;
  VersaoQRCode := DeGeralConfNFe.VersaoQRCode;
  CamposFatObrigatorios := DeGeralConfNFe.CamposFatObrigatorios;
end;

procedure TGeralConfNFe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteString(fpConfiguracoes.SessaoIni, 'IdCSC', IdCSC);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'CSC', CSC);
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'ModeloDF', Integer(ModeloDF));
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF));
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'AtualizarXMLCancelado', AtualizarXMLCancelado);
  AIni.WriteInteger(fpConfiguracoes.SessaoIni, 'VersaoQRCode', Integer(VersaoQRCode));
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'CamposFatObrigatorios', CamposFatObrigatorios);
end;

procedure TGeralConfNFe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  IdCSC := AIni.ReadString(fpConfiguracoes.SessaoIni, 'IdCSC', IdCSC);
  CSC := AIni.ReadString(fpConfiguracoes.SessaoIni, 'CSC', CSC);
  ModeloDF := TpcnModeloDF(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'ModeloDF', Integer(ModeloDF)));
  VersaoDF := TpcnVersaoDF(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoDF', Integer(VersaoDF)));
  AtualizarXMLCancelado := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'AtualizarXMLCancelado', AtualizarXMLCancelado);
  VersaoQRCode :=  TpcnVersaoQrCode(AIni.ReadInteger(fpConfiguracoes.SessaoIni, 'VersaoQRCode', Integer(VersaoQRCode)));
  CamposFatObrigatorios := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'CamposFatObrigatorios', CamposFatObrigatorios);
end;

procedure TGeralConfNFe.SetModeloDF(AValue: TpcnModeloDF);
begin
  FModeloDF := AValue;
  FModeloDFCodigo := StrToInt(ModeloDFToStr(FModeloDF));
end;

procedure TGeralConfNFe.SetCSC(const AValue: String);
begin
  if FCSC=AValue then
    Exit;

  FCSC:=Trim(AValue);
end;

procedure TGeralConfNFe.SetIdCSC(const AValue: String);
begin
  if FIdCSC=AValue then
    Exit;

  FIdCSC:=IntToStrZero(StrToIntDef(AValue,0),6);
end;

procedure TGeralConfNFe.SetVersaoDF(const Value: TpcnVersaoDF);
begin
  FVersaoDF := Value;
end;

{ TArquivosConfNFe }

constructor TArquivosConfNFe.Create(AOwner: TConfiguracoes);
begin
  inherited Create(AOwner);

  FDownloadNFe := TDownloadConfNFe.Create;
  FEmissaoPathNFe := False;
  FSalvarEvento := False;
  FSalvarApenasNFeProcessadas := False;
  FNormatizarMunicipios := False;
  FPathNFe := '';
  FPathInu := '';
  FPathEvento := '';
  FPathArquivoMunicipios := '';
end;

destructor TArquivosConfNFe.Destroy;
begin
  FDownloadNFe.Free;
  inherited;
end;

procedure TArquivosConfNFe.Assign(DeArquivosConfNFe: TArquivosConfNFe);
begin
  inherited Assign(DeArquivosConfNFe);

  EmissaoPathNFe             := DeArquivosConfNFe.EmissaoPathNFe;
  SalvarEvento               := DeArquivosConfNFe.SalvarEvento;
  SalvarApenasNFeProcessadas := DeArquivosConfNFe.SalvarApenasNFeProcessadas;
  NormatizarMunicipios       := DeArquivosConfNFe.NormatizarMunicipios;
  PathNFe                    := DeArquivosConfNFe.PathNFe;
  PathInu                    := DeArquivosConfNFe.PathInu;
  PathEvento                 := DeArquivosConfNFe.PathEvento;
  PathArquivoMunicipios      := DeArquivosConfNFe.PathArquivoMunicipios;
  FDownloadNFe.Assign(DeArquivosConfNFe.DownloadNFe);
end;

procedure TArquivosConfNFe.GravarIni(const AIni: TCustomIniFile);
begin
  inherited GravarIni(AIni);

  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'SalvarEvento', SalvarEvento);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'SalvarApenasNFeProcessadas', SalvarApenasNFeProcessadas);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'EmissaoPathNFe', EmissaoPathNFe);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'NormatizarMunicipios', NormatizarMunicipios);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathNFe', PathNFe);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathInu', PathInu);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathEvento', PathEvento);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'PathArquivoMunicipios', PathArquivoMunicipios);
  AIni.WriteString(fpConfiguracoes.SessaoIni, 'Download.PathDownload', DownloadNFe.PathDownload);
  AIni.WriteBool(fpConfiguracoes.SessaoIni, 'Download.SepararPorNome', DownloadNFe.SepararPorNome);
end;

procedure TArquivosConfNFe.LerIni(const AIni: TCustomIniFile);
begin
  inherited LerIni(AIni);

  SalvarEvento := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'SalvarEvento', SalvarEvento);
  SalvarApenasNFeProcessadas := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'SalvarApenasNFeProcessadas', SalvarApenasNFeProcessadas);
  EmissaoPathNFe := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'EmissaoPathNFe', EmissaoPathNFe);
  NormatizarMunicipios := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'NormatizarMunicipios', NormatizarMunicipios);
  PathNFe := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathNFe', PathNFe);
  PathInu := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathInu', PathInu);
  PathEvento := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathEvento', PathEvento);
  PathArquivoMunicipios := AIni.ReadString(fpConfiguracoes.SessaoIni, 'PathArquivoMunicipios', PathArquivoMunicipios);
  DownloadNFe.PathDownload := AIni.ReadString(fpConfiguracoes.SessaoIni, 'Download.PathDownload', DownloadNFe.PathDownload);
  DownloadNFe.SepararPorNome := AIni.ReadBool(fpConfiguracoes.SessaoIni, 'Download.SepararPorNome', DownloadNFe.SepararPorNome);
end;

function TArquivosConfNFe.GetPathDownload(const xNome: String = ''; CNPJ: String = ''; Data: TDateTime = 0): String;
var
  rPathDown: String;
begin
  rPathDown := '';
  if EstaVazio(FDownloadNFe.PathDownload) then
     FDownloadNFe.PathDownload := PathSalvar;

  if (FDownloadNFe.SepararPorNome) and (NaoEstaVazio(xNome)) then
     rPathDown := rPathDown + PathWithDelim(FDownloadNFe.PathDownload) + OnlyAlphaNum(xNome)
  else
     rPathDown := FDownloadNFe.PathDownload;

  Result := GetPath(rPathDown, 'Down', CNPJ, Data);
end;

function TArquivosConfNFe.GetPathEvento(tipoEvento: TpcnTpEvento; CNPJ: String;
  Data: TDateTime): String;
var
  Dir: String;
begin
  Dir := GetPath(FPathEvento, 'Evento', CNPJ, Data);

  if AdicionarLiteral then
    Dir := PathWithDelim(Dir) + TpEventoToDescStr(tipoEvento);

  if not DirectoryExists(Dir) then
    ForceDirectories(Dir);

  Result := Dir;
end;

function TArquivosConfNFe.GetPathInu(CNPJ: String = ''): String;
begin
  Result := GetPath(FPathInu, 'Inu', CNPJ);
end;

function TArquivosConfNFe.GetPathNFe(Data: TDateTime = 0; CNPJ: String = ''; Modelo: Integer = 0): String;
var
  DescricaoModelo: String;
begin
  case Modelo of
     0:
       begin
         if Assigned(fpConfiguracoes.Owner) then
           DescricaoModelo := TACBrNFe(fpConfiguracoes.Owner).GetNomeModeloDFe
         else
           DescricaoModelo := 'NFe';
       end;

    55:
       DescricaoModelo := 'NFe';
    65:
       DescricaoModelo := 'NFCe';
  end;

  Result := GetPath(FPathNFe, DescricaoModelo, CNPJ, Data, DescricaoModelo);
end;

end.

