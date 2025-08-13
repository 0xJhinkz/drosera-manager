// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test, console} from "forge-std/Test.sol";
import {Trap, DiscordCadetTrap} from "../src/Trap.sol";

contract TrapTest is Test {
    Trap public trap;
    DiscordCadetTrap public discordTrap;

    function setUp() public {
        trap = new Trap();
        discordTrap = new DiscordCadetTrap();
    }

    function testCollect() public {
        bytes memory data = trap.collect();
        assertGt(data.length, 0, "Collect should return data");
        
        // Decode and verify the data
        (uint256 timestamp, uint256 blockNumber) = abi.decode(data, (uint256, uint256));
        assertEq(timestamp, block.timestamp, "Timestamp should match block.timestamp");
        assertEq(blockNumber, block.number, "Block number should match block.number");
    }

    function testShouldRespond() public {
        bytes memory collectData = trap.collect();
        bytes[] memory dataArray = new bytes[](1);
        dataArray[0] = collectData;
        
        (bool shouldRespond, bytes memory responseData) = trap.shouldRespond(dataArray);
        
        // The response depends on whether block number is even
        bool expectedResponse = block.number % 2 == 0;
        assertEq(shouldRespond, expectedResponse, "Should respond based on block number parity");
        
        if (shouldRespond) {
            assertGt(responseData.length, 0, "Response data should not be empty when responding");
        }
    }

    function testShouldRespondWithEmptyData() public {
        bytes[] memory emptyData = new bytes[](0);
        (bool shouldRespond, bytes memory responseData) = trap.shouldRespond(emptyData);
        
        assertFalse(shouldRespond, "Should not respond with empty data");
        assertEq(responseData.length, 0, "Response data should be empty");
    }

    function testDiscordTrapCollect() public {
        bytes memory data = discordTrap.collect();
        assertGt(data.length, 0, "Discord trap should return data");
        
        (bool active, string memory name) = abi.decode(data, (bool, string));
        assertEq(name, "YOUR_DISCORD_USERNAME", "Discord name should match constant");
    }

    function testDiscordTrapShouldRespond() public {
        // Create mock data
        bytes memory mockData = abi.encode(true, "TestUser");
        bytes[] memory dataArray = new bytes[](1);
        dataArray[0] = mockData;
        
        (bool shouldRespond, bytes memory responseData) = discordTrap.shouldRespond(dataArray);
        
        assertTrue(shouldRespond, "Should respond when active and name provided");
        assertGt(responseData.length, 0, "Response data should not be empty");
        
        string memory decodedName = abi.decode(responseData, (string));
        assertEq(decodedName, "TestUser", "Response should contain the username");
    }

    function testDiscordTrapShouldNotRespondWhenInactive() public {
        // Create mock data with inactive status
        bytes memory mockData = abi.encode(false, "TestUser");
        bytes[] memory dataArray = new bytes[](1);
        dataArray[0] = mockData;
        
        (bool shouldRespond,) = discordTrap.shouldRespond(dataArray);
        
        assertFalse(shouldRespond, "Should not respond when inactive");
    }

    function testDiscordTrapShouldNotRespondWithEmptyName() public {
        // Create mock data with empty name
        bytes memory mockData = abi.encode(true, "");
        bytes[] memory dataArray = new bytes[](1);
        dataArray[0] = mockData;
        
        (bool shouldRespond,) = discordTrap.shouldRespond(dataArray);
        
        assertFalse(shouldRespond, "Should not respond with empty name");
    }
}
