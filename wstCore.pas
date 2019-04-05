unit wstCore;

{ Unit wstCore mendefinisikan tipe data, konstanta, fungsi, dan prosedur umumm yang digunakan. }

interface
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

implementation
    function isDateValid(d : Date) : boolean;
        { SPESIFIKASI : Menentukan apakah tanggal valid. }
        { ALGORITMA }
        begin
            { Tahun valid? }
            if (d.y >= 0) and (d.y <= 9999) then begin
                { Bulan dengan jumlah hari 31? }
                if (d.m = 1) or (d.m = 3) or (d.m = 5) or (d.m = 7) or (d.m = 8) or (d.m = 10) or (d.m = 12) then begin
                    isDateValid := (d.d >= 1) and (d.d <= 31);
                { Bulan dengan jumlah hari 30? }
                end else if (d.m = 4) or (d.m = 6) or (d.m = 9) or (d.m = 11) then begin
                    isDateValid := (d.d >= 1) and (d.d <= 30);
                { Bulan Februari? }
                end else if (d.m = 2) then begin
                    { Tahun Kabisat? }
                    if ((d.y mod 4 = 0) and (d.y mod 100 <> 0)) or (d.y mod 400 = 0) then begin
                        isDateValid := (d.d >= 1) and (d.d <= 29);
                    end else begin {((d.y mod 4 <> 0) or (d.y mod 100 = 0)) and (d.y mod 400 <> 0)}
                        isDateValid := (d.d >= 1) and (d.d <= 28);
                    end;
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
        { SPESIFIKASI : Mengonversi format tanggal dari tipe data Date menjadi string 'DD/MM/YYYY' }
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

    procedure readCSVStrDelim(var f : text; var s : string; delimiter : char);
        { SPESIFIKASI : membaca elemen string pada file csv f dengan dibatasi oleh 
            karakter delimiter dan menyimpannya ke string s. }
        { I.S. f sudah dibuka dengan mode reset/read, delimiter terdefinisi. }
        { F.S. elemen pertama yang dibaca tersimpan pada string s. }
        { KAMUS LOKAL }
        var
            c : char;
        { ALGORITMA }
        begin
            { Proses sekuensial dengan MARK (MARK = delimiter atau eof) untuk membaca karakter 
                satu persatu, dan memasukkan karakter tersebut ke string s selama karakter 
                bukan delimiter dan belum mencapai akhir file/eof. }
            s := '';
            read(f, c);
            while (c <> delimiter) and not (eof(f)) do begin
                s += c;
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
end.
