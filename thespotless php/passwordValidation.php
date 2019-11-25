<?php
include_once ("dbconnect.php");

if($_SERVER['REQUEST_METHOD'] == "POST"){
    $response = array();
    $email = $_POST['email'];
    $code = $_POST['code'];

    $checkEmail = "SELECT * FROM user WHERE email = '$email' and reset = '$code'";
    $check = mysqli_fetch_array(mysqli_query($conn, $checkEmail));
    
    if(isset($check)){
        $update = mysqli_query($conn, "UPDATE user SET reset = NULL WHERE email = '$email'");
        $response['value'] = 1;
        echo json_encode($response);
    }else{
        $response['value'] = 0;
        $response['message'] = "Wrong Passcode";
        echo json_encode($response);
    }
}
?>