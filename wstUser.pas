unit wstUser;

{ Unit wstUser mendefinisikan tipe data User, Userlist, fungsi, dan prosedur yang terkait. }

interface
    uses wstCore;

    { Tipe data User adalah representasi user dengan variabel anggota :
        _fullname   : nama lengkap user
        _address    : alamat user
        _username   : username
        _password   : password user
        _role       : peran user (admin atau pengunjung)   
    }
    type User = record
        _fullName, _address, _username, _password, _role : string;
    end;

    { Tipe data UserList adalah daftar User dengan variabel anggota :
        t           : array dengan tipe elemen User dan ukuran LIST_NMAX yang didefinisikan di unit wstCore
        Neff        : ukuran efektif array (banyak elemen array yang terisi)
    }
    type UserList = record
        t : array [1 .. LIST_NMAX] of User;
        Neff : integer
    end;

    { Deklarasi fungsi/prosedur terkait User dan UserList }
    procedure UserWriteToCSV(var f : text; u : User);
        { SPESIFIKASI : Memasukkan entri User u di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, u terdefinisi. }
        { F.S. entri baru dengan nilai dari u pada baris paling bawah file f. }
    procedure UserSaveListToCSV(var f : text; ul : UserList);
        { SPESIFIKASI : Menyimpan UserList ul ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, ul terdefinisi. }
        { F.S. f berisi data dari ul }
    procedure UserReadFromCSV(var f : text; var u : User);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada User u. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. u terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
    procedure UserLoadListFromCSV(var f : text; var ul : UserList);
        { SPESIFIKASI : Memuat file csv f ke dalam Userlist ul. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. ul berisi data dari file csv f.}
    procedure UserAppendList(var ul : UserList; u : User);
        { SPESIFIKASI : Melakukan append User u ke Userlist ul. 
            u diletakkan di elemen terakhir ul jika array belum penuh. }
        { I.S. ul berukuran n }
        { F.S. ul berukuran n + 1 dengan elemen ke n + 1 adalah u. }
    
implementation

    procedure UserWriteToCSV(var f : text; u : User);
        { SPESIFIKASI : Memasukkan entri User u di file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, u terdefinisi. }
        { F.S. entri baru dengan nilai dari u pada baris paling bawah file f. }
        { ALGORITMA }
        begin
            write(f, u._fullname, ',', u._address, ',', u._username, ',', u._password, ',', u._role, #13, #10);
        end;

    procedure UserSaveListToCSV(var f : text; ul : UserList);
        { SPESIFIKASI : Menyimpan UserList ul ke dalam format file csv f. }
        { I.S. f dibuka dengan mode rewrite/write, ul terdefinisi. }
        { F.S. f berisi data dari ul }
        { KAMUS LOKAL }
        var
            i : integer;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header }
            write(f, 'Nama,Alamat,Username,Password,Role', #13, #10);
            { Proses pengulangan dengan jumlah pengulangan tertentu untuk mengisi file }
            for i := 1 to ul.Neff do begin
                { Menulis data buku pada baris selanjutnya }
                UserWriteToCSV(f, ul.t[i]);
            end;
        end;

    procedure UserReadFromCSV(var f : text; var u : User);
        { SPESIFIKASI : Membaca satu baris entri pada file csv dan menyimpannya pada User u. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. u terdefinisi dengan nilai dari entri pada file csv, prosedur dapat mambaca baris selanjutnya. }
        { ALGORITMA }
        begin
            readCSVStrDelim(f, u._fullname, ',');
            readCSVStrDelim(f, u._address, ',');
            readCSVStrDelim(f, u._username, ',');
            readCSVStrDelim(f, u._password, ',');
            readCSVStrDelim(f, u._role, #10);
        end;

    procedure UserLoadListFromCSV(var f : text; var ul : UserList);
        { SPESIFIKASI : Memuat file csv f ke dalam Userlist ul. }
        { I.S. f dibuka dengan mode reset/read. }
        { F.S. ul berisi data dari file csv f.}
        { KAMUS LOKAL }
        var
            u : User;
        { ALGORITMA }
        begin
            { Baris pertama file adalah header. dibaca, tetapi tidak diproses }
            UserReadFromCSV(f, u);
            { Proses sekuensial dengan MARK (MARK = LIST_NMAX atau eof) untuk membaca entri
                per baris, kemudian melakukan append ke list selama }
            ul.Neff := 0;
            while (not eof(f)) and (ul.Neff < LIST_NMAX) do begin
                UserReadFromCSV(f, u);
                UserAppendList(ul, u);
            end;
        end;

    procedure UserAppendList(var ul : UserList; u : User);
        { SPESIFIKASI : Melakukan append User u ke Userlist ul. 
            u diletakkan di elemen terakhir ul jika array belum penuh. }
        { I.S. ul berukuran n }
        { F.S. ul berukuran n + 1 dengan elemen ke n + 1 adalah u. }
        begin
            if (ul.Neff < LIST_NMAX) then begin
                ul.Neff += 1;
                ul.t[ul.Neff] := u;
            end;
        end;
end.