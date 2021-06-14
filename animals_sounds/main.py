# Main App class.

from errors import error_response, bad_request
from flask import Flask, request, jsonify
from animal import Animal
import random

app = Flask(__name__)

# Global Variables.
username = 'Evgeny Ageev'
inspiration = 'Made with inspiration by '
emoji = ['😉','😊','😃','😄','😁','😆','😅','😂', '😜','😝','😎']

# Constants.
SOMETHING_WENT_WRONG = 'Something went wrong';
PAGE_NOT_FOUND = 'Page not found';
USER_SIDE_ERROR = 'Error on the user side';

# Monitoring for DevOps.
@app.route('/',methods=['GET'])
def check_status():
  return 'Up and Running!'

# Posting an Animal DTO object and getting an answer.
# TODO: change data to an Animal object.
@app.route('/',methods=['POST'])
def json_example():
  data = request.get_json()
  if data:
    if 'animal' in data and 'sound' in data and 'count' in data:
      animal = data['animal']
      sound = data['sound']
      count = data['count']
      resp_str = '';
      ri = random.randint(0, len(emoji) - 1)
      for _ in range(count):
        resp_str += animal + ' sounds ' + sound + " \n"
      resp_str += inspiration + username + ' ' + emoji[ri] + "\n"
      return resp_str
  return 'Send correct JSON, please\n', 400

# Error handler for 500 status code.
@app.errorhandler(500)
def page_not_found(error):
  return error_response(500, SOMETHING_WENT_WRONG)

# Error handler for 404 status code.
@app.errorhandler(404)
def page_not_found(error):
  return error_response(404, PAGE_NOT_FOUND)

@app.errorhandler(400)
def page_not_found(error):
  return bad_request(USER_SIDE_ERROR)

if __name__ == '__main__':
  app.run(debug=True, port = 5000)
