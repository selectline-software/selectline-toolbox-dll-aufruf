unit Params;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Windows,
  Model,
  DllInformation;


implementation

// --- handling default values (TToolBoxFctParamW.IsDefault) -----

function GetValueOf(aFunctionInformation: TToolBoxFctInfoW; aParameterName, aParameterValue: PWideChar): string;
var
  pointerToParam    : PToolBoxFctParamW;
  foundEntry        : Boolean;
  requiresDefaultValue : Boolean;
begin
  requiresDefaultValue := Length(aParameterValue) <= 0;
  if (not requiresDefaultValue) then begin
    Exit(aParameterValue);
  end;

  foundEntry := false;
  pointerToParam := aFunctionInformation.Params;   // pointer: all params included

  // Get param
  for var index := 0 to aFunctionInformation.ParamsCount-1 do begin

    if StrIComp(aParameterName, pointerToParam^.Name) = 0 then begin
      foundEntry := true;
      break;
    end;

    // not found
    Inc(pointerToParam);
  end;

  if (not pointerToParam^.IsDefault) then begin
    // parameter is not required
    Exit(aParameterValue);
  end;

  // return default value of parameter
  if foundEntry then begin
    Result := pointerToParam^.Default;
  end;
end;

// --- functions to export ----

procedure ShowMessageBox(aCount : integer; aNames, aValues : PPWideChar); stdcall;
var
  content: string;
begin
  // Get value of first and only parameter
  content := GetValueOf(CFunctionsInfo[1], aNames^, aValues^);
  MessageBoxW(0, PWideChar(content), 'Der fantastische Titel', MB_ICONINFORMATION);
end;

procedure SaveToFile(aCount : integer; aNames, aValues : PPWideChar); stdcall;
const
  directory = 'C:\Temp';
  filename  = 'example.txt';
var
  content: TStringList;
  result : Integer;
  a, b   : Integer;
begin
  // Get values of parameter
  a.TryParse(aValues^, a);
  Inc(aValues);
  b.TryParse(aValues^, b);

  // sum up values
  result := a + b;

  // prepare saving file
  if (not DirectoryExists(directory)) then begin
    CreateDir(directory);
  end;

  // prepare content and save file
  content := TStringList.Create;
  try
    content.Add(String.Format('%d + %d = %d', [a, b, result]));
    content.SaveToFile(TPath.Combine(directory, filename));
  finally
    content.Free;
  end;
end;

exports
  SaveToFile,
  ShowMessageBox;

end.
