program odwr_not_pol;

uses unit_rownanie_na_struktury, unit_kolejki_stosy; {* dolacza jednostke z deklaracja typow danych, struktur oraz funkcja zamieniajaca
                                napis na tablice struktur(rozbij_na_str(rownanie, wynik, licznik): Boolean *}


var
    rownanie:       string;
    tablica_str:    tablica;
    ile_str:        integer;
    stan:           Boolean;

    P_kolejki: ^element_kolejki;   { glowa kolejki }
    P_stosu:   ^element_stosu;     { glowa kopca }

    i:integer;
    kolejki_temp: Struktura;

function zamien_na_onp(var tablica_str: tablica; ile_str: integer):Boolean;
        var i:integer;
        begin
        for i:=1 to ile_str do { dla kazdej struktury w tablicy }
                begin
                if tablica_str[i].typ = Liczba then { jesli struktura jest liczba to wrzuc ja do kolejki }
                        begin
                        Do_kolejki(P_kolejki, tablica_str[i]);
                        end

                else if tablica_str[i].typ = Zmienna then { jesli struktura jest zmienna to wrzuc ja do kolejki }
                        begin
                        Do_kolejki(P_kolejki, tablica_str[i]);
                        end

                else if tablica_str[i].typ = Funkcja then { jesli struktura jest funkcja to wrzuc ja na stos }
                        begin
                        Na_stos(P_stosu, tablica_str[i]);
                        end

                else if tablica_str[i].typ = Nawias then { jesli struktura jest nawias to sprawdz czy lewy czy prawy }
                        begin
                        if tablica_str[i].nazwa = '(' then { lewy nawias wrzuc na stos }
                                begin
                                Na_stos(P_stosu, tablica_str[i]);
                                end
                        else   {* jesli nawias jest prawy to sciagaj ze stosu az do znalezienia lewego
                                 i przenos elementy do kolejki wyjsciowej *}
                                begin
                                while (True) do
                                        begin
                                        kolejki_temp:=Ze_stosu(P_stosu);

                                        if (kolejki_temp.typ = Pusty) then { jesli kolejka jest pusta to przerwij dzialanie}
                                                begin                     { bo rownanie jest niepoprawne }
                                                zamien_na_onp:=False;
                                                i:=ile_str+1; { to powinno spowodowac przerwanie zewnetrznej petli for }
                                                break;        { to powinno spowodowac przerwanie petli while }
                                                end

                                        else if (kolejki_temp.nazwa <> '(') then { jesli jest cos innego niz lewy nawias }
                                                begin
                                                Do_kolejki(P_kolejki, kolejki_temp);
                                                end

                                        else    { jesli wczytano '(' przerwij dzialanie petli }
                                                break;

                                        end;
                                end;
                        end

                else if ( tablica_str[i].typ = Operacja ) then { jesli struktura to operator }
                        begin



begin
rownanie:='-sin(a+b)';

stan:=rozbij_na_str(rownanie, tablica_str, ile_str);
stan:=zamien_na_onp(tablica_str, ile_str);

for i:=1 to ile_str do
        begin
        writeln('El.',i);
        writeln('Nazwa: ',tablica_str[i].nazwa);
        writeln('Typ: ', tablica_str[i].typ,' unarny?: ', tablica_str[i].unarny);
        end;

end.
