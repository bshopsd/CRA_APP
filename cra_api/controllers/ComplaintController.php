<?php

require_once '../models/Complaint.php';
class ComplaintController {
    private $complaint;

    public function __construct($db) {
        $this->complaint = new Complaint($db);
    }

    public function create($data) {
        return $this->complaint->create($data['user_id'], $data['title'], $data['description'], $data['photo'], $data['latitude'], $data['longitude']);
    }

    public function getUserComplaints($user_id) {
        return $this->complaint->getUserComplaints($user_id);
    }

    public function getAll() {
        return $this->complaint->getAll();
    }

    public function updateStatus($id, $status) {
        return $this->complaint->updateStatus($id, $status);
    }
}