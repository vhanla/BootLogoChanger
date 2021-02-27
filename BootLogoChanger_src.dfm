object Win8BootLogo: TWin8BootLogo
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Boot Logo Changer v1.5 by vhanla | https://apps.codigobit.info'
  ClientHeight = 510
  ClientWidth = 736
  Color = clBtnFace
  DragMode = dmAutomatic
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label2: TLabel
    Left = 8
    Top = 8
    Width = 3
    Height = 13
  end
  object Label5: TLabel
    Left = 148
    Top = 347
    Width = 129
    Height = 13
    Cursor = crHandPoint
    Caption = 'https://apps.codigobit.info'
    OnClick = Label5Click
  end
  object Label6: TLabel
    Left = 8
    Top = 347
    Width = 134
    Height = 13
    Caption = 'For more free software visit'
  end
  object Splitter1: TSplitter
    Left = 0
    Top = 392
    Width = 736
    Height = 5
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 394
  end
  object ImgView321: TImgView32
    Left = 9
    Top = 40
    Width = 343
    Height = 301
    Bitmap.ResamplerClassName = 'TNearestResampler'
    BitmapAlign = baCustom
    Color = clWhite
    ParentColor = False
    Scale = 1.000000000000000000
    ScaleMode = smScale
    ScrollBars.ShowHandleGrip = True
    ScrollBars.Style = rbsDefault
    ScrollBars.Size = 17
    ScrollBars.Visibility = svAuto
    OverSize = 0
    TabOrder = 0
  end
  object Button5: TButton
    Left = 39
    Top = 366
    Width = 73
    Height = 25
    Caption = 'Load Picture'
    TabOrder = 1
    OnClick = Button5Click
  end
  object btnPreview: TButton
    Left = 174
    Top = 366
    Width = 75
    Height = 25
    Hint = 'A simulated preview'
    CustomHint = BalloonHint1
    Caption = 'Preview'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    OnClick = btnPreviewClick
  end
  object btnReload: TButton
    Left = 118
    Top = 366
    Width = 50
    Height = 25
    Caption = 'Reload'
    Enabled = False
    TabOrder = 3
    OnClick = btnReloadClick
  end
  object Button1: TButton
    Left = 8
    Top = 366
    Width = 25
    Height = 25
    Caption = '?'
    TabOrder = 4
    OnClick = Button1Click
  end
  object pages: TPageControl
    Left = 478
    Top = 8
    Width = 239
    Height = 383
    ActivePage = TabSheet1
    TabOrder = 5
    object TabSheet1: TTabSheet
      Caption = 'Bitmaps'
      object Label3: TLabel
        Left = 2
        Top = 8
        Width = 226
        Height = 13
        Caption = 'Original pictures: (double click to see each one)'
      end
      object Label4: TLabel
        Left = 3
        Top = 116
        Width = 75
        Height = 13
        Caption = 'Edited pictures:'
      end
      object Label1: TLabel
        Left = 0
        Top = 258
        Width = 105
        Height = 13
        Caption = 'Backup file not found!'
      end
      object ListBox1: TListBox
        Left = 29
        Top = 27
        Width = 196
        Height = 89
        ItemHeight = 13
        TabOrder = 0
        OnDblClick = ListBox1DblClick
      end
      object ListBox2: TListBox
        Left = 29
        Top = 135
        Width = 196
        Height = 86
        ItemHeight = 13
        TabOrder = 1
        OnDblClick = ListBox2DblClick
      end
      object btnCreatePictures: TButton
        Left = 3
        Top = 135
        Width = 20
        Height = 86
        Hint = 'Generate bitmaps '
        CustomHint = BalloonHint1
        Caption = '>'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 2
        OnClick = btnCreatePicturesClick
      end
      object btnRePack: TButton
        Left = 3
        Top = 227
        Width = 222
        Height = 25
        Hint = 'Update bootres.dll bitmaps in the temporary file'
        CustomHint = BalloonHint1
        Caption = 'Generate bootres.dll'
        ParentShowHint = False
        ShowHint = True
        TabOrder = 3
        OnClick = btnRePackClick
      end
      object btnApply: TButton
        Left = 87
        Top = 327
        Width = 71
        Height = 25
        Hint = 'Replace current bootres.dll with the new one'
        CustomHint = BalloonHint1
        Caption = 'Apply'
        ElevationRequired = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 4
        OnClick = btnApplyClick
      end
      object btnBackupRestore: TButton
        Left = 3
        Top = 327
        Width = 78
        Height = 25
        Hint = 'Backup file is located in windows folder'
        CustomHint = BalloonHint1
        Caption = '&Backup'
        ElevationRequired = True
        ParentShowHint = False
        ShowHint = True
        TabOrder = 5
        OnClick = btnBackupRestoreClick
      end
      object Button8: TButton
        Left = 161
        Top = 327
        Width = 67
        Height = 25
        Caption = 'E&xit'
        TabOrder = 6
        OnClick = btnCancelClick
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Testmode'
      ImageIndex = 1
      object Label7: TLabel
        Left = 3
        Top = 3
        Width = 87
        Height = 13
        Caption = 'Testsigning mode:'
      end
      object Label8: TLabel
        Left = 3
        Top = 50
        Width = 225
        Height = 89
        AutoSize = False
        Caption = 
          'Testsigning mode ON shows a watermark in the right bottom part o' +
          'f your desktop. However,  you can patch "shell32.dll.mui" and "b' +
          'asebrd.dll.mui" files with the following options. You will need ' +
          'to restart explorer after those procedures. '
        WordWrap = True
      end
      object btnTestMode: TButton
        Left = 3
        Top = 19
        Width = 225
        Height = 25
        Caption = 'Turn it ON or OFF'
        TabOrder = 0
        OnClick = btnTestModeClick
      end
      object Button2: TButton
        Left = 3
        Top = 137
        Width = 143
        Height = 25
        Caption = 'Backup shell32.dll.mui'
        ElevationRequired = True
        TabOrder = 1
        OnClick = Button2Click
      end
      object Button3: TButton
        Left = 152
        Top = 137
        Width = 76
        Height = 25
        Caption = 'Patch'
        ElevationRequired = True
        TabOrder = 2
        OnClick = Button3Click
      end
      object Button4: TButton
        Left = 3
        Top = 223
        Width = 143
        Height = 25
        Caption = 'Backup basebrd.dll.mui'
        ElevationRequired = True
        TabOrder = 3
        OnClick = Button4Click
      end
      object Button6: TButton
        Left = 152
        Top = 223
        Width = 76
        Height = 25
        Caption = 'Patch'
        ElevationRequired = True
        TabOrder = 4
        OnClick = Button6Click
      end
      object ListBox3: TListBox
        Left = 3
        Top = 168
        Width = 225
        Height = 57
        ItemHeight = 13
        TabOrder = 5
      end
      object ListBox4: TListBox
        Left = 3
        Top = 248
        Width = 225
        Height = 41
        ItemHeight = 13
        TabOrder = 6
      end
      object Button7: TButton
        Left = 3
        Top = 295
        Width = 225
        Height = 25
        Caption = 'Restart Explorer.exe'
        TabOrder = 7
        OnClick = Button7Click
      end
      object btnCancel: TButton
        Left = 161
        Top = 327
        Width = 67
        Height = 25
        Caption = 'E&xit'
        TabOrder = 8
        OnClick = btnCancelClick
      end
    end
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 397
    Width = 736
    Height = 113
    ActivePage = TabSheet3
    Align = alBottom
    TabOrder = 6
    object TabSheet3: TTabSheet
      Caption = 'System Status'
      object lblOS: TLabel
        Left = 18
        Top = 16
        Width = 90
        Height = 13
        Caption = 'Operating System:'
      end
      object lblBIOS: TLabel
        Left = 18
        Top = 32
        Width = 57
        Height = 13
        Caption = 'BIOS mode:'
      end
      object lblTest: TLabel
        Left = 18
        Top = 48
        Width = 59
        Height = 13
        Caption = 'TestSigning:'
      end
      object lblCurShell: TLabel
        Left = 170
        Top = 32
        Width = 98
        Height = 13
        Caption = 'Current Shell32.mui:'
      end
      object lblBkpShell: TLabel
        Left = 170
        Top = 48
        Width = 95
        Height = 13
        Caption = 'Backup Shell32.mui:'
      end
      object lblBootres: TLabel
        Left = 18
        Top = 64
        Width = 95
        Height = 13
        Caption = 'Current Bootres.dll:'
      end
      object lblBkpBootres: TLabel
        Left = 354
        Top = 64
        Width = 92
        Height = 13
        Caption = 'Backup Bootres.dll:'
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Log Output'
      ImageIndex = 1
      object mmLog: TMemo
        Left = 0
        Top = 0
        Width = 728
        Height = 85
        Align = alClient
        Lines.Strings = (
          'Boot Logo Changer log:'
          ''
          '')
        ReadOnly = True
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object cbVignette: TCheckBox
    Left = 264
    Top = 369
    Width = 97
    Height = 17
    Caption = 'Vignette Effect'
    TabOrder = 7
  end
  object OpenPictureDialog1: TOpenPictureDialog
    Filter = 
      'All (*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.ico;*.emf;*.w' +
      'mf)|*.gif;*.jpg;*.jpeg;*.png;*.bmp;*.tif;*.tiff;*.ico;*.emf;*.wm' +
      'f|GIF Image (*.gif)|*.gif|JPEG Image File (*.jpg)|*.jpg|JPEG Ima' +
      'ge File (*.jpeg)|*.jpeg|Portable Network Graphics (*.png)|*.png|' +
      'Bitmaps (*.bmp)|*.bmp|TIFF Images (*.tif)|*.tif|TIFF Images (*.t' +
      'iff)|*.tiff|Icons (*.ico)|*.ico|Enhanced Metafiles (*.emf)|*.emf' +
      '|Metafiles (*.wmf)|*.wmf'
    Left = 320
    Top = 200
  end
  object DropComboTarget1: TDropComboTarget
    DragTypes = [dtMove]
    OnDrop = DropComboTarget1Drop
    Target = ImgView321
    WinTarget = 0
    Left = 264
    Top = 208
  end
  object BalloonHint1: TBalloonHint
    Style = bhsStandard
    Delay = 75
    Left = 320
    Top = 264
  end
end
