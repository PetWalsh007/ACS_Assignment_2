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
import sqlite3

try:
    app = dash.Dash(__name__)
except Exception as e:
    print(f"Error initializing Dash app: {e}")
    


DB_FILE = '/home/ec2-user/pw-assign2.txt'


#read the db file 

def read_db():
    try:
        with open(DB_FILE, 'r') as file:
            return file.read().strip()
    except:
        return None



# Connect to the SQLite database
def connect_db():
    con_str = read_db()
    if con_str is None:
        print("Database connection string is empty.")
        return None
    try:
        conn = sqlite3.connect(con_str)
        return conn
    except sqlite3.Error as e:
        print(f"Error connecting to database: {e}")
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
    
    conn = connect_db()
    if conn is None:
        return "Database connection failed."

    try:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email, comment) VALUES (?, ?, ?)", (name, email, comment))
        conn.commit()
        return f"Data submitted: {name}, {email}, {comment}"
    except sqlite3.Error as e:
        return f"Error inserting data: {e}"
    finally:
        conn.close()

# Callback to handle data retrieval
@app.callback(
    Output('user-table', 'data'),
    Input('get-data-button', 'n_clicks')
)
def get_data(n_clicks):
    if n_clicks is None:
        return []
    
    conn = connect_db()
    if conn is None:
        return []

    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        rows = cursor.fetchall()
        columns = [description[0] for description in cursor.description]
        data = [dict(zip(columns, row)) for row in rows]
        return data
    except sqlite3.Error as e:
        print(f"Error retrieving data: {e}")
        return []
    finally:
        conn.close()


# Run the app
if __name__ == '__main__':
 
    app.run(host='0.0.0.0',debug=True) 