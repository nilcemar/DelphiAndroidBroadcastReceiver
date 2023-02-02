unit HeaderFooterTemplate;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  batBroadcastReceiver, FMX.Controls.Presentation, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo
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
  THeaderFooterForm = class(TForm)
    Header: TToolBar;
    Footer: TToolBar;
    HeaderLabel: TLabel;
    BroadcastReceiver1: TAndroidBroadcastReceiver;
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure BroadcastReceiver1Receive(csContext: JContext; csIntent: JIntent);
  private
    { Private declarations }
  public
    { Public declarations }
    function getStringFromByteArray(ABytes: System.TArray<System.Byte> ): String;
  end;

var
  HeaderFooterForm: THeaderFooterForm;

implementation

{$R *.fmx}

procedure THeaderFooterForm.BroadcastReceiver1Receive(csContext: JContext;
  csIntent: JIntent);

var
  barocode: System.TArray<System.Byte>;
  barcodeStr: String;
  barocodeLen: Integer;
begin
  //Receive the message from listener
  //You can catch message string with csIntent.getAction
  //You can catch message data with, form example: csIntent.getByteArrayExtra('name');
  //in this example we receive a message from Barcode Scanner

  if JStringToString(csIntent.getAction).Equals('scan.rcv.message') then
  begin
    barocode:= TAndroidHelper.TJavaArrayToTBytes(csIntent.getByteArrayExtra(StringToJString('barocode')));
    barocodeLen:= csIntent.getIntExtra(StringToJString('length'),0);
    barcodeStr:= getStringFromByteArray(barocode);
    Memo1.Lines.Add(barcodeStr);

  end;


  Memo1.Lines.Add('Message: '+JStringToString(csIntent.getAction));
  Memo1.Lines.Add('-----------------------------------------');
end;

procedure THeaderFooterForm.Button1Click(Sender: TObject);
begin
  BroadcastReceiver1.RegisterReceive;
  BroadcastReceiver1.Add('scan.rcv.message');

end;

function THeaderFooterForm.getStringFromByteArray(
  ABytes: System.TArray<System.Byte>): String;
  //convert a byte array to string
begin
   Result := TEncoding.ANSI.GetString(ABytes);
end;


end.
