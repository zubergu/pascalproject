{*
        MODUL ZAWIERAJACY IMPLEMENTACJE WSZYSTKICH UZYWANYCH KOLEJEK I STOSOW  PRZY ZAMIANIE NA ONP

        1. KOLEJKA WYJSCIOWA UZYWANA PRZY ZAMIANIE TABLICY STRUKTUR NA ONP
        2. KOPIEC UZYWANY PRZY ZAMIANIE TABLICY STRUKTUR NA ONP

*}


unit unit_kolejki_stosy;



interface

uses unit_rownanie_na_struktury;

type
        Twsk_elstosu =  ^element_stosu;
        Twsk_elkolejki = ^element_kolejki;

        element_stosu = record              { typ elementow kolejki i kopca do przetwarzania na onp }
                informacje:Struktura;
                next: ^element_stosu;
                end;


        element_kolejki = element_stosu;

procedure Na_stos(var P_stosu:Twsk_elstosu; element: Struktura);
function Ze_stosu(var P_stosu: ^element_stosu): Struktura;
procedure Do_kolejki(var P_kolejki: ^element_kolejki; element: Struktura);
function  Z_kolejki(var P_kolejki: ^element_kolejki): Struktura;

implementation

procedure Na_stos(var P_stosu: ^element_stosu; element: Struktura);
        var
                temp: ^element_stosu;

        begin
            New(temp);
            temp^.informacje:= element;
            temp^.next:= P_stosu;

            P_stosu:=temp;
        end;

function Ze_stosu(var P_stosu: ^element_stosu): Struktura;
        var
                temp:^element_stosu;
                el_temp: Struktura;

        begin

                if (P_stosu = nil) then
                        begin
                        Ze_stosu:=nil;
                        end

                else
                        begin
                        el_temp:= P_stosu^.informacje;
                        temp:=P_stosu;
                        P_stosu:=P_stosu^.next;

                        Dispose(temp);
                        Ze_stosu:=el_temp;
                        end;
        end;

procedure Do_kolejki(var P_kolejki: ^element_kolejki; element: Struktura);
        var
                temp: ^element_kolejki;
                ostatni: ^element_kolejki;

        begin

                New(temp);
                temp^.informacje:=element;
                temp^.next:=nil;

                if (P_kolejki = nil) then { jesli dodajemy do pustej kolejki }
                        begin
                        P_kolejki:=temp;
                        end
                else
                        begin
                        ostatni:=P_kolejki;

                        while (ostatni^.next <> nil ) do { dopoki nie mamy wskaznika na ostatni element w liscie }
                                begin
                                ostatni:=ostatni^.next;
                                end;
                        ostatni^.next:= temp;
                        end;

        end;


function Z_kolejki(var P_kolejki: ^element_kolejki): Struktura;
        var
                temp_el: Struktura;
                temp:    ^element_kolejki;

        begin
                if (P_kolejki = nil ) then { jesli kolejka jest pusta }
                        begin
                        Z_kolejki:=nil;
                        end

                else
                        begin
                        temp_el:=P_kolejki^.informacje;
                        temp:=P_kolejki;
                        P_kolejki:=P_kolejki^.next;
                        Dispose(temp);

                        Z_kolejki:=temp_el;
                        end;
        end;

end.


