unit wstLostReport;

{ Unit wstLostReport mendefinisikan tipe data LostReport, LostReportlist, fungsi, dan prosedur yang terkait. }

interface
    uses wstCore;

    { Tipe data LostReport adalah representasi laporan kehilangan buku dengan variabel anggota :
        _username   : username pelapor
        _id         : id buku yang hilang (numerik)
        _reportDate : tanggal pelaporan
    }
    type LostReport = record
        _id : integer;
        _username : string;
        _reportDate : Date;
    end;

    { Tipe data LostReportList adalah daftar LostReport dengan variabel anggota :
        t           : array dengan tipe elemen LostReport dan ukuran LIST_NMAX yang didefinisikan di unit wstCore
        Neff        : ukuran efektif array (banyak elemen array yang terisi)
    }
    type LostReportList = record
        t : array [1 .. LIST_NMAX] of LostReport;
        Neff : integer
    end;

    { Deklarasi fungsi/prosedur terkait LostReport dan LostReportList }
    procedure LostReportWriteToCSV(var f : text; lr : LostReport);
        { SPESIFIKASI : Memasukkan entri LostReport lr di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, lr terdefinisi. }
        { F.S. entri baru dengan nilai dari lr pada baris paling bawah file f. }
    procedure LostReportSaveListToCSV(var f : text; lrl : LostReportList);
        { SPESIFIKASI : Menyimpan LostReportList lrl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, lrl terdefinisi. }
        { F.S. f berisi data dari lrl }
    procedure LostReportReadFromCSV(var f : text; var lr : LostReport);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada LostReport lr. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. lr terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
    procedure LostReportLoadListFromCSV(var f : text; var lrl : LostReportList);
        { SPESIFIKASI : Memuat file csv f ke dalam LostReportlist lrl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. lrl berisi data dari file csv f.}
    procedure LostReportAppendList(var lrl : LostReportList; lr : LostReport);
        { SPESIFIKASI : Melakukan append LostReport lr ke LostReportlist lrl. 
            lr diletakkan di elemen terakhir lrl jika array belum penuh. }
        { I.S. lrl berukuran n }
        { F.S. lrl berukuran n + 1 dengan elemen ke n + 1 adalah lr. }
    
implementation

    procedure LostReportWriteToCSV(var f : text; lr : LostReport);
        { SPESIFIKASI : Memasukkan entri LostReport lr di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, lr terdefinisi. }
        { F.S. entri baru dengan nilai dari lr pada baris paling bawah file f. }
        { ALGORITMA }
        begin
            write(f, lr._username, ',', lr._id, ',', fromDate(lr._reportDate), #13, #10);
        end;

    procedure LostReportSaveListToCSV(var f : text; lrl : LostReportList);
        { SPESIFIKASI : Menyimpan LostReportList lrl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, lrl terdefinisi. }
        { F.S. f berisi data dari lrl }
        { KAMUS LOKAL }
        var
            i : integer;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header }
            write(f, 'Username,ID_Buku_Hilang,Tanggal_Laporan', #13, #10);
            { Proses pengulangan dengan jumlah pengulangan tertentu untuk mengisi file }
            for i := 1 to lrl.Neff do begin
                { Menulis data buku pada baris selanjutnya }
                LostReportWriteToCSV(f, lrl.t[i]);
            end;
        end;

    procedure LostReportReadFromCSV(var f : text; var lr : LostReport);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada LostReport lr. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. lr terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
        { ALGORITMA }
        begin
            readCSVStrDelim(f, lr._username, ',');
            readCSVUIntDelim(f, lr._id, ',');
            readCSVDateDelim(f, lr._reportDate, #10);
        end;

    procedure LostReportLoadListFromCSV(var f : text; var lrl : LostReportList);
        { SPESIFIKASI : Memuat file csv f ke dalam LostReportlist lrl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. lrl berisi data dari file csv f.}
        { KAMUS LOKAL }
        var
            lr : LostReport;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header. dibaca, tetapi tidak diproses }
            LostReportReadFromCSV(f, lr);
            { Proses sekuensial dengan MARK (MARK = LIST_NMAX atau eof) untuk membaca entri
                per baris, kemudian melakukan append ke list selama }
            lrl.Neff := 0;
            while (not eof(f)) and (lrl.Neff < LIST_NMAX) do begin
                LostReportReadFromCSV(f, lr);
                LostReportAppendList(lrl, lr);
            end;
        end;

    procedure LostReportAppendList(var lrl : LostReportList; lr : LostReport);
        { SPESIFIKASI : Melakukan append LostReport lr ke LostReportlist lrl. 
            lr diletakkan di elemen terakhir lrl jika array belum penuh. }
        { I.S. lrl berukuran n }
        { F.S. lrl berukuran n + 1 dengan elemen ke n + 1 adalah lr. }
        begin
            if (lrl.Neff < LIST_NMAX) then begin
                lrl.Neff += 1;
                lrl.t[lrl.Neff] := lr;
            end;
        end;
end.