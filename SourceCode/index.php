<?php
include_once("Database.php");

$DB = new Database();
$DB->query("SELECT * FROM elegantemvc.users where user_id = 69;");
$results = $DB->resultset();

//print_r($results);
foreach($results[0] as $key => $value) {
    echo "$key : $value <br/>";
  }
?>