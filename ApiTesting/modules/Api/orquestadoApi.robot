*** Settings ***
Documentation    Orquestar operaciones CRUD de reservas en Restful Booker con autenticación.
Library          RequestsLibrary
Library          Collections
Library          OperatingSystem
Library          BuiltIn
Resource         ../../helpers/resources/pruebaApi.resource

*** Variables ***
${BASE_URL}      https://restful-booker.herokuapp.com
${AUTH_URL}      /auth

*** Keywords ***
Load JSON From File
    [Arguments]    ${file_path}
    ${json_string}=    Get File    ${file_path}
    ${json_data}=      Evaluate    json.loads('''${json_string}''')    json
    [Return]    ${json_data}

*** Test Cases ***
Orquestar operaciones CRUD de reservas en Restful Booker
    [Documentation]    Este caso de prueba realiza la creación, consulta, actualización y eliminación de una reserva usando la API de Restful Booker con autenticación.
    [Tags]             API   CRUD

    # Crear una sesión para la API
    Create Session     API_Session    ${BASE_URL}

    # Paso 0: Autenticar y obtener el token
    ${auth_data}=      Load JSON From File    ../../helpers/jsonFiles/auth_data.json
    ${response}=       POST On Session        API_Session    ${AUTH_URL}    json=${auth_data}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${token}=          Set Variable           ${response.json()["token"]}
    Log To Console     Autenticado con token: ${token}
    
    # Establecer la cookie con el token
    ${headers}=        Create Dictionary      Cookie=token=${token}
    
    # Paso 1: Crear una nueva reserva
    ${booking_data}=   Load JSON From File    ../../helpers/jsonFiles/booking_data.json
    ${response}=       POST On Session        API_Session    /booking    json=${booking_data}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${booking_id}=     Set Variable           ${response.json()["bookingid"]}
    Log To Console     Creada reserva con ID: ${booking_id}

    # Paso 2: Consultar la reserva creada
    ${response}=       GET On Session         API_Session    /booking/${booking_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${booking_data_fetched}=  Set Variable    ${response.json()}
    Log To Console     Consultada reserva: ${booking_data_fetched}

    # Paso 3: Actualizar la reserva
    ${updated_booking_data}=    Load JSON From File    ../../helpers/jsonFiles/updated_booking_data.json
    ${response}=       PUT On Session         API_Session    /booking/${booking_id}    json=${updated_booking_data}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    200
    ${updated_booking}=    Set Variable           ${response.json()}
    Log To Console     Reserva actualizada: ${updated_booking}
    Should Be Equal As Numbers    ${updated_booking["totalprice"]}    150

    # Paso 4: Eliminar la reserva
    ${response}=       DELETE On Session      API_Session    /booking/${booking_id}    headers=${headers}
    Should Be Equal As Numbers    ${response.status_code}    201
    Log To Console     Reserva con ID ${booking_id} eliminada
