unit wstBorrowHist;

{ Unit wstBorrowHist mendefinisikan tipe data BorrowHist, BorrowHistlist, fungsi, dan prosedur yang terkait. }

interface
    uses wstCore;

    { Tipe data BorrowHist adalah representasi histori peminjaman buku dengan variabel anggota :
        _username   : username peminjam
        _id         : id buku yang dipinjam (numerik)
        _borrowDate : tanggal peminjaman
        _dueDate    : batas pengembalian
        _status     : status pengembalian (sudah/belum)
    }
    type BorrowHist = record
        _id : integer;
        _username, _status : string;
        _borrowDate, _dueDate : Date;
    end;

    { Tipe data BorrowHistList adalah daftar BorrowHist dengan variabel anggota :
        t           : array dengan tipe elemen BorrowHist dan ukuran LIST_NMAX yang didefinisikan di unit wstCore
        Neff        : ukuran efektif array (banyak elemen array yang terisi)
    }
    type BorrowHistList = record
        t : array [1 .. LIST_NMAX] of BorrowHist;
        Neff : integer
    end;

    { Deklarasi fungsi/prosedur terkait BorrowHist dan BorrowHistList }
    procedure BorrowHistWriteToCSV(var f : text; bh : BorrowHist);
        { SPESIFIKASI : Memasukkan entri BorrowHist bh di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bh terdefinisi. }
        { F.S. entri baru dengan nilai dari bh pada baris paling bawah file f. }
    procedure BorrowHistSaveListToCSV(var f : text; bhl : BorrowHistList);
        { SPESIFIKASI : Menyimpan BorrowHistList bhl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bhl terdefinisi. }
        { F.S. f berisi data dari bhl }
    procedure BorrowHistReadFromCSV(var f : text; var bh : BorrowHist);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada BorrowHist bh. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bh terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
    procedure BorrowHistLoadListFromCSV(var f : text; var bhl : BorrowHistList);
        { SPESIFIKASI : Memuat file csv f ke dalam BorrowHistlist bhl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bhl berisi data dari file csv f.}
    procedure BorrowHistAppendList(var bhl : BorrowHistList; bh : BorrowHist);
        { SPESIFIKASI : Melakukan append BorrowHist bh ke BorrowHistlist bhl. 
            bh diletakkan di elemen terakhir bhl jika array belum penuh. }
        { I.S. bhl berukuran n }
        { F.S. bhl berukuran n + 1 dengan elemen ke n + 1 adalah bh. }
    
implementation

    procedure BorrowHistWriteToCSV(var f : text; bh : BorrowHist);
        { SPESIFIKASI : Memasukkan entri BorrowHist bh di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bh terdefinisi. }
        { F.S. entri baru dengan nilai dari bh pada baris paling bawah file f. }
        { ALGORITMA }
        begin
            write(f, bh._username, ',', bh._id, ',', fromDate(bh._borrowDate), ',', fromDate(bh._dueDate), ',', bh._status, #13, #10);
        end;

    procedure BorrowHistSaveListToCSV(var f : text; bhl : BorrowHistList);
        { SPESIFIKASI : Menyimpan BorrowHistList bhl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bhl terdefinisi. }
        { F.S. f berisi data dari bhl }
        { KAMUS LOKAL }
        var
            i : integer;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header }
            write(f, 'Username,ID_Buku,Tanggal_Peminjaman,Tanggal_Batas_Pengembalian,Status_Pengembalian', #13, #10);
            { Proses pengulangan dengan jumlah pengulangan tertentu untuk mengisi file }
            for i := 1 to bhl.Neff do begin
                { Menulis data buku pada baris selanjutnya }
                BorrowHistWriteToCSV(f, bhl.t[i]);
            end;
        end;

    procedure BorrowHistReadFromCSV(var f : text; var bh : BorrowHist);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada BorrowHist bh. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bh terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
        { ALGORITMA }
        begin
            readCSVStrDelim(f, bh._username, ',');
            readCSVUIntDelim(f, bh._id, ',');
            readCSVDateDelim(f, bh._borrowDate, ',');
            readCSVDateDelim(f, bh._dueDate, ',');
            readCSVStrDelim(f, bh._status, #10);
        end;

    procedure BorrowHistLoadListFromCSV(var f : text; var bhl : BorrowHistList);
        { SPESIFIKASI : Memuat file csv f ke dalam BorrowHistlist bhl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bhl berisi data dari file csv f.}
        { KAMUS LOKAL }
        var
            bh : BorrowHist;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header. dibaca, tetapi tidak diproses }
            BorrowHistReadFromCSV(f, bh);
            { Proses sekuensial dengan MARK (MARK = LIST_NMAX atau eof) untuk membaca entri
                per baris, kemudian melakukan append ke list selama }
            bhl.Neff := 0;
            while (not eof(f)) and (bhl.Neff < LIST_NMAX) do begin
                BorrowHistReadFromCSV(f, bh);
                BorrowHistAppendList(bhl, bh);
            end;
        end;

    procedure BorrowHistAppendList(var bhl : BorrowHistList; bh : BorrowHist);
        { SPESIFIKASI : Melakukan append BorrowHist bh ke BorrowHistlist bhl. 
            bh diletakkan di elemen terakhir bhl jika array belum penuh. }
        { I.S. bhl berukuran n }
        { F.S. bhl berukuran n + 1 dengan elemen ke n + 1 adalah bh. }
        begin
            if (bhl.Neff < LIST_NMAX) then begin
                bhl.Neff += 1;
                bhl.t[bhl.Neff] := bh;
            end;
        end;
end.