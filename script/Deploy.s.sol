// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Script, console} from "forge-std/Script.sol";
import {Trap, DiscordCadetTrap} from "../src/Trap.sol";

contract DeployScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the main Trap contract
        Trap trap = new Trap();
        console.log("Trap deployed at:", address(trap));

        // Optionally deploy Discord Cadet Trap
        DiscordCadetTrap discordTrap = new DiscordCadetTrap();
        console.log("Discord Cadet Trap deployed at:", address(discordTrap));

        vm.stopBroadcast();
    }
}

contract DeployTrapOnly is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        Trap trap = new Trap();
        console.log("Trap deployed at:", address(trap));

        vm.stopBroadcast();
    }
}

contract DeployDiscordTrapOnly is Script {
    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        DiscordCadetTrap discordTrap = new DiscordCadetTrap();
        console.log("Discord Cadet Trap deployed at:", address(discordTrap));

        vm.stopBroadcast();
    }
}
