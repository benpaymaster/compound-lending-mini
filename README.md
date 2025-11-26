# Compound Lending Mini

A mini DeFi lending application built with Solidity, React, and ethers.js. Users can supply and withdraw ERC20 assets via a smart contract, with a modern frontend for wallet connection and transaction management. Perfect for demonstrating blockchain development skills and smart contract integration.

## Features

- Supply and withdraw ERC20 assets
- Smart contract interaction using ethers.js
- React UI for user actions and wallet connection
- Transaction status feedback

## Getting Started

1. Deploy the `LendingVault.sol` contract and note its address.
2. Update the contract address in `frontend-next/components/useLendingVault.ts`.
3. Install dependencies:
   ```bash
   cd frontend-next
   npm install
   ```
4. Start the frontend:
   ```bash
   npm run dev
   ```
5. Connect your wallet (MetaMask) and interact with the contract using the UI.

## Tech Stack

- Solidity
- React + TypeScript
- ethers.js

## Security & Auditability

- Implements OpenZeppelin-style reentrancy protection (`ReentrancyGuard`)
- Emits events for all supply and withdraw actions
- Comprehensive comments for auditability

## Testing

- Foundry tests for supply, withdraw, and reentrancy protection
- To run tests:
  ```bash
  forge test
  ```
- All tests must pass for new features

## Gas Optimization

- The `LendingVault` contract uses `unchecked` blocks for balance updates in supply and withdraw functions, reducing gas costs while maintaining safety due to prior input checks.
- Foundry tests confirm correct behavior and show gas usage:
  - `testSupply()`: ~74,555 gas
  - `testWithdraw()`: ~81,649 gas
- This demonstrates practical gas-saving techniques and how to measure their impact in Solidity projects.

## Next Steps

- Add more tests and error handling
- Improve UI/UX
- Document deployment and environment setup

---

For questions or contributions, open an issue or pull request!
