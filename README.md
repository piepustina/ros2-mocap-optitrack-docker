# ros2-mocap-optitrack-docker
Docker container for the motion capture system Optitrack-Motive.

## Run on Windows
To run the container move to the directory where the Dockerfile is located and build the image with the command
```
docker build --tag mocap .
```

docker network create -d macvlan --subnet=10.125.37.0/24 --gateway=10.125.37.1 -o parent="Ethernet 5" mocap-net


## Run on Ubuntu
To run the container move to the directory where the Dockerfile is located and log in as root user
```
sudo -s
```

Build the image with the command
```
docker build --tag mocap .
```

Since the motion capture system sends the information to a broadcast address, the Docker container must be visibile on the physical network where Motive is pushing the packages; a macvlan network has to be created. For, suppose that the Docker host is located on the subnet: 10.125.37.0/24 with gateway: 10.125.37.2 through the network interface eno1. Then, to create the macvlan network run the command 
```
docker network create -d macvlan \
  --subnet=10.125.37.0/24 \
  --gateway=10.125.37.2 \
  -o parent=eno1 \
  --aux-address="WS=10.125.37.1" \
  mocap-net
```
Through the optional parameter --aux-address it is possible to specify a set of addresses already in use in the subnet, so as to avoid that the Docker container IP is assigned to a used address. For example, in the above command we assume that there are two devices connected to the network: the gateway, with address 10.125.37.2, and "WS", with address 10.125.37.1. 
To specify more than one address pass as argument a map
```
  --aux-address={"PC1=10.125.37.1", "PC2=10.125.37.3"} \
```

Finally, just run the image with
```
sudo docker run -it --rm --network mocap-net mocap
```
In the above command we specifu to run the container in interactive mode and with the just created network.
