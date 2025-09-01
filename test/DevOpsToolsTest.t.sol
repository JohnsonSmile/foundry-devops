// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Test} from "forge-std/Test.sol";
import {DevOpsTools} from "../src/DevOpsTools.sol";

contract DevOpsToolsTest is Test {
    string public constant SEARCH_PATH = "broadcast";

    function testGetMostRecentlyDeployedContract() public view {
        string memory contractName = "Stuff";
        uint256 chainId = 31337;
        address expectedAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        (address mostRecentDeployment, bool exists) = DevOpsTools
            .getLastDeployedContract(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
        assertEq(exists, true);
    }

    function testGetMostRecentlyDeployedEvenWhenMultipleAreDeployed()
        public
        view
    {
        string memory contractName = "FundMe";
        uint256 chainId = 1234;
        address expectedAddress = 0xCf7Ed3AccA5a467e9e704C703E8D87F634fB0Fc9;
        (address mostRecentDeployment, bool exists) = DevOpsTools
            .getLastDeployedContract(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
        assertEq(exists, true);
    }

    /// forge-config: default.allow_internal_expect_revert = true
    function testExpectRevertIfNoDeployment() public {
        string memory contractName = "MissingContract";
        uint256 chainId = 1234;
        vm.expectRevert(
            bytes.concat(
                "No contract named ",
                "'",
                bytes(contractName),
                "'",
                " has been deployed on chain ",
                bytes(vm.toString(chainId))
            )
        );
        DevOpsTools.mustLoadContract(contractName, chainId);
    }

    // All other tests use what appear to be legacy broadcast files
    // This one uses the newer type with no rpc property
    function testNonLegacyBroadcast() public view {
        string memory contractName = "NewStuff";
        uint256 chainId = 31337;
        address expectedAddress = 0x5FbDB2315678afecb367f032d93F642f64180aa3;
        (address mostRecentDeployment, bool exists) = DevOpsTools
            .getLastDeployedContract(contractName, chainId, SEARCH_PATH);
        assertEq(mostRecentDeployment, expectedAddress);
        assertEq(exists, true);
    }
}
