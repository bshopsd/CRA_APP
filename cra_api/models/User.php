<?php

class User {
    private $conn;
    private $table = 'users';

    public function __construct($db) {
        $this->conn = $db;
    }

    public function register($name, $email, $password) {
        $stmt = $this->conn->prepare("INSERT INTO {$this->table} (name, email, password, role) VALUES (?, ?, ?, 'user')");
        return $stmt->execute([$name, $email, password_hash($password, PASSWORD_BCRYPT)]);
    }

    public function login($email) {
        $stmt = $this->conn->prepare("SELECT * FROM {$this->table} WHERE email = ?");
        $stmt->execute([$email]);
        return $stmt->fetch(PDO::FETCH_ASSOC);
    }
}