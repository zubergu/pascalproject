
    program simple_one;
    
    type
        structure = record
            value:integer;
            end;

    var
        my_arr: array[1..3] of structure;
        how_many_out: integer;

    procedure fill_in(var arr: array of structure; var how_many_in:integer);
        var i:integer;
        begin
        how_many_in:=0;
        i:=1;
        for i:=1 to 3 do
            begin
            writeln('Iteration no. ',i);
            arr[i].value:=i;
            writeln('How many in before ', how_many_in);
            how_many_in:=how_many_in+1;
            writeln('How many in after addition ', how_many_in);
            end;
        writeln('how_many_in= ',how_many_in);
        end;

    begin
        how_many_out:=0;
        fill_in(my_arr,how_many_out);
        writeln('how_many_out= '. how_many_out);

        while ( how_many_out >= 1 ) do
            begin
            writeln('my_arr[',how_many_out,']= ', my_arr[how_many_out].value);
            how_many_out:=how_many_out-1;
            end;
    end.



