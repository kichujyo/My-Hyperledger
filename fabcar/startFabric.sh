#!/bin/bash
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
# Exit on first error
set -e

# don't rewrite paths for Windows Git Bash users
export MSYS_NO_PATHCONV=1
starttime=$(date +%s)
LANGUAGE=${1:-"golang"}
CC_SRC_PATH=github.com/fabcar/go
if [ "$LANGUAGE" = "node" -o "$LANGUAGE" = "NODE" ]; then
	CC_SRC_PATH=/opt/gopath/src/github.com/fabcar/node
fi

# clean the keystore
rm -rf ./hfc-key-store

# launch network; create channel and join peer to channel
cd ../basic-network
./start.sh

# Now launch the CLI container in order to install, instantiate chaincode
# and prime the ledger with our 10 cars
docker-compose -f ./docker-compose.yml up -d cli

docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode install -n fabcar -v 1.0 -p "$CC_SRC_PATH" -l "$LANGUAGE"
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n fabcar -l "$LANGUAGE" -v 1.0 -c '{"Args":[""]}' -P "OR ('Org1MSP.member','Org2MSP.member')"
sleep 10
docker exec -e "CORE_PEER_LOCALMSPID=Org1MSP" -e "CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp" cli peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"initLedger","Args":[""]}'

printf "\nTotal setup execution time : $(($(date +%s) - starttime)) secs ...\n\n\n"
printf "Start by installing required packages run 'npm install'\n"
printf "Then run 'node enrollAdmin.js', then 'node registerUser'\n\n"
printf "The 'node invoke.js' will fail until it has been updated with valid arguments\n"
printf "The 'node query.js' may be run at anytime once the user has been registered\n\n"

# peer chaincode install -n fabcar -v 1.0 -p /opt/gopath/src/github.com/fabcar/node -l node


# peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n fabcar -l node -v 1.0 -c '{"Args":[""]}' -P "AND ('Org1MSP.member','Org2MSP.member')"
#
# peer channel create -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/channel.tx
#
# peer channel join -b mychannel.block
# CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer0.org2.example.com:7051 CORE_PEER_LOCALMSPID="Org2MSP" peer channel join -b mychannel.block
# peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/Org1MSPanchors.tx
# CORE_PEER_MSPCONFIGPATH=/opt/gopath/src/github.com/hyperledger/fabric/peer/crypto/peerOrganizations/org2.example.com/users/Admin@org2.example.com/msp CORE_PEER_ADDRESS=peer0.org2.example.com:7051 CORE_PEER_LOCALMSPID="Org2MSP" peer channel update -o orderer.example.com:7050 -c mychannel -f ./channel-artifacts/Org2MSPanchors.tx
# peer chaincode install -n fabcar -v 1.0 -p /opt/gopath/src/github.com/fabcar/node -l node
# peer chaincode instantiate -o orderer.example.com:7050 -C mychannel -n fabcar -l node -v 1.0 -c '{"Args":[""]}' -P "AND ('Org1MSP.member','Org2MSP.member')"
# peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"initLedger","Args":[""]}'

15  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"initLedger","Args":[""]}'
	16  history
	17  ls
	18  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"queryCar","Args":["CAR0"]}'
	19  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"queryCar","Args":["CAR1"]}'
	20  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"queryAllCars","Args":[""]}'
	21  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"createCar","Args":["sujith","test1","test2","test3","test4"]}'
	22  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"queryAllCars","Args":[""]}'
	23  peer chaincode invoke -o orderer.example.com:7050 -C mychannel -n fabcar -c '{"function":"queryCar","Args":["sujith"]}'
