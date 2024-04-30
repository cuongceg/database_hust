--a, Xử lý chuỗi giờ
/*1,Cho biết NGAYTD, TENCLB1, TENCLB2, KETQUA các trận đấu diễn ra vào tháng 3 trên sân 
nhà mà không bị thủng lưới.*/
select td.NGAYTD,clb1.TENCLB,clb2.TENCLB,td.KETQUA from TRANDAU td,CAULACBO clb1,CAULACBO clb2 where td.MACLB1=clb1.MACLB and td.MACLB2=clb2.MACLB
and MONTH(td.NGAYTD)=3 and LEFT(td.KETQUA,1)='0';
/*2,Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ lót là “Công”.*/
select HOTEN,NGAYSINH,MACT from CAUTHU where HOTEN like N'%Công%';
/*3, Cho biết mã số, họ tên, ngày sinh của những cầu thủ có họ không phải là họ “Nguyễn “*/
select MACT,HOTEN,NGAYSINH from CAUTHU where HOTEN not like N'Nguyễn%';
/*4, Cho biết mã huấn luyện viên, họ tên, ngày sinh, đ ịa chỉ của những huấn luyện viên Việt 
Nam có tuổi nằm trong khoảng 35-40.*/
select MAHLV,TENHLV,NGAYSINH,DIACHI from HUANLUYENVIEN join QUOCGIA on HUANLUYENVIEN.MAQG=QUOCGIA.MAQG where TENQG=N'Việt Nam' and DATEDIFF(year,NGAYSINH,GETDATE()) between 50 and 70;
/*select DATEDIFF(year,NGAYSINH,GETDATE()) as AGE from HUANLUYENVIEN*/
/*5,Cho biết tên câu lạc bộ có huấn luyện viên trưởng sinh vào ngày 20 tháng 8 năm 2019*/
select clb.TENCLB from CAULACBO clb,HLV_CLB,HUANLUYENVIEN hlv where HLV_CLB.MAHLV=hlv.MAHLV and HLV_CLB.MACLB=clb.MACLB and CONVERT(date, hlv.NGAYSINH) = '2019-08-20' ;
/*6,Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có số bàn thắng nhiều nhất tính đến 
hết vòng 3 năm 2009*/
select clb.TENCLB,tinh.TENTINH,BANGXH.HIEUSO from CAULACBO clb join TINH tinh on clb.MATINH=tinh.MATINH join BANGXH on clb.MACLB=BANGXH.MACLB where BANGXH.SOTRAN=3 
and left(HIEUSO,1)=(select left(MAX(HIEUSO),1) from BANGXH where SOTRAN=3);

--b, Truy vấn con
/*1,Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ nước 
ngoài (Có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ có nhiều hơn 2 cầu 
thủ nước ngoài*/
select clb.MACLB,clb.TENCLB,TENSAN,svd.DIACHI,count(MACT) as SOLUONGCAUTHU from CAULACBO clb join SANVD svd
on clb.MASAN=svd.MASAN join CAUTHU on clb.MACLB=CAUTHU.MACLB where CAUTHU.MAQG not like 'VN' group by clb.MACLB,clb.TENCLB,TENSAN,svd.DIACHI having count(MACT)>2;
/*2,Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng có hiệu số bàn thắng bại cao nhất năm 2009.*/
select TOP 1 clb.TENCLB,tinh.TENTINH from CAULACBO clb join TINH tinh on clb.MATINH=tinh.MATINH join BANGXH on clb.MACLB=BANGXH.MACLB where BANGXH.NAM=2009 order by BANGXH.HIEUSO desc;
/*3,Cho biết danh sách các trận đấu ( NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009*/
select NGAYTD,TENSAN,clb1.TENCLB as TENCLB1,clb2.TENCLB as TENCLB2,KETQUA from TRANDAU join SANVD on TRANDAU.MASAN=SANVD.MASAN join CAULACBO clb1 on TRANDAU.MACLB1=clb1.MACLB join CAULACBO clb2 on TRANDAU.MACLB2=clb2.MACLB 
where TRANDAU.MACLB1=(select TOP 1 MACLB from BANGXH where VONG=3 order by HANG desc) or TRANDAU.MACLB2=(select TOP 1 MACLB from BANGXH where VONG=3 order by HANG desc);
/*4, Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại 
(kể cả sân nhà và sân khách) trong mùa giải năm 2009.*/
select clb.MACLB,clb.TENCLB from CAULACBO clb where clb.MACLB in 
(select MACLB from CAULACBO clb,TRANDAU td where NAM=2009 and (clb.MACLB=td.MACLB1 or clb.MACLB=td.MACLB2) group by MACLB
having count(MACLB)=(select count(MACLB)-1 from CAULACBO)); 
/*5,Cho biết mã câu lạc bộ, tên câu lạc bộ đã tham gia thi đấu với tất cả các câu lạc bộ còn lại 
( chỉ tính sân nhà) tro ng mùa giải năm 2009*/
select clb.MACLB,clb.TENCLB from CAULACBO clb where clb.MACLB in 
(select MACLB from CAULACBO clb,TRANDAU td where NAM=2009 and clb.MACLB=td.MACLB1 group by MACLB
having count(MACLB)=(select count(MACLB)-1 from CAULACBO) ); 

--c,Bài tập về Rule
/*1,Khi thêm cầu thủ mới, kiểm tra vị trí trên sân của cầu thủ chỉ thuộc một trong các vị
trí sau: Thủ môn, tiền đạo, tiền vệ, trung vệ, hậu vệ.*/
alter table CAUTHU add constraint constraint_1 check(VITRI=N'Thủ môn' or VITRI=N'Tiền đạo' or VITRI=N'Tiền vệ' or VITRI=N'Trung vệ' or VITRI=N'Hậu vệ');
/*2,Khi phân công huấn luyện viên, kiểm tra vai trò của huấn luyện viên chỉ thuộc một trong 
các vai trò sau: HLV chính, HLV phụ, HLV thể lực, HLV thủ môn.*/
alter table HLV_CLB add constraint constraint_2 check(VAITRO=N'HLV chính' or VAITRO=N'HLV phụ' or VAITRO=N'HLV thể lực' or VAITRO=N'HLV thủ môn');
/*3,Khi thêm cầu thủ mới, kiểm tra cầu thủ đó có tuổi phải đủ 18 trở lên (chỉ tính năm sinh)*/
alter table CAUTHU add constraint constraint_3 check(year(GETDATE())-year(CAUTHU.NGAYSINH)>18);
/*4, Kiểm tra kết quả trận đấu có dạng số_bàn_thắng- số_bàn_thua.*/
alter table TRANDAU add constraint constraint_4 check(KETQUA like '_-_');

--d,Bài tập về View
/*1. Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bón g “SHB
Đà Nẵng” có quốc tịch “Bra-xin”.*/
create view view_1 as(
select MACT,HOTEN,NGAYSINH,DIACHI,VITRI from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB join QUOCGIA on CAUTHU.MAQG=QUOCGIA.MAQG
where CAULACBO.TENCLB = N'SHB Đà Nẵng' and QUOCGIA.TENQG=N'Brazil');
select * from view_1;
/*2, Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các trận
đấu vòng 3 của mùa bóng năm 2009*/
create view view_2 as(
select MATRAN, NGAYTD, TENSAN, clb1.TENCLB, clb2.TENCLB, KETQUA from TRANDAU join CAULACBO clb1 on TRANDAU.MACLB1=clb1.MACLB join CAULACBO clb2 on TRANDAU.MACLB2=clb2.MACLB join SANVD on TRANDAU.MASAN=SANVD.MASAN
where VONG=3 and NAM=2009
);
select * from view_2;
/*3,Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc 
của các huấn luyện viên có quốc tịch “Việt Nam”*/
create view view_3 as(
select HUANLUYENVIEN.MAHLV,TENHLV,NGAYSINH,DIACHI,VAITRO,TENCLB from HLV_CLB join HUANLUYENVIEN on HLV_CLB.MAHLV=HUANLUYENVIEN.MAHLV join CAULACBO on HLV_CLB.MACLB=CAULACBO.MACLB
where HUANLUYENVIEN.MAQG='VN'
);
select * from view_3;
/*4, Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu thủ
nước ngoài (có quốc tịch khác “Việt Nam”) tương ứng của các câu lạc bộ nhiều hơn 
2 cầu thủ nước ngoài*/
create view view_4 as(
select CAULACBO.MACLB,CAULACBO.TENCLB,TENSAN,SANVD.DIACHI,count(MACT) as SOLUONGCAUTHU from CAULACBO join SANVD 
on CAULACBO.MASAN=SANVD.MASAN join CAUTHU on CAULACBO.MACLB=CAUTHU.MACLB where CAUTHU.MAQG not like 'VN' group by CAULACBO.MACLB,CAULACBO.TENCLB,TENSAN,SANVD.DIACHI having count(MACT)>2
);
select * from view_4;
/*5, Cho biết tên tỉnh, số lượng câu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc 
bộ thuộc địa bàn tỉnh đó quản lý.*/
create view view_5 as(
select TINH.TENTINH,count(MACT) as SL from CAULACBO join TINH on CAULACBO.MATINH=TINH.MATINH right join CAUTHU on CAULACBO.MACLB=CAUTHU.MACLB where CAUTHU.VITRI= N'Tiền đạo' group by TINH.TENTINH
);
select * from view_5;
/*6, Cho biết tên câu lạc bộ,tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng xếp 
hạng của vòng 3 năm 2009.*/
create view view_6 as(
select CAULACBO.TENCLB,TINH.TENTINH from CAULACBO join TINH on CAULACBO.MATINH=TINH.MATINH join BANGXH on BANGXH.MACLB=CAULACBO.MACLB where BANGXH.HANG=1 and VONG=3 and NAM=2009
);
select * from view_6;
/*7, Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong 1 câu lạc bộ mà chưa có số
điện thoại*/
create view view_7 as(
select TENHLV from HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV where VAITRO is not null and HUANLUYENVIEN.DIENTHOAI is null
);
select * from view_7;
/*8, Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện tại 
bất kỳ một câu lạc bộ*/
create view view_8 as(
select TENHLV from HUANLUYENVIEN where TENHLV not in(select TENHLV from HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV)
);
select * from view_8;
/*9,Cho biết kết quả các trận đấu đã diễn ra (MACLB1, MACLB2, NAM, VONG,
SOBANTHANG,SOBANTHUA).*/
create view view_9 as(
select MACLB1, MACLB2, NAM, VONG,left(KETQUA,1) as SOBANTHANG,right(KETQUA,1) as SOBANTHUA from TRANDAU
);
select * from view_9;
/*10, Cho biết kết quả các trận đấu trên sân nhà (MACLB, NAM, VONG,
SOBANTHANG, SOBANTHUA)
*/
create view view_10 as(
select MACLB1 as MACLB, NAM, VONG,left(KETQUA,1) as SOBANTHANG,right(KETQUA,1) as SOBANTHUA from TRANDAU 
);
select * from view_10;
/*11, Cho biết kết quả các trận đấu trên sân khách (MACLB, NAM, VONG,
SOBANTHANG,SOBANTHUA).*/
create view view_11 as(
select MACLB1, MACLB2, NAM, VONG,left(KETQUA,1) as SOBANTHANG,right(KETQUA,1) as SOBANTHUA from TRANDAU 
);
select * from view_11;
/*12, Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, 
KETQUA) của câu lạc bộ CLB đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009.*/
create view view_12 as(
select NGAYTD,TENSAN,clb1.TENCLB as TENCLB1,clb2.TENCLB as TENCLB2,KETQUA from TRANDAU join SANVD on TRANDAU.MASAN=SANVD.MASAN join CAULACBO clb1 on TRANDAU.MACLB1=clb1.MACLB join CAULACBO clb2 on TRANDAU.MACLB2=clb2.MACLB 
where TRANDAU.MACLB1=(select MACLB from BANGXH where VONG=3 and HANG=1) or TRANDAU.MACLB2=(select MACLB from BANGXH where VONG=3 and HANG=1)
);
select * from view_12;
/*13, Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) 
của câu lạc bộ CLB có thứ hạng thấp nhất trong bảng xếp hạng vòng 3 năm 2009*/
create view view_13 as(
select NGAYTD,TENSAN,clb1.TENCLB as TENCLB1,clb2.TENCLB as TENCLB2,KETQUA from TRANDAU join SANVD on TRANDAU.MASAN=SANVD.MASAN join CAULACBO clb1 on TRANDAU.MACLB1=clb1.MACLB join CAULACBO clb2 on TRANDAU.MACLB2=clb2.MACLB 
where TRANDAU.MACLB1=(select TOP 1 MACLB from BANGXH where VONG=3 order by HANG desc) or TRANDAU.MACLB2=(select TOP 1 MACLB from BANGXH where VONG=3 order by HANG desc)
);
select * from view_13;
