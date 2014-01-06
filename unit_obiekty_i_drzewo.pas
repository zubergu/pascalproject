unit unit_obiekty_i_drzewo;

interface

uses math,sysutils, unit_rownanie_na_struktury, unit_tabstr_na_onp, unit_kolejki_stosy;




type


    TWsk_na_wezel = ^wezel_drzewa;
    TWsk_na_elstosu = ^element_stosu_obiektow;

    element_stosu_obiektow = record
        adres_wezla: TWsk_na_wezel;
        next: TWsk_na_elstosu;
        end;







    { POCZATEK definicji obiektu wezel_drzewa }
    wezel_drzewa = object
        nazwa:          string;
        typ:            Typy;
        unarny:         Boolean;
        lewy_operand:   TWsk_na_wezel;
        prawy_operand:  Twsk_na_wezel;

        constructor init(nazwa1:string; typ1:Typy; unarny1: Boolean; lewy_operand1: TWsk_na_wezel; prawy_operand1: TWsk_na_wezel);
        function    wartosc : real;


        end;

function oblicz_rownanie(var root:TWsk_na_wezel; var rownanie:string; var tablica_struktur:tablica; var liczba_struktur:integer; var stan_programu:Boolean):real;

implementation

        constructor wezel_drzewa.init(nazwa1: string; typ1: Typy; unarny1: Boolean; lewy_operand1: TWsk_na_wezel; prawy_operand1: Twsk_na_wezel);
            {* konstruktor dla obiektu przechowujacego informacje ze struktury
                oraz zaleznosc pomiedzy tworzonym obiektem oraz pozostalymi obiektami *}
            begin

            self.nazwa:=nazwa1;
            self.typ:= typ1;
            self.unarny:= unarny1;
            self.lewy_operand:=lewy_operand1;
            self.prawy_operand:=prawy_operand1;
            end;

        function wezel_drzewa.wartosc:real;
            var
                wartosc_zmiennej: integer;

            begin
            WRITELN('LICZE ', SELF.NAZWA);
            if (self.typ = Liczba) then { jesli obiekt jest liczba }
                begin
                wartosc := StrToInt(self.nazwa);
                end

            else if (self.typ = Zmienna) then { jesli obiekt jest zmienna }
                begin
                writeln('Podaj wartosc calkowita zmiennej: ',self.nazwa);
                readln(wartosc_zmiennej);
                wartosc:=wartosc_zmiennej;
                end

            else if (self.typ = Operacja ) then { jesli obiekt jest operatorem }
                begin
                if (self.nazwa = '+') then
                    begin
                    wartosc := lewy_operand^.wartosc + prawy_operand^.wartosc ;
                    end
                else if (self.nazwa = '*') then
                    begin
                    wartosc := lewy_operand^.wartosc * prawy_operand^.wartosc;
                    end

                else if (self.nazwa = '/' ) then
                    begin
                    wartosc := lewy_operand^.wartosc / prawy_operand^.wartosc;
                    end

                else if (self.nazwa = '-' ) then
                    begin

                    if (self.unarny = True ) then
                        begin
                        wartosc := -lewy_operand^.wartosc;
                        end

                    else
                        begin
                        wartosc := lewy_operand^.wartosc - prawy_operand^.wartosc;
                        end;
                    end;
                end

            else if (self.typ = Funkcja) then { jesli obiekt jest funkcja }
                begin
                if (self.nazwa = 'sin' ) then
                    begin
                    wartosc := sin(lewy_operand^.wartosc);
                    end
                else if (self.nazwa = 'cos' ) then
                    begin
                    wartosc := cos(lewy_operand^.wartosc);
                    end
                else if (self.nazwa = 'tg' ) then
                    begin
                    wartosc := tan(lewy_operand^.wartosc);
                    end
                else if ( self.nazwa = 'ctg' ) then
                    begin
                    wartosc := cotan(lewy_operand^.wartosc);
                    end;
                end;
            end; { koniec funkcji self.wartosc dla wezla drzewa }



procedure Na_stos_obiektow(var P_stosu_obiektow: TWsk_na_elstosu; adres_obiektu: TWsk_na_wezel);
    var
        temp: TWsk_na_elstosu;

    begin
    New(temp);

    temp^.adres_wezla := adres_obiektu;
    temp^.next := P_stosu_obiektow;
    P_stosu_obiektow:=temp;
    end;

function Ze_stosu_obiektow(var P_stosu_obiektow: TWsk_na_elstosu): TWsk_na_wezel;
        var
                temp:       TWsk_na_elstosu;
                el_temp:    TWsk_na_wezel;

        begin

            if (P_stosu_obiektow = nil) then
                begin
                Ze_stosu_obiektow:=nil; {* jesli stos jest pusty to zwroci nil *}
                end

            else
                begin
                el_temp:= P_stosu_obiektow^.adres_wezla;
                temp:=P_stosu_obiektow;
                P_stosu_obiektow:=P_stosu_obiektow^.next;

                Dispose(temp);
                Ze_stosu_obiektow := el_temp; { zwroci adres wezla z elementu na szczycie stosu }
                end;
        end;





function stworz_obiekt(var P_stosu_obiektow: TWsk_na_elstosu; element_tablicy:Struktura): Boolean;
    var
        temp:       TWsk_na_wezel;
        Lewy:       TWsk_na_wezel;
        Prawy:      TWsk_na_wezel;
        poprawne:   Boolean;

    begin
    poprawne:=True;

    if ( element_tablicy.typ = Funkcja ) then   { jesli tworzymy obiekt funkcja }
        begin
        { lewy operand pobieramy ze stosu }
        Lewy:= Ze_stosu_obiektow(P_stosu_obiektow);
        Prawy:=nil;
        if (Prawy = nil) and (Lewy = nil) then { jesli po zakonczeniu obydwa sa nil to znaczy, ze cos poszlo nie tak }
            begin
            WRITELN(' NIEPRAWIDLOWE POWIAZANIE OBIEKTU. PRAWDOPODOBNIE STOS BYL PUSTY ');
            stworz_obiekt:=False;
            poprawne:=False;
            end;
        end
    else if ( element_tablicy.typ = Operacja ) then { jesti tworzymy obiekt operatora }
        begin
        if (element_tablicy.unarny = False) then
            begin
            Prawy:=Ze_stosu_obiektow(P_stosu_obiektow);
            if (Prawy = nil ) then
                begin
                WRITELN(' NIE UDALO SIE POBRAC ADRESU OBIEKTU ZE STOSU ');
                stworz_obiekt:=False;
                poprawne:=False;
                end;
            end
        else
            begin
            Prawy:=nil;
            end;
        Lewy:= Ze_stosu_obiektow(P_stosu_obiektow);
        if (Lewy = nil ) then
            begin
            WRITELN(' NIE UDALO SIE POBRAC ADRESU OBIEKTU ZE STOSU ');
            stworz_obiekt:=False;
            end;

        end
    else if ( element_tablicy.typ = Liczba ) then { jesli tworzymy obkiekt liczba }
        begin
        Prawy:=nil;
        Lewy:=nil;
        end
    else if ( element_tablicy.typ = Zmienna ) then {jesli tworzymy obiekt zmienna }
        begin

        if (pos(element_tablicy.nazwa[1], litery) = 0 ) then { jesli pierwszy znak nazwy nie jest litera }
            begin
            writeln('Nazwa zmiennej MUSI zaczynac sie od litery.');
            exit();
            end;
        Prawy:=nil;
        Lewy:=nil;
        end;

    if ( poprawne = True ) then { jesli wczesniej nie wystapil blad przy zdejmowaniu adresow ze stosu }
        begin
        New(temp, init(element_tablicy.nazwa, element_tablicy.typ, element_tablicy.unarny, Lewy, Prawy));
        { po stworzeniu obiektu wrzucamy jego adres na stos obiektow }
        Na_stos_obiektow(P_stosu_obiektow,temp);
        stworz_obiekt:=True;
        end;


    end; { koniec funkcji stworz_obiekt }


    {* FUNKCJA TWORZACA DRZEWO NA PODSTAWIE TABLICY STRUKTUR, ROOT DRZEWA POWINIEN POCHODZIC Z ZEWNATRZ FUNKCJI *}


function stworz_drzewo(var root: TWsk_na_wezel; tablica_onp: tablica; liczba_str: integer): Boolean;
    var
        P_stosu_obiektow: TWsk_na_elstosu;
        i:                integer;
        stan:             Boolean;

    begin
    stan:=True;
    P_stosu_obiektow:=nil;

    for i:=1 to liczba_str do { dla kazdej struktury w tablicy_onp }
        begin
        stan:=stworz_obiekt(P_stosu_obiektow, tablica_onp[i]);
        if stan=False then { jesli nie udalo sie stworzyc obiektu }
            begin
            WRITELN(' COS zawiodlo w funkcji stworz_drzewo ');
            break;
            end;
        end;

    if (stan = False ) then
        begin
        stan:=False;
        end;

    if ( stan = True ) then {*   jesli stworzono poprawnie wszystkie struktury to zmien roota drzewa poprzez zdjecie
                                ostatniego elementu stosu,
                                jesli po zmianie roota stos nie jest pusty, to mamy blad *}
        begin
        root:= Ze_stosu_obiektow(P_stosu_obiektow);
        end;


     if (root = nil ) then { jesli na koniec root jest rowny nil to cos poszlo nie tak, stos byl pusty? *}
        begin
        WRITELN('BLAD. Prawdopodobnie stos byl pusty, bo root jest nadal rowny nil( albo nie podano puste rownanie.');
        stan:=False;
        end;

     if ( Ze_stosu_obiektow(P_stosu_obiektow) <> nil) then { jesli cos zostalo jeszcze na stosie to uwolnij pamiec i wywal blad }
        begin
        while(Ze_stosu_obiektow(P_stosu_obiektow)<>nil) do
            continue;
        WRITELN(' STOS NIE BYL PUSTY PO ZAKONCZENIU TWORZENIA DRZEWA. PRAWDOPODOBNIE ZLE ROWNANIE WEJSCIOWE');
        stan:=False;
        end;

     stworz_drzewo:=stan;

     end;



function oblicz_rownanie(var root:TWsk_na_wezel; var rownanie:string; var tablica_struktur:tablica; var liczba_struktur:integer;var stan_programu:Boolean):real;

begin
stan_programu:= True;
liczba_struktur:=0;

stan_programu:= rozbij_na_str(rownanie, tablica_struktur, liczba_struktur);
if(stan_programu = False) then
    begin
    writeln('Blad rozbij_na_str');
    exit;
    end;

stan_programu:= zamien_na_onp(tablica_struktur, liczba_struktur);
if(stan_programu = False) then
    begin
    writeln('Blad zamiany na onp');
    exit;
    end;

stan_programu:= stworz_drzewo(root, tablica_struktur, liczba_struktur);
if(stan_programu = False) then
    begin
    writeln('Blad tworzenia drzewa');
    exit;
    end;

oblicz_rownanie:= root^.wartosc;
end; { koniec funkcji oblicz_wartosc }

end.












