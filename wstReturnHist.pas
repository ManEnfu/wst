unit wstReturnHist;

{ Unit wstReturnHist mendefinisikan tipe data ReturnHist, ReturnHistlist, fungsi, dan prosedur yang terkait. }

interface
    uses wstCore, wstBook;

    { Tipe data ReturnHist adalah representasi histori peminjaman buku dengan variabel anggota :
        _username   : username peminjam
        _id         : id buku yang dipinjam (numerik)
        _borrowDate : tanggal pengembalian
    }
    type ReturnHist = record
        _id : integer;
        _username : string;
        _returnDate : Date;
    end;

    { Tipe data ReturnHistList adalah daftar ReturnHist dengan variabel anggota :
        t           : array dengan tipe elemen ReturnHist dan ukuran LIST_NMAX yang didefinisikan di unit wstCore
        Neff        : ukuran efektif array (banyak elemen array yang terisi)
    }
    type ReturnHistList = record
        t : array [1 .. LIST_NMAX] of ReturnHist;
        Neff : integer
    end;

    { Deklarasi fungsi/prosedur terkait ReturnHist dan ReturnHistList }
    procedure ReturnHistWriteToCSV(var f : text; rh : ReturnHist);
        { SPESIFIKASI : Memasukkan entri ReturnHist rh di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, rh terdefinisi. }
        { F.S. entri baru dengan nilai dari rh pada baris paling bawah file f. }
    procedure ReturnHistSaveListToCSV(var f : text; rhl : ReturnHistList);
        { SPESIFIKASI : Menyimpan ReturnHistList rhl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, rhl terdefinisi. }
        { F.S. f berisi data dari rhl }
    procedure ReturnHistReadFromCSV(var f : text; var rh : ReturnHist);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada ReturnHist rh. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. rh terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
    procedure ReturnHistLoadListFromCSV(var f : text; var rhl : ReturnHistList);
        { SPESIFIKASI : Memuat file csv f ke dalam ReturnHistlist rhl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. rhl berisi data dari file csv f.}
    procedure ReturnHistAppendList(var rhl : ReturnHistList; rh : ReturnHist);
        { SPESIFIKASI : Melakukan append ReturnHist rh ke ReturnHistlist rhl. 
            rh diletakkan di elemen terakhir rhl jika array belum penuh. }
        { I.S. rhl berukuran n }
        { F.S. rhl berukuran n + 1 dengan elemen ke n + 1 adalah rh. }

implementation

    procedure ReturnHistWriteToCSV(var f : text; rh : ReturnHist);
        { SPESIFIKASI : Memasukkan entri ReturnHist rh di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, rh terdefinisi. }
        { F.S. entri baru dengan nilai dari rh pada baris paling bawah file f. }
        { ALGORITMA }
        begin
            write(f, '"', rh._username, '","', rh._id, '","', fromDate(rh._returnDate), '"',#13, #10);
        end;

    procedure ReturnHistSaveListToCSV(var f : text; rhl : ReturnHistList);
        { SPESIFIKASI : Menyimpan ReturnHistList rhl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, rhl terdefinisi. }
        { F.S. f berisi data dari rhl }
        { KAMUS LOKAL }
        var
            i : integer;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header }
            write(f, 'Username,ID_Buku,Tanggal_Pengembalian', #13, #10);
            { Proses pengulangan dengan jumlah pengulangan tertentu untuk mengisi file }
            for i := 1 to rhl.Neff do begin
                { Menulis data buku pada baris selanjutnya }
                ReturnHistWriteToCSV(f, rhl.t[i]);
            end;
        end;

    procedure ReturnHistReadFromCSV(var f : text; var rh : ReturnHist);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada ReturnHist rh. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. rh terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
        { ALGORITMA }
        begin
            readCSVStrDelim(f, rh._username, ',');
            readCSVUIntDelim(f, rh._id, ',');
            readCSVDateDelim(f, rh._returnDate, #10);
        end;

    procedure ReturnHistLoadListFromCSV(var f : text; var rhl : ReturnHistList);
        { SPESIFIKASI : Memuat file csv f ke dalam ReturnHistlist rhl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. rhl berisi data dari file csv f.}
        { KAMUS LOKAL }
        var
            rh : ReturnHist;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header. dibaca, tetapi tidak diproses }
            ReturnHistReadFromCSV(f, rh);
            { Proses sekuensial dengan MARK (MARK = LIST_NMAX atau eof) untuk membaca entri
                per baris, kemudian melakukan append ke list selama }
            rhl.Neff := 0;
            while (not eof(f)) and (rhl.Neff < LIST_NMAX) do begin
                ReturnHistReadFromCSV(f, rh);
                ReturnHistAppendList(rhl, rh);
            end;
        end;

    procedure ReturnHistAppendList(var rhl : ReturnHistList; rh : ReturnHist);
        { SPESIFIKASI : Melakukan append ReturnHist rh ke ReturnHistlist rhl. 
            rh diletakkan di elemen terakhir rhl jika array belum penuh. }
        { I.S. rhl berukuran n }
        { F.S. rhl berukuran n + 1 dengan elemen ke n + 1 adalah rh. }
        { ALGORITMA }
        begin
            if (rhl.Neff < LIST_NMAX) then begin
                rhl.Neff += 1;
                rhl.t[rhl.Neff] := rh;
            end;
        end;
end.