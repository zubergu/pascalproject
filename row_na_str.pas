program rownanie_na_struktury;


const

    cyfry = '0123456789';         { zestaw wszystkich cyfr }
    litery = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; { zestaw wszystkich liter }
    operatory = '+-/*';             { zestaw wszystkich operatorow }
    nawiasy = '()';                 { zestaw wszystkich rozpoznawanych nawiasow }
    funkcje = 'sin,cos,tg,ctg';                   { zestaw wszystkich rozpoznawanych funkcji,
                                                    TU POWINNA BYC RACZEJ TABLICA NAPISOW }

type
    Typy = (Zmienna, Liczba, Funkcja, Operacja, Nawias, Pusty);       {* Definicja typu  wyliczeniowego
                                                                      do przechowywania informacji
                                                                    o typie struktury badz obiektu *}


    Struktura = record
        nazwa:string;
        typ: Typy;
        unarny: Boolean;
        end;

    tablica = array[1..255] of Struktura;         {* tablica maksymalnie 255 struktur odpowiadajacych elementow
                                                    rownania wejsciowego *}

var
    rownanie:string;
    rozbite: tablica;
    liczba_str: integer;





function typ_elementu(tymczasowy:string):Typy;
    var
        czy_ustalony: Boolean;
        czy_liczba:   Boolean;
        czy_funkcja:  Boolean;
        dlugosc:      integer;
        i:            integer;
    begin

    czy_ustalony:=False;
    czy_liczba:= True;


    i:=1;
    dlugosc:=length(tymczasowy);

    if ( dlugosc = 0 ) then { jesli tymczasowy jest pusty }
        begin
        typ_elementu:=Pusty;
        czy_ustalony:=True;
        end
    else if (pos(tymczasowy, operatory)<>0) then { jesli tymczasowy jest wsrod operatorow }
        begin
        typ_elementu:=Operacja;
        czy_ustalony:=True;
        end
    else if (pos(tymczasowy, nawiasy) <> 0) then { jesli tymczasowy jest nawiasem }
        begin
        typ_elementu:=Nawias;
        czy_ustalony:=True;
        end;

    if (czy_ustalony = False ) then
        begin
        for i:=1 to dlugosc do
            begin
            if (pos(tymczasowy[i], cyfry) = 0) then { jesli ktorykolwiek ze znakow nie jest cyfra }
                begin
                czy_liczba:=False;
                break;
                end;
            end;
        if (czy_liczba = True ) then { jesli wszedzie byly cyfry to jest to liczba }
            begin
            typ_elementu:=Liczba;
            czy_ustalony:=True;
            end;
        end;

    if (czy_ustalony = False ) then  {* funkcja jest jako pusty napis a zapewne bedzie jako tablica napisow, dlatego tutaj
                                        bedzie petla sprawdzajaca czy mamy do czynienia z funkcja, bo inaczej czesciowa
                                        nazwa funkcji moglaby byc odebrana jako funkcja np "si" przy przeszukiwaniu
                                        zostalaby potraktowana jako "sin" *}
        begin
        if (pos(tymczasowy, funkcje) <> 0) then
            begin
            typ_elementu:=Funkcja;
            czy_ustalony:=True;
            end;
        end;

    if (czy_ustalony = False ) then { jesli nie jest Pusty,Liczba, Operator, Nawias, Funkcja, to jest ZMIENNA }
        begin
        typ_elementu:=Zmienna;
        czy_ustalony:=True;
        end;

    WRITELN(' TYMCZASOWY: ',TYMCZASOWY,' ROZPOZNALEM JAKO TYP: ', TYP_ELEMENTU);
    end; { koniec funkcji typ_tymczasowego }




procedure stworz_strukture(tymczasowy: string; czy_unarny: Boolean; var wynik: tablica; var licznik_str:integer);
    begin
    licznik_str:=licznik_str+1;

    WRITELN(' STWORZ STRUKTURE WEWN. ');

    wynik[licznik_str].nazwa:=tymczasowy;
    wynik[licznik_str].typ := typ_elementu(tymczasowy);
    wynik[licznik_str].unarny:= czy_unarny;

    if wynik[licznik_str].typ = Funkcja then     { *jesli element jest funkcja, to jest z natury unarny, to moze miec
                                                    pozniejsze znaczenie *}
        begin
        wynik[licznik_str].unarny:=True;
        end;
    end;





function rozbij_na_str(r_wej:string; var wynik: tablica; var licznik_str:integer): Boolean;
    var
        tymczasowy:  string;
        dlugosc:     integer;
        i:           integer;
        nowy_el:     Boolean;
        unarny:      Boolean;
    begin

    dlugosc:=length(r_wej);
    nowy_el:=True;
    unarny:=False;
    licznik_str:=0;

    for i:=1 to dlugosc do { czytaj znak po znaku }
        begin
        if(nowy_el = True) then { jesli wczytywany jest nowy element }
            begin
            tymczasowy:='';
            unarny:=False;
            nowy_el:=False;
            end;
        if ( pos(r_wej[i],(nawiasy+operatory))<>0 ) then { jesli wczytano nawias lub operator }
            begin
            { utworz strukture na podstawie tymczasowego }
            if (typ_elementu(tymczasowy) <> Pusty ) then { jesli tymczasowy napis nie jest jeszcze pusty }
                begin
                stworz_strukture(tymczasowy,unarny, wynik, licznik_str); { stworz strukture dla tymczasowego }
                end;
            if (r_wej[i] = '-') then  {* jesli wczytano operator '-' to sprawdz czy jest unarny czy tez nie *}
                begin
                if ((typ_elementu(tymczasowy)<>Zmienna) and (typ_elementu(tymczasowy)<>Liczba)) then
                    begin
                    unarny:=True;
                    end;
                if (i-1>0) then   { jesli '-' nie jest pierwszy w tablicy,
                                    to jesli przed nim jest ')' to'-' NIE jest unarny }
                    begin
                    if (r_wej[i-1] = ')') then
                        begin
                        unarny:=False;
                        end;
                    end;
                end;
            stworz_strukture(r_wej[i], unarny, wynik, licznik_str);      { stworz strukture dla wczytanego op. lub naw }
            nowy_el:=True;
            tymczasowy:=''; { zeruje tymczasowy po kazdym operatorze, bo jesli operator jest na koncu rownania to
                                zostaje tam poprzednio wczytana liczba na koniec petli }
            end

        else if (pos(r_wej[i], (litery+cyfry)) <> 0) then  { jesli wczytano litere lub cyfre to dopisz do tymcz. }
            begin
            tymczasowy:=tymczasowy+r_wej[i]
            end

        else if (r_wej[i] = ' ') then          { pomijaj wszystkie spacje }
            continue

        else    {* jesli nie wczytano litery, cyfry, nawiasu, operatora ani spacji to prerwij i zwroc blad *}
            begin
            writeln('Nierozpoznawalne znaki w rownaniu!');
            rozbij_na_str:=False;
            break;
            end;


        end;

    if (typ_elementu(tymczasowy) <> Pusty ) then { jesli na koniec napisu jeszcze cos zostalo w tymczasowym }
        begin
        stworz_strukture(tymczasowy, unarny, wynik, liczba_str);
        end;

    end;    { koniec funkcji rozbij_na_str }









{* tu zaczyna sie wlasciwa czesc programu, ktory bedzie potem wykorzystany jako procedura w main.pas *}
begin
rownanie:='-sin(-abc-arg)-cos(abc)';
liczba_str:=0;

IF (rozbij_na_str(rownanie, rozbite, liczba_str)) THEN
    BEGIN
    writeln(liczba_str);

    while( liczba_str>0 ) do
        begin
        writeln('nazwa elementu ',liczba_str,': ', rozbite[liczba_str].nazwa,' typ: ', rozbite[liczba_str].typ,' unarny: ',rozbite[liczba_str].unarny);
        liczba_str:=liczba_str-1;
        end;

    end
ELSE
    WRITELN(' PROGRAM NIE ROZPOZNAL CZESCI ZNAKOW W ROWNANIU. KONIEC DZIALANIA. ');
END.
