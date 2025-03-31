// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

contract SimpleBank {
    struct client_account {
        int client_id; 
        address client_address;
        uint client_balance_in_ether;
    }

    client_account[] clients;
    int clientCounter;
    address payable manager;

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can call this!");
        _;
    }

    modifier onlyClients() {
        bool isclient = false;
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].client_address == msg.sender) {
                isclient = true;
                break;
            }
        }
        require(isclient, "Only clients can call this!");
        _;
    }

    constructor() {
        clientCounter = 0;
    }

    receive() external payable { }

    function setManager(address managerAddress) public returns (string memory) {
        manager = payable(managerAddress);
        return "";
    }

    function joinAsClient() public payable returns (string memory) {
        clients.push(client_account(clientCounter++, msg.sender, 0)); // Initialize balance to 0
        return "";
    }

    function deposit() public payable onlyClients {
        // Find the client and update their balance
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].client_address == msg.sender) {
                clients[i].client_balance_in_ether += msg.value; // Add deposited amount to client's balance
                break;
            }
        }
    }

    function withdraw(uint amount) public payable onlyClients {
        // Find the client and check/update their balance
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].client_address == msg.sender) {
                require(clients[i].client_balance_in_ether >= amount, "Insufficient balance!");
                clients[i].client_balance_in_ether -= amount; // Deduct the amount from client's balance
                payable(msg.sender).transfer(amount); // Transfer the amount to the client
                break;
            }
        }
    }

    function sendInterest() public payable onlyManager {
        for (uint i = 0; i < clients.length; i++) {
            address initialAddress = clients[i].client_address;
            payable(initialAddress).transfer(1 ether); // Changed from 1 ether to 0.001 ether
        }
    }

    function getContractBalance() public view returns (uint) {
        return address(this).balance;
    }

    // Added function to display the client's balance
    function getClientBalance() public view onlyClients returns (uint) {
        for (uint i = 0; i < clients.length; i++) {
            if (clients[i].client_address == msg.sender) {
                return clients[i].client_balance_in_ether;
            }
        }
        return 0;
    }
}