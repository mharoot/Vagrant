<?php

$website = 'http://localhost';
define("COOKIE_RUNTIME", 1209600);
define("COOKIE_DOMAIN", "$website");
define("COOKIE_SECRET_KEY", "1gp@TMPS{+$78sfpMJFe-92s");
define("EMAIL_USE_SMTP", true);
define("EMAIL_SMTP_HOST", "smtp.gmail.com");
define("EMAIL_SMTP_AUTH", true);
define("EMAIL_SMTP_USERNAME", "ElegantORM@gmail.com");
define("EMAIL_SMTP_PASSWORD", "DONOTPOSTTOGITHUB");
define("EMAIL_SMTP_PORT", 587);
define("EMAIL_SMTP_ENCRYPTION", "tls");

define("EMAIL_PASSWORDRESET_URL", "$website/user-password-reset");
define("EMAIL_PASSWORDRESET_FROM", "ElegantORM@gmail.com");
define("EMAIL_PASSWORDRESET_FROM_NAME", "ElegantMVC");
define("EMAIL_PASSWORDRESET_SUBJECT", "Password reset for ElegantMVC");
define("EMAIL_PASSWORDRESET_CONTENT", "Please click on this link to reset your password:");

define("EMAIL_VERIFICATION_URL", "$website/user-email-verification");
define("EMAIL_VERIFICATION_FROM", "ElegantORM@gmail.com");
define("EMAIL_VERIFICATION_FROM_NAME", "ElegantMVC");
define("EMAIL_VERIFICATION_SUBJECT", "Account activation for ElegantMVC");
define("EMAIL_VERIFICATION_CONTENT", "Please click on this link to activate your account:");


define("HASH_COST_FACTOR", "10");