-- =========================================================================
-- PHẦN 1: TẠO VÀ SỬ DỤNG CƠ SỞ DỮ LIỆU
-- =========================================================================
CREATE DATABASE QuanLyNhanKhau;
GO

USE QuanLyNhanKhau;
GO

-- =========================================================================
-- PHẦN 2: TẠO CÁC BẢNG (TABLES) VÀ KHÓA CHÍNH, KHÓA NGOẠI
-- LƯU Ý: Phải tạo bảng NHAN_KHAU đầu tiên vì các bảng khác đều nối vào nó
-- =========================================================================

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