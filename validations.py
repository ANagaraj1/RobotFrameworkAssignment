"""
This script is used for API response validation
"""

def check_pagination_in_response(json_response):
    try:
        print("\nPagination value is "+str(json_response['meta']['pagination']))     #Tries to receive pagination value
    except KeyError as err:
        print("\npagination not present")

def validate_email(json_response):
    expected_keys = ['id', 'name', 'email', 'gender', 'status']
    try:
        for i in json_response['data']:  # Gets the data of each user
            actual_keys = []
            for key, value in i.items():
                actual_keys.append(key)  # Gets all the attributes present for the user
            if actual_keys == expected_keys:
                print("\nvalidated all the attributes of " + i[
                    'name'])  # Checks if attributes are as same and as expected
            else:
                print("\nActual and expected attributes are different for " + i['name'])
    except Exception as e:
        print("\n Error occured", e)
