unit unit_tabstr_na_onp;


interface

uses unit_rownanie_na_struktury, unit_kolejki_stosy; {* dolacza jednostke z deklaracja typow danych, struktur oraz funkcja zamieniajaca
                                napis na tablice struktur(rozbij_na_str(rownanie, wynik, licznik): Boolean *}


function zamien_na_onp(var tablica_str: tablica; var ile_str: integer):Boolean;



implementation

function porownaj_operatory(op_stos: Struktura; op_tablica: Struktura): integer;
{ funkcja bedzie zwracala roznice w wysokosci proriorytetu operatora na stosie i operatora z tablicy }
        const
                PR_UNARNEGO = 4; { operator unarny ma najwyzszy prorytet i wyznacza rozmiar tablicy }
        var
                priorytety: array[1..PR_UNARNEGO] of string;

                priorytet_stos: integer;
                priorytet_tab:  integer;
                i:              integer; { indeks w tablicy priorytetow, czyli wlasnie priorytet operatora }

        begin
        {* NIESTETY NIE UDALO MI SIE ZAINICJALIZOWAC TABLICY PRIORYTETOW W ZADEN SENSOWNY SPOSOB WIEC
                ROBIE TO RECZNIE *}
        priorytety[1]:='+-';
        priorytety[2]:='*/';
        priorytety[3]:='^';
        priorytety[4]:='unarny'; { w sumie tylko dla zasady, bo unarnosc sprawdza sie poprzez odwolanie
                                   do wlasciwego pola w strukturze }


        priorytet_stos:=0;
        priorytet_tab:=0;

        if op_stos.unarny = True then { jesli operator jest unarny }
                begin
                priorytet_stos:=PR_UNARNEGO;
                end
        else
                begin
                for i:=1 to PR_UNARNEGO do
                        begin
                        if (pos(op_stos.nazwa, priorytety[i]) <> 0) then { jesli operator jest pod danym indeksem }
                                begin
                                priorytet_stos:=i;
                                break;
                                end;
                        end;
                end;

        if op_tablica.unarny = True then { jesli operator jest unarny }
                begin
                priorytet_tab:=PR_UNARNEGO;
                end
        else
                begin

                for i:=1 to PR_UNARNEGO do
                        begin
                        if (pos(op_tablica.nazwa, priorytety[i]) <> 0) then { jesli operator jest pod danym indeksem }
                                begin
                                priorytet_tab:=i;
                                break;
                                end;
                        end;
                end;

        porownaj_operatory:=priorytet_stos - priorytet_tab; { nadanie wartosci funkcji }
        end; { koniec funkcji porownaj_operatory }


function zamien_na_onp(var tablica_str: tablica; var ile_str: integer):Boolean;
        var
                i:              integer;
                poprawna:       Boolean;
                nowe_ile_str:   integer; { za kazdym razem, kiedy dodaje do kolejki doliczam jedna strukture }
                P_kolejki:      ^element_kolejki;
                P_stosu:        ^element_stosu;
                kolejki_temp:   Struktura;
        begin
        poprawna:=True;
        nowe_ile_str:=0;
        P_kolejki:=nil;
        P_stosu:=nil;

        for i:=1 to ile_str do { dla kazdej struktury w tablicy }
                begin
                //WRITELN('TYP SPRAWDZANEGO ELEMENTU TABLICY:', i, TABLICA_STR[I].TYP, TABLICA_STR[I].NAZWA);
                if tablica_str[i].typ = Liczba then { jesli struktura jest liczba to wrzuc ja do kolejki }
                        begin
                        Do_kolejki(P_kolejki, tablica_str[i]);
                        nowe_ile_str:=nowe_ile_str+1;
                        end

                else if tablica_str[i].typ = Zmienna then { jesli struktura jest zmienna to wrzuc ja do kolejki }
                        begin
                        Do_kolejki(P_kolejki, tablica_str[i]);
                        nowe_ile_str:=nowe_ile_str+1;
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
                                                poprawna:=False;
                                                writeln('Blad. Prawdopodobnie jakis prawy nawias nie mial pary.');
                                                nowe_ile_str:=0; { bedzie 0 nowych struktur }
                                                //i:=ile_str+1; { to powinno spowodowac przerwanie zewnetrznej petli for }
                                                READLN(); { TO USUNAC PO DEBUGOWANIU KODU }
                                                exit;
                                                break;        { to powinno spowodowac przerwanie petli while }
                                                end

                                        else if (kolejki_temp.nazwa <> '(') then { jesli jest cos innego niz lewy nawias }
                                                begin
                                                Do_kolejki(P_kolejki, kolejki_temp);
                                                nowe_ile_str:=nowe_ile_str+1;
                                                end

                                        else    {* jesli wczytano '(' to zdejmij nastepny element
                                                    i jesli jest to funkcja to wrzuc go do kolejki wyjsciowej,
                                                    jestli to nie jest funkcja zwroc na stos *}
                                                begin
                                                kolejki_temp:=Ze_stosu(P_stosu);
                                                WRITELN(' WCZYTALEM LEWY NAWIAS I POBIERAM ELEMENT ZE STOSU ');
                                                if (kolejki_temp.typ = Funkcja) then
                                                    begin
                                                    Do_kolejki(P_kolejki, kolejki_temp);
                                                    nowe_ile_str:=nowe_ile_str+1;
                                                    break;
                                                    end
                                                else if (kolejki_temp.typ <> Pusty ) then
                                                    begin
                                                    Na_stos(P_stosu, kolejki_temp);
                                                    break;
                                                    end
                                                else
                                                    begin
                                                    break;
                                                    end;
                                                end;



                                        end;
                                end;
                        end

                else if ( tablica_str[i].typ = Operacja ) then { jesli struktura to operator }
                        {*
                                TA CZESC JEST DO SPRAWDZENIA, CZESCIOWO PRZETESTOWANA, ALE NIE DO KONCA
                        *}
                        begin
                        kolejki_temp:=Ze_stosu(P_stosu); { zdejmij element ze stosu, zeby porownac jego priorytet }
                        if (kolejki_temp.typ <> Operacja)  then { jesli na wierzchu stosu nie ma operatora }
                                begin
                                if (kolejki_temp.typ <> Pusty) then { jesli wczesnie stos nie byl pusty }
                                        begin
                                        Na_stos(P_stosu, kolejki_temp);         { wrzuc to co zdjales wczesniej }
                                        end;
                                Na_stos(P_stosu, tablica_str[i]);       { wrzuc operator ktory wziales z tablicy }

                                end

                        else    { jesli jednak na stosie byl operator, to trzeba sprawdzic jego priorytet itd. }
                                begin
                                while ( kolejki_temp.typ = Operacja) and ( porownaj_operatory(kolejki_temp, tablica_str[i])>=0) do
                                        begin           {* dopoki ze stosu zdejmowany jest
                                                        operator i operator ten ma priorytet wieksz lub rowny
                                                        priorytetowi operatora w z tablicy to wrzucaj operatory
                                                        ze stosu do kolejki *}

                                        Do_kolejki(P_kolejki, kolejki_temp);
                                        nowe_ile_str:=nowe_ile_str+1;
                                        kolejki_temp:=Ze_stosu(P_stosu);
                                        end;
                                { jesli ostatni zdjety ze stosu element nie byl Pusty to trzeba go zwrocic na stos,
                                  a potem wrzucic na stos operator z tablicy }
                                if kolejki_temp.typ <> Pusty then
                                        begin
                                        Na_stos(P_stosu, kolejki_temp);
                                        end;
                                Na_stos(P_stosu, tablica_str[i]);
                                end;

                        end;

                end;
        {*
                KONIEC PETLI FOR, NIE MA WIECEJ ELEMENTOW

                TU TRZEBA PRZERZUCIC POZOSTALE ELEMENTY ZE STOSU DO KOLEJKI A Z KOLEJKI DO TABLICY TABLICA_STR
        *}
        if (poprawna = True ) then { jesli wczesniej nie wystapil zaden blad }
                begin
                kolejki_temp:=Ze_stosu(P_stosu);

                while(kolejki_temp.typ <> Pusty ) do { jest stos nie jest pusty to wrzucaj do kolejki wyjsciowej }
                        begin
                        Do_kolejki(P_kolejki, kolejki_temp);
                        nowe_ile_str:=nowe_ile_str+1;
                        kolejki_temp:=Ze_stosu(P_stosu);
                        end;
                {*
                        TERAZ PRZERZUCAMY Z KOLEJKI DO TABLICY
                *}

                kolejki_temp:=Z_kolejki(P_kolejki);
                i:=0;
                while( kolejki_temp.typ <> Pusty ) do { jesli kolejka nie pusta to zapisz do kolejnego miejsca w tablicy }
                        begin
                        i:=i+1;
                        if kolejki_temp.typ = Nawias then { jesli na koniec zostaly w kolejce jakies nawiasy, }
                                begin                     { to oznacza, ze byly niesparowane, niepoprawne rownanie }
                                writeln('Blad. Znaleziono nawias w kolejce. Prawdopodobnie jakis lewy nawias byl niesparowany.');
                                poprawna:=False;
                                zamien_na_onp:=False;
                                nowe_ile_str:=0;
                                break;
                                end;

                        tablica_str[i]:=kolejki_temp;
                        kolejki_temp:=Z_kolejki(P_kolejki);
                        end;
                if (poprawna = True ) then { jesli nadal wszystko poszlo ok to }
                        begin
                        zamien_na_onp:=True;
                        end;
                end;
        ile_str:=nowe_ile_str; { na koniec zawsze zaktualizuj liczbe struktur, 0 w przypadku bledu }
        end; { koniec funkcji zamien_na_onp }

end.
