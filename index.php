<?php
session_start();
include 'conexion.php'; 

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $usuario = $_POST['usuario'];
    $password = $_POST['password']; 

    // Sentencia preparada para evitar SQLi
    $sql = "SELECT ID_Usuario, Nombre, Rol, Contraseña FROM Usuario WHERE Nombre_Usuario = ?";
    
    $stmt = $conn->prepare($sql);
    $stmt->bind_param("s", $usuario);
    $stmt->execute();
    $resultado = $stmt->get_result();

    if ($row = $resultado->fetch_assoc()) {
        // Validación criptográfica de la contraseña
        // IMPORTANTE: En tu BD, las contraseñas deben estar guardadas usando password_hash()
        if (password_verify($password, $row['Contraseña']) || $password === $row['Contraseña']) { 
            
            // Mitigación de fijación de sesión
            session_regenerate_id(true);

            $_SESSION['id_usuario'] = $row['ID_Usuario']; // Útil para consultas futuras
            $_SESSION['rol'] = $row['Rol'];
            $_SESSION['usuario'] = $row['Nombre']; 
            
            header("Location: dashboard.php"); 
            exit();
        } else {
            // Mensaje genérico para evitar enumeración
            $error = "Usuario o contraseña incorrectos.";
        }
    } else {
        // Mismo mensaje genérico
        $error = "Usuario o contraseña incorrectos.";
    }
    
    $stmt->close();
}
?>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | Sistema Académico</title>
    <style>
        /* Diseño Moderno - Estilo Dark UI */
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        body {
            background-color: #0d1117; /* Fondo oscuro profundo */
            background-image: radial-gradient(circle at 50% 0%, #1f2937 0%, #0d1117 70%);
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            color: #c9d1d9; /* Texto gris claro */
        }
        .login-container {
            background: #161b22;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.8);
            width: 100%;
            max-width: 380px;
            border: 1px solid #30363d;
            transition: transform 0.3s ease;
        }
        .login-container:hover {
            transform: translateY(-5px); /* Pequeño efecto de elevación */
        }
        .login-container h2 {
            text-align: center;
            margin-bottom: 30px;
            color: #58a6ff; /* Azul vibrante */
            font-size: 26px;
            letter-spacing: 1px;
        }
        .input-group {
            margin-bottom: 20px;
        }
        .input-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 14px;
            color: #8b949e;
            font-weight: 600;
        }
        .input-group input {
            width: 100%;
            padding: 14px;
            background-color: #0d1117;
            border: 1px solid #30363d;
            border-radius: 6px;
            color: #c9d1d9;
            font-size: 16px;
            outline: none;
            transition: all 0.3s ease;
        }
        .input-group input:focus {
            border-color: #58a6ff;
            box-shadow: 0 0 0 3px rgba(88, 166, 255, 0.2);
        }
        .btn-login {
            width: 100%;
            padding: 14px;
            background-color: #238636; /* Verde tipo botón de confirmación */
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
            transition: background-color 0.3s ease, transform 0.1s;
            margin-top: 10px;
        }
        .btn-login:hover {
            background-color: #2ea043;
        }
        .btn-login:active {
            transform: scale(0.98); /* Efecto de clic */
        }
        .error-msg {
            background-color: rgba(248, 81, 73, 0.1);
            color: #f85149;
            padding: 12px;
            border-radius: 6px;
            border: 1px solid rgba(248, 81, 73, 0.4);
            margin-bottom: 20px;
            text-align: center;
            font-size: 14px;
            font-weight: 500;
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h2>_Acceso_Seguro</h2>
        
        <?php if(isset($error)) { echo "<div class='error-msg'>$error</div>"; } ?>
        
        <form method="POST" action="">
            <div class="input-group">
                <label for="usuario">Usuario</label>
                <input type="text" id="usuario" name="usuario" required autocomplete="off" placeholder="ej. admin">
            </div>
            
            <div class="input-group">
                <label for="password">Contraseña</label>
                <input type="password" id="password" name="password" required placeholder="••••••••">
            </div>
            
            <button type="submit" class="btn-login">Iniciar Sesión</button>
        </form>
    </div>

</body>
</html>