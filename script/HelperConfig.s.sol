// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";

contract HelperConfig {
    // Deploy mocks when we are on a local anvil chain
    // Keep track of contract addresses across different chains
    // Sepolia / Mainnet / Arbitrum

    NetworkConfig public activeConfig;

    struct NetworkConfig {
        address pricefeed; // ETH/USD pricefeed
    }

    constructor() {
        if (block.chainid == uint(11155111)) {
            activeConfig = getSepoliaEthConfig();
        }
        if (block.chainid == uint(421614)) {
            activeConfig = getArbSepoliaEthConfig();
        } else {
            activeConfig = getAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // pricefeed address
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getArbSepoliaEthConfig()
        public
        pure
        returns (NetworkConfig memory)
    {
        // pricefeed address
        NetworkConfig memory arbSepoliaConfig = NetworkConfig({
            pricefeed: 0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165
        });
        return arbSepoliaConfig;
    }

    function getAnvilEthConfig() public pure returns (NetworkConfig memory) {
        // pricefeed address
        // NetworkConfig memory anvilConfig = NetworkConfig({
        //     pricefeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // });
    }
}
