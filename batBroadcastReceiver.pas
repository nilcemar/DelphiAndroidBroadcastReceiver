unit batBroadcastReceiver;

interface

uses
  System.SysUtils, System.Classes


  {$IFDEF ANDROID}
  ,Androidapi.JNI.Embarcadero
  ,Androidapi.JNI.GraphicsContentViewText
  ,Androidapi.Helpers
  ,Androidapi.JNIBridge
  ,Androidapi.JNI.JavaTypes
  ,Androidapi.JNI.App
  {$ENDIF}
  ;

type


  {$IFNDEF ANDROID}
  JIntent = class
  end;
  JContext = class
  end;
  {$ENDIF}

  TAndroidBroadcastReceiver= class;
  TOnReceive = procedure (csContext: JContext; csIntent: JIntent) of object;

  {$IFDEF ANDROID}
  TBroadcastListener = class(TJavaLocal, JFMXBroadcastReceiverListener)
    private
      FOwner: TAndroidBroadcastReceiver;
    public
      constructor Create(AOwner: TAndroidBroadcastReceiver);
      procedure OnReceive(csContext: JContext; csIntent: JIntent); cdecl;
  end;
  {$ENDIF}


  TAndroidBroadcastReceiver = class(TComponent)
  private
    { Private declarations }
    {$IFDEF ANDROID}
    FReceiver: JBroadcastReceiver;
    FListener : TBroadcastListener;
    {$ENDIF}
    FOnReceive: TOnReceive;
    FItems: TStringList;
    function GetItem(const csIndex: Integer): String;

  protected
    { Protected declarations }
  public
    { Public declarations }
    constructor Create(AOwner: TComponent); override;
    destructor  Destroy; override;
    procedure SendBroadcast(csValue: String);
    procedure Add(csValue: String);
    procedure Delete(csIndex: Integer);
    procedure Clear;
    {$IFDEF ANDROID}
    procedure setResultData(data: JString);
    {$ENDIF}
    function Remove(const csValue: String): Integer;
    function First: String;
    function Last: String;
    function HasPermission(const csPermission: string): Boolean;
    procedure RegisterReceive;
    property Item[const csIndex: Integer]: string read GetItem; default;
    property Items: TStringList read FItems write FItems;
    function StringFromByteArray(ABytes: System.TArray<System.Byte>): String;

  published
    { Published declarations }
    property OnReceive: TOnReceive read FOnReceive write FOnReceive;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('BAT_Tecnologia', [TAndroidBroadcastReceiver]);
end;

{ TAndroidBroadcastReceiver }

procedure TAndroidBroadcastReceiver.Add(csValue: String);
{$IFDEF ANDROID}
var
  Filter: JIntentFilter;
{$ENDIF}
begin
  {$IFDEF ANDROID}
  if (FListener = nil) or (FReceiver = nil) then
  begin
    Raise Exception.Create('First use RegisterReceive!');
    Exit;
  end;
  {$ENDIF}

  if FItems <> nil then
    if FItems.IndexOf(csValue) = -1 then
    begin
    {$IFDEF ANDROID}
      filter := TJIntentFilter.Create;
      filter.addAction(StringToJString(csValue));
      TAndroidHelper.Context.registerReceiver(FReceiver, filter);
    {$ENDIF}
      FItems.Add(csValue);
    end;
end;

procedure TAndroidBroadcastReceiver.Clear;
begin
  FItems.Clear;
end;

constructor TAndroidBroadcastReceiver.Create(AOwner: TComponent);
begin
  inherited;
  FItems := TStringList.Create;
end;


procedure TAndroidBroadcastReceiver.Delete(csIndex: Integer);
begin
  if FItems <> nil then
  begin
    FItems.Delete(csIndex);
    {$IFDEF ANDROID}
      TAndroidHelper.Activity.UnregisterReceiver(FReceiver);
      RegisterReceive;
    {$ENDIF}
  end;
end;


destructor TAndroidBroadcastReceiver.Destroy;
begin
  FItems.Free;
{$IFDEF ANDROID}
  if FReceiver <> nil  then
    TAndroidHelper.Activity.UnregisterReceiver(FReceiver);
{$ENDIF}
  inherited;
end;


function TAndroidBroadcastReceiver.First: String;
begin
  Result := FItems[0];
end;


function TAndroidBroadcastReceiver.GetItem(const csIndex: Integer): String;
begin
  Result := FItems[csIndex];
end;

function TAndroidBroadcastReceiver.HasPermission(
  const csPermission: string): Boolean;
{$IFDEF ANDROID}
begin
  Result := TAndroidHelper.Activity.checkCallingOrSelfPermission(StringToJString(csPermission)) = TJPackageManager.JavaClass.PERMISSION_GRANTED;
{$ELSE}
begin
  Result := False;
{$ENDIF}
end;



function TAndroidBroadcastReceiver.Last: String;
begin
  Result := FItems[FItems.Count];
end;


procedure TAndroidBroadcastReceiver.RegisterReceive;
{$IFDEF ANDROID}
var
  I: Integer;
begin
  if FListener = nil then
    FListener := TBroadcastListener.Create(Self);
  if FReceiver = nil then
    FReceiver := TJFMXBroadcastReceiver.JavaClass.init(FListener);
  if FItems <> nil then
    if FItems.Count > 0 then
      for I := 0 to FItems.Count -1 do
        Add(FItems[I]);
{$ELSE}
begin
{$ENDIF}
end;


function TAndroidBroadcastReceiver.Remove(const csValue: String): Integer;
begin
  Result := FItems.IndexOf(csValue);
  if Result > -1 then
    FItems.Delete(Result);
end;


procedure TAndroidBroadcastReceiver.SendBroadcast(csValue: String);
{$IFDEF ANDROID}
var
  Inx: JIntent;
begin
  Inx := TJIntent.Create;
  Inx.setAction(StringToJString(csValue));
  TAndroidHelper.Context.sendBroadcast(Inx);
{$ELSE}
begin
{$ENDIF}
end;


function TAndroidBroadcastReceiver.StringFromByteArray(
  ABytes: System.TArray<System.Byte>): String;
//convert a byte array to string
begin
   Result := TEncoding.ANSI.GetString(ABytes);
end;

{$IFDEF ANDROID}
procedure TAndroidBroadcastReceiver.setResultData(data: JString);
begin
  FReceiver.setResultData(data);
end;
{$ENDIF}


{ TBroadcastListener }

{$IFDEF ANDROID}
constructor TBroadcastListener.Create(AOwner: TAndroidBroadcastReceiver);
begin
  inherited Create;
  FOwner := AOwner;
end;

procedure TBroadcastListener.OnReceive(csContext: JContext; csIntent: JIntent);
begin
  if Assigned(FOwner.OnReceive) then
    FOwner.onReceive(csContext, csIntent);
end;
{$ENDIF}

end.
