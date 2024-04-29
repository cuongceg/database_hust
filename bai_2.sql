/*a. Truy vấn cơ bản*/

/*1,Cho biết thông tin (mã cầu thủ, họ tên, số áo, vị trí, ngày sinh, địa chỉ) của tất cả các cầu thủ’.*/
select MACT,HOTEN,SO,VITRI,NGAYSINH,DIACHI from CAUTHU;

/*2,Hiển thị thông tin tất cả các cầu thủ có số áo là 7 chơi ở vị trí Tiền vệ.*/
select * from CAUTHU where SO=7 and VITRI = N'Tiền vệ';

/*3,Cho biết tên, ngày sinh, địa chỉ, điện thoại của tất cả các huấn luyện viên.*/
select TENHLV,NGAYSINH,DIACHI,DIENTHOAI from HUANLUYENVIEN;

/*4,Hiển thi thông tin tất cả các cầu thủ có quốc tịch Việt Nam thuộc câu lạc bộBecamex Bình Dương.*/
select * from CAUTHU where MACLB like 'BBD' and MAQG like 'VN';

/*5,Cho biết mã số, họ tên, ngày sinh, địa chỉ và vị trí của các cầu thủ thuộc đội bóng‘SHB Đà Nẵng’ có quốc tịch*/
select MACT,HOTEN,SO,VITRI,NGAYSINH,DIACHI from CAUTHU where MACLB = 'SDN' and MAQG is not null;

/*6,Hiển thị thông tin tất cả các cầu thủ đang thi đấu trong câu lạc bộ có sân nhà là
“Long An”.*/
select * from CAUTHU where MACLB in (select MACLB1 from TRANDAU where MASAN = 'LA' union select MACLB2 from TRANDAU where MASAN = 'LA');

/*7,Cho biết kết quả (MATRAN, NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA) các 
trận đấu vòng 2 của mùa bóng năm 2009.*/
select MATRAN,NGAYTD,SANVD.TENSAN,CLB1.TENCLB as TENCLB1,CLB2.TENCLB as TENCLB2,KETQUA from TRANDAU join CAULACBO as CLB1 on TRANDAU.MACLB1=CLB1.MACLB join CAULACBO as CLB2 on TRANDAU.MACLB2=CLB2.MACLB join SANVD on TRANDAU.MASAN=SANVD.MASAN where VONG =2 and NAM =2009;

/*8,Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB
đang làm việc của các huấn luyện viên có quốc tịch “ViệtNam”.*/
select HUANLUYENVIEN.MAHLV,TENHLV,NGAYSINH,DIACHI,HLV_CLB.VAITRO,CAULACBO.TENCLB from HLV_CLB right join HUANLUYENVIEN on HLV_CLB.MAHLV=HUANLUYENVIEN.MAHLV left join CAULACBO on HLV_CLB.MACLB=CAULACBO.MACLB where HUANLUYENVIEN.MAQG = 'VN';

/*9,Lấy tên 3 câu lạc bộ có điểm cao nhất sau vòng 3 năm 2009*/
select CAULACBO.TENCLB from CAULACBO join BANGXH on CAULACBO.MACLB=BANGXH.MACLB where VONG>3 and (HANG=1 or HANG =2 or HANG =3);

/*10,Cho biết mã huấn luyện viên, họ tên, ngày sinh, địa chỉ, vai trò và tên CLB đang làm việc mà câu lạc bộ đó đóng ở tỉnh Binh Dương.*/
select HLV_CLB.MAHLV,HUANLUYENVIEN.TENHLV,HUANLUYENVIEN.NGAYSINH,HUANLUYENVIEN.DIACHI,HLV_CLB.VAITRO,CAULACBO.TENCLB from HLV_CLB join HUANLUYENVIEN on HLV_CLB.MAHLV=HUANLUYENVIEN.MAHLV join CAULACBO on HLV_CLB.MACLB=CAULACBO.MACLB where CAULACBO.MATINH = 'BD';

/*b. Các phép toán trên nhóm*/

/*1,Thống kê số lượng cầu thủ của mỗi câu lạc bộ.*/
select CAULACBO.TENCLB,count(MACT) from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB group by CAULACBO.TENCLB;

/*2,Thống kê số lượng cầu thủ nước ngoài (có quốc tịch khác Việt Nam) của mỗi câu lạc bộ*/
select CAULACBO.TENCLB,count(MACT) from CAUTHU join CAULACBO on CAUTHU.MACLB=CAULACBO.MACLB where CAUTHU.MAQG != 'VN' group by CAULACBO.TENCLB;

/*3,Cho biết mã câu lạc bộ, tên câu lạc bộ, tên sân vận động, địa chỉ và số lượng cầu 
thủ nước ngoài (có quốc tịch khác Việt Nam) tương ứng của các câu lạc bộ có nhiều 
hơn 2 cầu thủ nước ngoài.*/
select CAULACBO.MACLB,CAULACBO.TENCLB,SANVD.TENSAN,SANVD.DIACHI,count(MACT) from CAULACBO join CAUTHU on CAULACBO.MACLB=CAUTHU.MACLB join SANVD on CAULACBO.MASAN=SANVD.MASAN where CAUTHU.MAQG != 'VN' group by CAULACBO.MACLB,CAULACBO.TENCLB,SANVD.TENSAN,SANVD.DIACHI having count(MACT)>2;

/*4,Cho biết tên tỉnh, số lượng cầu thủ đang thi đấu ở vị trí tiền đạo trong các câu lạc 
bộ thuộc địa bàn tỉnh đó quản lý*/
select TINH.TENTINH,count(MACT) as SL from CAULACBO join TINH on CAULACBO.MATINH=TINH.MATINH right join CAUTHU on CAULACBO.MACLB=CAUTHU.MACLB where CAUTHU.VITRI= N'Tiền đạo' group by TINH.TENTINH;

/*5,Cho biết tên câu lạc bộ, tên tỉnh mà CLB đang đóng nằm ở vị trí cao nhất của bảng 
xếp hạng vòng 3, năm 2009.*/
select CAULACBO.TENCLB,TINH.TENTINH from CAULACBO join TINH on CAULACBO.MATINH=TINH.MATINH join BANGXH on BANGXH.MACLB=CAULACBO.MACLB where BANGXH.HANG=1 and VONG=3 and NAM=2009;

/*c. Các toán tử nâng cao*/
/*1,Cho biết tên huấn luyện viên đang nắm giữ một vị trí trong một câu lạc bộ
mà chưa có số điện thoại.*/
select TENHLV from HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV where VAITRO is not null and HUANLUYENVIEN.DIENTHOAI is null;

/*2,Liệt kê các huấn luyện viên thuộc quốc gia Việt Nam chưa làm công tác huấn luyện 
tại bất kỳ một câu lạc bộ nào.*/
select TENHLV from HUANLUYENVIEN where TENHLV not in(select TENHLV from HUANLUYENVIEN join HLV_CLB on HUANLUYENVIEN.MAHLV=HLV_CLB.MAHLV);

/*3,Liệt kê các cầu thủ đang thi đấu trong các câu lạc bộ có thứ hạng ở vòng 3 năm 2009
lớn hơn 6 hoặc nhỏ hơn 3*/
select distinct(CAUTHU.HOTEN),HANG from CAUTHU join BANGXH on CAUTHU.MACLB=BANGXH.MACLB where (BANGXH.HANG <3 or BANGXH.HANG>6)and VONG=3 and NAM=2009 ;
/*4,Cho biết danh sách các trận đấu (NGAYTD, TENSAN, TENCLB1, TENCLB2, KETQUA)
của câu lạc bộ (CLB) đang xếp hạng cao nhất tính đến hết vòng 3 năm 2009*/
select TRANDAU.NGAYTD,SANVD.TENSAN,CLB1.TENCLB as TENCLB1,CLB2.TENCLB as TENCLB2,TRANDAU.KETQUA from TRANDAU join CAULACBO as CLB1 on TRANDAU.MACLB1=CLB1.MACLB join CAULACBO as CLB2 on TRANDAU.MACLB2=CLB2.MACLB join SANVD on TRANDAU.MASAN=SANVD.MASAN
where CLB1.MACLB in (select BANGXH.MACLB from BANGXH where HANG = 1 and VONG=3 and NAM=2009) or CLB2.MACLB in (select BANGXH.MACLB from BANGXH where HANG = 1 and VONG=3 and NAM=2009);