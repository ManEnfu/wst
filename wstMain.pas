program wstMain;

uses wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstLostReport;

{ F13 - Load File }
procedure wstLoadFile(
		var fb, fu, fbh, frh, flr : text;
		var bl : BookList;
		var ul : Userlist;
		var bhl : BorrowHistList;
		var rhl : ReturnHistList;
		var lrl : LostReportList
	);
	var
		sb, su, sbh, srh, slr : string;
	begin
		writeln('Masukkan nama File Buku: ');
		readln(sb);
		writeln('Masukkan nama File User: ');
		readln(su);
		writeln('Masukkan nama File Peminjaman: ');
		readln(sbh);
		writeln('Masukkan nama File Pengembalian: ');
		readln(srh);
		writeln('Masukkan nama File Buku Hilang: ');
		readln(slr);
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
	var
		sb, su, sbh, srh, slr : string;
	begin
		writeln('Masukkan nama File Buku: ');
		readln(sb);
		writeln('Masukkan nama File User: ');
		readln(su);
		writeln('Masukkan nama File Peminjaman: ');
		readln(sbh);
		writeln('Masukkan nama File Pengembalian: ');
		readln(srh);
		writeln('Masukkan nama File Buku Hilang: ');
		readln(slr);
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

{ F15 - Cari Anggota }

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
begin
	wstLoadFile(fb, fu, fbh, frh, flr, bl, ul, bhl, rhl, lrl);
	for i := 1 to bl.Neff do begin
		b := bl.t[i];
		writeln(b._id, ' | ', b._title, ' | ', b._author, ' | ', b._qty, ' | ', b._year, ' | ', b._category);
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
end.