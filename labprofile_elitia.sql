-- Memeriksa dan membuat database jika belum ada
CREATE DATABASE IF NOT EXISTS `labprofile_elitia`;

-- Menggunakan database yang baru dibuat
USE `labprofile_elitia`;

-- Struktur dari tabel `anggota_divisi`
CREATE TABLE IF NOT EXISTS `anggota_divisi` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `division_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Struktur dari tabel `divisi`
CREATE TABLE IF NOT EXISTS `divisi` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Struktur dari tabel `users`
CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(255) NOT NULL,
  `role` enum('Tuhan','Admin','Anggota') NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `img_url` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Data untuk tabel `users`
INSERT INTO `users` (`id`, `nama`, `role`, `username`, `password`, `img_url`) VALUES
(6, 'Farhan Naufal', 'Tuhan', 'ffl', '$2a$10$NW4WH/EVr8qXbvJMjvQEHu6lwrmKCy5J/F.G5nqmZQXS/xfGDUoYy', ''),
(8, 'Tes member', 'Anggota', 'member', '$2a$10$eFem.7E87dukXFq/ASn7IeeIOf/mxacEVKEChbxev253u6uEA1AmG', ''),
(9, 'Tes Admin', 'Admin', 'admin', '$2a$10$Dlcpys25a4vtiulY3sK1JuF8p9Zgu4zM1YMEBs.6grFRP4aAS56ba', '');

-- Indeks untuk tabel `anggota_divisi`
ALTER TABLE `anggota_divisi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `division_id` (`division_id`);

-- Indeks untuk tabel `divisi`
ALTER TABLE `divisi`
  ADD PRIMARY KEY (`id`);

-- Indeks untuk tabel `users`
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

-- AUTO_INCREMENT untuk tabel yang dibuang
ALTER TABLE `anggota_divisi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `divisi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

-- Foreign Key Constraints untuk tabel `anggota_divisi`
ALTER TABLE `anggota_divisi`
  ADD CONSTRAINT `anggota_divisi_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `anggota_divisi_ibfk_2` FOREIGN KEY (`division_id`) REFERENCES `divisi` (`id`);

COMMIT;
