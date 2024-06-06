//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    FundMe fundMe;
    address user = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;

    modifier funded() {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    function setUp() external {
        // FundMe is deployed by DeployFundMe.run()
        // owner will be msg.sender again
        // fundMe = new FundMe(0xd30e2101a97dcbAeBCBC04F14C3f624E67A35165);
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        // give user some money for the tests
        vm.deal(user, STARTING_BALANCE);
    }

    function test_MinDollarIsFive() public view {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    //msg.sender is not the owner
    function test_OwnerIsTheSender() public view {
        console.log(fundMe.getOwner());
        console.log(msg.sender);
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function test_PriceFeedVersion() public view {
        console.log(fundMe.getVersion());
        assertEq(fundMe.getVersion(), 4);
    }

    function test_FundFailsWithoutEnoughETH() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function test_UpdatesPublicDataStructure() public {
        vm.prank(user);
        // will be sent by user (make sure user has money)
        fundMe.fund{value: SEND_VALUE}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(user);
        assertEq(amountFunded, SEND_VALUE);
    }

    function test_AddsFunderToArrayFunders() public {
        vm.prank(user);
        fundMe.fund{value: SEND_VALUE}();

        address funder = fundMe.getFunder(0);

        assertEq(funder, user);
    }

    function test_onlyOwnerCanWithdraw() public funded {
        vm.expectRevert();
        vm.prank(user);
        fundMe.withdraw();
    }
}
