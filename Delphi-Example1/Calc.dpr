library Calc;

{ Wichtiger Hinweis zur DLL-Speicherverwaltung: ShareMem muss die erste
  Unit in der USES-Klausel Ihrer Bibliothek UND in der USES-Klausel Ihres Projekts
  (w�hlen Sie 'Projekt-Quelltext anzeigen') sein, wenn Ihre DLL Prozeduren oder Funktionen
  exportiert, die Strings als Parameter oder Funktionsergebnisse �bergeben. Dies
  gilt f�r alle Strings, die an oder von Ihrer DLL �bergeben werden, auch f�r solche,
  die in Records und Klassen verschachtelt sind. ShareMem ist die Interface-Unit zur
  gemeinsamen BORLNDMM.DLL-Speicherverwaltung, die zusammen mit Ihrer DLL
  weitergegeben werden muss. �bergeben Sie String-Informationen mit PChar- oder ShortString-Parametern, um die Verwendung von BORLNDMM.DLL zu vermeiden.
 }

uses
  Model in 'Implementation\Model.pas',
  DLLInformation in 'Implementation\DLLInformation.pas',
  FunctionalityToExport in 'Implementation\FunctionalityToExport.pas';

{$R *.res}

function GetToolBoxInfoW : PToolBoxFctsW; stdcall;
begin
  Result  := @CDllInformation;
end;

exports
  GetToolBoxInfoW;

begin
end.
