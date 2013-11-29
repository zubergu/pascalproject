program klasy_i_drzewo;

uses heaptrc,sysutils, unit_rownanie_na_struktury, unit_tabstr_na_onp, unit_kolejki_stosy;


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

        constructor init(nazwa:string; typ:Typy; unarny: Boolean; lewy_operand: TWsk_na_wezel; prawy_operand: TWsk_na_wezel);
        function    wartosc : real;


        end;

        constructor wezel_drzewa.init(nazwa: string; typ: Typy; unarny: Boolean; lewy_operand: TWsk_na_wezel; prawy_operand: Twsk_na_wezel);
            {* konstruktor dla obiektu przechowujacego informacje ze struktury
                oraz zaleznosc pomiedzy tworzonym obiektem oraz pozostalymi obiektami *}
            begin

            self.nazwa:=nazwa;
            self.typ:= typ;
            self.unarny:= unarny;
            self.lewy_operand:=nil;
            self.prawy_operand:=nil;
            end;

        function wezel_drzewa.wartosc;
            var
                wartosc_zmiennej: integer;

            begin

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





procedure stworz_obiekt(var P_stosu_obiektow: TWsk_na_elstosu; element_tablicy);
    var
        temp: TWsk_na_wezel;



begin
writeln('czy dziala');

end.
