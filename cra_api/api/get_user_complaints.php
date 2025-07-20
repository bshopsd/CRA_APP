<?php

require_once '../config/Database.php';
require_once '../controllers/ComplaintController.php';

$db = (new Database())->connect();

$controller = new ComplaintController($db);

$user_id = $_GET['user_id'] ?? null;

if (!$user_id) {
    echo json_encode(['success' => false, 'message' => 'Missing user_id']);
    exit;
}

$data = $controller->getUserComplaints($user_id);

echo json_encode(['success' => true, 'complaints' => $data]);
