<?php
include_once ("dbconnect.php");

if($_SERVER['REQUEST_METHOD'] == "POST"){
    $response = array();
    $email = $_POST['email'];
    $length = 6;
    $randomString = substr(str_shuffle("0123456789"), 0 , $length);
    
    $checkEmail = "SELECT * FROM user WHERE email = '$email'";
    $check = mysqli_fetch_array(mysqli_query($conn, $checkEmail));
    
    if(isset($check)){
        $update = mysqli_query($conn, "UPDATE user SET reset = '$randomString' WHERE email = '$email'");
        $response['value'] = 1;
        echo json_encode($response);
    }else{
        $response['value'] = 0;
        $response['message'] = "Email has not been registered!";
        echo json_encode($response);
    }
}
?>