# KAFKA_BROKER=localhost:9092 FLASK_PORT=9999 python webapp.py

from gevent.wsgi          import WSGIServer
from os                   import getenv
from uuid                 import uuid1
from json                 import dumps
from pykafka.partitioners import hashing_partitioner
from pykafka              import KafkaClient as KC
from datetime             import datetime    as dt
from flask                import ( render_template as rt
                                 , Flask
                                 , request
                                 , redirect
                                 , session )

POSSIBLE_SIGNALS = \
    [ 'aaa', 'aaaa', 'aaaaa', 'aaaaaa'
    , 'bbb', 'bbbb', 'bbbbb', 'bbbbbb'
    , 'ccc', 'cccc', 'ccccc', 'cccccc'
    , 'ddd', 'dddd', 'ddddd', 'dddddd'
    , 'eee', 'eeee', 'eeeee', 'eeeeee' ]

POSSIBLE_SIGNALS_AS_SET = set(POSSIBLE_SIGNALS)

app = Flask(__name__)

@app.route('/')
def home():
    real_ip_addr = request.environ.get('HTTP_X_REAL_IP', request.remote_addr)
    return rt( 'buttons.html'
             , button_pressed=session.get('BUTTON_PRESSED')
             , real_ip_addr=real_ip_addr )

@app.route('/processinput', methods=['POST'])
def processinput():
    buttons_pressed_as_list = list( request.form )
    if len(buttons_pressed_as_list) == 1:
        button_pressed = buttons_pressed_as_list[0]
        if button_pressed in POSSIBLE_SIGNALS_AS_SET:
            real_ip_addr = request.environ.get('HTTP_X_REAL_IP', request.remote_addr)
            tstamp_str = dt.now().isoformat()
            raw_payload = { 'ip_token': '{}_{}'.format(real_ip_addr,button_pressed)
                          , 'tstamp': tstamp_str }
            payload = dumps(raw_payload)
            print(payload)
            session['BUTTON_PRESSED'] = button_pressed
            app.config['PRODUCER'].produce(payload.encode(), partition_key=button_pressed.encode())
    return redirect('/')

if __name__ == '__main__':
    kafka_broker = getenv('KAFKA_BROKER', 'localhost:9092')
    kafka_client = KC(hosts=kafka_broker)
    test_topic = kafka_client.topics[b'raw']
    app.config['PRODUCER'] = \
        test_topic.get_sync_producer(partitioner=hashing_partitioner)
    app.config['SECRET_KEY'] = getenv( 'SECRET_SESSION_KEY'
                                     , str( uuid1() ) )
    flask_port = int( getenv('FLASK_PORT') )
    http_server = WSGIServer( ('', flask_port), app )
    http_server.serve_forever()

