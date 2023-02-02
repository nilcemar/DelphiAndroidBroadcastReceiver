#Delphi TBroadcastReceiver Component

 🇺🇸 - A Delphi component for send and receive Android Intent Broadcast messages, for you can easy integrate your applications with devices native SDK.
 
 🇧🇷 - Um componente Delphi para enviar e receber mensagens Android Intent Broadcast, para que você possa integrar facilmente seus aplicativos com SDK nativos de dispositivos.

## Installation

1)Install DPK in your Delphi
2)Add the paths to your source path in Delphi


## Usage

- 1) Put component in your project
- 2) Initialize the receiver with method "RegisterReceive":

```delphi
BroadcastReceiver1.RegisterReceive;
```

- 2) Add the broadcasts message(s) that you want to monitor

```delphi
BroadcastReceiver1.Add('scan.rcv.message'); //monitor messages from a intent sending of a barcode scan SDK
```

- 3) When a message is received, you can interact via OnReceive event

```delphi
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
    barcodeStr:= BroadcastReceiver1.getStringFromByteArray(barocode); //convert a byte array to string
    Memo1.Lines.Add(barcodeStr);
  end;
end;
```

- You can delete one or more messages from listener with "Delete" method 


## Contribute

We would ❤️ to see your contribution!

## Donate
Did you like this plugin? Give me a coffee 😍 Gostou do componente? Me pague um café clicando no link abaixo:
https://www.paypal.com/donate/?hosted_button_id=C7W7WEY2HXEHU

## About

Created by Nilcemar Ferreira - .BAT Tecnologia
Made in Brazil 🇧🇷

instagram: @battecnologia
site: https://www.battecnologia.com
blog: nilcemar.blogspot.com
