<?php

require_once '../models/User.php';
class AuthController {
    private $user;

    public function __construct($db) {
        $this->user = new User($db);
    }

    public function register($data) {
        return $this->user->register($data['name'], $data['email'], $data['password']);
    }

    public function login($data) {
        $user = $this->user->login($data['email']);
        if ($user && password_verify($data['password'], $user['password'])) {
            return $user;
        }
        return false;
    }
}