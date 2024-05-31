--a,Procedure
/*1. In ra dòng ‘Xin chào’.*/
create proc PrintGreeting
AS
begin
    SET NOCOUNT ON;
    DECLARE @Greeting NVARCHAR(20);
    SET @Greeting = N'Xin chào';
    PRINT @Greeting;
end;
exec PrintGreeting;
/*2. In ra dòng ‘Xin chào’ + @ten với @ten là tham số đầu vào là tên của bạn. 
Cho thực thi và in giá trị của các tham số này để kiểm tra*/
create proc PrintMyName @Name nvarchar(30)
as
begin
    set nocount on;
	declare @Greeting nvarchar(100);
	set @Greeting=N'Xin chào '+@Name;
	Print @Greeting;
end;
exec PrintMyName N'Đỗ Mạnh Cường';
/*3,Nhập vào 2 số @s1,@s2. Xuất tổng @s1+@s2 ra tham số @tong.*/
create proc PrintSum @s1 int,@s2 int, @tong int out
as
begin
   set nocount on;
   set @tong=@s1+@s2;
   declare @printTong nvarchar(20);
   set @printTong=N'tổng là : '+convert(nvarchar(2),@tong);
   print @printTong;
end
declare @sum int;
exec PrintSum 5,10,@sum;
/*4,Nhập vào 2 số @s1,@s2. In ra câu ‘Số lớn nhất của @s1 và @s2 là max’ 
với @s1,@s2,max là các giá trị tương ứng*/
create proc PrintMinandMax @So1 int, @So2 int, @Max int out,@Min int out
as
begin
    set nocount on;
	if @So1>@So2
	begin
	   set @Max=@So1;
	   set @Min=@So2;
    end
    else
	begin
	   set @Max=@So2;
	   set @Min=@So1;
    end
end
declare @maxEle int, @minEle int,@maxEleDis nvarchar(50),@minEleDis nvarchar(50);
exec PrintMinandMax 6,-2,@maxEle out,@minEle out
set @maxEleDis=N'Số lớn nhất của 6 và -2 là '+convert(nvarchar(2),@maxEle);
set @minEleDis=N'Số lớn nhất của 6 và -2 là '+convert(nvarchar(2),@minEle);
print @maxEleDis;
print @minEleDis;
/*6. Nhập vào số nguyên @n. In ra các số từ 1 đến @n*/
create proc PrintSmallerN @n int
as
begin
   set nocount on;
   declare @i int=1;
   while @i<@n
    begin
	print @i;
	set @i=@i+1;
	end
end
exec PrintSmallerN 100
/*7. Nhập vào số nguyên @n. In ra tổng các số chẵn từ 1 đến @n*/
create proc PrintEvenSmallerN @n int
as
begin
    set nocount on;
	declare @i int =0,@tong int =0;
	while @i<@n
	 begin
	   set @tong=@tong+@i;
	   set @i=@i+2;
     end
	 print @tong
end
exec PrintEvenSmallerN 10;
drop proc PrintEvenSmallerN
/*8,Nhập vào số nguyên @n. In ra tổng và số lượng các số chẵn từ 1 đến @n .Cho thực thi và in giá trị của các tham số này để kiểm tra.*/
create proc PrintEvenCount @n int
as
begin
    set nocount on;
	declare @i int =0,@tong int =0,@count int =0;
	while @i<@n
    begin
	  set @tong=@tong+@i;
	  set @count=@count+1;
	  set @i=@i+2;
	end
	declare @printSum nvarchar(50),@printCount nvarchar(50);
	set @printSum=N'Tổng các số chẵn là '+CONVERT(nvarchar(4),@tong);
	set @printCount=N'Số lượng các số chẵn là '+convert(nvarchar(4),@count);
	print @printSum;
	print @printCount;
end
exec PrintEvenCount 10;
drop proc PrintEvenCount
go

/*9. Viết store procedure tương ứng với các câu ở phần View. Sau đó cho thực hiện để kiểm tra kết quả*/
use QLBongDa
--View 1
create proc procView1 @TENCLB nvarchar(50),@TENQG nvarchar(50)
as
begin
  select MACT,HOTEN,NGAYSINH,DIACHI,VITRI from CAUTHU 
  join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB 
  join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
  where CAULACBO.TENCLB = @TENCLB 
  and QUOCGIA.TENQG=@TENQG
end
exec procView1 N'SHB Đà Nẵng',N'Brazil'
drop proc procView1
go
-- View 2
create proc procView2 @VONG int, @NAM int
as
begin 
   select MATRAN, NGAYTD, TENSAN, clb1.TENCLB, clb2.TENCLB, KETQUA from TRANDAU 
   join CAULACBO clb1 on TRANDAU.MACLB1=clb1.MACLB 
   join CAULACBO clb2 on TRANDAU.MACLB2=clb2.MACLB 
   join SANVD on TRANDAU.MASAN=SANVD.MASAN
   where VONG=@VONG and NAM=@NAM
end
exec procView2 3,2009;
drop proc procView2;
go

-- View 3
create proc procView3 @MAQG nvarchar(4)
as
begin
   select HUANLUYENVIEN.MAHLV,TENHLV,NGAYSINH,DIACHI,VAITRO,TENCLB from HLV_CLB 
   join HUANLUYENVIEN on HLV_CLB.MAHLV=HUANLUYENVIEN.MAHLV 
   join CAULACBO on HLV_CLB.MACLB=CAULACBO.MACLB
   where HUANLUYENVIEN.MAQG=@MAQG
end
exec procView3 N'VN';
drop proc procView3;
go

-- View 4 
create proc procView4 @MAQG nvarchar(4), @COUNT int
as
begin 
   select CAULACBO.MACLB,CAULACBO.TENCLB,TENSAN,SANVD.DIACHI,count(MACT) as SOLUONGCAUTHU 
   from CAULACBO 
   join SANVD on CAULACBO.MASAN=SANVD.MASAN 
   join CAUTHU on CAULACBO.MACLB=CAUTHU.MACLB 
   where CAUTHU.MAQG not like @MAQG 
   group by CAULACBO.MACLB,CAULACBO.TENCLB,TENSAN,SANVD.DIACHI 
   having count(MACT)>@COUNT;
end
exec procView4 N'VN',2
drop proc procView4;
go

/*10, Ứng với mỗi bảng trong CSDL Quản lý bóng đá, bạn hãy viết 4 Stored Procedure ứng với 4 công việc Insert/Update/Delete/Select. Trong đó Stored Procedure Update và Delete lấy khóa chính làm tham số*/

create proc insertTinh @MATINH varchar(5),@TENTINH nvarchar(100),@result nvarchar(100)
as
begin
   declare @count int =0,@errorDiag nvarchar(100),@error int=0,@id int=0;
   select @count=COUNT(MATINH) from TINH where TINH.MATINH=@MATINH;
   if @count>0
      begin
	    set @errorDiag=N'Đã tồn tại tỉnh';
		print @errorDiag;
      end
   else 
    begin
      insert into TINH(MATINH,TENTINH) values (@MATINH,@TENTINH);
	  SELECT @error = @@ERROR, @id = SCOPE_IDENTITY(); 
			if @error = 0
				set @result = N'Đã tạo dữ liệu cho mã tỉnh là: '+@MATINH;
			else
				set @result= N'Đã xảy ra lỗi tạo dữ liệu với mã lỗi: '+@id;
	end;
end;
declare @printResult nvarchar(100);
exec insertTinh HP,N'Hải Phòng',@printResult;
print @printResult;
drop proc insertTinh;
go;

--b,Trigger
/*1,Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cần thủ chỉ thuộc một trong các vị trí sau: Thủ môn, Tiền đạo, Tiền vệ, Trung vệ, Hậu vệ.*/
create trigger trigCauThu on CAUTHU
for insert
as 
  DECLARE @HOTEN NVARCHAR(100);
  DECLARE @VITRI NVARCHAR(50);
  DECLARE @NGAYSINH DATE;
  DECLARE @DIACHI NVARCHAR(200);
  DECLARE @MACLB VARCHAR(5);
  DECLARE @MAQG VARCHAR (5);
  DECLARE @SO INT;
  declare @countSoAo int;
  select @HOTEN=a.HOTEN,@VITRI=a.VITRI,@NGAYSINH=a.NGAYSINH,@DIACHI=a.DIACHI,@MACLB=a.MACLB,@MAQG=a.MAQG,@SO=a.SO from inserted a;
  select @countSoAo=COUNT(*) from CAUTHU where CAUTHU.MACLB=@MACLB and CAUTHU.SO=@SO;
begin
  if (@VITRI = N'Thủ môn' OR  @VITRI = N'Tiền Đạo' OR   @VITRI = N'Tiền vệ' 
      OR @VITRI = N'Trung vệ' OR @VITRI = N'Hậu vệ' )
	  begin
	   if(@countSoAo=0)
	   begin
         DECLARE @CAU_THU_NUOC_NGOAI INT;
		 SELECT @CAU_THU_NUOC_NGOAI = COUNT(*) 
		 FROM CAUTHU C JOIN CAULACBO B ON C.MACLB = B.MACLB
		 WHERE C.MACLB=@MACLB AND C.MAQG <> 'VN'; 
		 if @CAU_THU_NUOC_NGOAI <=8
		    begin
			  DECLARE @error INT;
			  INSERT INTO CAUTHU VALUES (@HOTEN,@VITRI,@NGAYSINH,@DIACHI,@MACLB,@MAQG,@SO);
			  SELECT @error = @@ERROR; 
			  IF @error = 0
				BEGIN
				 COMMIT TRANSACTION;
				 PRINT N'Đã thêm cầu thủ mới';
				END
			  ELSE
				BEGIN
				 print N'Xảy ra lỗi khi thêm cầu thủ mới';
				 ROLLBACK TRANSACTION;
				END
            end
       else 
	     begin
           print 'Number is existed';
	       rollback transaction;
	     end
		end
  else 
    begin
    print 'Inserted failed';
	rollback transaction;
	end
end
end
INSERT INTO CAUTHU VALUES (N'Nguyễn Công Kien',N'Tiền đạo','1990-02-20',NULL,'BBD','VN',10);
drop trigger trigCauThu;
