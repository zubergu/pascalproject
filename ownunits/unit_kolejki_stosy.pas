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
function Ze_stosu(var P_stosu: Twsk_elstosu): Struktura;
procedure Do_kolejki(var P_kolejki: Twsk_elkolejki; element: Struktura);
function  Z_kolejki(var P_kolejki: Twsk_elkolejki): Struktura;

implementation

procedure Na_stos(var P_stosu: Twsk_elstosu; element: Struktura);
        var
                temp: Twsk_elstosu;

        begin
            New(temp);
            temp^.informacje:= element;
            temp^.next:= P_stosu;

            P_stosu:=temp;
        end;

function Ze_stosu(var P_stosu: Twsk_elstosu): Struktura;
        var
                temp:Twsk_elstosu;
                el_temp: Struktura;

        begin
                el_temp.nazwa:='';
                el_temp.typ:=Pusty;
                el_temp.unarny:=False;

                if (P_stosu = nil) then
                        begin
                        Ze_stosu:=el_temp; {* jesli stos jest pusty to zwroci strukture bez nazwy, nieunarna,
                                                o typie Pusty! *}
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

procedure Do_kolejki(var P_kolejki: Twsk_elkolejki; element: Struktura);
        var
                temp: Twsk_elkolejki;
                ostatni: Twsk_elkolejki;

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


function Z_kolejki(var P_kolejki: Twsk_elkolejki): Struktura;
        var
                el_temp: Struktura;
                temp:    Twsk_elkolejki;

        begin
                el_temp.nazwa:='';
                el_temp.typ:=Pusty;
                el_temp.unarny:=False;

                if (P_kolejki = nil ) then { jesli kolejka jest pusta }
                        begin
                        Z_kolejki:=el_temp;
                        end

                else
                        begin
                        el_temp:=P_kolejki^.informacje;
                        temp:=P_kolejki;
                        P_kolejki:=P_kolejki^.next;
                        Dispose(temp);

                        Z_kolejki:=el_temp;
                        end;
        end;

end.


