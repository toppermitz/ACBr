{******************************************************************************}
{ Projeto: Componentes ACBr                                                    }
{  Biblioteca multiplataforma de componentes Delphi para intera��o com equipa- }
{ mentos de Automa��o Comercial utilizados no Brasil                           }
{                                                                              }
{ Direitos Autorais Reservados (c) 2004 Daniel Simoes de Almeida               }
{                                                                              }
{ Colaboradores nesse arquivo:                                                 }
{                                                                              }
{  Voc� pode obter a �ltima vers�o desse arquivo na pagina do  Projeto ACBr    }
{ Componentes localizado em      http://www.sourceforge.net/projects/acbr      }
{                                                                              }
{  Esta biblioteca � software livre; voc� pode redistribu�-la e/ou modific�-la }
{ sob os termos da Licen�a P�blica Geral Menor do GNU conforme publicada pela  }
{ Free Software Foundation; tanto a vers�o 2.1 da Licen�a, ou (a seu crit�rio) }
{ qualquer vers�o posterior.                                                   }
{                                                                              }
{  Esta biblioteca � distribu�da na expectativa de que seja �til, por�m, SEM   }
{ NENHUMA GARANTIA; nem mesmo a garantia impl�cita de COMERCIABILIDADE OU      }
{ ADEQUA��O A UMA FINALIDADE ESPEC�FICA. Consulte a Licen�a P�blica Geral Menor}
{ do GNU para mais detalhes. (Arquivo LICEN�A.TXT ou LICENSE.TXT)              }
{                                                                              }
{  Voc� deve ter recebido uma c�pia da Licen�a P�blica Geral Menor do GNU junto}
{ com esta biblioteca; se n�o, escreva para a Free Software Foundation, Inc.,  }
{ no endere�o 59 Temple Street, Suite 330, Boston, MA 02111-1307 USA.          }
{ Voc� tamb�m pode obter uma copia da licen�a em:                              }
{ http://www.opensource.org/licenses/lgpl-license.php                          }
{                                                                              }
{ Daniel Sim�es de Almeida  -  daniel@djsystem.com.br  -  www.djsystem.com.br  }
{              Pra�a Anita Costa, 34 - Tatu� - SP - 18270-410                  }
{                                                                              }
{******************************************************************************}

{******************************************************************************
|* Historico
|*
|* 04/10/2005: Daniel Sim�es de Almeida
|*  - Primeira Versao ACBrBALToledo
|* 11/04/2007 Daniel Sim�es de Almeida
|*  - Corrigido para trabalhar com diversos protocolos da Toledo
|*
|* 11/10/2016 - Elias C�sar Vieira
|*  - Refatora��o de ACBrBALToledo2180
******************************************************************************}

{$I ACBr.inc}

unit ACBrBALToledo2180;

interface

uses
  ACBrBALClass, Classes;

type

  { TACBrBALToledo2180 }

  TACBrBALToledo2180 = class(TACBrBALClass)
  public
    constructor Create(AOwner: TComponent);

    procedure LeSerial( MillisecTimeOut : Integer = 500) ; override;
    function InterpretarRepostaPeso(const aResposta: AnsiString): Double; override;
  end;

implementation

uses
  ACBrConsts, SysUtils, Math,
  {$IFDEF COMPILER6_UP}
  DateUtils, StrUtils
  {$ELSE}
  ACBrD5, synaser, synaser, Windows
  {$ENDIF};

{ TACBrBALToledo2180 }

constructor TACBrBALToledo2180.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);

  fpModeloStr := 'Toledo 2180';
end;

procedure TACBrBALToledo2180.LeSerial(MillisecTimeOut: Integer);
var
  wPesos: array[1..5] of Double;
  I: Integer;
begin
  fpUltimoPesoLido := 0;
  fpUltimaResposta := '';

  try
    for I := 1 to 5 do
    begin
      fpUltimaResposta := fpDevice.LeString(MillisecTimeOut, 0, #13);
      GravaLog(' - ' + FormatDateTime('hh:nn:ss:zzz', Now) + ' RX <- ' + fpUltimaResposta);

      wPesos[I] := InterpretarRepostaPeso(fpUltimaResposta);
    end;

    if (wPesos[3] = wPesos[4]) and (wPesos[4] = wPesos[5]) then
      fpUltimoPesoLido := wPesos[5]
    else
      fpUltimoPesoLido := -1;
  except
    { Peso n�o foi recebido (TimeOut) }
    fpUltimoPesoLido := -9;
  end;

  GravaLog('              UltimoPesoLido: ' + FloatToStr(fpUltimoPesoLido) +
           ' - Resposta: ' + fpUltimaResposta);
end;

function TACBrBALToledo2180.InterpretarRepostaPeso(const aResposta: AnsiString): Double;
var
  wPos: Integer;
  wResposta: AnsiString;
begin
  Result := 0;

  if (aResposta = EmptyStr) then
    Exit;

  wPos := Pos(#96, aResposta);

  if (wPos > 0) then
  begin
    wResposta := Copy(aResposta, wPos + 1, Length(aResposta));
    wResposta := Copy(wResposta, 1, 6);
    Insert('.', wResposta, 6);
  end
  else
    wResposta := 'I';

  { Ajustando o separador de Decimal corretamente }
  wResposta := StringReplace(wResposta, '.', DecimalSeparator, [rfReplaceAll]);
  wResposta := StringReplace(wResposta, ',', DecimalSeparator, [rfReplaceAll]);

  try
    Result := StrToFloat(wResposta);
  except
    Result := 0;
  end;
end;

end.
