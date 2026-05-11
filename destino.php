<?php
session_start();

// Validar que nadie entre saltándose el login
if (!isset($_SESSION['rol'])) {
    header("Location: index.php"); // Si no estás logueado, te regresa al login
    exit();
}
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel de Control</title>
    <style>
        body { font-family: Arial, sans-serif; background-color: #f4f4f9; padding: 20px; }
        .nav { background-color: #333; color: white; padding: 15px; border-radius: 5px; display: flex; justify-content: space-between; align-items: center;}
        .nav a { color: #ff4757; text-decoration: none; font-weight: bold; }
        .content { margin-top: 20px; background: white; padding: 20px; border-radius: 5px; box-shadow: 0 2px 5px rgba(0,0,0,0.1); }
    </style>
</head>
<body>

    <div class="nav">
        <span>Bienvenido, <b><?php echo $_SESSION['usuario']; ?></b> (Rol: <?php echo $_SESSION['rol']; ?>)</span>
        <a href="logout.php">Cerrar Sesión</a> 
    </div>

    <div class="content">
        <h3>Aquí irá tu tabla de Alumnos o Administradores</h3>
        <p>En este espacio incrustaremos las consultas a la base de datos de MySQL para que puedas agregar, editar o borrar registros de forma fluida.</p>
    </div>

</body>
</html>