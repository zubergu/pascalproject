program glowny.pas;

const
    cyfry = '0123456789';         { zestaw wszystkich cyfr }
    litery = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'; { zestaw wszystkich liter }
    operatory = '+-/*';             { zestaw wszystkich operatorow }


type
    Typy = (Zmienna, Liczba, Funkcja, Operacja, Nawias);       {* Definicja typu do przechowywania informacji
                                                                    o typie struktury badz obiektu *}

    Struktura = record   {* na takie struktury bedzie rozbijane rownanie wejsciowe podane przez uzytkownika
                            przed zamiana na Odwrocona Notacje Polska *}
        nazwa:string;
        typ: Typy;
        end;



var
    rownanie: string; { zmienna przechowujaca rownanie wprowadzone przez uzytkownika }

    przed_onp: array[10] of Struktura; {* tablica struktur,

            !!!!WARNING!!!

    rozmiar do poprawienia, 10 elementow tylko do testow *}


{*
    * Definicje funkcji i procedure
    * uzywanych w czesci glownej programu.
*}

function czy_litera(znak: char) : Boolean;  { sprawdzi czy znak jest litera }
function czy_operator(znak: char) : Boolean;{ sprawdzi czy znak jest operatorem }
function czy_cyfra(znak: char) : Boolean;   { sprawdzi czy znak jest cyfra }
procedure rownanie_na_struktury(var przed_onp: array[10] of Struktura; wpr_rownanie:string);
{ tu zaczynamy wykonywanie glownej czesci programu }
begin

            { tu pobieramy rownanie od uzytkownika }

writeln('Podaj rownanie do obliczenia: ');
readln(rownanie);


{ rozbieramy rownanie na czesci, zapisujemy kazdy element w tablicy struktur (nazwa i typ) }

{ przegladamy stworzona tablice napisow i przetwarzamy ja do odwroconej notacji polskiej }

{ na podstawie tablicy z odwrocona notacja polska tworzymy drzewo obliczen }

{ wyswietlamy wynik i uwalniamy pamiec po drzewie }

end.
