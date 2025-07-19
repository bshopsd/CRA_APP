<?php

require_once '../config/Database.php';
require_once '../controllers/ComplaintController.php';

$db = (new Database())->connect();
$controller = new ComplaintController($db);
$user_id = $_GET['user_id'];
$data = $controller->getUserComplaints($user_id);

echo json_encode(['success' => true, 'complaints' => $data]);

// File: api/get_all_complaints.php
require_once '../config/Database.php';
require_once '../controllers/ComplaintController.php';

$db = (new Database())->connect();
$controller = new ComplaintController($db);
$data = $controller->getAll();

echo json_encode(['success' => true, 'complaints' => $data]);