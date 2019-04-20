unit wstCore;

{ Unit wstCore mendefinisikan tipe data, konstanta, fungsi, dan prosedur umumm yang digunakan. }

interface
    uses crt;
    { Konstanta }
    const
        LIST_NMAX = 256;
        INVALID_DATE = '-1/-1/-111';

    { Tipe data Date adalah record yang terdiri dari tanggal, bulan, dan tahun dalam bentuk numerik. }
    type Date = record
        y, m, d : integer;
    end;

    { Deklarasi fungsi/prosedur untuk tipe Date }
    function isDateValid(d : Date) : boolean;
        { SPESIFIKASI : Menentukan apakah tanggal valid. }
    function toDate(s : string) : Date;
        { SPESIFIKASI : Mengonversi format tanggal dari bentuk string 'DD/MM/YYYY'
            ke dalam tipe data Date. Jika masukan tidak valid keluaran akan berupa -1/-1/-1. }
    function fromDate(d : Date) : string;
        { SPESIFIKASI : Mengonversi format tanggal dari tipe data Date menjadi string 'DD/MM/YYYY' }
    function compareDate(d1, d2 : Date) : integer;
        { SPESIFIKASI : Membandingkan dua tanggal. keluaran:
             1 : d1 > d2 
             0 : d1 = d2
            -1 : d1 < d2 }
    function addDate(d1 : Date; x : integer) : Date;
        { SPESIFIKASI : Mengembalikan tanggal x hari setelah tanggal d1. }
    function subDate(d1, d2 : Date) : integer;
        { SPESIFIKASI : Mengembalikan selisih hari dari dua tanggal d1 dan d2. }

    { Deklarasi fungsi pembacaan file CSV }
    procedure readCSVStrDelim(var f : text; var s : string; delimiter : char);
        { SPESIFIKASI : membaca elemen string pada file csv f dengan dibatasi oleh 
            karakter delimiter dan menyimpannya ke string s. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. elemen pertama yang dibaca tersimpan pada string s. }
    procedure readCSVUIntDelim(var f : text; var i : integer; delimiter : char);
        { SPESIFIKASI : membaca elemen unsigned integer pada file csv f dengan dibatasi oleh
            karakter delimiter dan menyimpannya ke integer i. elemen valid jika tidak bernilai negatif (i >= 0).
            jika elemen tidak valid, i akan bernilai -1. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. i bernilai elemen pertama yang dibaca jika valid (>= 0) dan bernilai -1 jika tidak valid (< 0). }
    procedure readCSVDateDelim(var f : text; var d : date; delimiter : char);
        { SPESIFIKASI : membaca elemen tanggal pada file csv f dengan dibatasi oleh
            karakter delimiter dan menyimpannya ke Date d. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. d bernilai elemen pertama yang dibaca. }
    procedure readPass(var s : string);

implementation
    function isLeapYear(y : integer) : boolean;
        begin
            isLeapYear := ((y mod 4 = 0) and (y mod 100 <> 0)) or (y mod 400 = 0);
        end;

    function maxDayOfMonth(m : integer; y : integer) : integer;
        begin
            { Bulan dengan jumlah hari 31? }
            if (m = 1) or (m = 3) or (m = 5) or (m = 7) or (m = 8) or (m = 10) or (m = 12) then begin
                maxDayOfMonth := 31
            { Bulan dengan jumlah hari 30? }
            end else if (m = 4) or (m = 6) or (m = 9) or (m = 11) then begin
                maxDayOfMonth := 30
            { Bulan Februari? }
            end else if (m = 2) then begin
                { Tahun Kabisat? }
                if (isLeapYear(y)) then begin
                    maxDayOfMonth := 29;
                end else begin {((y mod 4 <> 0) or (y mod 100 = 0)) and (y mod 400 <> 0)}
                    maxDayOfMonth := 28;
                end;        
            end;
        end;

    function isDateValid(d : Date) : boolean;
        { SPESIFIKASI : Menentukan apakah tanggal valid. }
        { ALGORITMA }
        begin
            { Tahun valid? }
            if (d.y >= 0) and (d.y <= 9999) then begin
                { Bulan dengan jumlah hari 31? }
                if (d.m >=  1) and (d.m <= 12) then begin
                    isDateValid := (d.d >= 1) and (d.d <= maxDayOfMonth(d.m, d.y));
                end else begin { bulan tidak valid }
                    isDateValid := false;
                end;
            end else begin {(d.y < 0) or (d.y > 9999)}
                isDateValid := false;
            end;
        end;                            

    function toDate(s : string) : Date;
        { SPESIFIKASI : Mengonversi format tanggal dari bentuk string 'DD/MM/YYYY'
            ke dalam tipe data Date. Jika masukan tidak valid keluaran akan berupa -1/-1/-1. }
        { KAMUS LOKAL }
        var
            dd, mm, yyyy : string; { hasil parsing }
            cd, cm, cy : integer; { hasil konversi }
            isValid : boolean;
        { ALGORITMA }   
        begin
            { menggunakan skema standar validasi }
            isValid := false;
            { validasi panjang string }
            if (length(s) = 10) then begin
                { parsing tanggal, bulan, tahun }
                dd := copy(s, 1, 2);
                mm := copy(s, 4, 2);
                yyyy := copy(s, 7, 4);
                val(dd, toDate.d, cd);
                val(mm, toDate.m, cm);
                val(yyyy, toDate.y, cy);
                { validasi konversi }
                if (cd = 0) and (cm = 0) and (cy = 0) and (isDateValid(toDate)) then begin
                    isValid := true;
                end; { else do nothing }
            end;
            { jika tidak valid, mengembalikan -1/-1/-1 }
            if (not isValid) then begin
                toDate.d := -1;
                toDate.m := -1;
                toDate.y := -1;
            end; { else  do nothing }
        end;

    function fromDate(d : Date) : string;
        { SPESIFIKASI : Mengonversi format tanggal dari tipe data Date menjadi string 'DD/MM/YYYY'.
            Jika masukan tidak valid keluaran akan berupa -1/-1/-1. }
        { KAMUS LOKAL }
        var
            sd, sm, sy : string;
        { ALGORITMA }
        begin
            if (isDateValid(d)) then begin
                str(d.d, sd);
                sd := concat(copy('00', 1, 2 - length(sd)), sd);
                str(d.m, sm);
                sm := concat(copy('00', 1, 2 - length(sm)), sm);
                str(d.y, sy);
                sy := concat(copy('0000', 1, 4 - length(sy)), sy);
                fromDate := concat(sd, '/', sm, '/', sy);
            end else begin
                fromDate := INVALID_DATE;
            end;
        end;

    function compareDate(d1, d2 : Date) : integer;
        { SPESIFIKASI : Membandingkan dua tanggal d1 dan d2 dengan asumsi keduanya valid.
            Keluaran:
             1 : d1 > d2 
             0 : d1 = d2
            -1 : d1 < d2 }
        { ALGORITMA }
        begin
            compareDate := 0;
            if (d1.y > d2.y) then begin
                compareDate := 1;
            end else if (d1.y = d2.y) then begin
                if (d1.m > d2.m) then begin
                    compareDate := 1;
                end else if (d1.m = d2.m) then begin
                    if (d1.d > d2.d) then begin
                        compareDate := 1;
                    end else if (d1.d = d2.d) then begin
                        compareDate := 0;
                    end else begin {d1.d < d2.d}
                        compareDate := -1;
                    end;
                end else begin {d1.y < d2.y}
                    compareDate := -1;
                end;
            end else begin {d1.y < d2.y}
                compareDate := -1;
            end;
        end;

    function addDate(d1 : Date; x : integer) : Date;
        var
            d : Date;
            stop : boolean;
            md : integer;
        begin
            d := d1;
            d.d += x;
            stop := false;
            repeat
                if (isLeapYear(d.y)) then begin
                    if (d.d > 366) then begin
                        d.y += 1;
                        d.d -= 366;
                    end else begin
                        stop := true;
                    end;
                end else begin { not isLeapYear(d) }
                    if  (d.d > 365) then begin
                        d.y += 1;
                        d.d -= 365;
                    end else begin
                        stop := true;
                    end;
                end;
            until stop;
            stop := false;
            repeat
                md := maxDayOfMonth(d.m, d.y);
                if (d.d > md) then begin
                    d.m += 1;
                    if (d.m = 13) then begin
                        d.m := 1;
                        d.y += 1;
                    end;
                    d.d -= md;
                end else begin
                    stop := true;
                end;
            until stop;
            addDate := d; 
        end;

    function subDate(d1, d2 : Date) : integer;
        var
            d, i : integer;  
        begin
            d := d1.d - d2.d;
            if (d1.m > d2.m) then begin
                for i := d2.m to (d1.m - 1) do begin
                    d += maxDayOfMonth(i, d2.y);
                end;
            end else if (d1.m < d2.m) then begin
                for i := d1.m to (d2.m - 1) do begin
                    d -= maxDayOfMonth(i, d2.y);
                end;
            end; { else do nothing }
            if (d1.y > d2.y) then begin
                for i := d2.y to (d1.y - 1) do begin
                    if (isLeapYear(i)) then begin
                        d += 366;
                    end else begin { not isLeapYear(i) }
                        d += 355;
                    end;
                end;
            end else if (d1.m < d2.m) then begin
                for i := d1.m to (d2.m - 1) do begin
                    if (isLeapYear(i)) then begin
                        d -= 366;
                    end else begin { not isLeapYear(i) }
                        d -= 355;
                    end;
                end;
            end; { else do nothing }
            subDate := d;
        end;

    procedure readCSVStrDelim(var f : text; var s : string; delimiter : char);
        { SPESIFIKASI : membaca elemen string pada file csv f dengan dibatasi oleh 
            karakter delimiter dan menyimpannya ke string s. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. elemen pertama yang dibaca tersimpan pada string s. }
        { KAMUS LOKAL }
        var
            c : char;
            esc : boolean;
        { ALGORITMA }
        begin
            { Proses sekuensial dengan MARK (MARK = delimiter atau eof) untuk membaca karakter 
                satu persatu, dan memasukkan karakter tersebut ke string s selama karakter 
                bukan delimiter dan belum mencapai akhir file/eof. }
            s := '';
            esc := false;
            if not (eof(f)) then begin
                read(f, c);
            end;
            while ((c <> delimiter) or (esc)) and not (eof(f)) do begin
                if (c = '"') then begin
                    esc := not esc; 
                end else if (c <> #10) and (c <> #13) then begin { Periksa jika karakter bukan tanda petik, Carriage Return atau Line Feed }
                    s += c;
                end; { else do nothing }
                read(f, c);
            end;
        end;

    procedure readCSVUIntDelim(var f : text; var i : integer; delimiter : char);
        { SPESIFIKASI : membaca elemen unsigned integer pada file csv f dengan dibatasi oleh
            karakter delimiter dan menyimpannya ke integer i. elemen valid jika tidak bernilai negatif (i >= 0).
            jika elemen tidak valid, i akan bernilai -1. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. i bernilai elemen pertama yang dibaca jika valid (>= 0) dan bernilai -1 jika tidak valid (< 0). }
        { KAMUS LOKAL }
        var
            s : string;
            err : integer;
        { ALGORITMA }
        begin
            err := 0;
            readCSVStrDelim(f, s, delimiter);
            val(s, i, err); { Type cast dari string ke integer }
            { Proses validasi }
            if (err <> 0) or (i <= 0) then begin
                i := -1;
            end; {else do nothing}
        end;

    procedure readCSVDateDelim(var f : text; var d : date; delimiter : char);
        { SPESIFIKASI : membaca elemen tanggal pada file csv f dengan dibatasi oleh
            karakter delimiter dan menyimpannya ke Date d. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. d bernilai elemen pertama yang dibaca. }
        { KAMUS LOKAL }
        var
            s : string;
        { ALGORITMA }
        begin
            readCSVStrDelim(f, s, delimiter);
            d := toDate(s);
        end;

    
    procedure readPass(var s : string);
        var
            ch : char;
        begin
            s := '';
            repeat
            ch := readKey;
            
            if (ch >= #32) and (ch <= #126) then begin
                s += ch;
                write('*');
            end else if (ch = #8) and (length(s) >= 1) then begin
                s := copy(s, 1, length(s) - 1);
                write(#8, ' ', #8);
            end;
            until (ch = #13);
            write(#13, #10);
        end;



end.
