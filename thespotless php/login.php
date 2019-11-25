<?php
error_reporting(0);
include_once("dbconnect.php");
$email = $_POST['email'];
$password = $_POST['password'];
$passwordsha = sha1($password);

$sql = "SELECT * FROM user WHERE email = '$email' AND password = '$passwordsha' AND verify ='1'";
$result = $conn->query($sql);


if ($result->num_rows > 0) {
    echo "Welcome";
}else{
    echo "Email or Password Incorrect";
}