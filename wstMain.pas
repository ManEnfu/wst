program wstMain;

uses wstCore, wstBook;

var
	d1, d2 : Date;
	fb : text;
	bl : BookList;
	b : Book;
	i : integer;
begin
	d1.d := 12;
	d1.m := 05;
	d1.y := 2003;
	d2 := toDate('12/05/8003');
	writeln(fromDate(d1));
	writeln(fromDate(d2));
	writeln(compareDate(d1,d2));
	assign(fb, 'bookdb.csv');
	reset(fb);
	BookLoadListFromCSV(fb, bl);
	for i := 1 to bl.Neff do begin
		b := bl.t[i];
		writeln(b._id, ' | ', b._title, ' | ', b._author, ' | ', b._qty, ' | ', b._year, ' | ', b._category);
	end;

	close(fb);
	bl.t[bl.Neff + 1] := b;
	bl.Neff += 1; 
	rewrite(fb);
	BookSaveListToCSV(fb, bl);
	close(fb);
end.