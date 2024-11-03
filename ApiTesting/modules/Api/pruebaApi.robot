*** Settings ***
Library           RequestsLibrary
Resource          ../helpers/resources/pruebaApi.resource

*** Test Cases ***
Obtener usuario por ID
    [Documentation]    Este caso de prueba obtiene un usuario por ID y verifica la respuesta.
    [Tags]             API   GET
    
    # Crear una sesión con la opción 'verify=False' para evitar la advertencia de SSL
    Create Session     API_Session    ${BASE_URL}    verify=False
    
    # Enviar la solicitud GET usando 'GET On Session'
    ${response}=       GET On Session    API_Session    /users/1

    # Verificar el código de estado de la respuesta
    Should Be Equal As Numbers    ${response.status_code}    200

    # Convertir la respuesta a JSON usando ${response.json()}
    ${json_data}=      Set Variable    ${response.json()}
    
    # Imprimir el JSON en la consola
    Log To Console     ${json_data}

    # Verificar que el JSON tiene el campo "username"
    Should Contain     ${json_data}    username