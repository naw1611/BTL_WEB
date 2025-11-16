-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 16, 2025 at 09:00 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sports_shop`
--

-- --------------------------------------------------------

--
-- Table structure for table `cartitems`
--

CREATE TABLE `cartitems` (
  `MaCart` int(11) NOT NULL,
  `MaUser` int(11) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `SoLuong` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `cartitems`
--

INSERT INTO `cartitems` (`MaCart`, `MaUser`, `MaSP`, `SoLuong`) VALUES
(2, 3, 24, 1),
(3, 2, 13, 2),
(4, 3, 27, 1),
(38, 6, 4, 1),
(44, 6, 35, 1),
(53, 8, 33, 1),
(54, 8, 2, 1),
(55, 6, 22, 1);

-- --------------------------------------------------------

--
-- Table structure for table `chitietdonhang`
--

CREATE TABLE `chitietdonhang` (
  `MaChiTiet` int(11) NOT NULL,
  `MaDon` int(11) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `SoLuong` int(11) DEFAULT 1,
  `DonGia` decimal(10,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `chitietdonhang`
--

INSERT INTO `chitietdonhang` (`MaChiTiet`, `MaDon`, `MaSP`, `SoLuong`, `DonGia`) VALUES
(1, 3, 17, 1, NULL),
(2, 3, 22, 1, NULL),
(3, 1, 19, 1, NULL),
(4, 2, 18, 1, NULL),
(5, 1, 6, 1, NULL),
(6, 4, 2, 1, 150000.00),
(7, 4, 9, 1, 800000.00),
(8, 4, 3, 1, 70000.00),
(9, 7, 8, 1, 300000.00),
(10, 7, 20, 1, 1250000.00),
(14, 10, 1, 1, 200000.00),
(15, 10, 7, 1, 179400.00),
(16, 11, 28, 1, 250000.00);

-- --------------------------------------------------------

--
-- Table structure for table `danhmuc`
--

CREATE TABLE `danhmuc` (
  `MaDanhMuc` int(11) NOT NULL,
  `TenDanhMuc` varchar(200) NOT NULL,
  `MoTa` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `danhmuc`
--

INSERT INTO `danhmuc` (`MaDanhMuc`, `TenDanhMuc`, `MoTa`) VALUES
(1, 'Cầu Lông', 'Các sản phẩm và dụng cụ chơi cầu lông.'),
(2, 'Bóng ', 'Các sản phẩm và dụng cụ chơi bóng .'),
(3, 'Găng tay', 'các bộ găng tay tương đương với bộ môn thể thao phù hợp'),
(4, 'Vợt', 'Vợt thể thao chất lượng cao, thiết kế gọn nhẹ, phù hợp mọi trình độ'),
(5, 'Gậy', 'Gậy thể thao chất lượng cao, giúp kiểm soát bóng chính xác'),
(6, 'Phụ kiện', 'Phụ kiện thể thao đa dạng, tiện lợi, hỗ trợ tập luyện hiệu quả'),
(7, 'Giày', 'Giày thể thao nhẹ, êm chân, tối ưu cho luyện tập và thi đấu.'),
(8, 'Ván Trượt', 'Các loại ván và phụ kiện trượt ván.');

-- --------------------------------------------------------

--
-- Table structure for table `donhang`
--

CREATE TABLE `donhang` (
  `MaDon` int(11) NOT NULL,
  `MaUser` int(11) NOT NULL,
  `NgayDat` datetime DEFAULT NULL,
  `TongTien` decimal(12,2) DEFAULT NULL,
  `TrangThai` varchar(50) DEFAULT 'Đang xử lý',
  `DiaChiGiao` varchar(255) DEFAULT NULL,
  `SDT` varchar(20) DEFAULT NULL,
  `TenNguoiNhan` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `donhang`
--

INSERT INTO `donhang` (`MaDon`, `MaUser`, `NgayDat`, `TongTien`, `TrangThai`, `DiaChiGiao`, `SDT`, `TenNguoiNhan`) VALUES
(1, 3, '2025-10-27 00:00:00', 769000.00, 'Đã hủy', '101 Đường Test, TP. Thủ Đức', NULL, NULL),
(2, 2, '2025-10-28 00:00:00', 4500000.00, 'Đã giao hàng', '999 Đường Quản Lý, Q. Phú Nhuận, TP.HCM', NULL, NULL),
(3, 1, '2025-10-28 00:00:00', 179000.00, 'Đã giao hàng', '303 Hẻm VIP, Đà Nẵng', NULL, NULL),
(4, 6, '2025-10-29 00:00:00', 1020000.00, 'Đã giao hàng', 'Phú Thọ', NULL, NULL),
(7, 6, '2025-11-03 16:30:30', 1550000.00, 'Đã hủy', 'Phú Thọ', '0967730504', 'Trần Anh Nam'),
(10, 6, '2025-11-07 14:30:31', 379400.00, 'Đã giao hàng', 'Phú Thọ', '0967730504', 'Trần Anh Nam'),
(11, 7, '2025-11-12 11:00:13', 250000.00, 'Đã giao hàng', 'Hải Dương', '0373994214', 'Nguyễn Thị Huyền Trang');

-- --------------------------------------------------------

--
-- Table structure for table `khuyenmai`
--

CREATE TABLE `khuyenmai` (
  `MaKM` int(11) NOT NULL,
  `TenKM` varchar(100) DEFAULT NULL,
  `NoiDung` text DEFAULT NULL,
  `NgayBatDau` date DEFAULT NULL,
  `NgayKetThuc` date DEFAULT NULL,
  `PhanTramGiam` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `khuyenmai`
--

INSERT INTO `khuyenmai` (`MaKM`, `TenKM`, `NoiDung`, `NgayBatDau`, `NgayKetThuc`, `PhanTramGiam`) VALUES
(1, 'KM Bóng Đá 20.4%', 'Giảm giá bóng đá còn 199.000 VNĐ', '2025-11-01', '2025-11-30', 20.40),
(2, 'KM Bóng Chuyền 22.17%', 'Giảm giá bóng chuyền còn 179.000 VNĐ', '2025-11-01', '2025-11-30', 22.17),
(3, 'KM Bóng Rổ 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(4, 'KM Bóng Chày 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(5, 'KM Bóng Pickleball 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(6, 'KM Cầu Lông 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(7, 'KM Bóng Bàn 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(8, 'KM Bóng Bầu Dục 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(9, 'KM Golf 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(10, 'KM Bóng Tennis 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(11, 'KM Găng Tay Bóng Chày 16.2%', 'Giảm giá găng tay bóng chày còn 419.000 VNĐ', '2025-11-01', '2025-11-30', 16.20),
(12, 'KM Găng Tay Bóng Đá 0%', 'Giảm giá găng tay bóng đá không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(13, 'KM Vợt Tennis 11.33%', 'Giảm giá vợt tennis còn 399.000 VNĐ', '2025-11-01', '2025-11-30', 11.33),
(14, 'KM Vợt Cầu Lông 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(15, 'KM Vợt Pickleball 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(16, 'KM Vợt Bóng Bàn 15.05%', 'Giảm giá vợt bóng bàn còn 1.699.000 VNĐ', '2025-11-01', '2025-11-30', 15.05),
(17, 'KM Gậy Bóng Chày 14.34%', 'Giảm giá gậy bóng chày còn 1.499.000 VNĐ', '2025-11-01', '2025-11-30', 14.34),
(18, 'KM Gậy Khúc Côn Cầu 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(19, 'KM Gậy Golf 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(20, 'KM Gậy Trượt Tuyết 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(21, 'KM Mũ BH Thể Thao 19.59%', 'Giảm giá mũ bảo hiểm thể thao còn 599.000 VNĐ', '2025-11-01', '2025-11-30', 19.59),
(22, 'KM Tai Nghe Chống Nước 12.91%', 'Giảm giá tai nghe chống nước còn 479.000 VNĐ', '2025-11-01', '2025-11-30', 12.91),
(23, 'KM Tạ Tay 23.82%', 'Giảm giá tạ tay còn 499.000 VNĐ', '2025-11-01', '2025-11-30', 23.82),
(24, 'KM Đồng Hồ Thể Thao 11.51%', 'Giảm giá đồng hồ thể thao còn 1.199.000 VNĐ', '2025-11-01', '2025-11-30', 11.51),
(25, 'KM Kính Bơi 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(26, 'KM Mũ Trùm Bơi 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(27, 'KM Túi Đựng Thể Thao 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(28, 'KM Bình Nước Thể Thao 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(29, 'KM Phụ Kiện Bảo Hộ 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(30, 'KM Thảm Tập Yoga 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(31, 'KM Dây Kháng Lực 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(32, 'KM Giày Patin 13.4%', 'Giảm giá giày patin còn 1.299.000 VNĐ', '2025-11-01', '2025-11-30', 13.40),
(33, 'KM Giày Đá Bóng 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(34, 'KM Giày Trượt Băng 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00),
(35, 'KM Ván Lướt Sóng 11.15%', 'Giảm giá ván lướt sóng còn 2.399.000 VNĐ', '2025-11-01', '2025-11-30', 11.15),
(36, 'KM Ván Trượt Truyền Thống 0%', 'Không giảm giá', '2025-11-01', '2025-11-30', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `lienhe`
--

CREATE TABLE `lienhe` (
  `MaLienHe` int(11) NOT NULL,
  `MaUser` int(11) DEFAULT NULL,
  `TenKhach` varchar(100) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `NoiDung` text NOT NULL,
  `NgayGui` datetime DEFAULT current_timestamp(),
  `TrangThai` varchar(50) DEFAULT 'Chưa xử lý',
  `PhanHoi` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `NgayPhanHoi` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lienhe`
--

INSERT INTO `lienhe` (`MaLienHe`, `MaUser`, `TenKhach`, `Email`, `NoiDung`, `NgayGui`, `TrangThai`, `PhanHoi`, `NgayPhanHoi`) VALUES
(1, 4, 'Hoàng Văn Cảnh', 'hoangvanccanh@test.com', 'Tôi muốn khiếu nại về chất lượng của sản phẩm Tạ Tay đã nhận.', '2025-10-27 16:13:41', 'Đã phản hồi', 'Chúng tôi xin lỗi vì chất lượng sản phẩm . Chúng tôi có thể đổi hàng giúp bạn được không ?', '2025-11-13 11:35:50'),
(2, NULL, 'Nguyễn Văn F', 'nguyenvf@unknown.com', 'Tôi không thể thanh toán đơn hàng bằng thẻ tín dụng. Xin kiểm tra giúp.', '2025-10-27 16:13:41', 'Chưa xử lý', NULL, NULL),
(3, 5, 'Phạm Thị Hà', 'superadmin@shop.com', 'Kiểm tra xem chức năng phản hồi tự động có hoạt động tốt không?', '2025-10-27 16:13:41', 'Đã xử lý', NULL, NULL),
(4, NULL, 'Lê Thị Giang', 'lethigiang@hot.com', 'Khuyến mãi Giày Patin đến khi nào thì kết thúc?', '2025-10-27 16:13:41', 'Đã xử lý', NULL, NULL),
(5, 6, 'Trần Anh Nam', 'namanh272xh@gmail.com', 'tôi muốn thiết kế riêng găng tay bóng đá', '2025-11-13 11:44:01', 'Đã phản hồi', 'Dạ 2TQN xin chào quý khách . Bạn có thể cho mình thêm yêu cầu về thiết kế mà bạn mong muốn được không ?', '2025-11-13 11:45:31');

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `MaReview` int(11) NOT NULL,
  `MaSP` int(11) NOT NULL,
  `MaUser` int(11) NOT NULL,
  `SoSao` int(11) NOT NULL CHECK (`SoSao` between 1 and 5),
  `NoiDung` text DEFAULT NULL,
  `NgayDanhGia` datetime DEFAULT current_timestamp(),
  `AdminReply` text DEFAULT NULL,
  `AdminReplyDate` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `reviews`
--

INSERT INTO `reviews` (`MaReview`, `MaSP`, `MaUser`, `SoSao`, `NoiDung`, `NgayDanhGia`, `AdminReply`, `AdminReplyDate`) VALUES
(1, 1, 1, 5, 'Giày rất êm, đi cả ngày không đau chân. Màu sắc đẹp, đúng như hình. Giao hàng nhanh!', '2025-11-10 09:30:00', NULL, NULL),
(2, 1, 1, 4, 'Chất lượng tốt, nhưng size hơi nhỏ hơn so với bảng size. Nên chọn lớn hơn 1 size.', '2025-11-12 14:20:00', NULL, NULL),
(3, 1, 2, 5, 'Tuyệt vời! Đi học thể dục thoải mái, không bị bí. Đáng tiền!', '2025-11-13 10:15:00', NULL, NULL),
(4, 2, 3, 4, 'Áo mềm, mát, giặt không phai màu. Nhưng cổ hơi rộng, nên mặc layer bên trong.', '2025-11-14 16:45:00', NULL, NULL),
(5, 2, 3, 5, 'Mua cho bạn trai, anh ấy thích lắm. Form chuẩn, in sắc nét. Sẽ mua thêm!', '2025-11-15 20:10:00', NULL, NULL),
(10, 1, 6, 5, 'sản phẩm oke nha mn', '2025-11-16 14:45:59', 'Cảm ơn bạn đã ủng hộ cửa hàng của chúng tôi . Hi vọng sẽ gặp lại bạn ở đơn hàng tiếp theo', '2025-11-16 14:54:39');

-- --------------------------------------------------------

--
-- Table structure for table `sanpham`
--

CREATE TABLE `sanpham` (
  `MaSP` int(11) NOT NULL,
  `TenSP` varchar(150) NOT NULL,
  `CodeSP` varchar(20) NOT NULL,
  `Gia` decimal(10,2) NOT NULL,
  `SoLuong` int(11) DEFAULT 0,
  `HinhAnh` varchar(255) DEFAULT NULL,
  `MoTa` text DEFAULT NULL,
  `MaDanhMuc` int(11) DEFAULT NULL,
  `MaKM` int(11) DEFAULT NULL,
  `DaXoa` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sanpham`
--

INSERT INTO `sanpham` (`MaSP`, `TenSP`, `CodeSP`, `Gia`, `SoLuong`, `HinhAnh`, `MoTa`, `MaDanhMuc`, `MaKM`, `DaXoa`) VALUES
(1, 'Bóng Đá', 'BD001', 250000.00, 48, 'bongda.jpg', 'Màu xanh lá, đen, đỏ, vàng, xanh dương, cam; Chu vi 70, đường kính 22', 2, 1, 0),
(2, 'Cầu Lông', 'CL001', 150000.00, 100, 'caulong.jpg', '12 quả/ bộ', 1, 6, 0),
(3, 'Bóng Bàn', 'BB001', 70000.00, 200, 'bongban.jpg', 'Màu cam, xanh lá; Chu vi 12.5, đường kính 4', 2, 7, 0),
(4, 'Bóng Rổ', 'BR001', 300000.00, 30, 'bongro.jpg', 'Chu vi 76, đường kính 24', 2, 3, 0),
(5, 'Bóng Chày', 'BC001', 280000.00, 40, 'bongchay.jpg', 'Chu vi 23, đường kính 7.4', 2, 4, 0),
(6, 'Bóng Pickleball', 'BP001', 150000.00, 60, 'bongpickle.jpg', '6 quả/ bộ; Chu vi 7.4, đường kính 7.4', 2, 5, 0),
(7, 'Bóng Chuyền', 'BCH001', 230000.00, 35, 'bongchuyen.jpg', 'Chu vi 65, đường kính 20', 2, 2, 0),
(8, 'Bóng Bầu Dục', 'BBD001', 300000.00, 20, 'bongbauduc.jpg', 'Chu vi 78, đường kính 25', 2, 8, 0),
(9, 'Golf', 'G001', 800000.00, 50, 'golf.jpg', '12 quả/ bộ', 2, 9, 0),
(10, 'Bóng Tennis', 'BT001', 150000.00, 60, 'bongtennis.jpg', '3 quả/ bộ', 2, 10, 0),
(11, 'Găng Tay Bóng Chày', 'GTC001', 500000.00, 40, 'gangtaychay.jpg', 'Màu đen, nâu, cam, đỏ, xanh dương', 3, 11, 0),
(12, 'Găng Tay Bóng Đá', 'GTD001', 200000.00, 80, 'gangtayda.jpg', 'Màu đen, xanh lá, xanh dương, vàng, cam, hồng, trắng', 3, 12, 0),
(13, 'Vợt Tennis', 'VT001', 450000.00, 50, 'votennis.jpg', 'Màu trắng, vàng, xanh lá, xanh dương, đỏ, cam, tím, hồng', 4, 13, 0),
(14, 'Vợt Cầu Lông', 'VCL001', 550000.00, 60, 'vcaulong.jpg', 'Màu trắng, vàng, xanh lá, xanh dương, đỏ, cam, tím, hồng', 4, 14, 0),
(15, 'Vợt Bóng Bàn', 'VBB001', 2000000.00, 30, 'vbbongban.jpg', '', 4, 16, 0),
(16, 'Vợt Pickleball', 'VP001', 350000.00, 50, 'vpickleball.jpg', 'Viền xanh lá, xanh dương, tím, hồng, đỏ, cam, trắng', 4, 15, 0),
(17, 'Gậy Bóng Chày', 'GBC001', 1750000.00, 25, 'gaychay.jpg', 'Màu đỏ, đen, trắng, xanh dương', 5, 17, 0),
(18, 'Khúc Côn Cầu', 'KCH001', 2000000.00, 15, 'khucconcau.jpg', '', 5, 18, 0),
(19, 'Gậy Golf', 'GG001', 3700000.00, 20, 'gaygolf.jpg', '', 5, 19, 0),
(20, 'Gậy Trượt Tuyết', 'GTT001', 1250000.00, 30, 'gaytruytuyet.jpg', 'Màu đen, trắng, đỏ, cam', 5, 20, 0),
(21, 'Kính Bơi', 'KB001', 100000.00, 100, 'kinhboi.jpg', 'Màu xanh dương, cam, đen, hồng, tím, đỏ', 6, 25, 0),
(22, 'Mũ Bảo Hiểm Thể Thao', 'MBH001', 745000.00, 40, 'mubaohiem.jpg', 'Màu xanh lá, đỏ, vàng, cam, xanh dương, trắng, đen', 6, 21, 0),
(23, 'Tai Nghe Chống Nước', 'TN001', 550000.00, 35, 'tainhe.jpg', 'Màu đen, trắng', 6, 22, 0),
(24, 'Tạ Tay', 'TT001', 655000.00, 50, 'tatay.jpg', 'Màu hồng, xanh lá, xanh dương, đỏ, cam', 6, 23, 0),
(25, 'Mũ Trùm Bơi', 'MT001', 155000.00, 60, 'mutrumboi.jpg', 'Màu cam, xanh lá, vàng, đen', 6, 26, 0),
(26, 'Đồng Hồ Thể Thao', 'DH001', 1355000.00, 25, 'dongho.jpg', 'Màu đen, trắng', 6, 24, 0),
(27, 'Túi Đựng Thể Thao', 'TDT001', 330000.00, 40, 'tuiththethao.jpg', 'Màu đen, trắng', 6, 27, 0),
(28, 'Bình Nước Thể Thao', 'BN001', 250000.00, 49, 'binhnuocthethao.jpg', 'Màu hồng, cam, đen, trắng, xanh lá', 6, 28, 0),
(29, 'Phụ Kiện Bảo Hộ', 'PK001', 245000.00, 59, 'phukienbaohothethao.jpg', '', 6, 29, 0),
(30, 'Thảm Tập Yoga', 'TY001', 270000.00, 40, 'tham.jpg', 'Màu hồng, tím, vàng, cam, xanh lá, đỏ, xanh dương, đen, trắng', 6, 30, 0),
(31, 'Dây Kháng Lực', 'DKL001', 160000.00, 50, 'daykhangluc.jpg', 'Màu hồng, tím, vàng, cam, xanh lá, đỏ, xanh dương, đen, trắng', 6, 30, 0),
(32, 'Giày Đá Bóng', 'GDB001', 850000.00, 40, 'giaydabong.jpg', 'Màu hồng, tím, vàng, cam, xanh lá, đỏ, xanh dương, đen, trắng, nâu, xám; size 35-43', 7, 33, 0),
(33, 'Giày Patin', 'GP001', 1500000.00, 35, 'giaypatin.jpg', 'Giảm giá còn 1.299.000 VNĐ; Màu hồng, tím, vàng, cam, xanh lá, đỏ, xanh dương, đen, trắng; size 32-43', 7, 32, 0),
(34, 'Giày Trượt Băng', 'GTB001', 2100000.00, 20, 'giaytrutbang.jpg', 'Màu đen, xám, trắng; size 35, 36, 38, 40, 42-45', 7, 34, 0),
(35, 'Ván Trượt Truyền Thống', 'VTT001', 1200000.00, 25, 'vantruytthong.jpg', 'Màu hồng, tím, vàng, cam, xanh lá, đỏ, xanh dương, đen, trắng; kích cỡ 18-22', 8, 36, 0),
(36, 'Ván Lướt Sóng', 'VLS001', 2700000.00, 15, 'vanluotsong.jpg', 'Giảm giá còn 2.399.000 VNĐ; Màu xanh lá, cam, vàng; kích cỡ 45-60', 8, 36, 0),
(37, 'Áo bóng đá', 'ABD001', 100000.00, 50, 'ao-bongda.jpg', 'áo thoáng mát , dễ vận động', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `MaUser` int(11) NOT NULL,
  `Username` varchar(50) NOT NULL,
  `FullName` varchar(100) NOT NULL,
  `MatKhau` varchar(255) NOT NULL,
  `Email` varchar(100) NOT NULL,
  `SoDienThoai` varchar(20) DEFAULT NULL,
  `DiaChi` varchar(255) DEFAULT NULL,
  `NgayTao` datetime DEFAULT current_timestamp(),
  `Role` varchar(20) DEFAULT 'user',
  `TrangThai` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`MaUser`, `Username`, `FullName`, `MatKhau`, `Email`, `SoDienThoai`, `DiaChi`, `NgayTao`, `Role`, `TrangThai`) VALUES
(1, 'admin', 'Phạm Thị Hà', '$2a$10$IlQ8PuYImVMrNlAmW8UhIeLsNFpWnfEelcilKwtmuA1hZZRvxzD66', 'superadmin@shop.com', '0900112233', '999 Đường Quản Lý, Q. Phú Nhuận, TP.HCM', '2025-10-27 16:13:09', 'admin', 1),
(2, 'user03', 'Hoàng Văn Cảnh', '$2a$10$ZZZZZ', 'hoangvancanh@test.com', '0933445566', '101 Đường Test, TP. Hải Dương', '2025-10-27 16:13:09', 'user', 1),
(3, 'user04', 'Đỗ Thị Dung', '$2a$10$AAAABBBB', 'dothidung@test.com', '0966778899', '202 Phố Mua Sắm, Hà Nội', '2025-10-27 16:13:09', 'user', 1),
(4, 'vipuser', 'Trương Minh Đạt', '$2a$10$CCCCC', 'truongminhdat@vip.com', '0977889900', '303 Hẻm VIP, Thái Bình', '2025-10-27 16:13:09', 'user', 1),
(5, 'newcustomer', 'Bùi Thị Lan', '$2a$10$DDDDDD', 'buithilan@fresh.com', '0888776655', '404 Đường Mới, Hải Phòng', '2025-10-27 16:13:09', 'user', 1),
(6, 'nam1611', 'Trần Anh Nam', '$2a$12$Zbmhp..4wS5NIdVkQdSsb.OKmvqFI1UKPrw31hFAFAcWrXETWlbHS', 'namanh272xh@gmail.com', '0967730504', 'Vĩnh Phúc', '2025-10-27 16:17:45', 'user', 1),
(7, 'trang1402', 'Nguyễn Thị Huyền Trang', '$2a$10$xNiiriDENhKbH0VFSboThuP2aK11xfVoIwNN/QBzHQ9VdwRIF/0RW', 'trang1402@gmail.com', '0373994214', 'Hải Dương', '2025-10-27 17:13:00', 'user', 1),
(8, 'quynh2812', 'Bùi Thị Như Quỳnh', '$2a$10$T.5EB0h6S0c2O0n.E6OKqusppkoaiZ5nFT.3UDS4m8J6wnfQxARna', 'Quynh2812@gmail.com', '0335787267', 'Thái Bình', '2025-10-27 17:14:52', 'user', 1),
(9, 'Trang2111', 'Trịnh Thu Trang', '$2a$10$h2KVd48OQo5wat8TMLMMae/GkOdmGp/ePy48W4Ku1WAVgxZUNjADK', 'trang2111@gmail.com', '0987652412', 'Hà Nam', '2025-10-27 17:16:00', 'user', 1);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD PRIMARY KEY (`MaCart`),
  ADD KEY `MaUser` (`MaUser`),
  ADD KEY `MaSP` (`MaSP`);

--
-- Indexes for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD PRIMARY KEY (`MaChiTiet`),
  ADD KEY `MaDon` (`MaDon`),
  ADD KEY `MaSP` (`MaSP`);

--
-- Indexes for table `danhmuc`
--
ALTER TABLE `danhmuc`
  ADD PRIMARY KEY (`MaDanhMuc`);

--
-- Indexes for table `donhang`
--
ALTER TABLE `donhang`
  ADD PRIMARY KEY (`MaDon`),
  ADD KEY `MaUser` (`MaUser`);

--
-- Indexes for table `khuyenmai`
--
ALTER TABLE `khuyenmai`
  ADD PRIMARY KEY (`MaKM`);

--
-- Indexes for table `lienhe`
--
ALTER TABLE `lienhe`
  ADD PRIMARY KEY (`MaLienHe`),
  ADD KEY `MaUser` (`MaUser`);

--
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`MaReview`),
  ADD KEY `MaSP` (`MaSP`),
  ADD KEY `MaUser` (`MaUser`);

--
-- Indexes for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD PRIMARY KEY (`MaSP`),
  ADD UNIQUE KEY `CodeSP` (`CodeSP`),
  ADD KEY `MaDanhMuc` (`MaDanhMuc`),
  ADD KEY `MaKM` (`MaKM`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`MaUser`),
  ADD UNIQUE KEY `Username` (`Username`),
  ADD UNIQUE KEY `Email` (`Email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cartitems`
--
ALTER TABLE `cartitems`
  MODIFY `MaCart` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=56;

--
-- AUTO_INCREMENT for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  MODIFY `MaChiTiet` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `danhmuc`
--
ALTER TABLE `danhmuc`
  MODIFY `MaDanhMuc` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `donhang`
--
ALTER TABLE `donhang`
  MODIFY `MaDon` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `khuyenmai`
--
ALTER TABLE `khuyenmai`
  MODIFY `MaKM` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `lienhe`
--
ALTER TABLE `lienhe`
  MODIFY `MaLienHe` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `MaReview` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `sanpham`
--
ALTER TABLE `sanpham`
  MODIFY `MaSP` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=38;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `MaUser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cartitems`
--
ALTER TABLE `cartitems`
  ADD CONSTRAINT `cartitems_ibfk_1` FOREIGN KEY (`MaUser`) REFERENCES `users` (`MaUser`),
  ADD CONSTRAINT `cartitems_ibfk_2` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Constraints for table `chitietdonhang`
--
ALTER TABLE `chitietdonhang`
  ADD CONSTRAINT `chitietdonhang_ibfk_1` FOREIGN KEY (`MaDon`) REFERENCES `donhang` (`MaDon`),
  ADD CONSTRAINT `chitietdonhang_ibfk_2` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`);

--
-- Constraints for table `donhang`
--
ALTER TABLE `donhang`
  ADD CONSTRAINT `donhang_ibfk_1` FOREIGN KEY (`MaUser`) REFERENCES `users` (`MaUser`);

--
-- Constraints for table `lienhe`
--
ALTER TABLE `lienhe`
  ADD CONSTRAINT `lienhe_ibfk_1` FOREIGN KEY (`MaUser`) REFERENCES `users` (`MaUser`);

--
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`MaSP`) REFERENCES `sanpham` (`MaSP`),
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`MaUser`) REFERENCES `users` (`MaUser`);

--
-- Constraints for table `sanpham`
--
ALTER TABLE `sanpham`
  ADD CONSTRAINT `sanpham_ibfk_1` FOREIGN KEY (`MaDanhMuc`) REFERENCES `danhmuc` (`MaDanhMuc`),
  ADD CONSTRAINT `sanpham_ibfk_2` FOREIGN KEY (`MaKM`) REFERENCES `khuyenmai` (`MaKM`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
