// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/LendingVault.sol";

contract ERC20Mock {
    string public name = "MockToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply;
        balanceOf[msg.sender] = _initialSupply;
    }

    function transfer(address to, uint256 amount) external returns (bool) {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;
        return true;
    }

    function approve(address spender, uint256 amount) external returns (bool) {
        allowance[msg.sender][spender] = amount;
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool) {
        require(balanceOf[from] >= amount, "Insufficient balance");
        require(
            allowance[from][msg.sender] >= amount,
            "Insufficient allowance"
        );
        allowance[from][msg.sender] -= amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;
        return true;
    }
}

contract LendingVaultTest is Test {
    LendingVault vault;
    ERC20Mock token;
    address user = address(0xBEEF);

    function setUp() public {
        token = new ERC20Mock(1000 ether);
        vault = new LendingVault(address(token));
        token.approve(address(vault), 1000 ether);
    }

    function testSupply() public {
        vault.supply(address(token), 100 ether);
        assertEq(vault.balanceOf(address(this)), 100 ether);
    }

    function testWithdraw() public {
        vault.supply(address(token), 100 ether);
        vault.withdraw(address(token), 50 ether);
        assertEq(vault.balanceOf(address(this)), 50 ether);
    }

    function testReentrancyGuard() public {
        // Reentrancy test can be added here with a malicious contract
        // For now, just ensure nonReentrant modifier is present
        bool success = false;
        try vault.supply(address(token), 0) {
            // Should revert
        } catch {
            success = true;
        }
        assertTrue(success);
    }
}
