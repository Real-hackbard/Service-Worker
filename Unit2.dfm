object Form2: TForm2
  Left = 1696
  Top = 196
  BorderStyle = bsDialog
  Caption = 'Install Service'
  ClientHeight = 218
  ClientWidth = 449
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
    Width = 433
    Height = 153
    Caption = ' Service '
    TabOrder = 0
    object Label1: TLabel
      Left = 62
      Top = 26
      Width = 28
      Height = 13
      Caption = 'User :'
    end
    object Label2: TLabel
      Left = 17
      Top = 58
      Width = 73
      Height = 13
      Caption = 'Service Name :'
    end
    object Label3: TLabel
      Left = 18
      Top = 90
      Width = 71
      Height = 13
      Caption = 'Display Name :'
    end
    object Label4: TLabel
      Left = 41
      Top = 122
      Width = 47
      Height = 13
      Caption = 'File Path :'
    end
    object Edit1: TEdit
      Left = 96
      Top = 24
      Width = 297
      Height = 21
      TabStop = False
      Color = clBtnFace
      Enabled = False
      ReadOnly = True
      TabOrder = 0
    end
    object Edit2: TEdit
      Left = 96
      Top = 56
      Width = 297
      Height = 21
      TabStop = False
      TabOrder = 1
    end
    object Edit3: TEdit
      Left = 96
      Top = 88
      Width = 297
      Height = 21
      TabStop = False
      TabOrder = 2
    end
    object Edit4: TEdit
      Left = 96
      Top = 120
      Width = 297
      Height = 21
      TabStop = False
      TabOrder = 3
      Text = 'C:\Users\T3st3r\Desktop\Project1.exe'
    end
    object Button3: TButton
      Left = 400
      Top = 120
      Width = 25
      Height = 22
      Caption = '...'
      TabOrder = 4
      TabStop = False
      OnClick = Button3Click
    end
  end
  object Button1: TButton
    Left = 280
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Install'
    TabOrder = 1
    TabStop = False
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 360
    Top = 168
    Width = 75
    Height = 25
    Caption = 'Cancel'
    TabOrder = 2
    TabStop = False
    OnClick = Button2Click
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 199
    Width = 449
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
  object OpenDialog1: TOpenDialog
    Filter = 'Executable (*.EXE)|*.exe'
    Left = 128
    Top = 40
  end
end
