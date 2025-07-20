-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 20, 2025 at 06:10 AM
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
-- Database: `cra_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `complaints`
--

CREATE TABLE `complaints` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `latitude` decimal(10,8) DEFAULT NULL,
  `longitude` decimal(11,8) DEFAULT NULL,
  `status` enum('pending','in_progress','resolved') DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `complaints`
--

INSERT INTO `complaints` (`id`, `user_id`, `title`, `description`, `photo`, `latitude`, `longitude`, `status`, `created_at`) VALUES
(1, 2, 'Leak', 'Water leak', '/9j/4QGvRXhpZgAATU0AKgAAAAgABwEQAAIAAAAUAAAAYgEAAAQAAAABAAAFoAEBAAQAAAABAAAHgAEyAAIAAAAUAAAAdgESAAMAAAABAAEAAIdpAAQAAAABAAAAkQEPAAIAAAAHAAAAigAAAABzZGtfZ3Bob25lNjRfeDg2XzY0ADIwMjU6MDc6MTggMTA6NDE6MjkAR29vZ2xlAAAQgp0ABQAAAAEAAAFXgpoABQAAAAEAAAFfkpIAAgAAAAQ', 6.69429830, 124.67449500, 'resolved', '2025-07-18 02:41:33'),
(2, 3, 'Lock meter', 'lolckee', '', 6.69443530, 124.67499230, 'resolved', '2025-07-18 05:28:09'),
(3, 3, 'Meter Defect', 'we don\'t use water but meter is rotating', '', 6.67828480, 124.64191650, 'resolved', '2025-07-19 04:13:27'),
(4, 4, 'no water', 'no water', '', 6.67828350, 124.64192070, 'pending', '2025-07-19 09:53:19'),
(5, 4, 'water leakage', 'leak water outside the meter', '', 6.67827730, 124.64192560, 'pending', '2025-07-19 10:16:54');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('user','admin') DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `role`, `created_at`) VALUES
(1, 'Marchel Decena', 'admin@gmail.com', '$2y$10$jcx.jkYoFlPKhBChV0gC1.ps4ILgt7FtUVOqewXy1teVmzPdxeOtS', 'admin', '2025-07-18 01:38:49'),
(2, 'Juan Dela Cruz', 'user@gmail.com', '$2y$10$NzLqO6hA3THPqqFhOMun2.vmteqcJwzul5ygKjJWwvE5sRxAFKLYe', 'user', '2025-07-18 01:54:59'),
(3, 'user1', 'user1@gmail.com', '$2y$10$VVbRcW5l9LBLKAat3ZINMO1d1674sPS4QluOjsT8wc0FfH9daqYay', 'user', '2025-07-18 05:17:50'),
(4, 'User5', 'user5@gmail.com', '$2y$10$zW/v1ttjTdUo7FctkDU2tubwlNRVQEkYuIzqM28/.lmZqFp.bjRFi', 'user', '2025-07-19 08:21:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `complaints`
--
ALTER TABLE `complaints`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `complaints`
--
ALTER TABLE `complaints`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `complaints`
--
ALTER TABLE `complaints`
  ADD CONSTRAINT `complaints_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
