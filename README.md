# TRON Escrow Smart Contract

## Overview
This project implements an Escrow Smart Contract on the TRON blockchain. It provides a secure way for buyers and sellers to conduct transactions while ensuring platform fees and dispute resolutions are handled efficiently. The contract is deployed and tested on the Shasta testnet.

---

## Features
- **Create Escrow:** Allows sellers to create an escrow by depositing USDT.
- **Release Escrow:** Transfers funds to the buyer and deducts platform fees.
- **Cancel Escrow:** Allows sellers to cancel the escrow and receive a refund.
- **Dispute Resolution:** Arbitrators can resolve disputes by transferring funds to the correct party.
- **Platform Fee Management:** The platform owner can set fees and withdraw accumulated fees.
- **Configurable Roles:** Support for setting arbitrators, relayers, and platform withdrawal addresses.

---

## Prerequisites
1. **Node.js**: Install the latest version of Node.js and npm.
2. **TronLink Wallet**: Install and configure TronLink browser extension.
3. **TronBox**: Install TronBox to interact with TRON blockchain.
4. **Shasta Testnet Access**: Obtain test TRX from the Shasta Faucet.

---

## Installation
1. Clone the repository:
   ```bash
   git clone git@github.com:mprogrammer2020/tron-escrow.git
   cd tron-escrow
   ```
2. Install dependencies:
   ```bash
   npm install
   ```

3. Initialize TronBox:
   ```bash
   tronbox init
   ```

4. Configure the `tronbox.js` file to connect to the Shasta testnet:
   ```javascript
   module.exports = {
     networks: {
       shasta: {
         privateKey: '<YOUR_PRIVATE_KEY>',
         fullHost: 'https://api.shasta.trongrid.io',
         network_id: '*'
       }
     }
   };
   ```

---

## Deployment
1. Compile the contract:
   ```bash
   tronbox compile
   ```

2. Deploy the contract to the Shasta testnet:
   ```bash
   tronbox migrate --network shasta
   ```

3. Note the deployed contract address for interaction.

---

## Testing
1. Write test cases in the `test` folder (e.g., `EscrowTest.js`).
2. Run the test cases:
   ```bash
   tronbox test --network shasta
   ```
3. Verify the output to ensure all test cases pass.

---

## Usage
### Key Functions
1. **createEscrow**
   - **Description**: Creates a new escrow.
   - **Usage**:
     ```javascript
     await escrowInstance.createEscrow(buyerAddress, amount, { from: sellerAddress, value: amount });
     ```

2. **releaseEscrow**
   - **Description**: Releases escrow funds to the buyer.
   - **Usage**:
     ```javascript
     await escrowInstance.releaseEscrow(escrowId, { from: sellerAddress });
     ```

3. **cancelEscrow**
   - **Description**: Cancels escrow and refunds the seller.
   - **Usage**:
     ```javascript
     await escrowInstance.cancelEscrow(escrowId, { from: sellerAddress });
     ```

4. **resolveDispute**
   - **Description**: Resolves disputes by an arbitrator.
   - **Usage**:
     ```javascript
     await escrowInstance.resolveDispute(escrowId, recipientAddress, { from: arbitratorAddress });
     ```

### Events
- `EscrowCreated`
- `EscrowReleased`
- `EscrowCancelled`
- `DisputeResolved`

---

## Shasta Testnet Configuration
1. Switch your TronLink wallet to the Shasta testnet.
2. Use the [Shasta Faucet](https://www.trongrid.io/shasta) to get test TRX.

---

## Troubleshooting
- **Error: Could not find `package.json`:**
  Run `npm init -y` to generate a default `package.json` file.
- **TronLink Wallet Connection Issues:**
  Ensure TronLink is installed and switched to the Shasta testnet.
- **Test Case Failures:**
  Debug failing tests using `console.log` statements or verify your contract's logic.

---

## License
This project is licensed under the MIT License.

---

## Acknowledgments
- [TRON Blockchain](https://tron.network)
- [TronLink Wallet](https://www.tronlink.org/)
- [Shasta Testnet](https://www.trongrid.io/shasta)

