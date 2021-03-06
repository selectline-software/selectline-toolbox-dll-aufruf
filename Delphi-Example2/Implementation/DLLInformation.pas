unit DLLInformation;

interface

uses
  Model;

// --- dll information ----

const

// --- information about parameter ----

// --- parameter of function add up numbers  ----
  CAddUpNumbersParamsCount = 3;
  CAddUpNumbersParams : array[0..CAddUpNumbersParamsCount - 1] of TToolBoxFctParamW = (
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
    )     ,
    (
      Size         : sizeof(TToolBoxFctParamW);
      Name         : 'result';
      Description  : 'result of calculation';
      Typ          : tbxtInteger;
      Direction    : tbxdIn;
      IsDefault    : false;
      Default      : '0'
    )
  );

  // --- parameter of function report exception  ----
  CReportExceptionParamsCount = 1;
  CReportExceptionParams : array[0..CReportExceptionParamsCount - 1] of TToolBoxFctParamW = (
    (
      Size         : sizeof(TToolBoxFctParamW);
      Name         : 'msg';
      Description  : 'exception message';
      Typ          : tbxtString;
      Direction    : tbxdOut;
      IsDefault    : false;
    )
  );


// --- information about functions ----
  CFunctionsCount  = 2;
  CFunctionsInfo : array[0..CFunctionsCount - 1] of TToolBoxFctInfoW =
  (
    (
      Size        : sizeof(TToolBoxFctInfoW);
      Name        : 'AddUpNumbers';
      Description : 'add up two values and return result';
      Kind        : tbxcCallParamsResult;
      ParamsCount : CAddUpNumbersParamsCount;
      Params      : @CAddUpNumbersParams;
    ),
    (
      Size        : sizeof(TToolBoxFctInfoW);
      Name        : 'ReportException';
      Description : 'throw exception with a message';
      Kind        : tbxcCallMsg;
      ParamsCount : CReportExceptionParamsCount;
      Params      : @CReportExceptionParams;
    )
  );

  CDllInformation : TToolBoxFctsW =
  (
    Size        : sizeof(TToolBoxFctsW);
    VersionMajor: 2;
    VersionMinor: 0;
    CopyRight   : 'SelectLine GmbH Magdeburg';
    Description : 'Calculation of values with result';
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
