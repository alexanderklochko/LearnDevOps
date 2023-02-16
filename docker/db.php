<?php
session_start();

$conn = mysqli_connect(
  '10.5.0.2',
  'aleks',
  '123456',
  'php_mysql_crud'
) or die(mysqli_erro($mysqli));

?>
