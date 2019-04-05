unit wstBook;

interface
	uses wstCore;

	type Book = record
		_id, _qty, _year : integer;
		_title, _author, _category : string;
	end;

	type BookList = record
		t : array [1 .. LIST_NMAX] of Book;
		Neff : integer
	end;

	procedure BookWriteToCSV(var f : text; b : book);

	procedure BookSaveListToCSV(var f : text; bl : BookList);

	procedure BookReadFromCSV(var f : text; var b : Book);

	procedure BookLoadListFromCSV(var f : text; var bl : BookList);
	
implementation

	procedure BookWriteToCSV(var f : text; b : book);
		begin
			write(f, b._id, ',', b._title, ',', b._author, ',', b._qty, ',', b._year, ',', b._category, #10);
		end;

	procedure BookSaveListToCSV(var f : text; bl : BookList);
		var
			i : integer;
		begin
			write(f, 'ID_Buku,Judul_Buku,Author,Jumlah_Buku,Tahun_Penerbit,Kategori', #10);
			for i := 1 to bl.Neff do begin
				BookWriteToCSV(f, bl.t[i]);
			end;
		end;

	procedure BookReadFromCSV(var f : text; var b : Book);
		begin
			readCSVUIntDelim(f, b._id, ',');
			readCSVStrDelim(f, b._title, ',');
			readCSVStrDelim(f, b._author, ',');
			readCSVUIntDelim(f, b._qty, ',');
			readCSVUIntDelim(f, b._year, ',');
			readCSVStrDelim(f, b._category, #10);
		end;

	procedure BookLoadListFromCSV(var f : text; var bl : BookList);
		var
			b : Book;
		begin
			BookReadFromCSV(f, b);
			bl.Neff := 0;
			while (not eof(f)) and (bl.Neff < LIST_NMAX) do begin
				BookReadFromCSV(f, b);
				bl.Neff += 1;
				bl.t[bl.Neff] := b;
			end;
		end;
end.