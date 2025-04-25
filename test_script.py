import requests

def send_requests(server_url, num_requests):
    """
    Sends a specified number of HTTP GET requests to a given server URL.
    """

    for i in range(num_requests):
        try:
            response = requests.get(server_url, timeout=10)
            print(f"Request {i + 1}: Status Code = {response.status_code}")
        except requests.exceptions.RequestException as e:
            print(f"Request {i + 1}: Failed with error: {e}")

if __name__ == "__main__":
    
    server_url = "http://assign2-web-alb-1225881023.us-east-1.elb.amazonaws.com/" 
    num_requests = 100  
    
    send_requests(server_url, num_requests)