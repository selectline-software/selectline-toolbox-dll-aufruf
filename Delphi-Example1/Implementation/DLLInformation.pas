unit DLLInformation;

interface

uses
  Model;

// --- dll information ----

const

// --- information about parameter ----

// --- parameter of function show message box  ----
  CShowMessageBoxParamsCount = 1;
  CShowMessageBoxParams : array[0..CShowMessageBoxParamsCount - 1] of TToolBoxFctParamW = (
    (
      Size         : sizeof(TToolBoxFctParamW);
      Name         : 'content';
      Description  : 'content of the message box';
      Typ          : tbxtString;
      Direction    : tbxdOut;
      IsDefault    : true;
      Default      : 'Please do not throw sausage pizza away - OSI'
    )
  );

// --- parameter of function save to file  ----
  CSaveToFileParamsCount = 2;
  CSaveToFileParams : array[0..CSaveToFileParamsCount - 1] of TToolBoxFctParamW = (
    (
      Size         : sizeof(TToolBoxFctParamW);
      Name         : 'a';
      Description  : 'first value';
      Typ          : tbxtInteger;
      Direction    : tbxdOut;
      IsDefault    : false;
      Default      : '0'
    ),
    (
      Size         : sizeof(TToolBoxFctParamW);
      Name         : 'b';
      Description  : 'second value';
      Typ          : tbxtInteger;
      Direction    : tbxdOut;
      IsDefault    : false;
      Default      : '0'
    )
  );


// --- information about functions ----
  CFunctionsCount  = 2;
  CFunctionsInfo : array[0..CFunctionsCount - 1] of TToolBoxFctInfoW =
  (
    (
      Size        : sizeof(TToolBoxFctInfoW);
      Name        : 'SaveToFile';
      Description : 'Sum up two values and save result to file';
      Kind        : tbxcCallParams;
      ParamsCount : CSaveToFileParamsCount;
      Params      : @CSaveToFileParams;
    ),
    (
      Size        : sizeof(TToolBoxFctInfoW);
      Name        : 'ShowMessageBox';
      Description : 'Show message box with content';
      Kind        : tbxcCallParams;
      ParamsCount : CShowMessageBoxParamsCount;
      Params      : @CShowMessageBoxParams;
    )
  );

  CDllInformation : TToolBoxFctsW =
  (
    Size        : sizeof(TToolBoxFctsW);
    VersionMajor: 1;
    VersionMinor: 0;
    CopyRight   : 'SelectLine GmbH Magdeburg';
    Description : 'Calculation of values';
    FctsCount   : CFunctionsCount;
    Fcts        : @CFunctionsInfo;
  );

implementation

function GetToolBoxInfoW : PToolBoxFctsW; stdcall;
begin
  Result  := @CDllInformation;
end;

exports
  GetToolBoxInfoW;

end.
