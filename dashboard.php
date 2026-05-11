<?php
session_start();
include 'conexion.php'; 

// 1. Validación estricta de sesión (Control de Acceso)
if (!isset($_SESSION['rol']) || !isset($_SESSION['usuario'])) {
    header("Location: index.php"); 
    exit();
}

$rol_actual = $_SESSION['rol'];
?>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Panel - Escuela Lingua Viva</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; margin: 0; }
        .navbar { background-color: #1e1e2f; color: white; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
        .navbar a { background-color: #dc3545; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-weight: bold; }
        .container { padding: 30px; max-width: 1000px; margin: 0 auto; }
        .card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); margin-bottom: 20px; }
        table { width: 100%; border-collapse: collapse; margin-top: 15px; }
        th, td { border: 1px solid #ddd; padding: 12px; text-align: left; }
        th { background-color: #1e1e2f; color: white; }
        .totales-financieros { font-size: 18px; font-weight: bold; color: #1e1e2f; margin-top: 15px; text-align: right; }
    </style>
</head>
<body>

    <div class="navbar">
        <h2>Sistema Académico - Lingua Viva</h2>
        <div>
            <span>Hola, <b><?php echo htmlspecialchars($_SESSION['usuario'], ENT_QUOTES, 'UTF-8'); ?></b> 
            (Rol: <?php echo htmlspecialchars($rol_actual, ENT_QUOTES, 'UTF-8'); ?>)</span>
            <a href="logout.php" style="margin-left: 20px;">Cerrar Sesión</a>
        </div>
    </div>

    <div class="container">
        
        <?php
        // =========================================================
        // MÓDULO ADMINISTRADOR
        // =========================================================
        if ($rol_actual === 'Administrador') {
            
            // --- SECCIÓN A: CONTROL DE USUARIOS ---
            echo "<div class='card'>";
            echo "<h3>Panel Administrativo: Control de Usuarios</h3>";
            
            $sql_usuarios = "SELECT ID_Usuario, Nombre, Apellidos, Email, Rol FROM Usuario";
            $result = $conn->query($sql_usuarios);

            if ($result->num_rows > 0) {
                echo "<table>
                        <tr>
                            <th>ID</th>
                            <th>Nombre Completo</th>
                            <th>Correo</th>
                            <th>Rol</th>
                        </tr>";
                while($row = $result->fetch_assoc()) {
                    echo "<tr>
                            <td>" . htmlspecialchars($row['ID_Usuario'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Nombre'] . " " . $row['Apellidos'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Email'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Rol'], ENT_QUOTES, 'UTF-8') . "</td>
                          </tr>";
                }
                echo "</table>";
            } else {
                echo "<p>No hay usuarios registrados aún.</p>";
            }
            echo "</div>";

            // --- SECCIÓN B: REPORTE DE OCUPACIÓN ---
            echo "<div class='card'>";
            echo "<h3>Reporte: Ocupación de Grupos Activos</h3>";
            
            $sql_ocupacion = "
                SELECT 
                    g.ID_Grupo,
                    c.Nombre AS Curso,
                    g.Cupo_Maximo,
                    COUNT(CASE WHEN i.Estado_Academico = 'Cursando' THEN 1 END) AS Alumnos_Inscritos
                FROM Grupo g
                INNER JOIN Curso c ON g.ID_Curso = c.ID_Curso
                LEFT JOIN Alumno a ON g.ID_Grupo = a.ID_Grupo
                LEFT JOIN Inscripcion i ON a.ID_Alumno = i.Id_Alumno
                WHERE g.Estado_Activo = 1
                GROUP BY g.ID_Grupo, c.Nombre, g.Cupo_Maximo
            ";
            
            $res_ocupacion = $conn->query($sql_ocupacion);

            if ($res_ocupacion->num_rows > 0) {
                echo "<table>
                        <tr>
                            <th>ID Grupo</th>
                            <th>Curso</th>
                            <th>Inscritos / Cupo Máximo</th>
                            <th>Lugares Disponibles</th>
                        </tr>";
                while($row = $res_ocupacion->fetch_assoc()) {
                    $disponibles = $row['Cupo_Maximo'] - $row['Alumnos_Inscritos'];
                    $color_disponible = ($disponibles <= 0) ? "color: #dc3545; font-weight: bold;" : "color: #28a745; font-weight: bold;";

                    echo "<tr>
                            <td>" . htmlspecialchars($row['ID_Grupo'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Curso'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Alumnos_Inscritos'], ENT_QUOTES, 'UTF-8') . " / " . htmlspecialchars($row['Cupo_Maximo'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td style='$color_disponible'>" . $disponibles . "</td>
                          </tr>";
                }
                echo "</table>";
            } else {
                echo "<p>No hay grupos activos en este momento.</p>";
            }
            echo "</div>";

            // --- SECCIÓN C: REPORTE FINANCIERO DE INGRESOS ---
            echo "<div class='card'>";
            echo "<h3>Reporte: Ingresos por Método de Pago</h3>";
            
            $sql_ingresos = "
                SELECT 
                    Metodo_Pago, 
                    COUNT(ID_Pago) AS Total_Transacciones, 
                    SUM(Monto) AS Ingresos_Totales 
                FROM Pago 
                GROUP BY Metodo_Pago
            ";
            
            $res_ingresos = $conn->query($sql_ingresos);
            $suma_global = 0;

            if ($res_ingresos->num_rows > 0) {
                echo "<table>
                        <tr>
                            <th>Método de Pago</th>
                            <th>Cantidad de Transacciones</th>
                            <th>Ingresos Generados (MXN)</th>
                        </tr>";
                while($row = $res_ingresos->fetch_assoc()) {
                    $suma_global += $row['Ingresos_Totales'];
                    echo "<tr>
                            <td>" . htmlspecialchars($row['Metodo_Pago'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Total_Transacciones'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>$" . number_format($row['Ingresos_Totales'], 2) . "</td>
                          </tr>";
                }
                echo "</table>";
                echo "<div class='totales-financieros'>Ingreso Global Total: $" . number_format($suma_global, 2) . " MXN</div>";
            } else {
                echo "<p>No hay registros de pagos en el sistema.</p>";
            }
            echo "</div>";
        } 
        
        // =========================================================
        // MÓDULO PROFESOR
        // =========================================================
        elseif ($rol_actual === 'Profesor') {
            echo "<div class='card'>";
            echo "<h3>Mis Cursos y Grupos Asignados</h3>";
            
            $sql_profesor = "
                SELECT 
                    g.ID_Grupo, 
                    c.Nombre AS Curso, 
                    c.Nivel, 
                    g.Cupo_Maximo, 
                    g.Fecha_Inicio 
                FROM Profesor p
                INNER JOIN Curso c ON p.Id_Curso = c.ID_Curso
                INNER JOIN Grupo g ON c.ID_Curso = g.ID_Curso
                WHERE p.ID_Usuario = ? AND g.Estado_Activo = 1
            ";
                             
            $stmt_prof = $conn->prepare($sql_profesor);
            $stmt_prof->bind_param("i", $_SESSION['id_usuario']);
            $stmt_prof->execute();
            $res_prof = $stmt_prof->get_result();

            if ($res_prof->num_rows > 0) {
                echo "<table>
                        <tr>
                            <th>ID Grupo (Físico)</th>
                            <th>Curso Asignado</th>
                            <th>Nivel</th>
                            <th>Cupo Máximo</th>
                            <th>Fecha de Inicio</th>
                        </tr>";
                while($row = $res_prof->fetch_assoc()) {
                    echo "<tr>
                            <td>" . htmlspecialchars($row['ID_Grupo'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Curso'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Nivel'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Cupo_Maximo'], ENT_QUOTES, 'UTF-8') . "</td>
                            <td>" . htmlspecialchars($row['Fecha_Inicio'], ENT_QUOTES, 'UTF-8') . "</td>
                          </tr>";
                }
                echo "</table>";
            } else {
                echo "<p>No tienes grupos asignados en este momento.</p>";
            }
            
            $stmt_prof->close();
            echo "</div>";
        }
        
        // =========================================================
        // MÓDULO ALUMNO
        // =========================================================
        elseif ($rol_actual === 'Alumno') {
            echo "<div class='card'>";
            echo "<h3>Mi Estatus Académico y Curso Actual</h3>";
            
            $sql_alumno = "
                SELECT 
                    a.Nivel_Idioma, 
                    i.Estado_Academico, 
                    i.Fecha_Registro AS Fecha_Inscripcion,
                    c.Nombre AS Curso_Actual, 
                    g.Fecha_Inicio AS Inicio_Clases
                FROM Alumno a
                INNER JOIN Inscripcion i ON a.ID_Alumno = i.Id_Alumno
                INNER JOIN Grupo g ON a.ID_Grupo = g.ID_Grupo
                INNER JOIN Curso c ON g.ID_Curso = c.ID_Curso
                WHERE a.ID_Usuario = ?
            ";
                             
            $stmt_al = $conn->prepare($sql_alumno);
            $stmt_al->bind_param("i", $_SESSION['id_usuario']);
            $stmt_al->execute();
            $res_al = $stmt_al->get_result();

            if ($row = $res_al->fetch_assoc()) {
                echo "<table>
                        <tr>
                            <th>Concepto</th>
                            <th>Información Detallada</th>
                        </tr>
                        <tr>
                            <td><b>Curso Inscrito:</b></td>
                            <td>" . htmlspecialchars($row['Curso_Actual'], ENT_QUOTES, 'UTF-8') . "</td>
                        </tr>
                        <tr>
                            <td><b>Nivel de Dominio:</b></td>
                            <td>" . htmlspecialchars($row['Nivel_Idioma'], ENT_QUOTES, 'UTF-8') . "</td>
                        </tr>
                        <tr>
                            <td><b>Estado de Inscripción:</b></td>
                            <td>" . htmlspecialchars($row['Estado_Academico'], ENT_QUOTES, 'UTF-8') . "</td>
                        </tr>
                        <tr>
                            <td><b>Fecha de Alta:</b></td>
                            <td>" . htmlspecialchars($row['Fecha_Inscripcion'], ENT_QUOTES, 'UTF-8') . "</td>
                        </tr>
                        <tr>
                            <td><b>Inicio de Ciclo:</b></td>
                            <td>" . htmlspecialchars($row['Inicio_Clases'], ENT_QUOTES, 'UTF-8') . "</td>
                        </tr>
                      </table>";
            } else {
                echo "<p style='color: #f85149;'>Actualmente no cuentas con una inscripción activa.</p>";
            }
            
            $stmt_al->close();
            echo "</div>";
        } 
        else {
            echo "<div class='card'><p>Error de integridad: Rol no reconocido por el sistema.</p></div>";
        }
        ?>

    </div>
</body>
</html>