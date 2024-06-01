//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    function setUp() external {
        // FundMe is deployed by DeployFundMe.run()
        // owner will be msg.sender again
        // fundMe = new FundMe(0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
    }

    function test_MinDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    //msg.sender is not the owner
    function test_OwnerIsTheSender() public view {
        console.log(fundMe.i_owner());
        console.log(msg.sender);
        assertEq(fundMe.i_owner(), msg.sender);
    }

    function test_PriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }
}
