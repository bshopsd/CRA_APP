<?php

class Complaint {
    private $conn;
    private $table = 'complaints';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function create($user_id, $title, $description, $photo, $lat, $lng) {
        $stmt = $this->conn->prepare("INSERT INTO {$this->table} (user_id, title, description, photo, latitude, longitude, status) VALUES (?, ?, ?, ?, ?, ?, 'pending')");
        return $stmt->execute([$user_id, $title, $description, $photo, $lat, $lng]);
    }

    public function getUserComplaints($user_id) {
        $stmt = $this->conn->prepare("SELECT * FROM {$this->table} WHERE user_id = ?");
        $stmt->execute([$user_id]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getAll() {
        $stmt = $this->conn->query("SELECT * FROM {$this->table} ORDER BY created_at DESC");
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function updateStatus($id, $status) {
        $stmt = $this->conn->prepare("UPDATE {$this->table} SET status = ? WHERE id = ?");
        return $stmt->execute([$status, $id]);
    }
}