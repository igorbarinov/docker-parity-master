## How to build
sudo docker build -t igorbarinov/docker-parity-master .

## How to run
`sudo docker run --name parity-master -p 8545:8545 -p 30303:30303 -p 8001:8001 -p 8002:8002 -d igorbarinov/docker-parity-master`

## Ports
* 30303  p2p networking
* 8545 rpc calls. Should be restricted by cors settings in Dockerfile/firewalled in production
* 8001 for static page web server to get enode. Used to bootstrap other nodes
* 8002 for Parity UI (should be restricted to docker host/firewalled in production

## FAQ
Q: Where a /root volume mounted on local system?
A: `sudo docker inspect parity-master `

Q: How do I ssh to the container?
A:  `sudo docker exec -it parity-master bash`

## Source
Github: https://github.com/igorbarinov/docker-parity-master
based on: https://github.com/jesuscript/vagrant-eth-env

