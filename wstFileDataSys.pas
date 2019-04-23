unit wstFileDataSys;

interface 
    uses wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstLostReport;
    function isKatValid(x : char):boolean;
    procedure wstBookStockProc(var bl : BookList; bhl : BorrowHistList; lrl : LostReportList);
    { F01 - Registrasi }
    procedure wstRegister(var ul : UserList);
    { F02 - Login }
    procedure wstLogin(ul : UserList; var loggedUser : User; var log : boolean);
    { F03 - Pencarian buku berdasarkan kategori }
    procedure wstSearchBookCategory(bl : Booklist);
    { F04 - Mencari Tahun terbit buku }
    procedure wstSearchBookYear (Tabbook : BookList);
        { SPESIFIKASI : Membaca input tahun dan kategori kemudian memberitahu data buku. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data dimuat di list data. }
    { F05 - Peminjaman Buku }
    procedure wstBorrowBook(var Tabbook : BookList; var TabBorrowHist : BorrowHistList; loggedUser : User);
        { SPESIFIKASI : Membaca input id buku dan tanggal peminjaman kemudian memberitahu data peminjaman buku. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data dimuat di list data. }
    { F06 - Pengembalian Buku }
    procedure wstReturnBook (var Tabbook : BookList; var TabBorrowHist : BorrowHistList; var TabReturnHist : ReturnHistList; loggedUser : User);
    
    { F07 - Melaporkan buku  hilang }
    procedure wstReportLostBook(var bl : BookList; var listHilang : LostReportList; loggedUser : User);
        { SPESIFIKASI : membaca variabel listHilang bertipe LostReportList, dan variabel listBuku bertipe BookList}
        { I.S. menerima variabel id, title, tanggal pada LostReportList }
        { F.S. menuliskan output variabel id, title, dan tanggal pada LostReportList }
    { F08 - Lihat Laporan }
    procedure wstListLostReports(lrl : LostReportList; bl : BookList);
        { SPESIFIKASI : membaca inputan atribut buku, judul, serta tanggal kehilangan buku.}
        { I.S. lisHilang telah terdefinisi sebagai LoatReportLists }
        { F.S. variabel lr._id, b._title, dan fungsi fromdate (lr._reportDate) yang telah diunput pada awal prosedur }
    { F09 - Tambah buku }
    procedure wstAddBook(var listBuku : BookList);
        { SPESIFIKASI : menulis input variabel dan di masukkan ke dalam list BookList }
        { I.S. membaca input variabel _id, _title, _author, _year, _category }
        { F.S. memasukkan variabel yang telah diinput ke list BookList }
    { F10 - Melakukan penambahan jumlah buku ke sistem }
    procedure wstAddStock(var a : BookList);
        { SPESIFIKASI : Membaca input ID Buku dan jumlah yang akan ditambahkan}
        { I.S. ID Buku yang akan ditambah stocknya terdefinisi pada data. }
        { F.S. Buku dengan ID Buku terkait akan bertambah jumlah stocknya. }
    { F11 - Melihat riwayat peminjaman }
    procedure wstUserHist(var a : ReturnHistList; var d : BookList);
        { SPESIFIKASI : Menghitung statistik pengguna berupa admin dan pengunjung
        dan statistik buku berupa kategori}
        { I.S. a dan b terdefinisi, username yang dimasukkan terdefinisi pada data. }
        { F.S. Riwayat peminjaman pengguna terkait ditampilkan dengan format Tanggal_Pengembalian | ID_Buku | Judul Buku. }
    { F12 - Statistik }
    procedure wstStat(var a : UserList; var b : BookList);
        { SPESIFIKASI : Menghitung statistik pengguna berupa admin dan pengunjung
        dan statistik buku berupa kategori}
        { I.S. a dan b terdefinisi. }
        { F.S. Statistik jumlah pengguna dan jumlah buku per kategori ditampikan. }
    { F13 - Load File }
    procedure wstLoadFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian memuat data perpustakaan dari
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data perpustakaan dimuat di list data. }
    { F14 - Save File }
    procedure wstSaveFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian menyimpan data perpustakaan ke
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi, parameter list terdefinisi. }
        { F.S. Data perpustakaan disimpan. }
    { F15 - Pencarian Anggota }
    procedure wstSearchMember(ul : UserList);
        { SPESIFIKASI : Menerima input username dari user, kemudian mencari anggota dari UserList ul
            dengan username tersebut dan menampilkan nama dan alamat user jika ada atau menampilkan
            pesan jika tidak ada. }
        { I.S. ul terdefinisi. }
        { F.S. Nama dan alamat anggota, atau pesan tidak ada anggota ditammpilkan di layar. }
    { F16 - Exit }
    procedure wstExit(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Keluar dari program. (ada opsi untuk menyimpan file)}
        { I.S. Program berjalan, semua parameter terdefinisi. }
        { F.S. Program selesai, data perpustakaan disimpan jika input Y. }

implementation

    function isKatValid(x : char):boolean;
    begin
        if (x = '>') or (x = '=') or (x = '<') or (x = '<=') or (x = '>=') then isKatValid := True
        else isKatValid := false
    end;

    procedure wstBookStockProc(var bl : BookList; bhl : BorrowHistList; lrl : LostReportList);
        var
            i, j : integer;
        begin
            for i := 1 to bl.Neff do begin
                bl.t[i]._stock := bl.t[i]._qty;
                for j := 1 to bhl.Neff do begin
                    if (bl.t[i]._id = bhl.t[j]._id) and (bhl.t[j]._status = 'belum') then begin
                        bl.t[i]._stock -= 1;
                    end;
                end;
                for j := 1 to lrl.Neff do begin
                    if (bl.t[i]._id = lrl.t[j]._id) then begin
                        bl.t[i]._stock -= 1;
                    end;
                end;
            end;
        end;

    { F01 - Registrasi }
    procedure wstRegister(var ul : UserList);
        var
            u : User;
        begin
            writeln('<o> Masukkan nama pengunjung: ');
            readln(u._fullname);
            writeln('<o> Masukkan alamat pengunjung: ');
            readln(u._address);
            writeln('<o> Masukkan username pengunjung: ');
            readln(u._username);
            writeln('<o> Masukkan password pengunjung: ');
            readPass(u._password);
            u._role := 'pengunjung';
            UserAppendList(ul, u);
            writeln('[i] Pengunjung ', u._fullname, ' berhasil terdaftar sebagai user.');   
        end;

    { F02 - Login }
    procedure wstLogin(ul : UserList; var loggedUser : User; var log : boolean);
        var
            found       : Boolean;
            uname, pass : string;
            u           : User;
        begin
            writeln('<o> Masukkan username: ');
            readln(uname);
            writeln('<o> Masukkan password: ');
            readPass(pass);
            
            found := False;
            UserSearchByUname(ul, uname, u, found);
            if (found) then
                begin
                if (pass = u._password) then
                begin
                    writeln('[i] Selamat datang ', u._fullname, '!');
                    loggedUser := u;
                    log := true;
                end else
                begin
                    writeln('[i] Username / password salah! Silakan coba lagi.');
                end;
            end else
            begin
                writeln('[i] Username / password salah! Silakan coba lagi.');
            end;
        end;
    
    { F03 - Pencarian buku berdasarkan kategori }
    procedure wstSearchBookCategory(bl : Booklist);
        var
            i, count    : integer;
            findbook    : string;
            bfl         : BookList;
        begin
            bfl.Neff := 0;

            writeln('<o> Masukkan kategori: ');
            readln(findbook);
            
            count := 0;
            if (findbook = 'sastra') or (findbook = 'sains') or (findbook = 'manga') or (findbook = 'sejarah') or (findbook = 'programming') then
            begin
                for i:=1 to bl.Neff do
                begin
                    if (findbook = (bl.t[i]._category)) then
                    begin
                        count := count + 1;
                        BookAppendList(bfl, bl.t[i]);
                    end;
                end;
                if (count = 0) then 
                begin
                    writeln('[o] Tidak ada buku dalam kategori ini.');
                end else { count > 0 }
                begin
                    BookSortList(bfl);
                    for i:=1 to bfl.Neff do begin
                        writeln((bfl.t[i]._id), ' | ', (bfl.t[i]._title), ' | ',  (bfl.t[i]._author));
                    end;
                end;
            end else
            begin
                writeln('[o] Kategori ', findbook, ' tidak valid.');
            end;
        end;

    { F04 - Pencarian buku berdasarkan tahun terbit }
    procedure wstSearchBookYear (Tabbook : BookList);
        var
            tahun, i,a : integer;
            Kategori: char;
            bfl : BookList;
        begin
            bfl.Neff := 0;
            a :=0;
            writeln('<o> Masukkan tahun: ');
            readln(tahun);
            repeat
                writeln('<o> Masukkan kategori: ');
                readln(kategori);
                if isKatValid(kategori) = false then writeln('[i] Kategori salah! Silahkan coba lagi')
            until isKatValid(kategori) = true;
            
            writeln('[o] Buku yang terbit ' ,kategori, ' ', tahun, ' :');
            for i:= 1 to LIST_NMAX do 
            begin
                if (Kategori = '=') and (Tabbook.t[i]._year <> 0) then
                begin 
                    if (Tabbook.t[i]._year = tahun) then
                    begin
                        BookAppendList(bfl, Tabbook.t[i]);
                        a := a +1 ;
                    end;
                end
                else
                if (Kategori = '<') and (Tabbook.t[i]._year <> 0) then
                begin 
                    if (Tabbook.t[i]._year < tahun) then 
                    begin
                        BookAppendList(bfl, Tabbook.t[i]);
                        a := a +1;
                    end
                end
                else
                if (Kategori = '>') and (Tabbook.t[i]._year <> 0) then
                begin 
                    if (Tabbook.t[i]._year > tahun) then 
                    begin
                        BookAppendList(bfl, Tabbook.t[i]);
                        a := a +1;
                    end
                end
                else
                if (Kategori = '<=') and (Tabbook.t[i]._year <> 0) then
                begin 
                    if (Tabbook.t[i]._year <= tahun) then 
                    begin
                        BookAppendList(bfl, Tabbook.t[i]);
                        a := a +1;
                    end
                end
                else
                if (Kategori = '>=') and (Tabbook.t[i]._year <> 0) then
                begin 
                    if (Tabbook.t[i]._year >= tahun) then 
                    begin
                        BookAppendList(bfl, Tabbook.t[i]);
                        a := a +1;
                    end
                end;
            end;
            if (a = 0) then begin
                writeln('[o] Tidak ada buku dalam kategori ini.');
            end else { a > 0 }
            begin
                BookSortList(bfl);
                for i:=1 to bfl.Neff do begin
                    writeln((bfl.t[i]._id), ' | ', (bfl.t[i]._title), ' | ',  (bfl.t[i]._author));
                end;
            end;
        end;

    procedure wstBorrowBook(var Tabbook : BookList; var TabBorrowHist : BorrowHistList; loggedUser : User);
        var
            tgl : string;
            id, ib : integer;
            tanggal : Date;
            bh : BorrowHist;
            found : boolean;
            b : Book;
        begin 
            writeln('<o> Masukkan id buku yang ingin dipinjam:');
            readln(id);
            writeln('<o> Masukkan tanggal hari ini:');
            readln(tgl);
            tanggal := toDate(tgl);

            BookSearchByID(Tabbook, id, b, ib, found);
            if found then
            begin
                if b._stock > 0 then
                begin
                    writeln('[o] Buku ', b._title, ' berhasil dipinjam!');
                    Tabbook.t[ib]._stock -= 1;
                    writeln('[o] Tersisa ', Tabbook.t[ib]._stock, ' buku ',b._title);
                    writeln('[o] Terima kasih sudah meminjam.');        
                    bh._username := loggedUser._username;
                    bh._id := id;
                    bh._borrowDate := tanggal;
                    bh._dueDate := addDate(tanggal, 7);
                    bh._Status := 'belum';
                    BorrowHistAppendList(TabBorrowHist, bh);
                end
                else
                begin 
                    writeln('[o] Buku ', b._title, ' sedang habis!');
                    writeln('[o] Coba lain kali.');
                end
            end 
            else
            begin
                writeln('[o] Tidak ada buku dengan id ', id, '.');
            end;
        end;

    procedure wstReturnBook (var Tabbook : BookList; var TabBorrowHist : BorrowHistList; var TabReturnHist : ReturnHistList; loggedUser : User);
        //prosedur utama F06 dan B02
        var
            id, ib, ibh: integer;
            tanggal:string;
            bedatgl: integer;
            b : Book;
            bh : BorrowHist;
            rh : ReturnHist;
            found1, found2 : boolean;
        begin 
            writeln('Masukkan id buku yang ingin dikembalikan:');
            readln(id);
            BookSearchByID(Tabbook, id, b, ib, found1);
            BorrowHistSearchByIDUserStatus(TabBorrowHist, id, loggedUser._username, 'belum', bh, ibh, found2);
            if (found1) and (found2) then
            begin
                writeln('[o] Data peminjaman:');
                writeln('Username: ', bh._username);  
                writeln('Judul buku: ', b._title) ;
                writeln('Tanggal peminjaman :', fromDate(bh._borrowDate));
                writeln('Tanggal batas pengembalian: ', fromDate(bh._dueDate));
                writeln('');
                writeln('<o> Masukan tanggal hari ini: ');
                readln(tanggal);
                if (compareDate(toDate(tanggal), bh._dueDate) <> 1) then
                begin
                    writeln('[o] Terima kasih sudah meminjam.');
                end
                else
                begin
                    writeln('[o] Anda terlambat mengembalikan buku.');
                    bedatgl := subDate(todate(tanggal), bh._dueDate);
                    writeln('[o] Anda terlambat ', bedatgl, ' hari');
                    writeln('[o] Anda terkena denda ', (bedatgl*2000), '.');
                end;
                Tabbook.t[ib]._stock += 1;
                TabBorrowHist.t[ibh]._status := 'sudah';
                rh._id := id;
                rh._username := loggedUser._username;
                rh._returnDate := toDate(tanggal);
                ReturnHistAppendList(TabReturnHist, rh);
            end else if not (found1) then begin
                writeln('[o] Tidak ada buku dengan id ', id, '.');
            end else begin { not (found2) }
                writeln('[o] Anda tidak meminjam buku ', b._title);
            end;
        end;

    { F07 - Melaporkan buku  hilang }
    procedure wstReportLostBook(var bl : BookList; var listHilang : LostReportList; loggedUser : User);
        { SPESIFIKASI : membaca variabel listHilang bertipe LostReportList, dan variabel listBuku bertipe BookList}
            { I.S. menerima variabel id, title, tanggal pada LostReportList }
            { F.S. menuliskan output variabel id, title, dan tanggal pada LostReportList }
        { KAMUS LOKAL }
        var
        title, tanggal : string;
        id : integer;
        lr : lostReport;
        //b : book;
        { ALGORITMA }
        begin
        {Memasukkan input data laporan kehilangan}
            {Input ID Buku}
            writeln ('<o> Masukkan id buku : '); readln (id);
            lr._id := id;
            {Input Judul Buku}
            writeln ('<o> Masukkan judul buku : '); readln (title);
            lr._title := title;
            {Input Tanggal Kehilangan}
            writeln ('<o> Masukkan tanggal pelaporan : '); readln (tanggal);
            lr._reportDate := toDate (tanggal);
            lr._username := loggedUser._username;
            {Memeasukkan semua inputan kedalam list}
            LostReportAppendList (listHilang, lr);
            writeln('[o] Laporan diterima.');
        end;

    { F08 - Lihat Laporan bukua hilang }
    procedure wstListLostReports(lrl : LostReportList; bl : BookList);
        { SPESIFIKASI : membaca inputan atribut buku, judul, serta tanggal kehilangan buku.}
        { I.S. lisHilang telah terdefinisi sebagai LoatReportLists }
        { F.S. variabel lr._id, b._title, dan fungsi fromdate (lr._reportDate) yang telah diunput pada awal prosedur }
        { KAMUS LOKAL }
        var
            i, ib: Integer;
            lr : LostReport;
            f : boolean;
            b : Book;
        { ALGORITMA }
        begin
            writeln ('[o] Buku yang hilang : ');
            for i := 1 to lrl.neff do
            begin
                lr := lrl.t[i];
                BookSearchByID(bl, lr._id, b, ib, f);
                writeln (lr._id, ' | ', b._title, ' | ', fromdate(lr._reportDate));
            end;
        end;

    { F09 - Tambah buku }
    procedure wstAddBook(var listBuku : BookList);
        { SPESIFIKASI : menulis input variabel dan di masukkan ke dalam list BookList }
        { I.S. membaca input variabel _id, _title, _author, _year, _category }
        { F.S. memasukkan variabel yang telah diinput ke list BookList }
        var
            input_buku : Book;  
        begin
            writeln ('[o] Masukkan informasi buku yang dibutuhkan : ');
            writeln ('<o> Masukkan id buku : '); readln (input_buku._id);
            writeln ('<o> Masukkan judul buku : '); readln (input_buku._title);
            writeln ('<o> Masukkan pengarang buku : '); readln (input_buku._author);
            writeln ('<o> Masukkan jumlah buku : '); readln (input_buku._qty);
            writeln ('<o> Masukkan tahun terbit buku : '); readln (input_buku._year);
            writeln ('<o> Masukkan kategori buku : '); readln (input_buku._category);
            input_buku._stock := input_buku._qty;
            BookAppendList (listbuku, input_buku);
            writeln('[i] Buku berhasil ditambahkan ke dalam sistem.')
        end;

    { F10 - Melakukan penambahan jumlah buku ke sistem }
    procedure wstAddStock(var  a : BookList);
        { SPESIFIKASI : Membaca input ID Buku dan jumlah yang akan ditambahkan}
        { I.S. ID Buku yang akan ditambah stocknya terdefinisi pada data. }
        { F.S. Buku dengan ID Buku terkait akan bertambah jumlah stocknya. }
        { KAMUS LOKAL }
        var
            idbuku : integer;
            tambah : integer;
            buku : Book;
            i : integer;
            found : boolean;
        { ALGORITMA }
        begin
            found := false;
            { Menerima masukan ID Buku dengan jumlah yang ingin ditambahkan. }
            writeln('<o> Masukkan ID Buku : ');
            readln(idbuku);
            { Mencari ID Buku yang sesuai dan melakukan penambahan quantity dan stock. }
            BookSearchByID(a, idbuku, buku, i, found);
            if (found) then begin
                writeln('<o> Masukkan jumlah buku yang ditambahkan : ');
                readln(tambah);
                a.t[i]._qty := a.t[i]._qty + tambah; { Penambahan quantity }
                a.t[i]._stock := a.t[i]._stock + tambah; { Penambahan Stock }
                writeln('[i] Pembaharuan jumlah buku berhasil dilakukan, total buku ',a.t[i]._title,' di perpustakaan menjadi ',a.t[i]._qty);
            end else begin { not found }
                writeln('[o] Tidak ada buku dengan id ', idbuku, '.');
            end;
        end;

    { F11 - Melihat riwayat peminjaman }
    procedure wstUserHist(var a : ReturnHistList; var d : BookList);
        { SPESIFIKASI : Menghitung statistik pengguna berupa admin dan pengunjung
        dan statistik buku berupa kategori}
        { I.S. a dan b terdefinisi, username yang dimasukkan terdefinisi pada data. }
        { F.S. Riwayat peminjaman pengguna terkait ditampilkan dengan format Tanggal_Pengembalian | ID_Buku | Judul Buku. }
        { KAMUS LOKAL }
        var
            username : string;
            i, j : integer;
        { ALGORITMA }
        begin
            { Menerima masukan username. }
            writeln('<o> Masukkan username pengunjung : ');
            readln(username);
            writeln('[o] Riwayat:');
            { Mencari username pada data dan riwayat peminjamannya. }
            for i := 1 to a.Neff do
            { Skema pengulangan berdasar jumlah pengulangan dengan batas akhir pengulangan
            yaitu Nilai efektif dari Array t of BorrowHist, untuk mencari username yang sama
            dengan masukan. }
            begin
                if (username = a.t[i]._username) then
                { Kondisi username masukan dengan data yang ada pada Array t of BorrowHist. }
                begin
                    for j := 1 to d.Neff do
                    { Skema pengulangan berdasar jumlah pengulangan dengan batas akhir pengulangan
                    yaitu Nilai efektif dari Array t of Book, untuk mencari ID Buku yang sama pada
                    data di Array t of BorrowHist dengan data di Array t of Book. }
                    begin
                        if (a.t[i]._id = d.t[j]._id) then
                        { Kondisi ID Buku pada Array t of BorrowHist sama dengan data ID Buku di Array t of Book. }
                        begin
                            writeln(fromDate(a.t[i]._returnDate),' | ',a.t[i]._id,' | ',d.t[j]._title);
                        end;
                    end;
                end;
            end;
        end;

    { F12 - Statistik }
    procedure wstStat(var a : UserList; var b : BookList);
        { SPESIFIKASI : Menghitung statistik pengguna berupa admin dan pengunjung
        dan statistik buku berupa kategori}
        { I.S. a dan b terdefinisi. }
        { F.S. Statistik jumlah pengguna dan jumlah buku per kategori ditampikan. }
        { KAMUS LOKAL }
        var
            i : integer;
            admin, pengunjung : integer;
            sastra, sains, manga, sejarah, programming : integer;
        { ALGORITMA }
        begin
            writeln('[o] Pengguna : ');
            admin := 0;
            pengunjung := 0;
            sastra := 0;
            sains := 0;
            manga := 0;
            sejarah := 0;
            programming := 0;
            for i := 1 to a.Neff do
            { Skema pengulangan berdasar jumlah pengulangan dengan batas akhir pengulangan
            yaitu Nilai efektif dari Array t of User, untuk menghitung jumlah pengguna yang
            terdiri dari admin dan pengunjung. }
            begin
                if (a.t[i]._role = 'admin') then
                { Kondisi peran user (_role) adalah seorang admin. }
                begin
                    admin := admin + 1;
                end else if (a.t[i]._role = 'pengunjung') then
                { Kondisi peran user (_role) adalah seorang pengunjung. }
                begin
                    pengunjung := pengunjung + 1;
                end;
            end;
            writeln('admin | ',admin);
            writeln('pengunjung | ',pengunjung);
            writeln('total | ',admin + pengunjung);
            writeln('[o] Buku : ');
            for i := 1 to b.Neff do
            { Skema pengulangan berdasar jumlah pengulangan dengan batas akhir pengulangan
            yaitu Nilai efektif dari Array t of Book, untuk menghitung jumlah buku sesuai
            dengan kategorinya masing - masing. }
            begin
                if (b.t[i]._category = 'sastra') then
                { Kondisi kategori buku (_category) adalah sastra. }
                begin
                    sastra := sastra + 1;
                end else if (b.t[i]._category = 'sains') then
                { Kondisi kategori buku (_category) adalah sains. }
                begin
                    sains := sains + 1;
                end else if (b.t[i]._category = 'manga') then
                { Kondisi kategori buku (_category) adalah manga. }
                begin
                    manga := manga + 1;
                end else if (b.t[i]._category = 'sejarah') then
                { Kondisi kategori buku (_category) adalah sejarah. }
                begin
                    sejarah := sejarah + 1;
                end else if (b.t[i]._category = 'programming') then
                { Kondisi kategori buku (_category) adalah programming. }
                begin
                    programming := programming + 1;
                end;
            end;
            writeln('sastra | ',sastra);
            writeln('sains | ',sains);
            writeln('manga | ',manga);
            writeln('sejarah | ',sejarah);
            writeln('programming | ',programming);
            writeln('total | ',sastra + sains + manga + sejarah + programming);
        end;


    { F13 - Load File }
    procedure wstLoadFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian memuat data perpustakaan dari
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data perpustakaan dimuat di list data. }
        { KAMUS LOKAL }
        var
            sb, su, sbh, srh, slr : string;
        { ALGORITMA }
        begin
            { Menerima nama file }
            writeln('<o> Masukkan nama File Buku: ');
            readln(sb);
            writeln('<o> Masukkan nama File User: ');
            readln(su);
            writeln('<o> Masukkan nama File Peminjaman: ');
            readln(sbh);
            writeln('<o> Masukkan nama File Pengembalian: ');
            readln(srh);
            writeln('<o> Masukkan nama File Buku Hilang: ');
            readln(slr);
            { Membaca isi file dan memuat data ke list }
            assign(fb, sb);
            reset(fb);
            BookLoadListFromCSV(fb, bl);
            close(fb);
            assign(fu, su);
            reset(fu);
            UserLoadListFromCSV(fu, ul);
            close(fu);
            assign(fbh, sbh);
            reset(fbh);
            BorrowHistLoadListFromCSV(fbh, bhl);
            close(fbh);
            assign(frh, srh);
            reset(frh);
            ReturnHistLoadListFromCSV(frh, rhl);
            close(frh);
            assign(flr, slr);
            reset(flr);
            LostReportLoadListFromCSV(flr, lrl);
            close(flr);
            wstBookStockProc(bl, bhl, lrl);
            writeln('[i] File perpustakaan berhasil dimuat!')
        end;

    { F14 - Save File }
    procedure wstSaveFile(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Membaca input nama-nama file kemudian menyimpan data perpustakaan ke
            file-file terseubut. }
        { I.S. Semua parameter terdeklarasi, parameter list terdefinisi. }
        { F.S. Data perpustakaan disimpan. }
        { KAMUS LOKAL }
        var
            sb, su, sbh, srh, slr : string;
        { ALGORITMA }
        begin
            { Menerima nama file }
            writeln('<o> Masukkan nama File Buku: ');
            readln(sb);
            writeln('<o> Masukkan nama File User: ');
            readln(su);
            writeln('<o> Masukkan nama File Peminjaman: ');
            readln(sbh);
            writeln('<o> Masukkan nama File Pengembalian: ');
            readln(srh);
            writeln('<o> Masukkan nama File Buku Hilang: ');
            readln(slr);
            { Membaca isi file dan memuat data ke list }
            assign(fb, sb);
            rewrite(fb);
            BookSaveListToCSV(fb, bl);
            close(fb);
            assign(fu, su);
            rewrite(fu);
            UserSaveListToCSV(fu, ul);
            close(fu);
            assign(fbh, sbh);
            rewrite(fbh);
            BorrowHistSaveListToCSV(fbh, bhl);
            close(fbh);
            assign(frh, srh);
            rewrite(frh);
            ReturnHistSaveListToCSV(frh, rhl);
            close(frh);
            assign(flr, slr);
            rewrite(flr);
            LostReportSaveListToCSV(flr, lrl);
            close(flr);
            writeln('[i] Data berhasil disimpan!')
        end;

    { F15 - Pencarian Anggota }
    procedure wstSearchMember(ul : UserList);
        { SPESIFIKASI : Menerima input username dari user, kemudian mencari anggota dari UserList ul
            dengan username tersebut dan menampilkan nama dan alamat user jika ada atau menampilkan
            pesan jika tidak ada. }
        { I.S. ul terdefinisi. }
        { F.S. Nama dan alamat anggota, atau pesan tidak ada anggota ditammpilkan di layar. }
        { KAMUS LOKAL }
        var
            i : integer;
            uname : string;
        begin
        { ALGORITMA }
            writeln('<o> Masukkan username: ');
            readln(uname);
            i := 1;
            while (uname <> ul.t[i]._username) and (i < ul.Neff) do begin
                i += 1;
            end;
            if (uname = ul.t[i]._username) then begin
                writeln('[o] Nama Anggota: ', ul.t[i]._fullname);
                writeln('[o] Alamat Anggota: ', ul.t[i]._address);
            end else begin { uname <> bl.t[i]._username }
                writeln('[o] Tidak ada anggota dengan username ', uname);
            end;
        end;

    { F16 - Exit }
    procedure wstExit(
            var fb, fu, fbh, frh, flr : text;
            var bl : BookList;
            var ul : Userlist;
            var bhl : BorrowHistList;
            var rhl : ReturnHistList;
            var lrl : LostReportList
        );
        { SPESIFIKASI : Keluar dari program. (ada opsi untuk menyimpan file)}
        { I.S. Program berjalan, semua parameter terdefinisi. }
        { F.S. Program selesai, data perpustakaan disimpan jika input Y. }
        { KAMUS LOKAL }
        var
            s : string;
        { ALGORITMA }
        begin
            { Menerima input secara terus-menerus sampai input Y atau N}
            repeat
                writeln('<o> Simpan file? (Y/N): ');
                readln(s);
            until (s = 'Y') or (s = 'N');
            if (s = 'Y') then begin
                wstSaveFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
            end; {else do nothing}
        end;

end.