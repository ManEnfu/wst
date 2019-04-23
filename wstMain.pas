program wstMain;
{ Program utama, mmemuat loop utama untuk menerima perintah }
uses wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstLostReport,
    wstFileDataSys, crt;

procedure wstDispLogo();
    { SPESIFIKASI : Menampilkan logo di pojok kiri atas layar. }
    { I.S. - }
    { F.S. Logo tercetak di pojok kiri atas layar. }
    var 
        i : integer;
    begin
        window(1, 1, 33, 25);
        clrscr;
        write('_______________________________ |');
        write('|                             | |');
        write('| \            ______________ | |');
        write('|  \   \      /  /      |     | |');
        write('|   \   \/   /   \___   |     | |');
        write('|    \  /\  /        \  |     | |');
        write('|     \/  \/ ________/________| |');
        write('|___________/ Library Systems.| |');
        write('|_____________________________| |');
        write('________________________________|');
        write('                                |');
        write('                                |');
        write('________________________________|');
        for i := 14 to 24 do begin
            write('                                |');
        end;
    end;

procedure wstDispLogin(isLogged : boolean; loggedUser : User); 
    { SPESIFIKASI : Menampilkan user yang login jika isLogged bernilai true dan menampilkan pesan
        'Not logged in.' jika isLogged bernilai false. }
    { I.S. isLogged dan loggedUser terdefinisi. }
    { F.S. Username yang sedang login atau pesan tercetak pada layar. }
    begin
        window(1, 11, 32, 12);
        clrscr;
        if isLogged then begin
            writeln('Logged in as: ');
            write(loggedUser._username);
        end else begin
            writeln('Not logged in');
            write(' ')
        end;
    end;

procedure wstDispMainMenu(var s : string; isLogged : boolean; loggedUser : User);
    { SPESIFIKASI : Menampilkan menu utama dan menerima input pulihan menu. 
        Menu utama berupa list pilihan yang bisa dipilih dengan menekan tombol
        arah atas-bawah atau w-s dan enter. Menu yang ditampilkan bergantung pada
        adanya user yang login dan role user yang login. }
    { I.S. isLogged dan loggedUser terdefinisi. }
    { In.S. Menu ditampilkan pada layar. }
    { F.S. Salah sat pilihan menu terpilih dan disimpan pada string s untuk kemudian diproses. }
    var
        ch1, ch2 : char;
        i : integer;
        updscr : boolean;
        msAdmin : array [1..13] of  string = (
                'register', 'login', 'cari kategori', 'cari tahun terbit', 'lihat laporan',
                'tambah buku', 'tambah jumlah buku', 'riwayat', 'statistik',
                'load', 'save', 'cari anggota', 'keluar'
            );
        msVisitor : array [1..10] of  string = (
                'login', 'cari kategori', 'cari tahun terbit',
                'pinjam buku', 'kembalikan buku', 'lapor buku hilang',
                'load', 'save', 'cari anggota', 'keluar'
            );
        msGuest : array [1..7] of  string = (
                'login', 'cari kategori', 'cari tahun terbit',
                'load', 'save', 'cari anggota', 'keluar'
            );
    begin
        ch1 := #0;
        ch2 := #0;
        i := 1;
        updscr := true;
        window(1, 14, 32, 25);
        repeat
            if (updscr) then begin
                clrscr;
                if (isLogged) then begin
                    if (loggedUser._role = 'admin') then begin
                        if (i < 13) then begin
                            i += 13;
                        end; { else do nothing }
                        writeln('        ^');
                        writeln(' ', msAdmin[((i - 3) mod 13) + 1]);
                        writeln(' ', msAdmin[((i - 2) mod 13) + 1]);
                        writeln('>', msAdmin[((i - 1) mod 13) + 1]);
                        writeln(' ', msAdmin[((i) mod 13) + 1]);
                        writeln(' ', msAdmin[((i + 1) mod 13) + 1]);
                        write('        v');
                        s := msAdmin[((i - 1) mod 13) + 1];
                    end else begin
                        if (i < 10) then begin
                            i += 10;
                        end; { else do nothing }
                        writeln('        ^');
                        writeln(' ', msVisitor[((i - 3) mod 10) + 1]);
                        writeln(' ', msVisitor[((i - 2) mod 10) + 1]);
                        writeln('>', msVisitor[((i - 1) mod 10) + 1]);
                        writeln(' ', msVisitor[((i) mod 10) + 1]);
                        writeln(' ', msVisitor[((i + 1) mod 10) + 1]);
                        writeln('        v');
                        s := msVisitor[((i - 1) mod 10) + 1];
                    end;
                end else begin
                    if (i < 7) then begin
                        i += 7;
                    end; { else do nothing }
                    writeln('        ^');
                    writeln(' ', msGuest[((i - 3) mod 7) + 1]);
                    writeln(' ', msGuest[((i - 2) mod 7) + 1]);
                    writeln('>', msGuest[((i - 1) mod 7) + 1]);
                    writeln(' ', msGuest[((i) mod 7) + 1]);
                    writeln(' ', msGuest[((i + 1) mod 7) + 1]);
                    writeln('        v');
                    s := msGuest[((i - 1) mod 7) + 1];
                end;
                updscr := false;
            end;
            ch2 := ch1;
            ch1 := readKey;
            if ((ch1 = #72) and (ch2 = #0)) or (ch1 = 'W') or (ch1 = 'w') then begin
                i -= 1;
                updscr := true;
            end else if ((ch1 = #80) and (ch2 = #0)) or (ch1 = 'S') or (ch1 = 's') then begin
                i += 1;
                updscr := true;
            end; { else do nothing }
        until (ch1 = #13);
    end;

{ KAMUS }
var
    { Variabel file }
    fb, fu, fbh, frh, flr : text;
    { Variabel list }
    bl : BookList;
    ul : Userlist;
    bhl : BorrowHistList;
    rhl : ReturnHistList;
    lrl : LostReportList;
    { Variabel sistem }
    loggedUser : User;
    i : integer;
    s : string;
    isLogged: boolean;
{ ALGORITMA }
begin
    { Inisialisasi }
    s := '';
    isLogged := false;
    { Menampilkan menu. }
    wstDispLogo();
    window(34, 1, 80, 25);
    { Program akan memuat file terlebih dahulu }
    wstLoadFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
    { Loop untuk menerima pilihan menu dan mengeksekusi fungsionalitas sesuai pilihan menu }
    repeat
        wstDispLogin(isLogged, loggedUser);
        wstDispMainMenu(s, isLogged, loggedUser);
        window(34, 1, 80, 25);
        clrscr;
        if (s = 'register') then begin
            wstRegister(ul);
        end else if (s = 'login') then begin
            wstLogin(ul, loggedUser, isLogged);
        end else if (s = 'cari kategori') then begin
            wstSearchBookCategory(bl);
        end else if (s = 'cari tahun terbit') then begin
            wstSearchBookYear(bl);
        end else if (s ='pinjam buku') then begin
            wstBorrowBook(bl, bhl, loggedUser);
        end else if (s = 'kembalikan buku') then begin
            wstReturnBook(bl, bhl, rhl, loggedUser);
        end else if (s = 'lapor buku hilang') then begin
            wstReportLostBook(bl, lrl, loggedUser);
        end else if (s = 'lihat laporan') then begin
            wstListLostReports(lrl, bl);
        end else if (s = 'tambah buku') then begin
            wstAddBook(bl);
        end else if (s = 'tambah jumlah buku') then begin
            wstAddStock(bl);
        end else if (s = 'riwayat') then begin
            wstUserHist(rhl, bl);
        end else if (s = 'statistik') then begin
            wstStat(ul, bl);
        end else if (s = 'load') then begin
            wstLoadFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
        end else if (s = 'save') then begin
            wstSaveFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
        end else if (s = 'cari anggota') then begin
            wstSearchMember(ul);
        end else  if (s = 'keluar') then begin
            wstExit(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
        end else begin
        end;
    until (s = 'keluar'); { s = 'keuar', dipilih menu keluar, loop berhenti dan program keluar. }
end.