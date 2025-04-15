-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Waktu pembuatan: 15 Apr 2025 pada 18.09
-- Versi server: 10.4.28-MariaDB
-- Versi PHP: 8.0.28

CREATE DATABASE IF NOT EXISTS `labprofile_elitia`;

USE `labprofile_elitia`;

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `labprofile_elitia`
--

-- --------------------------------------------------------

--
-- Struktur dari tabel `activity_logs`
--

CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL,
  `action` enum('create','update','delete','restore') NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `record_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `previous_data` text DEFAULT NULL,
  `new_data` text DEFAULT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `divisions`
--

CREATE TABLE `divisions` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `leader_id` int(11) DEFAULT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `divisions`
--

INSERT INTO `divisions` (`id`, `name`, `description`, `leader_id`, `img_url`, `created_at`, `deleted_at`) VALUES
(38, 'Riset', 'Melakukan riset reset', 89, 'assets/images/uploads/6dbfed86-dac5-4da1-b9ed-f47175f93600.png', '2025-04-09 06:22:17', NULL),
(39, 'Sekretaris', 'Sekre', 80, 'assets/images/uploads/e21cac81-ad53-4019-b1df-99f81969f807.png', '2025-04-09 06:25:55', NULL),
(40, 'Bendahara', 'Bendahara', 82, 'assets/images/uploads/2ec58e65-09d2-4a76-9b08-a589aa772567.png', '2025-04-09 06:26:12', NULL),
(41, 'Koordinator Laboratorium', 'Inti', 78, 'assets/images/uploads/41534b41-976b-4069-a732-daa3b988e704.png', '2025-04-09 06:26:34', NULL),
(42, 'Disiplin', 'Disiplin', 84, 'assets/images/uploads/a46ba0b0-5bf1-4dd4-a4d8-9b1ccd9d2056.png', '2025-04-09 06:28:50', NULL),
(43, 'Publikasi & Dokumentasi', 'Pubdok', 86, 'assets/images/uploads/32b3bd4b-99f6-4921-8279-649ff21ff31e.png', '2025-04-09 06:29:18', NULL),
(44, 'Hubungan Manusia', 'humas', 88, 'assets/images/uploads/ac740c6f-6455-4817-8976-0a6bc601f3f3.png', '2025-04-09 06:29:44', NULL),
(45, 'Praktikum', 'prak', 87, 'assets/images/uploads/552ddae5-75d7-4fbf-9764-8cdf97fc29e3.png', '2025-04-09 06:30:00', NULL),
(46, 'Logistik', 'log', 85, 'assets/images/uploads/e12582dd-1a20-4e8e-ba4d-66a03c8a087f.png', '2025-04-09 06:30:22', NULL);

-- --------------------------------------------------------

--
-- Struktur dari tabel `members`
--

CREATE TABLE `members` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `division_id` int(11) DEFAULT NULL,
  `role` enum('Ketua','Anggota') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Struktur dari tabel `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `role` enum('Tuhan','Admin','Anggota') NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `img_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data untuk tabel `users`
--

INSERT INTO `users` (`id`, `nama`, `role`, `username`, `password`, `img_url`, `created_at`) VALUES
(1, 'Farhan Naufal', 'Tuhan', 'ffl', '$2a$10$NW4WH/EVr8qXbvJMjvQEHu6lwrmKCy5J/F.G5nqmZQXS/xfGDUoYy', NULL, '2025-04-07 06:36:45'),
(78, 'Syifana Wulan Suci', 'Admin', 'arc', '$2a$10$UlViPivztjb8Pu9hIP3svO/DgvcKmLgzfYVDjsbECJcg84h.VPAgC', NULL, '2025-04-09 05:49:23'),
(79, 'Bintang Mulya Prima', 'Admin', 'bim', '$2a$10$n7v9ZPz/o9PvzqpMk/dd4OwHyWF4TEX7Yfnnaqv5h0sHsOZa7XAym', NULL, '2025-04-09 05:49:23'),
(80, 'Wina Salsabila Lestari', 'Admin', 'wna', '$2a$10$WKL6bK97vQk.WadEvkHE6ewx5iYCofbgB81yNUBhRbiA3/biQ81pa', NULL, '2025-04-09 05:49:23'),
(81, 'Ni Kadek Cindy Sriastiti', 'Admin', 'ndy', '$2a$10$FuArFbQkyBqJWjziBT2uEuXCOlB.BgCM7SPXShjjYy0s52GXa/t5e', NULL, '2025-04-09 05:49:23'),
(82, 'Shania Nurul Falah', 'Admin', 'nia', '$2a$10$5ek9SAxI2MdAUMfRiweiNe..gAXxZDF3tuU4oT7aVqa3zHzL7KDvi', NULL, '2025-04-09 05:49:23'),
(83, 'Daniel Parulian', 'Admin', 'dpr', '$2a$10$Nko9AEFil0bJ4d/1eACajuK1cpbRmM.MEQR6Fp3.99sNu2DGB9zt6', NULL, '2025-04-09 05:49:23'),
(84, 'Akhmad Nabil Al Mu\'ammar', 'Admin', 'mar', '$2a$10$viLnMVE.9mhnY1rD//ERTegrkWjzkKxWbe9iXgVl5Auc4a8Q.YTyC', NULL, '2025-04-09 05:49:23'),
(85, 'Ikhsan Habib', 'Admin', 'san', '$2a$10$IMfNmLRM6POiPxsblPFJKethyvVw7OS5y8MxKDzABjqnCbg610do2', NULL, '2025-04-09 05:49:23'),
(86, 'Muhammad Endy Rafif', 'Admin', 'hen', '$2a$10$Y7TeJu4GPie80IH6CyEBUu0PXy/MsnPq58.Gp1G4S8RDSKPSglbim', NULL, '2025-04-09 05:49:24'),
(87, 'Alif Rizky Dimandani', 'Admin', 'lip', '$2a$10$94C1GoAPGfIllnPoxlduSulFEz53Ellzo44MDjwW3ECJfDLhBCK3u', NULL, '2025-04-09 05:49:24'),
(88, 'Mayco Ikhsan Hanafi', 'Admin', 'hah', '$2a$10$5FOKHRxGk4sHZGzNxXvyV.cpo2xTm28h4yX4jcsPaV8Wz4/5UwCEy', NULL, '2025-04-09 05:49:24'),
(89, 'Abdillah Nur Isnaini', 'Admin', 'dil', '$2a$10$z4i14cyTvTiQB6N/AaBfReEo7E1/pFIGhvXOaesJWjWFOnsvwdwBK', NULL, '2025-04-09 05:49:24'),
(90, 'Ade Surya Saputra', 'Admin', 'kid', '$2a$10$LnTGmwAOu/sNY66AybuzKO4pqj6hTN8LDe5p4zpt6Hij49DR9lCBC', NULL, '2025-04-09 05:49:24'),
(91, 'Ashel Izzah Ulfiyah', 'Admin', 'cel', '$2a$10$jZ1pctll5orxvelMNYh6m.xZ.XUao4oyhv6xaZQWkNjE0grJsCRwO', NULL, '2025-04-09 05:49:24'),
(92, 'Dhion Razin Pavito', 'Admin', 'ion', '$2a$10$IYN0mH3mh0nVWLDUtrGkNOE3TjxRYnRVAUHljHqvqysVZ0SV0KBeS', NULL, '2025-04-09 05:49:24'),
(93, 'Florensa Anugrah Thosuly', 'Admin', 'flo', '$2a$10$wL6Q7XmJviRfVCyq8PKYd.vnr55bydaD6wG70rvpY9aXneMnTXP5.', NULL, '2025-04-09 05:49:24'),
(94, 'Giovanni Salim', 'Admin', 'yow', '$2a$10$QGghj.9hJY3SmU8qYfXImOvL5Qay7wHnBrtm84XL84/KVe4EHA3xe', NULL, '2025-04-09 05:49:24'),
(95, 'Bijak Agung Rizki', 'Admin', 'biz', '$2a$10$TDNenvpq5uWQC2T8PmiRPOmW.7kl/O20GEOeipsYLn6N9nuT8L7IK', NULL, '2025-04-09 05:49:24'),
(96, 'Fallerina Ribka Angela', 'Admin', 'ale', '$2a$10$RR1DridiE2yIETr9TeQQNuF.tQHqp2el/vKgLJYtSLMRCH26K/APu', NULL, '2025-04-09 05:49:24'),
(97, 'Jeremy Pieter Hutahaean', 'Admin', 'ter', '$2a$10$cexZZnBRhZDHWMRfR9ADOO2k.Omv2SzMVC281qXtpT.SKyh52Exsu', NULL, '2025-04-09 05:49:24'),
(98, 'Hanif Prasetyo Herlambang', 'Admin', 'han', '$2a$10$nX6kkv6DBLQwK2yqQz.m4OY5w.qfIPcLIT/LZ6xUAncHshsImJk0e', NULL, '2025-04-09 05:49:24'),
(99, 'Muhammad Adrian Maulana Nst', 'Admin', 'nst', '$2a$10$nnzFiPNw0GBSsgOKLmJBHuyokv48Qp0coNecN3VkRzD5qfwCaWGm6', NULL, '2025-04-09 05:49:24'),
(100, 'Garry Nelson', 'Admin', 'soh', '$2a$10$P/BFWHIqtfLL/KbUOnHIrexPWbNjsvJlGYo6oOF8rZVvwlFAxoAra', NULL, '2025-04-09 05:49:24'),
(101, 'Ghufron Andriansyah', 'Admin', 'abe', '$2a$10$OmpVxaCR67ZT1WRfhOGP.eTyCQQexTC9hWgOn/CJbdTXuvrNjaRpi', NULL, '2025-04-09 05:49:24'),
(102, 'Naufal Rayhan Ali Rahman', 'Admin', 'ray', '$2a$10$lp2BNhmpQG7QCOenyzWF0.ibr2kNguKSfBU0IbUkE4/PRijip34Lu', NULL, '2025-04-09 05:49:24'),
(103, 'Nurrahma Tillah Agustin', 'Admin', 'nra', '$2a$10$wcS7mx7.hwzVKSpsRIK7PuW5yXo.AbzmPjmNQngmmmW1itXZ0zlYW', NULL, '2025-04-09 05:49:24'),
(104, 'Zaidan Fitra Baihaqi', 'Admin', 'zaq', '$2a$10$N4ceVR39N4GDscnW1TxRmO5vlHH6enKqtxA5C5fw7pX743Fax4HrW', NULL, '2025-04-09 05:49:24'),
(105, 'Dermawan Setiananda', 'Admin', 'wan', '$2a$10$zh4cB4diD.upd5rY7watne.0qDqR0L8vxr62YyC2DSD5pDfRbboMe', NULL, '2025-04-09 05:49:24'),
(106, 'Fadillah Syofyan', 'Admin', 'fla', '$2a$10$kunEu19YIJGI4XtLNkSVmOjk67ZCxXo5mDo3pMXdfMOWYW50tlzYy', NULL, '2025-04-09 05:49:24'),
(107, 'Malsa Zainuffitri', 'Admin', 'mzf', '$2a$10$CrNWF.kJN1l29a9x7LhQ4e6CClETfbmYY0pe0RBxE7LIUVZhdoDh6', NULL, '2025-04-09 05:49:24'),
(108, 'Muhammad Hafizhuda', 'Admin', 'piz', '$2a$10$l677tQQubYg3DGP6PiD.Ge2maI.i2wCaye2AIFm6p21VO5pClKjZa', NULL, '2025-04-09 05:49:24'),
(109, 'Julia Monica Berliana', 'Admin', 'brl', '$2a$10$CUfJrt4a4l/D/7XVVogWpu9m9FCizVFdb7YlmBDUQ6qHZxW/AWZEW', NULL, '2025-04-09 05:49:25'),
(110, 'Justin Fairman Tan', 'Admin', 'jft', '$2a$10$2S3fKGHR./brtenDI6oFPOCkOSOFSWIMi4QMiOWDy2e4BA1Ccqm9a', NULL, '2025-04-09 05:49:25'),
(111, 'Teguh Patriananda', 'Admin', 'tgh', '$2a$10$WQbt3mCyIjbLriUlvn8vr.MWlxY8l3IDKqizFyonKi6DYIvBXWvuu', NULL, '2025-04-09 05:49:25'),
(112, 'Daffa Aryaputra', 'Admin', 'dar', '$2a$10$cAn5JlvuUYzO1jWfu4gKleH6c2HWP5zzG6tzde9kMuo/w/uPskShO', NULL, '2025-04-09 07:54:00'),
(113, 'Agung Setia Dharma', 'Admin', 'ocu', '$2a$10$0qo3JVfqYR7QwkQzEzn5mekrQCs1wT0Q3z0EYj9iR41yIXLnvEY.G', NULL, '2025-04-09 07:54:00'),
(115, 'Adrianus Wismar Nugrahanto', 'Admin', 'add', '$2a$10$3KYgLkxahn6azum.2.uIo.bcHp7rZOnJFOR4t9whEajUxbA5wXVcO', NULL, '2025-04-09 07:55:30'),
(116, 'Afi Fadhilah Zaki', 'Admin', 'afi', '$2a$10$lKkUWKypHqixQSZApfed7.fFxtUxovtKuadHUoJe7puhf.UyMPKEy', NULL, '2025-04-09 07:55:30'),
(117, 'Agus Miftah Parid', 'Admin', 'gus', '$2a$10$.x2FIJDxfu4DUFZWSRy/1esdNosy2lP4zg3j4bKnIu8EATf9GLVmu', NULL, '2025-04-09 07:55:30'),
(118, 'Aswangga Pandita Sadu', 'Admin', 'wgg', '$2a$10$7hWrPqO8ep6bCrI5p3poyeF0cgFsFsoCWXWTeVcE5kiI.c5ldrDfe', NULL, '2025-04-09 07:55:30'),
(119, 'Bryan Gabriel Izaac Sasabone', 'Admin', 'yen', '$2a$10$RPjQW/WvhlOic2D9rijGvuobuKN4LQNjJIYlQO/XRFhoVDm2W.QyS', NULL, '2025-04-09 07:55:30'),
(120, 'Czar Edgard Vincent Montoya', 'Admin', 'edg', '$2a$10$n742u.q3wXqWxAOPI1HNg.eJ2jP4pYmQ7FGLj/tH9JM9b7uqqTOKe', NULL, '2025-04-09 07:55:30'),
(121, 'Ivan Horas Hamonangan Simaremare', 'Admin', 'van', '$2a$10$qBLXZx/BaqkqQva/voQDSOLNtr990V5zMQQ0zP0f1HOTL67yxl6U.', NULL, '2025-04-09 07:55:30'),
(122, 'Moch. Ari Prasetyo', 'Admin', 'tyo', '$2a$10$bkfPqoeTq7L1HGRvJZgtduvjtyTMRpe500nMnUbJJNEaKcimdwpT6', NULL, '2025-04-09 07:55:30'),
(123, 'Moh Eldivo Alsyawal Otoluwa', 'Admin', 'oto', '$2a$10$odxdu4uBAjC2ttKJmfyqxOTjIOHBC9PnkN5/0XW1B1pA6TsF4IWZS', NULL, '2025-04-09 07:55:30'),
(124, 'Muhammad Asyrawi', 'Admin', 'awi', '$2a$10$E2u.OeLlUN5KyOwACaLOJOuDCyHZ3ymjCp1u9Ji/19AranU6VffhO', NULL, '2025-04-09 07:55:30'),
(125, 'Muhammad Azmi Anfasa Rizqi', 'Admin', 'aaa', '$2a$10$LsR/s3I.jvnQ.sn9/N740eNRwgTIKzmPZXHh1zP19sSHyG5v3TF8G', NULL, '2025-04-09 07:55:30'),
(126, 'Muhammad Fahrayhan Yudhi', 'Admin', 'fry', '$2a$10$i9hTuA/7hTvI0WepTuHt0OgjSwyWLu9T3jkDpcG/PM/hEBYQc6RNe', NULL, '2025-04-09 07:55:30'),
(127, 'Muhammad Ibrahim', 'Admin', 'him', '$2a$10$Gw2fGT2hm.z6rNE6fm2xj.iQS5y32R1xIDFgCIEb9iMCpwp/yH/BK', NULL, '2025-04-09 07:55:30'),
(128, 'Muhammad Irfan Zidny', 'Admin', 'zid', '$2a$10$mHPxISrsGdt0EL57mn0ZzOm/5nEVeEBhNrYyAEj3xThuCMqoCcr8u', NULL, '2025-04-09 07:55:30'),
(129, 'Muhammad Miqdam Fuadi', 'Admin', 'qbo', '$2a$10$iLA8FEeKjRk79m32vhbdCuU1XlvMbC.6iecLzFCzKzH5NT9H8YnOW', NULL, '2025-04-09 07:55:30'),
(130, 'Nadyah Rizky Amelia', 'Admin', 'nad', '$2a$10$hYThG/L6Vle3osv7CkYdo.F6nZxoVIYpz.6.RyRl6Vx687WXYIMsO', NULL, '2025-04-09 07:55:31'),
(131, 'Nasywa Anggieta Tiara', 'Admin', 'syw', '$2a$10$MrHIidGo4NLflp6Bw.1Z.e27DVhhQ9jKCnCo5VfBOFy8WYzrfsoPG', NULL, '2025-04-09 07:55:31'),
(132, 'Raden Arnold Damanik', 'Admin', 'nol', '$2a$10$gPENn5mjrehFRDYoMC7qteKUwLopxPDucfeYj5vamLSA4ROeX0zLe', NULL, '2025-04-09 07:55:31'),
(133, 'Ramdhani Pentana', 'Admin', 'rpn', '$2a$10$EXAZLDCDcXrTOpvM26Lp5OHdxV1Eyh6JImTSg04fhyka4ilEBYtJe', NULL, '2025-04-09 07:55:31'),
(134, 'Reyhan Andhata Pratama', 'Admin', 'rap', '$2a$10$Ibt0aSz9b/9ORIzmY9i.d.we.N.D1kdu3lNABWiw2aFEC2nURWqvS', NULL, '2025-04-09 07:55:31'),
(135, 'Samuel Morachal Girsang', 'Admin', 'sam', '$2a$10$P2lgAdeCBpVm9ptWYiyInehqUf6J1VALqeCop.5oAs9uTx3Jkyxnm', NULL, '2025-04-09 07:55:31'),
(136, 'Sinarjonnan Prastyaji Ariyanto', 'Admin', 'jon', '$2a$10$MwXQ0TNHTHRk7Bw02.k5Z.yZkvn4BQk2f1CLMa9a1O4OMMCrSEUVm', NULL, '2025-04-09 07:55:31'),
(137, 'Tsania Puspa Kirana', 'Admin', 'sun', '$2a$10$9rrNozziNjHMT46XkFd/qO2aOA/PGSwAhBZC/6QjZchwlNyeNtKUO', NULL, '2025-04-09 07:55:31'),
(138, 'Umar Haudhi', 'Admin', 'hex', '$2a$10$LjVJct0gI3E4yMbTAU6si.8bsFnIdnHHd1GNiz0mQ67ZYBfo8svmq', NULL, '2025-04-09 07:55:31'),
(139, 'Vincentius Artyanta Maheswara Purba', 'Admin', 'tnt', '$2a$10$yrHSCFf9nLgHWMFLwJUzrOENYPorgrFr1PzAPClfZg8pDdHTL2Jwe', NULL, '2025-04-09 07:55:31');

--
-- Indexes for dumped tables
--

--
-- Indeks untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indeks untuk tabel `divisions`
--
ALTER TABLE `divisions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `leader_id` (`leader_id`);

--
-- Indeks untuk tabel `members`
--
ALTER TABLE `members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `division_id` (`division_id`);

--
-- Indeks untuk tabel `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- AUTO_INCREMENT untuk tabel yang dibuang
--

--
-- AUTO_INCREMENT untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  MODIFY `log_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT untuk tabel `divisions`
--
ALTER TABLE `divisions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT untuk tabel `members`
--
ALTER TABLE `members`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT untuk tabel `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=140;

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `activity_logs`
--
ALTER TABLE `activity_logs`
  ADD CONSTRAINT `activity_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Ketidakleluasaan untuk tabel `divisions`
--
ALTER TABLE `divisions`
  ADD CONSTRAINT `divisions_ibfk_1` FOREIGN KEY (`leader_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Ketidakleluasaan untuk tabel `members`
--
ALTER TABLE `members`
  ADD CONSTRAINT `members_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `members_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `divisions` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
