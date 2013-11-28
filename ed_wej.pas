program przetworz_wejscie;

const
        cyfry = '0123456789';
        litery = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
        operatory = '*/+-()';

var
        i:integer;           { licznik petli }
        dlugosc: integer;       { dlugosc wczytanego rownania }
        rownanie:string;        { wczytane rownanie }
        ostateczna:string;      { wersja po przerobieniu }

begin
i:=1;
dlugosc:=1;
writeln('Podaj rownanie:');
readln(rownanie);
writeln('Podales rownanie:', rownanie, ' i to ono zostanie obliczone!');
dlugosc:=length(rownanie);
while (i <= dlugosc) do
    begin

    if (rownanie[i] = '-') and ((i-1 = 0) or (pos(rownanie[i-1],operatory)<>0)) then
        begin
        ostateczna:=ostateczna+'(0-';
        i:=i+1;
        while (i<=dlugosc) and (pos(rownanie[i], operatory) =  0) do
            begin
            ostateczna:=ostateczna+rownanie[i];
            i:=i+1;
            end;
        ostateczna := ostateczna + ')';
        end
    else
        begin
        ostateczna:=ostateczna + rownanie[i];
        i:=i+1;
        end;
    end;
writeln(ostateczna);
readln();
end.
