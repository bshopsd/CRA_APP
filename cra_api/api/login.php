<?php
require_once '../config/Database.php';
require_once '../controllers/AuthController.php';

$db = (new Database())->connect();
$controller = new AuthController($db);
$data = json_decode(file_get_contents("php://input"), true);
$user = $controller->login($data);

if ($user) {
    echo json_encode(['success' => true, 'user' => $user]);
} else {
    echo json_encode(['success' => false]);
}