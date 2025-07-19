<?php

require_once '../config/Database.php';
require_once '../controllers/ComplaintController.php';

$db = (new Database())->connect();
$controller = new ComplaintController($db);
$data = json_decode(file_get_contents("php://input"), true);

if ($controller->create($data)) {
    echo json_encode(['success' => true]);
} else {
    echo json_encode(['success' => false]);
}