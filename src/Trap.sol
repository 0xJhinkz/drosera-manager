// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "drosera-contracts/interfaces/ITrap.sol";

/**
 * @title ExampleTrap
 * @dev Example implementation of a Drosera trap contract
 * @notice This is a template trap that can be customized for your specific monitoring needs
 */
contract Trap is ITrap {
    /// @notice Collects data from the blockchain to be processed
    /// @return Encoded data that will be passed to shouldRespond
    function collect() external view returns (bytes memory) {
        // Example: Monitor block timestamp and number
        uint256 blockTimestamp = block.timestamp;
        uint256 blockNumber = block.number;
        
        // You can add your custom monitoring logic here
        // For example:
        // - Check contract state changes
        // - Monitor specific events
        // - Analyze transaction patterns
        // - Track token balances
        
        return abi.encode(blockTimestamp, blockNumber);
    }

    /// @notice Determines if the trap should respond based on collected data
    /// @param data Array of encoded data from collect() calls
    /// @return shouldRespond Whether the trap should trigger a response
    /// @return responseData Encoded response data if shouldRespond is true
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, "");
        }

        // Decode the collected data
        (uint256 timestamp, uint256 blockNumber) = abi.decode(data[0], (uint256, uint256));
        
        // Example condition: Respond if block number is even
        // Replace this with your custom logic
        bool condition = blockNumber % 2 == 0;
        
        if (condition) {
            // Prepare response data
            bytes memory responseData = abi.encode(
                "Trap triggered",
                timestamp,
                blockNumber
            );
            return (true, responseData);
        }
        
        return (false, "");
    }
}

/**
 * @title DiscordCadetTrap
 * @dev Special trap for Discord Cadet role verification
 * @notice This trap is used specifically for earning Discord Cadet roles
 */
contract DiscordCadetTrap is ITrap {
    /// @notice Response contract address for Discord Cadet verification
    address public constant RESPONSE_CONTRACT = 0x25E2CeF36020A736CF8a4D2cAdD2EBE3940F4608;
    
    /// @notice Your Discord username (replace with actual username)
    string constant DISCORD_NAME = "YOUR_DISCORD_USERNAME";

    /// @notice Interface for the mock response contract
    interface IMockResponse {
        function isActive() external view returns (bool);
    }

    /// @notice Collects data for Discord Cadet verification
    /// @return Encoded data containing activity status and Discord name
    function collect() external view returns (bytes memory) {
        bool active = IMockResponse(RESPONSE_CONTRACT).isActive();
        return abi.encode(active, DISCORD_NAME);
    }

    /// @notice Determines if should respond for Discord verification
    /// @param data Array of encoded data from collect() calls
    /// @return shouldRespond Whether to trigger response
    /// @return responseData Encoded Discord username if conditions are met
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory) {
        if (data.length == 0) {
            return (false, "");
        }

        (bool active, string memory name) = abi.decode(data[0], (bool, string));
        
        if (!active || bytes(name).length == 0) {
            return (false, "");
        }

        return (true, abi.encode(name));
    }
}
