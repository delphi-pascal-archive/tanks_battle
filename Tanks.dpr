program Tanks;

uses
  Forms,
  uTrajectoire in 'uTrajectoire.pas' {Form1},
  XPTheme in '.\XPTheme.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
