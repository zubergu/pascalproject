program odwr_not_pol;

uses rownanie_na_struktury; {* dolacza jednostke z deklaracja typow danych, struktur oraz funkcja zamieniajaca
                                napis na tablice struktur(rozbij_na_str(rownanie, wynik, licznik): Boolean *}


var
    rownanie:       string;
    tablica_str:    tablica;
    ile_str:        integer;

begin
rownanie:='-sin(a+b)';

if (rozbij_na_str(rownanie, tablica_str, ile_str) = True ) then
    begin
    writeln('utworzono ',ile_str,' struktur');
    end
else
    begin
    writeln('Nie udalo sie utworzyc struktur danych');
    end;
end.
