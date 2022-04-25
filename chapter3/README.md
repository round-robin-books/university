# Chapter 3 : Getting Started With Redpanda

This chapter covers how to install Redpanda and start a cluster. For more detailed documentation on Redpanda, check out [the excellent docs](https://docs.redpanda.com/) published by the Redpanda team. This document covers any commands run in the accompanying video to make it easy for anyone watching to follow along. 

## Prerequisites 

* Homebrew for package installation and management ([installation instructions](https://brew.sh/))
- Docker ([installation instructions](https://docs.docker.com/desktop/mac/install/)) 

## Install and Start RedPanda 

### On your local machine (MacOS)

1. Install Redpanda
    ```bash
    $ brew install redpanda-data/tap/redpanda
    ```

2. Confirm your install was successful
    ```bash
    $ rpk --help
    ``` 

3. Spin up a Redpanda 3-node cluster
    ```bash
    $ rpk container start -n 3
    ```

4. Interact with the cluster 
    ```bash
    $ rpk cluster info --brokers IPADDR1,IPADDR2,IPADDR3
    ``` 

5. Spin down the cluster
    ```bash
    $ rpk container purge
    ``` 

### Using Docker 
1. Spin up Redpanda 3-node cluster. This step uses a script included with this repo that creates the network, persistent volumes, and 3-node cluster. 
    ```bash
    $ ./scripts/dockersetup.sh
    ```

2. Interact with the cluster 
    ```bash
    # Grab the name of a container
    $ docker container list
    # Interact with rpk from the container 
    $ docker exec -it redpanda-1 rpk cluster info
    ```

3. Spin down the cluster. This step uses a script that removes the resources created in step 1. 
    ```bash
    $ ./scripts/dockercleanup.sh
    ```

#### [optional] Using docker-compose
1. Bring up the cluster using docker-compose. This step uses a docker-compose file included in the repo. It currently has the same settings as the cluster in the previous section. However, feel free to edit the settings before landing on configuration that works for you. 

    ```bash
    $ docker compose up -d 

    # interact with the one-node cluster
    $ docker container list
    $ docker exec -it redpanda-1 rpk cluster info

    # spin down resources
    $ docker composer down 
    ```

### Using Kubernetes (minkube)

#### Pre-requisites 
- [Kubernetes](https://kubernetes.io/docs/tasks/tools/)
- [Helm](https://github.com/helm/helm/releases)
- [Minikube](https://minikube.sigs.k8s.io/docs/start/)
- [JQ](https://stedolan.github.io/jq/)

NOTE: All of the prequisites can be installed using homebrew. 

1. Start local cluster 
    ```bash
    # start up the cluster 
    $ minikube start
    # confirm the cluster started up successfully
    $ minikube status
    ```

2. Set up cert-manager 
    ```bash
    # Install cert-manager 
    $ helm repo add jetstack https://charts.jetstack.io && \
    helm repo update && \
    helm upgrade --install \
      cert-manager jetstack/cert-manager \
      --namespace cert-manager \
      --create-namespace \
      --version v1.7.0 \
      --set installCRDs=true

    # Verify cert-manager was installed successfully 
    $ kubectl get pods --namespace cert-manager 
    
    $ kubectl apply -f resources/test-resources.yaml
    
    $ kubectl describe certificate -n cert-manager-test
    
    # clean up test cert 
    $ kubectl delete -f resources/test-resources.yaml 
    ```

3. Install Redpanda Operator. This step uses a script included in the repo. 
    ```bash
    $ ./scripts/kubernetessetup.sh
    
    # check to see if the redpanda operator is installed and running 
    $ kubectl get pods -n redpanda-system
    ```


4. Install and Start Redpanda 
    ```bash
    # create a namespace
    $ kubectl create ns panda-ns
    
    # install single-node cluster 
    $ kubectl apply \
    -n panda-ns \
    -f https://raw.githubusercontent.com/redpanda-data/redpanda/dev/src/go/k8s/config/samples/one_node_cluster.yaml
    
    # verify cluster was created 
    $ kubectl -n panda-ns get pods  
    $ kubeclt -n panda-ns  logs -f one-node-cluster-0 
    $ kubectl -n panda-ns describe pod one-node-cluster-0 
    $ kubectl -n panda-ns exec -it one-node-cluster-0 -- rpk cluster info --brokers='localhost:9092' 
    ```

5. Clean up resources
    ```bash
    # delete the cluster 
    $ minikube delete
    # remove the installed helm repos 
    $ helm repo remove jetstack
    $ helm repo remove redpanda
    ```