*** Settings ***
Documentation     API Response Testing
Library           validations.py
Library           RequestsLibrary


*** Variables ***
${base_url}    https://gorest.co.in/
${token}    xxx
${http_base_url}    http://gorest.co.in/

*** Keywords ***
Invoke GET API and retrieve response
    ${response} =    GET On Session    API_Testing    public/v1/users    params=access-token=${token}
    [return]    ${response}

Validate JSON Response
    ${response} =    GET On Session    API_Testing    public/v1/users    params=access-token=${token}
    ${json_response} =    set variable    ${response.json()}
    [return]    ${json_response}


*** Test Cases ***
Invoke GET API
    [Documentation]    Creates sessions and invokes API
    Create Session    API_Testing    ${base_url}    verify=True
    ${api_response} =    Invoke GET API and retrieve response
    Log to console    ${api_response}

Validate JSON Response
    [Documentation]    Validates if the response is a valid JSON
    ${json_response} =    Validate JSON Response
    Log To Console    Validated the JSON for GET API Response ${json_response}

Verify API Success Response
    [Documentation]    Checks the status code of the API response
    ${api_response} =    Invoke GET API and retrieve response
    ${status_code}=     convert to string   ${api_response.status_code}
    should be equal     ${status_code}      200
    Log To Console    Validated status code of API GET response

Verify Incorrect Authentication Request
    [Documentation]    Checks for incorrect authentication request
    ${api_response} =    Invoke GET API and retrieve response
    ${status_code}=     convert to string   ${api_response.status_code}
    Should Not Be Equal     ${status_code}      401
    Log To Console    Testcase executed successfully without authentication error

Verify Unauthorized Status Code
    [Documentation]    Checks for incorrect authorized status code
    ${api_response} =    Invoke GET API and retrieve response
    ${status_code}=     convert to string   ${api_response.status_code}
    Should Not Be Equal     ${status_code}      403
    Log To Console    Testcase executed successfully with authorization

Verify API Internal Server Error Request
    [Documentation]    Checks for Internal server error in the API request
    ${api_response} =    Invoke GET API and retrieve response
    ${status_code}=     convert to string   ${api_response.status_code}
    Should Not Be Equal     ${status_code}      500
    Log To Console    Testcase executed successfully without internal server error

Verify Service Unavailable Error Request
    [Documentation]    Checks for service unavailable error in the request
    ${api_response} =    Invoke GET API and retrieve response
    ${status_code}=     convert to string   ${api_response.status_code}
    Should Not Be Equal     ${status_code}      503
    Log To Console    Testcase executed successfully without Service Unavailable error

Verify Pagination
    [Documentation]    Checks for pagination field of the response
    ${json_response} =    Validate JSON Response
    check pagination in response    ${json_response}
    Log to console    Verified Pagination

Verify Email in Response
    [Documentation]    Verifies if response data has valid email address
    ${json_response} =    Validate JSON Response
    validate email    ${json_response}
    Log To Console    Validated email in response

Validate API without Authentication
    [Documentation]    Verify REST service without authentication
    ${response} =    GET On Session    API_Testing    public/v1/users
    ${status_code}=     convert to string   ${response.status_code}
    should not be equal     ${status_code}      200

Verify Non-SSL
    [Documentation]    Verify Non-SSL Rest endpoint behaviour
    Create Session    API_Testing    ${http_base_url}    verify=True
    ${response} =    GET On Session    API_Testing    public/v1/users    params=access-token=${token}
    ${status_code}=     convert to string   ${response.status_code}
    Log To Console    Checking for Non SSL
    should not be equal     ${status_code}      200