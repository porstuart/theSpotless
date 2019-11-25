<?php
//error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$name = $_POST['name'];
$password = sha1($_POST['password']);
$phoneNum = $_POST['phoneNum'];
$encoded_string = $_POST["encoded_string"];
$decoded_string = base64_decode($encoded_string);

$check_duplicate_email = "SELECT email FROM user WHERE email ='$email' ";
$result = mysqli_query($conn, $check_duplicate_email);
$count = mysqli_num_rows($result);

if($count > 0){
    echo "Email already existed!";
}else{
    $sqlinsert = "INSERT INTO user(email,name,password,phoneNum,verify) VALUES ('$email','$name','$password','$phoneNum','0')";
    
    if ($conn->query($sqlinsert) === TRUE) {
        $path = '../profile/'.$email.'.jpg';
        file_put_contents($path, $decoded_string);
        sendEmail($email);
        echo "success";
    } else {
        echo "failed";
    }
}

function sendEmail($useremail) {
    $to      = $useremail; 
    $subject = 'Verification for TheSpotless'; 
    $message = 'http://pickupandlaundry.com/thespotless/stuart/php/verify.php?email='.$useremail; 
    $headers = 'From: noreply@thespotless.com.my' . "\r\n" . 
    'Reply-To: '.$useremail . "\r\n" . 
    'X-Mailer: PHP/' . phpversion(); 
    mail($to, $subject, $message, $headers); 
}
?>