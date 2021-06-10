from flask import Flask, request, jsonify
app = Flask(__name__)

@app.route('/hello',methods=['GET'])
def hello_world():
    return 'Hello World!'

@app.route('/',methods=['POST'])
def json_example():
    request_data = request.get_json()
    animal = request_data['animal']
    sound = request_data['sound']
    count = request_data['count']
    return 'ANIMAL: {}\nSOUND: {}\nCOUNT: {}\n'.format(animal,sound,count)

if __name__ == '__main__':
    app.run(debug=True, port = 5000)
