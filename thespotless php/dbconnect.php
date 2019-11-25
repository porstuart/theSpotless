<?php
$servername = "localhost";
$username 	= "pickupan_mylaundryadmin2";
$password 	= "porstuart1997";
$dbname 	= "pickupan_mylaundry";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>