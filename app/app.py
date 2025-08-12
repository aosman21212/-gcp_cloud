from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def hello():
    return jsonify({
        'message': 'Hello from GKE!',
        'environment': os.getenv('ENVIRONMENT', 'development'),
        'version': os.getenv('VERSION', '1.0.0')
    })

@app.route('/health')
def health():
    return jsonify({'status': 'healthy'})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)