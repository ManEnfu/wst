program wstMain;

uses wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstLostReport,
	wstFileDataSys;
(*
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
		write('<o> Masukkan nama File Buku: ');
		readln(sb);
		write('<o> Masukkan nama File User: ');
		readln(su);
		write('<o> Masukkan nama File Peminjaman: ');
		readln(sbh);
		write('<o> Masukkan nama File Pengembalian: ');
		readln(srh);
		write('<o> Masukkan nama File Buku Hilang: ');
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
		//BookStockCalc(bl, bhl, lrl);
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
		write('<o> Masukkan nama File Buku: ');
		readln(sb);
		write('<o> Masukkan nama File User: ');
		readln(su);
		write('<o> Masukkan nama File Peminjaman: ');
		readln(sbh);
		write('<o> Masukkan nama File Pengembalian: ');
		readln(srh);
		write('<o> Masukkan nama File Buku Hilang: ');
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
		write('<o> Masukkan username: ');
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
		{ Menerima inpit secara terus-menerus sampai input Y atau N}
		repeat
			write('<o> Simpan file? (Y/N): ');
			readln(s);
		until (s = 'Y') or (s = 'N');
		if (s = 'Y') then begin
			wstSaveFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
		end; {else do nothing}
	end;
*)
var
	fb, fu, fbh, frh, flr : text;
	bl : BookList;
	ul : Userlist;
	bhl : BorrowHistList;
	rhl : ReturnHistList;
	lrl : LostReportList;
	b : Book;
	u : User;
	bh : BorrowHist;
	rh : ReturnHist;
	lr : LostReport;
	i : integer;
	s : string;
	found : boolean;
begin
	writeln('\            ______________');
	writeln(' \   \      /  /      |    ');
	writeln('  \   \/   /   \___   |    ');
	writeln('   \  /\  /        \  |    ');
	writeln('    \/  \/ ________/  |    ');
	repeat
		write('(o) : ');
		readln(s);
		if (s = 'load') then begin
			wstLoadFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
			for i := 1 to bl.Neff do begin
				b := bl.t[i];
				writeln(b._id, ' | ', b._title, ' | ', b._author, ' | ', b._qty, ' | ', b._stock, ' | ', b._year, ' | ', b._category);
			end;
			writeln(' ');
			for i := 1 to ul.Neff do begin
				u := ul.t[i];
				writeln(u._fullname, ',', u._address, ',', u._username, ',', u._password, ',', u._role);
			end;
			writeln(' ');
			for i := 1 to bhl.Neff do begin
				bh := bhl.t[i];
				writeln(bh._username, ',', bh._id, ',', fromDate(bh._borrowDate), ',', fromDate(bh._dueDate), ',', bh._status);
			end;
			writeln(' ');
			for i := 1 to rhl.Neff do begin
				rh := rhl.t[i];
				writeln(rh._username, ',', rh._id, ',', fromDate(rh._returnDate));
			end;
			writeln(' ');
			for i := 1 to lrl.Neff do begin
				lr := lrl.t[i];
				writeln(lr._username, ',', lr._id, ',', fromDate(lr._reportDate));
			end;
		end else if (s = 'find') then begin
			readln(i);
			BookSearchByID(bl, i, b, found);
			if (found) then begin
				writeln(b._id, ' | ', b._title, ' | ', b._author, ' | ', b._qty, ' | ', b._stock, ' | ', b._year, ' | ', b._category);
			end else begin
				writeln('not found');
			end;
		end else if (s = 'save') then begin
			wstSaveFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
		end else if (s = 'carianggota') then begin
			wstSearchMember(ul);
		end else  if (s = 'keluar') then begin
			wstExit(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
		end else begin

		end;
	until (s = 'keluar');
end.d