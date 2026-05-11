<?php
// =========================================================
// CONFIGURACIÓN DE SEGURIDAD (Evitar Information Disclosure)
// =========================================================
ini_set('display_errors', 0); // 0 = Apaga los errores en la pantalla web
ini_set('log_errors', 1);     // 1 = Enciende el guardado de errores en un log
error_reporting(E_ALL);       // Captura todos los errores posibles

$host = "localhost";
$user = "app_lingua_web"; // El usuario con privilegios restringidos que creaste
$pass = "WebUser2026!"; 
$db   = "lingua_viva_db";

mysqli_report(MYSQLI_REPORT_ERROR | MYSQLI_REPORT_STRICT);

try {
    $conn = new mysqli($host, $user, $pass, $db);
    $conn->set_charset("utf8mb4");
} catch (mysqli_sql_exception $e) {
    error_log("Error de conexión a la BD: " . $e->getMessage());
    die("Error 500: Falla interna del servicio. Contacte al administrador de infraestructura.");
}
?>