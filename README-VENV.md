
Before start Zoe:

1. Make sure download.sh has execution permissions.

2. Execute download.sh

    ```
    $ ./download.sh
    ```

To start Zoe:

1.  Open a terminal and get the latest base image:

    ```
    $ docker pull voiser/zoe-agent:latest
    ```

1.  Launch Zookeeper:

    ```
    $ docker-compose up --build zookeeper
    ```

1.  Open another terminal and launch Kafka:

    ```
    $ docker-compose up --build kafka
    ```

    Wait for a few seconds until Kafka initialises.

1.  Create and activate virtual environment:

    ```
    $ virtualenv -p python3.6 venv
    $ source venv/bin/activate
    ```

1.  Install all dependencies:

    ```
    $ find . -name \*requirements.txt | while read f; do echo $f; pip3 install -r $f; done
    ```

1.  Run non interactive agents:

    ```
    $ KAFKA_SERVERS=localhost:9092 python3 zoe-agent-user/src/agent.py &
    $ KAFKA_SERVERS=localhost:9092 python3 zoe-agent-mail/src/agent.py &
    $ KAFKA_SERVERS=localhost:9092 python3 zoe-agent-msglog/src/agent.py &
    ```

1.  In another terminal run:

    ```
    $ KAFKA_SERVERS=localhost:9092 python3 zoe-agent-shell/src/agent.py
    ```

    And type what has become Zoe's "hello world":

    ```
    email(user('someone'), 'subject', 'body')
    ```

    You should see a response this time, something like:

    ```
    [{'data': 'notification', 'from': 'email', 'text': 'message sent'}]
    ```

    Take a look at the message log and you should see a bunch of messages interchanged.
    You should also see how the intent tree is reduced to generate the final result
    displayed in the shell. That's great!
