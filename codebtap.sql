
CREATE DATABASE QuanLyNhanKhau;
GO

USE QuanLyNhanKhau;
GO



-- 1. BẢNG NHÂN KHẨU (Thông tin cốt lõi của công dân)
CREATE TABLE NHAN_KHAU (
    SoCCCD VARCHAR(12) NOT NULL PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    QueQuan NVARCHAR(255),
    DanToc NVARCHAR(50),
    TonGiao NVARCHAR(50),
    NhomMau VARCHAR(5)
);
GO

-- 2. BẢNG HỘ KHẨU (Quản lý địa chỉ thường trú)
CREATE TABLE HO_KHAU (
    MaHoKhau VARCHAR(20) NOT NULL PRIMARY KEY,
    SoCCCD_ChuHo VARCHAR(12) NOT NULL,
    DiaChiThuongTru NVARCHAR(255) NOT NULL,
    NgayLapHo DATE,
    
    -- Khóa ngoại: Chủ hộ phải là người có trong bảng NHAN_KHAU
    CONSTRAINT FK_HoKhau_ChuHo FOREIGN KEY (SoCCCD_ChuHo) REFERENCES NHAN_KHAU(SoCCCD)
);
GO

-- 3. BẢNG THÀNH VIÊN HỘ (Chi tiết những người chung một hộ khẩu)
CREATE TABLE THANH_VIEN_HO (
    MaHoKhau VARCHAR(20) NOT NULL,
    SoCCCD VARCHAR(12) NOT NULL,
    QuanHeVoiChuHo NVARCHAR(50) NOT NULL, -- Vợ, Chồng, Con đẻ, Con nuôi...
    NgayNhapKhau DATE,
    
    -- Khóa chính tổ hợp từ 2 cột
    CONSTRAINT PK_ThanhVienHo PRIMARY KEY (MaHoKhau, SoCCCD),
    
    -- Khóa ngoại nối về 2 bảng gốc
    CONSTRAINT FK_TVH_HoKhau FOREIGN KEY (MaHoKhau) REFERENCES HO_KHAU(MaHoKhau),
    CONSTRAINT FK_TVH_NhanKhau FOREIGN KEY (SoCCCD) REFERENCES NHAN_KHAU(SoCCCD)
);
GO

-- 4. BẢNG QUAN HỆ GIA ĐÌNH (Quản lý huyết thống, hôn nhân)
CREATE TABLE QUAN_HE_GIA_DINH (
    ID_QuanHe INT IDENTITY(1,1) PRIMARY KEY, -- ID tự động tăng
    SoCCCD_Nguoi1 VARCHAR(12) NOT NULL,
    SoCCCD_Nguoi2 VARCHAR(12) NOT NULL,
    LoaiQuanHe NVARCHAR(50) NOT NULL, -- Cha-Con, Mẹ-Con, Vợ-Chồng...
    
    -- Khóa ngoại: Cả 2 người đều phải tồn tại trong bảng NHAN_KHAU
    CONSTRAINT FK_QHGD_Nguoi1 FOREIGN KEY (SoCCCD_Nguoi1) REFERENCES NHAN_KHAU(SoCCCD),
    CONSTRAINT FK_QHGD_Nguoi2 FOREIGN KEY (SoCCCD_Nguoi2) REFERENCES NHAN_KHAU(SoCCCD)
);
GO

-- 5. BẢNG KHAI BÁO CƯ TRÚ (Quản lý tạm trú, tạm vắng, lưu trú)
CREATE TABLE KHAI_BAO_CU_TRU (
    MaKhaiBao VARCHAR(20) NOT NULL PRIMARY KEY,
    SoCCCD VARCHAR(12) NOT NULL,
    LoaiKhaiBao NVARCHAR(50) NOT NULL, -- Tạm trú, Tạm vắng...
    DiaChiCuTru NVARCHAR(255) NOT NULL,
    TuNgay DATE NOT NULL,
    DenNgay DATE, 
    LyDo NVARCHAR(255),
    
    -- Khóa ngoại trỏ về người đi khai báo
    CONSTRAINT FK_KhaiBao_NhanKhau FOREIGN KEY (SoCCCD) REFERENCES NHAN_KHAU(SoCCCD)
);
GO

-- 6. BẢNG TÀI KHOẢN VNEID (Quản lý định danh điện tử)
CREATE TABLE TAI_KHOAN_VNEID (
    SoCCCD VARCHAR(12) NOT NULL PRIMARY KEY, -- 1 người chỉ có 1 tài khoản
    SoDienThoai VARCHAR(15) NOT NULL,
    MatKhau VARCHAR(255) NOT NULL,
    MucDoDinhDanh INT DEFAULT 1, -- Mức 1 hoặc Mức 2
    TrangThai NVARCHAR(50) DEFAULT N'Hoạt động',
    
    -- Khóa ngoại
    CONSTRAINT FK_TaiKhoan_NhanKhau FOREIGN KEY (SoCCCD) REFERENCES NHAN_KHAU(SoCCCD)
);
GO


-- 1. THÊM DỮ LIỆU BẢNG NHÂN KHẨU
INSERT INTO NHAN_KHAU (SoCCCD, HoTen, NgaySinh, GioiTinh, QueQuan, DanToc, TonGiao, NhomMau)
VALUES 
('001099000001', N'Trần Văn Ông', '1950-10-10', N'Nam', N'Hà Nội', N'Kinh', N'Không', 'O'),
('001099000002', N'Nguyễn Thị Bà', '1955-05-20', N'Nữ', N'Hà Nội', N'Kinh', N'Phật giáo', 'A'),
('001099000003', N'Trần Văn Cha', '1978-02-15', N'Nam', N'Hà Nội', N'Kinh', N'Không', 'O'),
('001099000004', N'Lê Thị Mẹ', '1982-11-22', N'Nữ', N'Thanh Hóa', N'Kinh', N'Không', 'B'),
('001099000005', N'Trần Thị Con Gái', '2005-08-08', N'Nữ', N'Hà Nội', N'Kinh', N'Không', 'O'),
('001099000006', N'Trần Văn Con Trai', '2010-12-01', N'Nam', N'Hà Nội', N'Kinh', N'Không', 'AB'),
('038099000007', N'Lê Hoàng Sinh Viên', '2004-09-05', N'Nam', N'Nghệ An', N'Kinh', N'Công giáo', 'A');
GO

-- 2. THÊM DỮ LIỆU BẢNG HỘ KHẨU
INSERT INTO HO_KHAU (MaHoKhau, SoCCCD_ChuHo, DiaChiThuongTru, NgayLapHo)
VALUES 
('HK_HN_0001', '001099000001', N'Số 10, Ngõ 20, Phố Vọng, Hai Bà Trưng, Hà Nội', '2000-01-01'),
('HK_HN_0002', '001099000003', N'Căn hộ 12A, Chung cư X, Thanh Xuân, Hà Nội', '2015-06-10'),
('HK_NA_0003', '038099000007', N'Xóm 5, Xã Y, Huyện Quỳnh Lưu, Nghệ An', '2022-09-01');
GO

-- 3. THÊM DỮ LIỆU BẢNG THÀNH VIÊN HỘ
INSERT INTO THANH_VIEN_HO (MaHoKhau, SoCCCD, QuanHeVoiChuHo, NgayNhapKhau)
VALUES 
('HK_HN_0001', '001099000002', N'Vợ', '2000-01-01'),
('HK_HN_0002', '001099000004', N'Vợ', '2015-06-10'),
('HK_HN_0002', '001099000005', N'Con đẻ', '2015-06-10'),
('HK_HN_0002', '001099000006', N'Con đẻ', '2015-06-10');
GO

-- 4. THÊM DỮ LIỆU BẢNG QUAN HỆ GIA ĐÌNH
INSERT INTO QUAN_HE_GIA_DINH (SoCCCD_Nguoi1, SoCCCD_Nguoi2, LoaiQuanHe)
VALUES 
('001099000001', '001099000002', N'Vợ Chồng'),
('001099000003', '001099000004', N'Vợ Chồng'),
('001099000001', '001099000003', N'Cha Con'),
('001099000002', '001099000003', N'Mẹ Con'),
('001099000003', '001099000005', N'Cha Con'),
('001099000004', '001099000005', N'Mẹ Con');
GO

-- 5. THÊM DỮ LIỆU BẢNG KHAI BÁO CƯ TRÚ
INSERT INTO KHAI_BAO_CU_TRU (MaKhaiBao, SoCCCD, LoaiKhaiBao, DiaChiCuTru, TuNgay, DenNgay, LyDo)
VALUES 
('KB_TT_001', '001099000005', N'Tạm trú', N'Ký túc xá ĐH Bách Khoa Hà Nội', '2023-09-05', '2027-09-05', N'Đi học'),
('KB_TT_002', '038099000007', N'Tạm trú', N'Số 5, Ngõ 10, Tạ Quang Bửu, Hà Nội', '2024-02-10', '2024-08-10', N'Thuê trọ đi học'),
('KB_TV_001', '001099000003', N'Tạm vắng', N'Hồ Chí Minh', '2024-04-01', '2024-05-01', N'Đi công tác');
GO

-- 6. THÊM DỮ LIỆU BẢNG TÀI KHOẢN VNEID
INSERT INTO TAI_KHOAN_VNEID (SoCCCD, SoDienThoai, MatKhau, MucDoDinhDanh, TrangThai)
VALUES 
('001099000003', '0901234567', 'hashed_pass_123', 2, N'Hoạt động'),
('001099000004', '0912345678', 'hashed_pass_456', 2, N'Hoạt động'),
('001099000005', '0987654321', 'hashed_pass_789', 1, N'Hoạt động'),
('038099000007', '0977111222', 'hashed_pass_abc', 2, N'Hoạt động');
GO
