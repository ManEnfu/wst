unit wstBook;

{ Unit wstBook mendefinisikan tipe data Book, Booklist, fungsi, dan prosedur yang terkait. }

interface
    uses wstCore;

    { Tipe data Book adalah representasi dengan variabel anggota :
        _id         : id buku (numerik)
        _title      : judul buku
        _author     : penulis
        _qty        : jumlah buku (termasuk yang dipinjam)
        _year       : tahun terbit
        _category   : kategori buku
    }
    type Book = record
        _id, _qty, _year : integer;
        _title, _author, _category : string;
    end;

    { Tipe data BookList adalah daftar Book dengan variabel anggota :
        t           : array dengan tipe elemen Book dan ukuran LIST_NMAX yang didefinisikan di unit wstCore
        Neff        : ukuran efektif array (banyak elemen array yang terisi)
    }
    type BookList = record
        t : array [1 .. LIST_NMAX] of Book;
        Neff : integer
    end;

    { Deklarasi fungsi/prosedur terkait Book dan BookList }
    procedure BookAssign(var b : book; id : integer; title, author : string; qty, year : integer; ctg : string);
        { SPESIFIKASI : Mengisi nilai pada Book b. }
        { I.S. b terdeklarasi. }
        { F.S. b terisi dengan nilai yang diberikan. }
    procedure BookWriteToCSV(var f : text; b : book);
        { SPESIFIKASI : Memasukkan entri Book b di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, b terdefinisi.
            Contoh CSV:
            ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori
            id1,title1,author1,qty1,year1,category1 }
        { F.S. entri baru dengan nilai dari b pada baris paling bawah file f.
            Contoh CSV:
            ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori
            id1,title1,author1,qty1,year1,category1 
            id2,title2,author2,qty2,year2,category2 }
    procedure BookSaveListToCSV(var f : text; bl : BookList);
        { SPESIFIKASI : Menyimpan BookList bl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bl terdefinisi. }
        { F.S. f berisi data dari bl }
    procedure BookReadFromCSV(var f : text; var b : Book);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada Book b. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. b terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
    procedure BookLoadListFromCSV(var f : text; var bl : BookList);
        { SPESIFIKASI : Memuat file csv f ke dalam Booklist bl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bl berisi data dari file csv f.}
    procedure BookAppendList(var bl : BookList; b : book);
        { SPESIFIKASI : Melakukan append Book b ke Booklist bl. 
            b diletakkan di elemen terakhir bl jika array belum penuh. }
        { I.S. bl berukuran n }
        { F.S. bl berukuran n + 1 dengan elemen ke n + 1 adalah b. }
    
implementation

    procedure BookAssign(var b : book; id : integer; title, author : string; qty, year : integer; ctg : string);
        { SPESIFIKASI : Mengisi nilai pada Book b. }
        { I.S. b terdeklarasi. }
        { F.S. b terisi dengan nilai yang diberikan. }
        { ALGORITMA }
        begin
            b._id := id;
            b._title := title;
            b._author := author;
            b._qty := qty;
            b._year := year;
            b._category := ctg;
        end;

    procedure BookWriteToCSV(var f : text; b : book);
        { SPESIFIKASI : Memasukkan entri Book b di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, b terdefinisi.
            Contoh CSV:
            ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori
            id1,title1,author1,qty1,year1,category1 }
        { F.S. entri baru dengan nilai dari b pada baris paling bawah file f.
            Contoh CSV:
            ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori
            id1,title1,author1,qty1,year1,category1 
            id2,title2,author2,qty2,year2,category2 }
        { ALGORITMA }
        begin
            write(f, b._id, ',', b._title, ',', b._author, ',', b._qty, ',', b._year, ',', b._category, #13, #10);
        end;

    procedure BookSaveListToCSV(var f : text; bl : BookList);
        { SPESIFIKASI : Menyimpan BookList bl ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, bl terdefinisi. }
        { F.S. f berisi data dari bl }
        { KAMUS LOKAL }
        var
            i : integer;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header }
            write(f, 'ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori', #13, #10);
            { Proses pengulangan dengan jumlah pengulangan tertentu untuk mengisi file }
            for i := 1 to bl.Neff do begin
                { Menulis data buku pada baris selanjutnya }
                BookWriteToCSV(f, bl.t[i]);
            end;
        end;

    procedure BookReadFromCSV(var f : text; var b : Book);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada Book b. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. b terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
        { ALGORITMA }
        begin
            readCSVUIntDelim(f, b._id, ',');
            readCSVStrDelim(f, b._title, ',');
            readCSVStrDelim(f, b._author, ',');
            readCSVUIntDelim(f, b._qty, ',');
            readCSVUIntDelim(f, b._year, ',');
            readCSVStrDelim(f, b._category, #10);
        end;

    procedure BookLoadListFromCSV(var f : text; var bl : BookList);
        { SPESIFIKASI : Memuat file csv f ke dalam Booklist bl. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. bl berisi data dari file csv f.}
        { KAMUS LOKAL }
        var
            b : Book;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header. dibaca, tetapi tidak diproses }
            BookReadFromCSV(f, b);
            { Proses sekuensial dengan MARK (MARK = LIST_NMAX atau eof) untuk membaca entri
                per baris, kemudian melakukan append ke list selama }
            bl.Neff := 0;
            while (not eof(f)) and (bl.Neff < LIST_NMAX) do begin
                BookReadFromCSV(f, b);
                BookAppendList(bl, b);
            end;
        end;

    procedure BookAppendList(var bl : BookList; b : book);
        { SPESIFIKASI : Melakukan append Book b ke Booklist bl. 
            b diletakkan di elemen terakhir bl jika array belum penuh. }
        { I.S. bl berukuran n }
        { F.S. bl berukuran n + 1 dengan elemen ke n + 1 adalah b. }
        begin
            if (bl.Neff < LIST_NMAX) then begin
                bl.Neff += 1;
                bl.t[bl.Neff] := b;
            end;
        end;
end.