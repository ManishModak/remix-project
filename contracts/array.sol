// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleList {
    struct Item {
        string name;
        uint256 quantity;
    }

    Item[] public items;

    function addItem(string memory _name, uint256 _quantity) public {
        items.push(Item(_name, _quantity));
    }

    function getItem(uint256 _index) public view returns (string memory name, uint256 quantity) {
        Item memory item = items[_index];
        return (item.name, item.quantity);
    }

    function getItemCount() public view returns (uint256) {
        return items.length;
    }
}