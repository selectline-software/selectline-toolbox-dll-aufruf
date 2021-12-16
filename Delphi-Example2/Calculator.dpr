library Calculator;

{ Wichtiger Hinweis zur DLL-Speicherverwaltung: ShareMem muss die erste
  Unit in der USES-Klausel Ihrer Bibliothek UND in der USES-Klausel Ihres Projekts
  (wählen Sie 'Projekt-Quelltext anzeigen') sein, wenn Ihre DLL Prozeduren oder Funktionen
  exportiert, die Strings als Parameter oder Funktionsergebnisse übergeben. Dies
  gilt für alle Strings, die an oder von Ihrer DLL übergeben werden, auch für solche,
  die in Records und Klassen verschachtelt sind. ShareMem ist die Interface-Unit zur
  gemeinsamen BORLNDMM.DLL-Speicherverwaltung, die zusammen mit Ihrer DLL
  weitergegeben werden muss. Übergeben Sie String-Informationen mit PChar- oder ShortString-Parametern, um die Verwendung von BORLNDMM.DLL zu vermeiden.
 }

uses
  System.SysUtils,
  System.Classes,
  DLLInformation in 'Implementation\DLLInformation.pas',
  Model in 'Implementation\Model.pas',
  Calculations in 'Implementation\Calculations.pas';

{$R *.res}

function GetToolBoxInfoW : PToolBoxFctsW; stdcall;
begin
  Result  := @CDllInformation;
end;

procedure FreeToolBoxResultsW(aResults : PToolBoxCallReturnValuesW); stdcall; // diese Funktion muss so in der Dll enthalten sein!
var i : integer;
    v : PToolBoxCallReturnValueW;
begin
  if (aResults <> nil) then begin
    for i := 0 to aResults^.Count - 1 do begin
      v := aResults^.Values^[i];
      StrDispose(v^.Name);
      StrDispose(v^.Value);
      Dispose(v);
    end;
    FreeMem(aResults^.Values, aResults^.Count * sizeof(PToolBoxCallReturnValueW));
    Dispose(aResults);
  end;
end;

exports
  GetToolBoxInfoW,
  FreeToolBoxResultsW;

begin
end.
