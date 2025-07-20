<?php

require_once '../config/Database.php';
require_once '../controllers/ComplaintController.php';

$db = (new Database())->connect();
$controller = new ComplaintController($db);

$complaints = $controller->getAll();

if ($complaints) {
    echo json_encode(['success' => true, 'data' => $complaints]);
} else {
    echo json_encode(['success' => false, 'message' => 'No complaints found']);
}