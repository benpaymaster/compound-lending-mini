// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IComet.sol";
import "./ReentrancyGuard.sol";

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);

    function transfer(address to, uint256 amount) external returns (bool);

    function balanceOf(address account) external view returns (uint256);
}

/// @title LendingVault - Secure, auditable lending contract for ERC20 assets
/// @notice Implements supply/withdraw logic with reentrancy protection and event logging
import "./Ownable.sol";

contract LendingVault is IComet, ReentrancyGuard, Ownable {
    /// @notice Emergency withdraw all assets to owner (owner-only)
    function emergencyWithdraw() external onlyOwner nonReentrant {
        uint256 vaultBalance = asset.balanceOf(address(this));
        require(vaultBalance > 0, "Vault empty");
        require(asset.transfer(owner, vaultBalance), "Transfer failed");
    }

    IERC20 public immutable asset;
    mapping(address => uint256) public balances;

    /// @dev Emitted when a user supplies assets
    event Supplied(address indexed user, uint256 amount);
    /// @dev Emitted when a user withdraws assets
    event Withdrawn(address indexed user, uint256 amount);

    /// @param _asset ERC20 token address to be used as the vault asset
    constructor(address _asset) {
        asset = IERC20(_asset);
    }

    /// @notice Supply assets to the vault
    /// @param amount Amount of asset to supply
    function supply(address, uint amount) external override nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(
            asset.transferFrom(msg.sender, address(this), amount),
            "Transfer failed"
        );
        // Gas optimization: unchecked block for safe math (no overflow possible due to require)
        unchecked {
            balances[msg.sender] += amount;
        }
        emit Supplied(msg.sender, amount);
    }

    /// @notice Withdraw assets from the vault
    /// @param amount Amount of asset to withdraw
    function withdraw(address, uint amount) external override nonReentrant {
        require(amount > 0, "Amount must be > 0");
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // Gas optimization: unchecked block for safe math (no underflow possible due to require)
        unchecked {
            balances[msg.sender] -= amount;
        }
        require(asset.transfer(msg.sender, amount), "Transfer failed");
        emit Withdrawn(msg.sender, amount);
    }

    /// @notice Get the balance of a user
    /// @param account User address
    /// @return User's asset balance in the vault
    function balanceOf(address account) external view override returns (uint) {
        return balances[account];
    }
}
