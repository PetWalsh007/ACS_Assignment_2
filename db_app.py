# db app main 
from flask import Flask, request, jsonify
import sqlite3

app = Flask(__name__)

DB_FILE = '/home/ec2-user/pw-assign2.db'

def get_db_connection():
    try:
        conn = sqlite3.connect(DB_FILE)
        conn.row_factory = sqlite3.Row
        return conn
    except sqlite3.Error as e:
        print(f"Database connection error: {e}")
        return None

@app.route('/insert_user', methods=['POST'])
def insert_user():
    data = request.get_json()
    if not data:
        return jsonify({"error": "Missing JSON data"}), 400

    name = data.get('name')
    email = data.get('email')
    comment = data.get('comment')

    if not name or not email:
        return jsonify({"error": "Name and Email are required"}), 400

    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    try:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO users (name, email, comment) VALUES (?, ?, ?)", (name, email, comment))
        conn.commit()
        return jsonify({"message": "User inserted successfully"}), 200
    except sqlite3.Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

@app.route('/get_users', methods=['GET'])
def get_users():
    conn = get_db_connection()
    if conn is None:
        return jsonify({"error": "Database connection failed"}), 500

    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users")
        rows = cursor.fetchall()
        columns = [description[0] for description in cursor.description]
        data = [dict(zip(columns, row)) for row in rows]
        return jsonify(data)
    except sqlite3.Error as e:
        return jsonify({"error": str(e)}), 500
    finally:
        conn.close()

# specify port 5000 - what we have open in security group
if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False, use_reloader=False)

