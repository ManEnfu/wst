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
        { SPESIFIKASI : membaca input string dengan menyembunyikan string input kemudian 
            mengenkripsi string tersebut. }
        { I.S. - }
        { F.S. string dienkripsi dan disimpan di variabel s. }
    function encryptPass(s : string) : string;
        { SPESIFIKASI : mengembalikan string hasil enkripsi string s menggunakan base64. }
    function compareString(s1, s2 : string) : integer;
        { SPESIFIKASI : Membandingkan dua string secara leksikografis. mengembalikan :
            1 : s1 > s2
            0 : s1 = s2
            -1 : s1 < s2 }

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
        { SPESIFIKASI : Mengembalikan tanggal x hari setelah tanggal d1. }
        { KAMUS LOKAL }
        var
            d : Date;
            stop : boolean;
            md : integer;
        { ALGORITMA }
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
        { SPESIFIKASI : Mengembalikan selisih hari dari dua tanggal d1 dan d2. }
        { KAMUS LOKAL }
        var
            d, dd1, dd2, i : integer;
        { ALGORITMA }  
        begin
            dd1 := d1.d;
            i := 1;
            while (i < d1.m) do begin
                dd1 += maxDayOfMonth(i, d1.y);
                i += 1;
            end;
            dd2 := d2.d;
            i := 1;
            while (i < d2.m) do begin
                dd2 += maxDayOfMonth(i, d2.y);
                i += 1;
            end;
            d := 0;
            if (d1.y > d2.y) then begin
                for i := d2.y to (d1.y - 1) do begin
                    if (isLeapYear(i)) then begin
                        d += 366;
                    end else begin { not isLeapYear(i) }
                        d += 365;
                    end;
                end;
            end else if (d1.y < d2.y) then begin
                for i := d1.y to (d2.y - 1) do begin
                    if (isLeapYear(i)) then begin
                        d -= 366;
                    end else begin { not isLeapYear(i) }
                        d -= 365;
                    end;
                end;
            end; { else do nothing }
            subDate := d + dd1 - dd2;
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
        { SPESIFIKASI : membaca input string dengan menyembunyikan string input kemudian 
            mengenkripsi string tersebut. }
        { I.S. - }
        { F.S. string dienkripsi dan disimpan di variabel s. }
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
            s := encryptPass(s);
        end;

    function encryptPass(s : string) : string;
        { SPESIFIKASI : mengembalikan string hasil enkripsi string s menggunakan base64. }
        { KAMUS LOKAL }
        var
            b64 : array [1..64] of char = (
                'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H',
                'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 
                'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X',
                'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f',
                'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n',
                'o', 'p', 'q', 'r', 's', 't', 'u', 'v',
                'w', 'x', 'y', 'z', '0', '1', '2', '3',
                '4', '5', '6', '7', '8', '9', '+', '/' 
            );
            b, e : string;
            o, i, j, eb : integer;
        { ALGORITMA }
        begin
            e := '';
            b := '';
            for i := 1 to length(s) do begin
                o := ord(s[i]);
                if (o >= 128) then begin
                    b += '1';
                    o -= 128;
                end else begin
                    b += '0';
                end;
                if (o >= 64) then begin
                    b += '1';
                    o -= 64;
                end else begin
                    b += '0';
                end;
                if (o >= 32) then begin
                    b += '1';
                    o -= 32;
                end else begin
                    b += '0';
                end;
                if (o >= 16) then begin
                    b += '1';
                    o -= 16;
                end else begin
                    b += '0';
                end;
                if (o >= 8) then begin
                    b += '1';
                    o -= 8;
                end else begin
                    b += '0';
                end;
                if (o >= 4) then begin
                    b += '1';
                    o -= 4;
                end else begin
                    b += '0';
                end;
                if (o >= 2) then begin
                    b += '1';
                    o -= 2;
                end else begin
                    b += '0';
                end;
                if (o >= 1) then begin
                    b += '1';
                    o -= 1;
                end else begin
                    b += '0';
                end;
            end;
            i := 1;
            while  (i <= length(b)) do begin
                eb := 0;
                for j := 1 to 6 do begin
                    eb *= 2;
                    if (i <= length(b)) then begin
                        if (b[i] = '1') then begin
                            eb += 1;
                        end else begin
                            eb += 0;
                        end;
                    end else begin
                        eb += 0;
                    end;
                    i += 1;
                end;
                e += b64[eb + 1];
            end;
            encryptPass := e;
        end;

    function compareString(s1, s2 : string) : integer;
        { SPESIFIKASI : Membandingkan dua string secara leksikografis. mengembalikan :
            1 : s1 > s2
            0 : s1 = s2
            -1 : s1 < s2 }
        { KAMUS LOKAL }
        var
            ss1, ss2 : string;
            i : integer;
            stop : boolean;
        { ALGORITMA }
        begin
            i := 1;
            ss1 := upCase(s1);
            ss2 := upCase(s2);
            stop := false;
            while (not stop) and (i <= length(ss1)) and (i <= length(ss2)) do begin
                if (ss1[i] < ss2[i]) then begin
                    compareString := -1;
                    stop := true;
                end else if (ss1[i] > ss2[i]) then begin
                    compareString := 1;
                    stop := true;
                end else begin { ss1[i] = ss2[i] }
                    i += 1;
                end;
            end;
            if (not stop) then begin
                if (length(ss1) < length(ss2)) then begin
                    compareString := -1;
                end else if (length(ss1) > length(ss2)) then begin
                    compareString := 1;
                end else begin { (length(ss1) < length(ss2)) }
                    compareString := -1;
                end;
            end; { else do nothing }
        end;
end.
