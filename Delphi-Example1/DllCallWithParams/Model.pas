unit Model;

interface

type
  TToolBoxCallKind  = (tbxcNone, tbxcCall, tbxcCallMsg, tbxcCallParams, tbxcCallDBParams,
                       tbxcCallResult, tbxcCallMsgResult, tbxcCallParamsResult, tbxcCallDBParamsResult);

  TToolBoxParamType       = (tbxtString,    // Dekodierer: implizit
                             tbxtInteger,   // Dekodierer: StrToInt
                             tbxtDouble,    // Dekodierer: StrToFloat
                             tbxtDateTime,  // Dekodierer: StrToDateTime
                             tbxtDate,      // Dekodierer: StrToDate
                             tbxtTime,      // Dekodierer: StrToTime
                             tbxtBoolean    // Dekodierer: StrToBoolDef
                            );

  TToolBoxParamDirection  = (
      tbxdOut,  // input of dll-function
      tbxdIn,   // response of dll-function
      tbxdInOut // both
  );

  // --- record which contains information about params of dll-functions ---
  TToolBoxFctParamW = packed record
    Size        : integer;      // sizeof(TToolBoxFctParamW)
    Name        : PWideChar;
    Description : PWideChar;
    Dummy       : Byte;         // hier war fr�her  Kind: TToolBoxParamKind; der Recordaufbau muss aber bleiben
    Typ         : TToolBoxParamType;
    Direction   : TToolBoxParamDirection;
    IsDefault   : boolean;      // Is field required?
    Default     : PWideChar;    // default value
  end;
  PToolBoxFctParamW  = ^TToolBoxFctParamW;

  // --- record which contains information about dll-functions ---
  TToolBoxFctInfoW = packed record
    Size        : integer;    // sizeof(TToolBoxFctInfoW)
    Name        : PWideChar;
    Description : PWideChar;
    Kind        : TToolBoxCallKind;
    Dummy       : Byte;       // hier war fr�her  ParamsKind: TToolBoxParamsKind; der Recordaufbau muss aber bleiben
    ParamsCount : integer;
    Params      : PToolBoxFctParamW;
  end;
  PToolBoxFctInfoW = ^TToolBoxFctInfoW;

  // --- record which contains information about dll ---
  TToolBoxFctsW  = packed record
    Size          : integer;  // sizeof(TToolBoxFctsW)
    VersionMajor,
    VersionMinor  : word;
    CopyRight     : PWideChar;
    Description   : PWideChar;
    FctsCount     : integer;
    Fcts          : PToolBoxFctInfoW;
  end;
  PToolBoxFctsW  = ^TToolBoxFctsW;

implementation

end.