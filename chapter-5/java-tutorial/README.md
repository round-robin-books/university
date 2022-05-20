## Java Redpanda Tutorial
This is a Hello, World-style tutorial for producing and consuming data from [Redpanda][redpanda] with Java.

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
  
- Build the application.

  ```sh
  gradle build --info
  ```
  
- Run the producer.

  ```sh
  gradle runProducer --info
  
  # you should see this:
  Produced record. key=key1, value=Hello, World!
  ```
  
- Run the consumer.

  ```sh
  gradle runConsumer --info
  
  # you should see this:
  Consumed record. key=key1, value=Hello, World!
  ```
  
- Stop the Consumer

  ```sh
  ^C
  ```
  
- Clean up.

  ```sh
  docker-compose down
  ```
