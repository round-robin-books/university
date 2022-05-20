## NodeJS Redpanda Tutorial
This is a Hello, World-style tutorial for producing and consuming data from [Redpanda][redpanda] with NodeJS.

[redpanda]: https://redpanda.com/

The code contains a simple producer application that produces greetings (e.g. “Hello, World!”) to a topic called greetings, and a corresponding consumer that reads these messages from the same Redpanda topic.

## Get Started

- Start a local Redpanda cluster with Docker Compose.

  ```sh
  docker-compose up -d
  ```
  
- Save the broker endpoint to the `REDPANDA_BROKERS` variable. This is how the consumer and producer know which Redpanda cluster to talk to.

   ```sh
   export REDPANDA_BROKERS="127.0.0.1:9092"
   ```
  
- Create the `greetings` topic.

  ```sh
  rpk topic create greetings --partitions 4 --replicas 1
  ```
  
- Install the client library.

  ```sh
  npm i kafkajs
  ```
  
- Run the producer.

  ```sh
  node src/producer.js
  
  # you should see this:
  Produced greeting to topic
  ```
  
- Run the consumer.

  ```sh
  node src/consumer.js
  
  # you should see a record similar to this:
  { partition: 3, offset: '0', value: 'Hello, World!' }
  ```
  
- Stop the Consumer

  ```sh
  ^C
  ```
  
- Clean up.

  ```sh
  docker-compose down
  ```
