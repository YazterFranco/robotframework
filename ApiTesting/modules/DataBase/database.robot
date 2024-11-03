*** Settings ***
Documentation    Prueba de conexión a base de datos MySQL y validaciones con Robot Framework.
Library          DatabaseLibrary
Library          Collections

*** Variables ***
${DB_NAME}       example_db
${DB_USER}       root
${DB_PASSWORD}   root
${DB_HOST}       localhost
${DB_PORT}       3306

*** Test Cases ***
Conectar y Validar Datos en la Base de Datos MySQL
    [Documentation]    Este caso de prueba se conecta a una base de datos MySQL y valida algunos datos.
    
    # Conectar a la base de datos
    Connect To Database    pymysql    ${DB_NAME}    ${DB_USER}    ${DB_PASSWORD}    ${DB_HOST}    ${DB_PORT}
    
    # Ejecutar una consulta SQL
    ${query_result}=    Query    SELECT * FROM users WHERE id=1
    Log To Console    ${query_result}
    
    # Validar el resultado de la consulta
    Should Be Equal As Strings    ${query_result[0][1]}    Juan Perez
    Should Be Equal As Numbers    ${query_result[0][2]}    30
    
    # Cerrar la conexión a la base de datos
    Disconnect From Database
