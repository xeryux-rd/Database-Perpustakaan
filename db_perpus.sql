-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 10 Feb 2025 pada 17.57
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_perpus`
--

DELIMITER $$
--
-- Prosedur
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DeleteBuku` (IN `id` INT)   BEGIN DELETE FROM buku WHERE id_buku = id; END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertBuku` (IN `p_judul` VARCHAR(255), IN `p_penulis` VARCHAR(255), IN `p_kategori` VARCHAR(100), IN `p_stok` INT)   BEGIN
    INSERT INTO buku (judul_buku, penulis, kategori, stok) 
    VALUES (p_judul, p_penulis, p_kategori, p_stok);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertPeminjaman` (IN `p_id_siswa` INT, IN `p_id_buku` INT, IN `p_tanggal_pinjam` DATE, IN `p_tanggal_kembali` DATE)   BEGIN
    INSERT INTO peminjaman (id_siswa, id_buku, tanggal_pinjam, tanggal_kembali, status) 
    VALUES (p_id_siswa, p_id_buku, p_tanggal_pinjam, p_tanggal_kembali, 'Dipinjam');

    -- Mengurangi stok buku secara otomatis saat dipinjam
    UPDATE buku SET stok = stok - 1 WHERE id_buku = p_id_buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `InsertSiswa` (IN `p_nama` VARCHAR(255), IN `p_kelas` VARCHAR(50))   BEGIN
    INSERT INTO siswa (nama, kelas) 
    VALUES (p_nama, p_kelas);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SemuaSiswa` ()   BEGIN
    SELECT s.id_siswa, s.nama, s.kelas, 
    IF(p.id_siswa IS NULL, 'Belum Pernah Meminjam', 'Pernah Meminjam') AS Status
    FROM siswa s
    LEFT JOIN peminjaman p ON s.id_siswa = p.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllBuku` ()   BEGIN
    SELECT * FROM buku;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllPeminjaman` ()   BEGIN
    SELECT * FROM peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ShowAllSiswa` ()   BEGIN
    SELECT * FROM siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_kembalikan_buku` (IN `p_id_peminjaman` INT)   BEGIN
    -- Update status dan tanggal kembali ke tanggal saat ini
    UPDATE peminjaman
    SET 
        Status = 'Dikembalikan',
        tanggal_kembalian = CURDATE()
    WHERE 
        id_peminjaman = p_id_peminjaman;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_semua_buku` ()   BEGIN
    SELECT 
        b.*,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM peminjaman p 
                WHERE p.id_buku = b.id_buku
            ) THEN 'Pernah Dipinjam'
            ELSE 'Belum Pernah Dipinjam'
        END AS Status_Peminjaman
    FROM 
        buku b;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_semua_siswa` ()   BEGIN
    SELECT 
        s.*,
        CASE 
            WHEN EXISTS (
                SELECT 1 
                FROM peminjaman p 
                WHERE p.id_siswa = s.id_siswa
            ) THEN 'Pernah Meminjam'
            ELSE 'Tidak Pernah Meminjam'
        END AS Status_Peminjaman
    FROM 
        siswa s;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_siswa_peminjam` ()   BEGIN
    SELECT DISTINCT 
        siswa.id_siswa,
        siswa.nama,
        siswa.kelas
    FROM 
        siswa
    INNER JOIN 
        peminjaman ON siswa.id_siswa = peminjaman.id_siswa;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `UpdateBuku` (IN `id` INT, IN `new_stok` INT)   BEGIN UPDATE buku SET stok = new_stok WHERE id_buku = id; 
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `buku`
--

CREATE TABLE `buku` (
  `id_buku` int(11) NOT NULL,
  `judul_buku` varchar(255) DEFAULT NULL,
  `penulis` varchar(255) DEFAULT NULL,
  `kategori` varchar(100) DEFAULT NULL,
  `stok` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `buku`
--

INSERT INTO `buku` (`id_buku`, `judul_buku`, `penulis`, `kategori`, `stok`) VALUES
(1, 'Algoritma dan Pemrograman', 'Andi Wijaya', 'Teknologi', 5),
(2, 'Dasar-dasar Database', 'Budi Santoso', 'Teknologi', 7),
(3, 'Matematika Diskrit', 'Rina Sari', 'Matematika', 4),
(4, 'Sejarah Dunia', 'John Smith', 'Sejarah', 3),
(5, 'Pemrograman Web dengan PHP', 'Eko Prasetyo', 'Teknologi', 8),
(6, 'Sistem Operasi', 'Dian Kurniawan', 'Teknologi', 6),
(7, 'Jaringan Komputer', 'Ahmad Fauzi', 'Teknologi', 5),
(8, 'Cerita Rakyat Nusantara', 'Lestari Dewi', 'Sastra', 9),
(9, 'Bahasa Inggris untuk Pemula', 'Jane Doe', 'Bahasa', 10),
(10, 'Biologi Dasar', 'Budi Rahman', 'Sains', 7),
(11, 'Kimia Organik', 'Siti Aminah', 'Sains', 5),
(12, 'Teknik Elektro', 'Ridwan Hakim', 'Teknik', 6),
(13, 'Fisika Modern', 'Albert Einstein', 'Sains', 4),
(14, 'Manajemen Waktu', 'Steven Covey', 'Pengembangan', 8),
(15, 'Strategi Belajar Efektif', 'Tony Buzan', 'Pendidikan', 6);

-- --------------------------------------------------------

--
-- Struktur dari tabel `peminjaman`
--

CREATE TABLE `peminjaman` (
  `id_peminjaman` int(11) NOT NULL,
  `id_siswa` int(11) DEFAULT NULL,
  `id_buku` int(11) DEFAULT NULL,
  `tanggal_pinjam` date DEFAULT NULL,
  `tanggal_kembali` date DEFAULT NULL,
  `status` enum('Dipinjam','Dikembalikan') DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `peminjaman`
--

INSERT INTO `peminjaman` (`id_peminjaman`, `id_siswa`, `id_buku`, `tanggal_pinjam`, `tanggal_kembali`, `status`) VALUES
(1, 1, 1, '2025-02-01', '2025-02-08', 'Dipinjam'),
(2, 2, 2, '2025-01-28', '2025-02-04', 'Dikembalikan'),
(3, 3, 3, '2025-02-02', '2025-02-09', 'Dipinjam'),
(4, 4, 4, '2025-01-30', '2025-02-06', 'Dikembalikan'),
(5, 5, 5, '2025-01-25', '2025-02-01', 'Dikembalikan');

--
-- Trigger `peminjaman`
--
DELIMITER $$
CREATE TRIGGER `after_peminjaman_update` AFTER UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    -- akan cek jika status diubah menjadi 'Dikembalikan' dari status sebelumnya bukan 'Dikembalikan'
    IF NEW.status = 'Dikembalikan' AND OLD.status != 'Dikembalikan' THEN
        -- Tambah stok buku terkait
        UPDATE buku
        SET Stok = Stok + 1
        WHERE id_buku = NEW.id_buku;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `kurangi_stok` BEFORE INSERT ON `peminjaman` FOR EACH ROW BEGIN
    UPDATE buku SET stok = stok - 1 WHERE id_buku = NEW.id_buku;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `tambah_stok` BEFORE UPDATE ON `peminjaman` FOR EACH ROW BEGIN
    IF NEW.status = 'Dikembalikan' AND OLD.status = 'Dipinjam' THEN
        UPDATE buku SET stok = stok + 1 WHERE id_buku = NEW.id_buku;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `siswa`
--

CREATE TABLE `siswa` (
  `id_siswa` int(11) NOT NULL,
  `nama` varchar(255) DEFAULT NULL,
  `kelas` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `siswa`
--

INSERT INTO `siswa` (`id_siswa`, `nama`, `kelas`) VALUES
(1, 'Andi Saputra', 'X-RPL'),
(2, 'Budi Wijaya', 'X-TKJ'),
(3, 'Citra Lestari', 'XI-RPL'),
(4, 'Dewi Kurniawan', 'XI-TKJ'),
(5, 'Eko Prasetyo', 'XII-RPL');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `buku`
--
ALTER TABLE `buku`
  ADD PRIMARY KEY (`id_buku`);

--
-- Indeks untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD PRIMARY KEY (`id_peminjaman`),
  ADD KEY `id_siswa` (`id_siswa`),
  ADD KEY `id_buku` (`id_buku`);

--
-- Indeks untuk tabel `siswa`
--
ALTER TABLE `siswa`
  ADD PRIMARY KEY (`id_siswa`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `buku`
--
ALTER TABLE `buku`
  MODIFY `id_buku` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  MODIFY `id_peminjaman` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT untuk tabel `siswa`
--
ALTER TABLE `siswa`
  MODIFY `id_siswa` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `peminjaman`
--
ALTER TABLE `peminjaman`
  ADD CONSTRAINT `peminjaman_ibfk_1` FOREIGN KEY (`id_siswa`) REFERENCES `siswa` (`id_siswa`),
  ADD CONSTRAINT `peminjaman_ibfk_2` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
