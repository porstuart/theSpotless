<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_GET['email'];

$sql = "UPDATE user SET verify = '1' WHERE email = '$email'";
if ($conn->query($sql) === TRUE) {
    echo "success";
} else {
    echo "error";
}

$conn->close();
?>