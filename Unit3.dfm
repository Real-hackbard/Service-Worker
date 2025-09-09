object Form3: TForm3
  Left = 1603
  Top = 263
  BorderStyle = bsDialog
  Caption = 'Uninstall Service'
  ClientHeight = 250
  ClientWidth = 395
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 377
    Height = 177
    Caption = 'Service Name :'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 43
      Width = 73
      Height = 13
      Caption = 'Service Name :'
    end
    object Label2: TLabel
      Left = 96
      Top = 72
      Width = 198
      Height = 13
      Caption = 'The Service Name must be entered here ,'
    end
    object Label3: TLabel
      Left = 96
      Top = 88
      Width = 238
      Height = 13
      Caption = 'and not the Display Name to uninstall the Service..'
    end
    object Edit1: TEdit
      Left = 96
      Top = 40
      Width = 273
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 0
    end
    object RadioButton1: TRadioButton
      Left = 96
      Top = 120
      Width = 65
      Height = 17
      Caption = 'Selected'
      Checked = True
      TabOrder = 1
      TabStop = True
      OnClick = RadioButton1Click
    end
    object RadioButton2: TRadioButton
      Left = 96
      Top = 144
      Width = 89
      Height = 17
      Caption = 'Other Service'
      TabOrder = 2
      OnClick = RadioButton2Click
    end
  end
  object Button1: TButton
    Left = 216
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Uninstall'
    TabOrder = 1
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 304
    Top = 200
    Width = 75
    Height = 25
    Caption = 'Close'
    TabOrder = 2
    TabStop = False
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 231
    Width = 395
    Height = 19
    Panels = <
      item
        Text = 'Status :'
        Width = 50
      end
      item
        Text = 'ready.'
        Width = 50
      end>
  end
end
