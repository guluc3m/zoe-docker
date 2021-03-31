Before start Zoe:

1. Make sure download.sh has execution permissions

2. Execute install-docker.sh, which will install docker and docker-compose if you haven't them already 

3. Execute download.sh, which will install the dependencies, such as docker and docker-compose (FOR DEBIAN) and download the default Zoe agents

    ```
    $ ./download.sh
    ```

    The download script will download what we think are the "core" agents of Zoe. Feel free to remove or include any agent you like. Note that if you remove the `zoe-agent-msglog` and the `zoe-agent-shell` debugging and development will be more difficult

To start Zoe:

1.  Open a terminal and get the latest base image:

    ```
    $ docker pull voiser/zoe-agent:latest
    ```

1.  Launch Zookeeper (This will be running in foreground, so you will need more than 1 terminal):

    ```
    $ docker-compose up --build zookeeper
    ```

1.  Open another terminal and launch Kafka (This will be running in foreground too):

    ```
    $ docker-compose up --build kafka
    ```

    Wait for a few seconds until Kafka initialises.

1.  Open another terminal and launch agent msglog (More foreground):

    ```
    $ docker-compose up --build zoe-agent-msglog
    ```

    You should see something like:
    ```
    zoe-agent-msglog_1  | ** Checking /code for changes...
    zoe-agent-msglog_1  | ** Starting python3 -u /code/src/agent.py
    zoe-agent-msglog_1  | Setting up watches.  Beware: since -r was given, this may take a while!
    zoe-agent-msglog_1  | Watches established.
    zoe-agent-msglog_1  | Running!
    ```

1.  Open another terminal and launch agent shell:

    ```
    $ docker-compose run zoe-agent-shell
    ```

    You should see a welcome message. Type:

    ```
    email(user('someone'), 'subject', 'body')
    ```

    This is Zoe's hello world :)

    Change to the zoe-agent-msglog terminal and you should see a message
    in its log (a JSON object). Due to Kafka rebalancing it can take a few
    seconds, please be patient:
    ```
    zoe-agent-msglog_1  | {
    zoe-agent-msglog_1  |   intent: "shell.show"
    zoe-agent-msglog_1  |   payloads: [
    zoe-agent-msglog_1  |     {
    zoe-agent-msglog_1  |       body: "body"
    zoe-agent-msglog_1  |       intent: "mail.send"
    zoe-agent-msglog_1  |       recipient: {
    zoe-agent-msglog_1  |         intent: "user.get"
    zoe-agent-msglog_1  |         name: "someone"
    zoe-agent-msglog_1  |       }
    zoe-agent-msglog_1  |       subject: "subject"
    zoe-agent-msglog_1  |     }
    zoe-agent-msglog_1  |   ]
    zoe-agent-msglog_1  | }
    zoe-agent-msglog_1  |
    ```

    This means that the `shell` agent has sent an intent successfully.

    Let's check the Kafka status. Open another terminal and
    list the kafka topics:

    ```
    $ docker-compose exec kafka bash
    bash-4.3# cd /opt/kafka
    bash-4.3# ./bin/kafka-topics.sh --zookeeper zookeeper:2181 --list
    ```

    You should see something like:

    ```
    __consumer_offsets
    zoe
    ```

    That means that the `zoe` topic is created. Now, let's check the
    consumers:

    ```
    bash-4.3# ./bin/kafka-consumer-groups.sh --bootstrap-server kafka:9092 --list
    Shell
    Log
    ```

    Those are the consumer groups, which correspond to the two agents launched.
    Now, let's check the status of one of them, for example, `Log`:
    ```
    bash-4.3# ./bin/kafka-consumer-groups.sh --bootstrap-server kafka:9092 --describe --group Log
    ```

    This means that:

    - The `Log` groups is attached to the `zoe` topic which is split in 10 partitions
    - All partitions are owned by the same client (`kafka-python-1.3.5_/172.18.0.4`)
    - `CURRENT_OFFSET` tells us that here has been a single message in the topic (in this case in partition 2)
    - `LOG-END-OFFSET` tells us that the message has been correctly consumed.

1.  Launch the remaining agents in another terminal:

    ```
    $ docker-compose up --build zoe-agent-user zoe-agent-mail ... # whatever
    ```

    If you inspect Kafka again, you should see all agents connected. Now, go back
    to the shell and repeat the same command:

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
