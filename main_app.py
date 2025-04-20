# main app file

"""
CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  comment TEXT
);

"""

import dash
from dash import dcc, dash_table
from dash import html
from dash.dependencies import Input, Output, State
import requests

try:
    app = dash.Dash(__name__)
except Exception as e:
    print(f"Error initializing Dash app: {e}")
    


DB_FILE = '/home/ec2-user/endpoint.txt'


#read the db file 

def read_db():
    try:
        with open(DB_FILE, 'r') as file:
            return file.read().strip() # this will read the file and remove any leading/trailing whitespace
    except:
        return None



    

def main_page_layout():
    return html.Div([
        html.H1("User Comments", style={'textAlign': 'center', 'color': 'blue'}),
        html.Div([
            dcc.Input(id='name', type='text', placeholder='Name', style={'margin': '5px'}),
            dcc.Input(id='email', type='text', placeholder='Email', style={'margin': '5px'}),
            dcc.Textarea(id='comment', placeholder='Comment', style={'margin': '5px', 'width': '100%', 'height': '100px'}),
        ], style={'padding': '10px', 'textAlign': 'center'}),
        html.Div([
            html.Button('Submit', id='submit-button', style={'margin': '5px'}),
            html.Button('Get Data', id='get-data-button', style={'margin': '5px'}),
        ], style={'textAlign': 'center'}),
        html.Div(id='output-container-button', style={'marginTop': '10px', 'textAlign': 'center'}),
        html.Div(id='output-container', style={'marginTop': '10px', 'textAlign': 'center'}),
        dash_table.DataTable(id='user-table')
    ])

# Define the layout of the app
app.layout = main_page_layout()

# Callback to handle form submission
@app.callback(
    Output('output-container-button', 'children'),
    Input('submit-button', 'n_clicks'),
    State('name', 'value'),
    State('email', 'value'),
    State('comment', 'value')
)
def update_output(n_clicks, name, email, comment):
    if n_clicks is None:
        return "Enter your details and click submit."
    if not name or not email:
        return "Please enter both name and email."
    
    api_endpoint = read_db()
    if api_endpoint is None:
        return "Database connection string is empty."
    try:
        response = requests.post(api_endpoint + '/insert_user', json={
            'name': name,
            'email': email,
            'comment': comment
        })
        if response.status_code == 200:
            return "User inserted successfully."
        else:
            return f"Error inserting user: {response.json().get('error', 'Unknown error')}"
    except requests.RequestException as e:
        return f"Error connecting to API: {e}"



# Callback to handle data retrieval
@app.callback(
    Output('user-table', 'data'),
    Input('get-data-button', 'n_clicks')
)
def get_data(n_clicks):
    if n_clicks is None:
        return []
    api_endpoint = read_db()
    if api_endpoint is None:
        return "Database connection string is empty."
    try:
        response = requests.get(api_endpoint + '/get_users')
        if response.status_code == 200:
            return response.json()
        else:
            return []

    except requests.RequestException as e:
        return []

    


# Run the app
if __name__ == '__main__':
 
    app.run(host='0.0.0.0', debug=False) 