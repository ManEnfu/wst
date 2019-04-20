unit wstPinjam;

interface
	uses  wstCore, wstBook, wstUser, wstBorrowHist, wstReturnHist, wstFileDataSys;
	{F05 - Peminjaman Buku}
	procedure pinjam (var Tabbook : BookList; TabBorrowHist:BorrowHistList;TabUserlist : UserList);
	
	{ SPESIFIKASI : Membaca input id buku dan tanggal peminjaman kemudian memberitahu data peminjaman buku. }
        { I.S. Semua parameter terdeklarasi. }
        { F.S. Data dimuat di list data. }
	
implementation
	function addweek (d: Date):string;
	//d.d=tgl / d.m=bln / d.y=thn

	begin
		if (d.m=1) or (d.m=3) or (d.m=5) or (d.m=7) or (d.m=8) or (d.m=10) then
		begin
			if (d.d <=24)then
			begin
				d.d := d.d + 7;
			end
			else 
				d.d := d.d - 24;
				d.m := d.m +1;
			end
			else if (d.m=2) then
			begin
				if (d.y mod 100 = 0) then
				begin
					if (d.y mod 400 = 0) then
					begin
						if (d.d<=22) then
						begin
							d.d := d.d + 7;
						end
						else 	
							d.d:= d.d + 22;
							d.m := d.m +1;
					end
					else
					begin
						if (d.d<=21) then
						begin
							d.d := d.d + 7;
						end
						else 
							d.d:= d.d + 21;
							d.m := d.m +1;
					end
				end
				else if (d.y mod 4 = 0) then
				begin
					if (d.d<=22) then
					begin
						d.d := d.d + 7;
					end
					else 
						d.d:= d.d + 22;
						d.m := d.m +1;
					end				
					else
					begin
					if (d.d<=21) then
					begin
						d.d := d.d + 7;
					end
					else 
						d.d:= d.d + 21;
						d.m := d.m +1;
					end
				end
				
			else if (d.m=4) or (d.m=6) or (d.m=9) or (d.m=11) then
				begin	
					if (d.d <=23) then
					begin
						d.d := d.d + 7;
					end
					else 
						d.d := d.d - 23;
						d.m := d.m +1;
				end
			else if (d.m=12) then
			begin
				if (d.d <=24)then
				begin	
					d.d := d.d + 7;
				end
				else 
				begin
					d.d := d.d - 24;
					d.y := d.y + 1;
					d.m := 1;
				end	
			end;
			addweek := fromDate(d);
		end;

	procedure pinjam (var Tabbook : BookList; TabBorrowHist:BorrowHistList;TabUserlist : UserList);
	var
		tgl : string;
		id, i, NewIndex: integer;
		tanggal : Date;
	begin 
		writeln('Masukkan id buku yang ingin dipinjam:');
		readln(id);
		writeln('Masukkan tanggal hari ini:');
		readln(tgl);
		tanggal := toDate(tgl);

		for i:=1 to LIST_NMAX do
		begin
			if (Tabbook.t[i]._id = id) then
			begin
				if Tabbook.t[i]._stock > 0 then
				begin
					writeln('Buku ', Tabbook.t[i]._title, ' berhasil dipinjam!');
					Tabbook.t[i]._stock := Tabbook.t[i]._stock - 1;
					writeln('Tersisa ', Tabbook.t[i]._stock, ' buku ',Tabbook.t[i]._title);
					writeln('Terima kasih sudah meminjam.');
							
					NewIndex := TabBorrowHist.Neff+1;
					TabBorrowHist.t[NewIndex]._username := TabUserList.t[i]._username;
					TabBorrowHist.t[NewIndex]._id := id;
					TabBorrowHist.t[NewIndex]._borrowDate := tanggal;
					TabBorrowHist.t[NewIndex]._dueDate := toDate(addweek(tanggal));
					TabBorrowHist.t[NewIndex]._Status := 'Dipinjam';
					
				
				end
				else
				begin 
					writeln('Buku ', Tabbook.t[i]._title, ' sedang habis!');
					writeln('Coba lain kali.');
				end
			end	
	
		end;

	end;
Begin
end.
