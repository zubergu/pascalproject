program odwr_not_pol;

uses heaptrc,unit_rownanie_na_struktury, unit_kolejki_stosy, unit_tabstr_na_onp; {* dolacza jednostke z deklaracja typow danych, struktur oraz funkcja zamieniajaca
                                napis na tablice struktur(rozbij_na_str(rownanie, wynik, licznik): Boolean *}


var
    rownanie:       string;
    tablica_str:    tablica;
    ile_str:        integer;
    stan:           Boolean;
    i:              integer;

begin
rownanie:='sin(x+y)-z';

stan:=rozbij_na_str(rownanie, tablica_str, ile_str);
stan:=zamien_na_onp(tablica_str, ile_str);

if stan = True then
        begin
        for i:=1 to ile_str do
                begin
                writeln('El.',i);
                writeln('Nazwa: ',tablica_str[i].nazwa);
                writeln('Typ: ', tablica_str[i].typ,' unarny?: ', tablica_str[i].unarny);
                end;
        end
else
        writeln('cos poszlo nie tak jak powinno. Linijke wyzej powinno byc napisane co. ^^^');
end.
