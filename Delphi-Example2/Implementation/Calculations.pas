unit Calculations;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Model;

implementation

function BuildResults(const aNames, aValues : array of String) : PToolBoxCallReturnValuesW;
var i : integer;
    v : PToolBoxCallReturnValueW;
begin
  New(Result);
  Result^.Size  := SizeOf(TToolBoxCallReturnValuesW);
  Result^.Count := Length(aNames);
  GetMem(Result^.Values, Result^.Count * sizeof(PToolBoxCallReturnValueW));
  for i := 0 to Result^.Count - 1 do begin
    v                   := new(PToolBoxCallReturnValueW);
    Result^.Values^[i]  := v;
    v^.Size             := SizeOf(TToolBoxCallReturnValueW);
    v^.Name             := StrNew(PWideChar(aNames[i]));
    v^.Value            := StrNew(PWideChar(aValues[i]));
  end;
end;

procedure AddUpNumbers(aCount : integer; aNames, aValues : PPWideChar; out aResults: PToolBoxCallReturnValuesW); stdcall;
var
  result : Integer;
  a, b   : Integer;
begin
  // Get values of parameter
  a.TryParse(aValues^, a);
  Inc(aValues);
  b.TryParse(aValues^, b);

  // sum up values
  result := a + b;
  aResults := BuildResults(['result'], [result.ToString]);
end;

exports
  AddUpNumbers;

end.
