CREATE PROC [dbo].[proc_insert_food_and_drink]
   @LOAI VARCHAR(100) = NULL,
   @TEN VARCHAR(100) = NULL,
   @VERSION INT = NULL,
   @GIA BIGINT = NULL,
   @NGUYENLIEU VARCHAR(100) = NULL,
   @MOTA VARCHAR(100) = NULL,
   @NGAYTHEM DATE = NULL,
   @TINHTRANG VARCHAR(100) = NULL,
   @XUATXU VARCHAR(100) = NULL,
   @CACHCHEBIEN VARCHAR(100) = NULL,
   @CANHBAODIUNG VARCHAR(100) = NULL
AS
BEGIN
   DECLARE @NULLCOLUMN TABLE(COLUMNNAME VARCHAR(100))
   DECLARE @REDUNCOLUMN TABLE(SPARENAME VARCHAR(100))
   DECLARE @MISSINGCOLUMN VARCHAR(100)
   DECLARE @SPARECOLUMN VARCHAR(100)
   IF(@TEN IS NULL) INSERT INTO @NULLCOLUMN
   VALUES('cot TEN')
   IF(@VERSION IS NULL) INSERT INTO @NULLCOLUMN
   VALUES('cot VERSION')
   IF(@GIA IS NULL) INSERT INTO @NULLCOLUMN
   VALUES('cot GIA')
   IF(EXISTS(SELECT 1
   FROM @NULLCOLUMN))
   BEGIN
       SELECT @MISSINGCOLUMN = STRING_AGG(COLUMNNAME,',')
       FROM @NULLCOLUMN;
       EXEC sys.sp_addmessage 
       @msgnum   = 60000 
       ,@severity = 16 
       ,@msgtext  = N'Chua nhap du lieu o (%s).' 
       ,@lang = 'us_english'
       ,@with_log = 'FALSE'
       ,@replace = 'replace';
        DECLARE @msg NVARCHAR(2048) = FORMATMESSAGE(60000, @MISSINGCOLUMN);  
        THROW 60000, @msg, 1;
   END
   IF(EXISTS(SELECT 1
   FROM FOODANDDRINK
   WHERE @VERSION != VERSION))
   BEGIN
       ;THROW 60001, 'Khac version mon an', 1;
   END
   IF EXISTS(SELECT 1
   FROM FOODANDDRINK
   WHERE @TEN = TEN )
   BEGIN
       ;THROW 60002, 'Trung ten mon an', 1;
   END
   IF @GIA <=0
   BEGIN
       ;THROW 60003, 'Gia nhap khong hop le', 1;
   END
   IF @LOAI = 'DO AN'
   BEGIN
       IF(@NGUYENLIEU IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot NGUYENLIEU')
       IF(@MOTA IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot MOTA')
       IF(@NGAYTHEM IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot NGAYTHEM')
       IF(@TINHTRANG IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot TINHTRANG')
       IF(@CACHCHEBIEN IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot CACHCHEBIEN')
       IF(@CANHBAODIUNG IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot CANHBAODIUNG')
       IF(EXISTS(SELECT 1
       FROM @NULLCOLUMN))
       BEGIN
           SELECT @MISSINGCOLUMN = STRING_AGG(COLUMNNAME,',')
           FROM @NULLCOLUMN
           EXEC sys.sp_addmessage 
           @msgnum   = 60004
           ,@severity = 16 
           ,@msgtext  = N'Chua nhap du lieu o (%s).' 
           ,@lang = 'us_english'
           ,@with_log = 'FALSE'
           ,@replace = 'replace';
  
           DECLARE @msg1 NVARCHAR(2048) = FORMATMESSAGE(60004, @MISSINGCOLUMN);  
  
           THROW 60004, @msg1, 1;
       END
       IF(@XUATXU IS NOT NULL)
       BEGIN
           ;THROW 60005, 'Ban khong duoc nhap cot XUATXU', 1;
       END
       ELSE
       BEGIN
           INSERT INTO FOODANDDRINK
               (TEN,VERSION,GIA,NGUYENLIEU,MOTA,NGAYTHEM,TINHTRANG)
           VALUES(@TEN, @VERSION, @GIA, @NGUYENLIEU, @MOTA, @NGAYTHEM, @TINHTRANG)
           INSERT INTO MON_AN
               (TEN,VERSION,CACHCHEBIEN,CANHBAODIUNG)
           VALUES(@TEN, @VERSION, @CACHCHEBIEN, @CANHBAODIUNG)
       END
   END
   ELSE IF @LOAI = 'DO UONG'
   BEGIN
       IF(@CACHCHEBIEN IS NOT NULL) INSERT INTO @REDUNCOLUMN
       VALUES('cot CACHCHEBIEN')
       IF(@CANHBAODIUNG IS NOT NULL) INSERT INTO @REDUNCOLUMN
       VALUES('cot CANHBAODIUNG')
       IF(EXISTS(SELECT 1
       FROM @REDUNCOLUMN))
       BEGIN
           SELECT @SPARECOLUMN = STRING_AGG(SPARENAME,',')
           FROM @REDUNCOLUMN
           EXEC sys.sp_addmessage 
           @msgnum   = 60006
           ,@severity = 16 
           ,@msgtext  = N'Ban khong duoc nhap (%s).' 
           ,@lang = 'us_english'
           ,@with_log = 'FALSE'
           ,@replace = 'replace';
  
           DECLARE @msg2 NVARCHAR(2048) = FORMATMESSAGE(60006, @SPARECOLUMN);  
            THROW 60006, @msg2, 1;
       END
       IF(@NGUYENLIEU IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot NGUYENLIEU')
       IF(@MOTA IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot MOTA')
       IF(@NGAYTHEM IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot NGAYTHEM')
       IF(@TINHTRANG IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot TINHTRANG')
       IF(@XUATXU IS NULL) INSERT INTO @NULLCOLUMN
       VALUES('cot XUATXU')
       IF(EXISTS(SELECT 1
       FROM @NULLCOLUMN))
      
       BEGIN
           SELECT @MISSINGCOLUMN = STRING_AGG(COLUMNNAME,',')
           FROM @NULLCOLUMN
           EXEC sys.sp_addmessage 
           @msgnum   = 60007
           ,@severity = 16 
           ,@msgtext  = N'Chua nhap du lieu o (%s).' 
           ,@lang = 'us_english'
           ,@with_log = 'FALSE'
           ,@replace = 'replace';
  
           DECLARE @msg3 NVARCHAR(2048) = FORMATMESSAGE(60007, @MISSINGCOLUMN);
           THROW 60007, @msg3, 1;
       END
       ELSE
       BEGIN
           INSERT INTO FOODANDDRINK
               (TEN,VERSION,GIA,NGUYENLIEU,MOTA,NGAYTHEM,TINHTRANG)
           VALUES(@TEN, @VERSION, @GIA, @NGUYENLIEU, @MOTA, @NGAYTHEM, @TINHTRANG)
           INSERT INTO DO_UONG
               (TEN,VERSION,XUATXU)
           VALUES(@TEN, @VERSION, @XUATXU)
       END
   END
END
GO

------------------------------------------------
CREATE PROC [dbo].[proc_update_food_and_drink]
   @TEN VARCHAR(100) = NULL,
   @GIA BIGINT = NULL,
   @NGUYENLIEU VARCHAR(100) = NULL,
   @CACHCHEBIEN VARCHAR(100) = NULL,
   @XUATXU VARCHAR(100) = NULL
AS
BEGIN
   IF(NOT EXISTS(SELECT *
   FROM FOODANDDRINK
   WHERE @TEN = TEN))
   BEGIN
       ;THROW 60000, 'Ten mon khong ton tai!', 1;
   END
   IF @GIA <= 0
   BEGIN
       ;THROW 60001, 'Gia ca khong hop le!', 1;
   END
   ELSE
   BEGIN
       DECLARE @GIAFD BIGINT
       SELECT @GIAFD = GIA
       FROM FOODANDDRINK
       WHERE @TEN = TEN
       IF(@GIAFD<>@GIA)
       BEGIN
           UPDATE FOODANDDRINK
           SET GIA = @GIA,NGUYENLIEU = @NGUYENLIEU
           WHERE @TEN = TEN
           UPDATE MON_AN
           SET CACHCHEBIEN = @CACHCHEBIEN
           WHERE @TEN = TEN
           UPDATE DO_UONG
           SET XUATXU = @XUATXU
           WHERE @TEN = TEN
       END
       ELSE
       BEGIN
           UPDATE FOODANDDRINK
           SET NGUYENLIEU = @NGUYENLIEU
           WHERE @TEN = TEN
           UPDATE MON_AN
           SET CACHCHEBIEN = @CACHCHEBIEN
           WHERE @TEN = TEN
           UPDATE DO_UONG
           SET XUATXU = @XUATXU
           WHERE @TEN = TEN
       END
   END
END
GO
  
------------------------------------------------
CREATE PROC [dbo].[proc_delete_food_and_drink]
   @TEN VARCHAR(100) = NULL
AS
BEGIN
   IF(NOT EXISTS(SELECT *
   FROM FOODANDDRINK
   WHERE @TEN = TEN))
   BEGIN
       ;THROW 60000, 'Mon nay khong ton tai', 1;
   END
   IF(NOT EXISTS(SELECT DISTINCT TEN
   FROM HOADON HD
       JOIN DONHANG_FD DH
       ON HD.MADONHANG = DH.MDH
   WHERE @TEN = TEN)AND NOT EXISTS(SELECT TEN FROM FD_VOUCHER_APDUNG WHERE @TEN = TEN))
   BEGIN
       IF(NOT EXISTS(SELECT DISTINCT TEN
       FROM DO_UONG
       WHERE @TEN = TEN))
       BEGIN
           DELETE FROM MON_AN
           WHERE @TEN = TEN
           DELETE FROM DONHANG_FD
           WHERE @TEN = TEN
           DELETE FROM CHEBIEN_MON_AN
           WHERE @TEN = TEN
       END
       ELSE
       BEGIN
           DELETE FROM DO_UONG
           WHERE @TEN = TEN
       END
       DELETE FROM FOODANDDRINK
       WHERE @TEN = TEN
   END
   ELSE
   BEGIN
       UPDATE FOODANDDRINK
       SET TINHTRANG = 'Khong ban'
       WHERE @TEN = TEN
   END
END
GO


------------------------------------------------
CREATE TRIGGER trig_insert_employee ON NHANVIEN
FOR INSERT
AS
BEGIN
   DECLARE @manhanvien VARCHAR(100)


   SELECT @manhanvien = MANHANVIEN
   FROM inserted


   IF (LEFT(@manhanvien, 2) = 'PV')
   BEGIN
       INSERT INTO PHUCVU
       VALUES (@manhanvien)
   END
   ELSE IF (LEFT(@manhanvien, 2) = 'DB')
   BEGIN
       INSERT INTO DAUBEP
       VALUES (@manhanvien)
   END
   ELSE IF (LEFT(@manhanvien, 2) = 'TN')
   BEGIN
       INSERT INTO THUNGAN
       VALUES (@manhanvien)
   END
END
GO

------------------------------------------------
CREATE TRIGGER trig_total_cost_of_bill
ON DONHANG_FD
FOR INSERT, UPDATE, DELETE
AS
BEGIN
   DECLARE @VOUCHERTIEN BIGINT
   DECLARE @VOUCHERPHANTRAM INT
   DECLARE @MA VARCHAR(100)
   IF(EXISTS(SELECT *
   FROM inserted))
   BEGIN
       SELECT @MA = MDH
       FROM inserted
   END
   ELSE
   BEGIN
       SELECT @MA = MDH
       FROM deleted
   END
   ;
   WITH
       ST
       AS
       (
           SELECT H.MADONHANG, V.GIAMGIATHEOPHANTRAM, V.GIAMGIATHEOTIEN
           FROM HOADON_VOUCHER HV
               JOIN VOUCHER V
               ON HV.MAVOUCHER = V.MAVOUCHER
               JOIN HOADON H
               ON H.MAHOADON = HV.MAHOADON
       )
   SELECT @VOUCHERTIEN= GIAMGIATHEOTIEN, @VOUCHERPHANTRAM = GIAMGIATHEOPHANTRAM
   FROM ST
   WHERE @MA = MADONHANG
   IF(@VOUCHERTIEN IS NULL AND @VOUCHERPHANTRAM IS NULL)
   BEGIN
       UPDATE HOADON
       SET TONGTIEN =
       CASE
           WHEN HOADON.MADONHANG = @MA THEN (SELECT SUM(GIA)
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG)
           ELSE (SELECT SUM(GIA)
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG )
       END
   END
   ELSE IF(@VOUCHERTIEN IS NOT NULL AND @VOUCHERPHANTRAM IS NULL)
   BEGIN
       UPDATE HOADON
       SET TONGTIEN =
       CASE
           WHEN HOADON.MADONHANG = @MA THEN (SELECT SUM(GIA)-@VOUCHERTIEN
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG)
           ELSE (SELECT SUM(GIA)
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG)
       END
   END
   ELSE IF(@VOUCHERTIEN IS NULL AND @VOUCHERPHANTRAM IS NOT NULL)
   BEGIN
       UPDATE HOADON
       SET TONGTIEN =
       CASE
       WHEN HOADON.MADONHANG = @MA THEN (SELECT SUM(GIA)*(1-@VOUCHERPHANTRAM/100)
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG)
       ELSE (SELECT SUM(GIA)
       FROM DONHANG_FD
       WHERE DONHANG_FD.MDH = HOADON.MADONHANG )
       END
   END
END
GO

------------------------------------------------
CREATE PROC proc_list_employee_of_room
   @SOPHONG VARCHAR(100) = NULL,
   @NGAYPHUCVU DATE = NULL
AS
BEGIN
   SELECT PHUCVU.MANHANVIEN, NHANVIEN.HOTEN, NHANVIEN.GIOITINH, NHANVIEN.NGAYSINH, NHANVIEN.DIACHI, NHANVIEN.NGAYBATDAULAM, NHANVIEN.TKNGANHANG,
   NHANVIEN.BANGCAP, NHANVIEN.LUONGTHEOTHANG, NHANVIEN.LUONGTHEOGIO, NHANVIEN.MANVQUANLY
   FROM PHUCVU_PHONG
       JOIN PHUCVU
       ON PHUCVU.MANHANVIEN = PHUCVU_PHONG.MANVPHUCVU
       JOIN NHANVIEN
       ON PHUCVU_PHONG.MANVPHUCVU = NHANVIEN.MANHANVIEN
   WHERE @SOPHONG = SOPHONG AND @NGAYPHUCVU = NGAYPHUCVU
END
GO

------------------------------------------------
CREATE PROC proc_bestseller_food
   @QUY INT = NULL,
   @NAM INT = NULL
AS
BEGIN
   WITH
       QUY_NAM
       AS
       (
           SELECT YEAR(D1.NGAYDATHANG) AS NAM , DATEPART(QUARTER,D1.NGAYDATHANG) AS QUY , D2.TEN, SUM(D2.SOLUONG) AS TONGLUOTMUA, SUM(D2.GIA) AS TONGDOANHTHU
           FROM DONHANG D1
               JOIN DONHANG_FD D2
               ON D1.MADONHANG = D2.MDH
           GROUP BY YEAR(D1.NGAYDATHANG),DATEPART(QUARTER,D1.NGAYDATHANG),D2.TEN
           HAVING DATEPART(QUARTER,D1.NGAYDATHANG)= @QUY AND YEAR(D1.NGAYDATHANG) = @NAM
       )
   SELECT *
   FROM QUY_NAM
   WHERE TONGDOANHTHU >=400000
   ORDER BY QUY,TONGLUOTMUA
END
GO

------------------------------------------------
CREATE FUNCTION func_favorited_food
(
   @TEN VARCHAR(100),
   @YEAR INT
)
RETURNS VARCHAR(100)
AS
BEGIN
   DECLARE @KETQUA VARCHAR(100)


   IF NOT EXISTS(SELECT *
   FROM FOODANDDRINK
   WHERE TEN = @TEN)
   BEGIN
       SET @KETQUA = 'Mon nay khong ton tai'
   END
   ELSE
   BEGIN
       SELECT @KETQUA =
       CASE
           WHEN SUM(D1.SOLUONG)>=0 AND SUM(D1.SOLUONG)<1 THEN '1 sao'
           WHEN SUM(D1.SOLUONG)>= 1 AND SUM(D1.SOLUONG)< 2 THEN '2 sao'
           WHEN SUM(D1.SOLUONG)>=2 AND SUM(D1.SOLUONG)<3 THEN '3 sao'
           WHEN SUM(D1.SOLUONG) >=3 AND SUM(D1.SOLUONG)<4 THEN '4 sao'
           WHEN SUM(D1.SOLUONG) >=4 THEN '5 sao'
       END
       FROM DONHANG_FD D1
           JOIN FOODANDDRINK F1
           ON F1.TEN = D1.TEN
           JOIN DONHANG D2
           ON D1.MDH = D2.MADONHANG
       WHERE F1.TEN = @TEN AND YEAR(D2.NGAYDATHANG) = @YEAR
       GROUP BY F1.TEN,YEAR(D2.NGAYDATHANG)
   END


   RETURN @KETQUA
END
GO

------------------------------------------------
CREATE FUNCTION func_revenue (@ngay INT, @thang INT, @nam INT)
RETURNS VARCHAR(100)
AS
BEGIN
    DECLARE @doanhthu BIGINT

    IF (@ngay IS NOT NULL)
    BEGIN
        -- Kiem tra loi
        IF (@thang IS NULL)
        BEGIN
            RETURN 'Ban chua nhap thang'
        END
        IF (@nam IS NULL)
        BEGIN
           RETURN 'Ban chua nhap nam'
        END

        -- Tinh doanh thu theo ngay
        SELECT @doanhthu = SUM(TONGTIEN)
        FROM HOADON
        WHERE DAY(NGAYTAOHDON) = @ngay
            AND MONTH(NGAYTAOHDON) = @thang
            AND YEAR(NGAYTAOHDON) = @nam
    END
    ELSE
    BEGIN
        IF (@ngay IS NOT NULL)
        BEGIN
            -- Kiem tra loi
            IF (@nam IS NULL)
            BEGIN
                RETURN 'Ban chua nhap nam'
            END

            -- Tinh doanh thu theo thang
            SELECT @doanhthu = SUM(TONGTIEN)
            FROM HOADON
            WHERE MONTH(NGAYTAOHDON) = @thang
                AND YEAR(NGAYTAOHDON) = @nam
        END
        ELSE
        BEGIN
            -- Tinh doanh thu theo nam
            SELECT @doanhthu = SUM(TONGTIEN)
            FROM HOADON
            WHERE YEAR(NGAYTAOHDON) = @nam
        END
    END

    RETURN CAST(@doanhthu AS VARCHAR(100))
END
