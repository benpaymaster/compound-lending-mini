// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IComet.sol";

interface IERC20 {
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function transfer(address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract LendingVault is IComet {
    IERC20 public immutable asset;
    mapping(address => uint256) public balances;

    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    function supply(address, uint amount) external override {
        require(amount > 0, "Amount must be > 0");
        require(asset.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        balances[msg.sender] += amount;
    }

    function withdraw(address, uint amount) external override {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        balances[msg.sender] -= amount;
        require(asset.transfer(msg.sender, amount), "Transfer failed");
    }

    function balanceOf(address account) external view override returns (uint) {
        return balances[account];
    }
}
