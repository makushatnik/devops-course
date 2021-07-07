# Main App class.

from errors import error_response, bad_request
from flask import Flask, request, jsonify
import random

import jsonschema
from jsonschema import validate

app = Flask(__name__)

# Global Variables.
username = 'Evgeny Ageev'
emoji = ['😉','😊','😃','😄','😁','😆','😅','😂', '😜','😝','😎','❤']

# Constants.
ANIMALS_EMOJI_PATH = "/etc/systemd/system/emoji.txt"

SOMETHING_WENT_WRONG = 'Something went wrong';
PAGE_NOT_FOUND = 'Page not found';
USER_SIDE_ERROR = 'Error on the user side';

# Loading of emoji
with open(ANIMALS_EMOJI_PATH) as file:
    animals_emoji_source = dict(x.lower().rstrip().split(None, 1) for x in file)

animals_emoji = {v: k for k, v in animals_emoji_source.items()}
set_with_keys = set(key.lower() for key in emoji)

# JSON schema for validating input data from POST request
animalsSchema = {
    "type": "object",
    "properties": {
        "animal": {"type": "string"},
        "sound": {"type": "string"},
        "count": {"type": "number"}
    },
    "required": ["animal", "sound", "count"]
}


GREETING_STR = '''
<div style="position: absolute; top: 0px; left: 0px;">
<pre>
IIIIII                   _.---._
  II                 .'"".'/|\`.""'.
  II                :  .' / | \ `.  :
  II                '.'  /  |  \  `.'
  II                 `. /   |   \ .'
IIIIII                 `-.__|__.-'

I love shells --egypt
[== Inspired by Metasploit ==]
</pre>
</div>
<div style="color: red; position: absolute; left: 60px; top: 0px;">
<pre>
  dTb.dTb  
 4'  v  'B 
 6.     .P 
 'T;. .;P' 
  'T; ;P'  
   'YvP'   
</pre>
</div>
<div style="color: blue; position: absolute; top: 150px; left: 0px;">
我要成為骯髒的富人。<br>
Devops 技術和技能將幫助我解決這個問題。<br>
我喜歡在遊艇上航行、直升機、徒步旅行、滑雪、旅行。
</div>
'''

# Monitoring for DevOps.
@app.route('/',methods=['GET'])
def greeting():
  return GREETING_STR

# Monitoring for DevOps.
@app.route('/health',methods=['GET'])
def check_status():
  return 'Up and Running!'

def validate_json(json_data):
    try:
        validate(instance=json_data, schema=animalsSchema)
    except jsonschema.exceptions.ValidationError:
        return False
    return True

# Posting an Animal DTO object and getting an answer.
# TODO: change data to an Animal object.
@app.route('/',methods=['POST'])
def json_example():
  data = request.get_json()
  is_valid = validate_json(data)
  if is_valid:
    return generate_response(data)
  else:
    app.logger.info("Invalid JSON: %s", data)
    return 'Send correct JSON, please\n', 400

def generate_response(data):
  animal = data['animal']
  sound = data['sound']
  count = data['count']
  lowAnimal = animal.lower()

  if lowAnimal in animals_emoji:
    animal = animals_emoji[lowAnimal]

  res = '';
  ri = random.randint(0, len(emoji) - 1)
  for _ in range(count):
    res += animal + ' sounds ' + sound + " \n"

  return '{}Made with {} by {}\n'.format(res, emoji[ri], username)

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
