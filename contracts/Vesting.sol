// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "hardhat/console.sol";

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// Create a contract (vesting + token) with a token (XYZ token, 18 decimal ) supply of 100 Million.
// Admin/token deployer can enter upto ten addresses where the token will disperse evenly for 12 months.
// Token release schedule will be per min.

contract Vesting is ERC20 {
    address public admin;

    address public tokenDeployer;

    uint256 public vestingPeriod;

    address[] private disperseAddresses;

    uint256 public tokenReleaseInterval;

    uint256 public lastReleaseTimeStamp;

    uint256 public amountToRelease;

    constructor(
        uint256 _initialSupply,
        uint256 _vestingPeriod,
        uint256 _amountToRelease,
        uint256 _tokenReleaseInterval
    ) ERC20("XYZ", "XYZ") {
        _mint(address(this), _initialSupply * (10**decimals()));
        tokenDeployer = msg.sender;
        vestingPeriod = block.timestamp + (_vestingPeriod * 1 days);
        amountToRelease = _amountToRelease * 1 ether;
        tokenReleaseInterval = _tokenReleaseInterval * 1 minutes;
    }

    function setAdmin(address _address) public onlyAdminOrDeployer {
        admin = _address;
    }

    function addDisperseAddress(address _address) public onlyAdminOrDeployer {
        require(
            disperseAddresses.length < 10,
            "You can only add up to 10 addresses"
        );
        disperseAddresses.push(_address);
    }

    function sendTokens() external {
        require(block.timestamp < vestingPeriod, "Vesting period over");
        require(
            (block.timestamp - lastReleaseTimeStamp) > tokenReleaseInterval,
            "Too Recent"
        );

        for (uint256 i = 0; i < disperseAddresses.length; i++) {
            transfer(disperseAddresses[i], amountToRelease);
        }
        lastReleaseTimeStamp = block.timestamp;
    }

    function updateReleaseInterval(uint256 _minutes)
        public
        onlyAdminOrDeployer
    {
        tokenReleaseInterval = _minutes * 1 minutes;
    }

    function updateAmount(uint256 _amountToRelease) public onlyAdminOrDeployer {
        amountToRelease = _amountToRelease * 1 ether;
    }

    modifier onlyAdminOrDeployer() {
        require(
            msg.sender == admin || msg.sender == tokenDeployer,
            "address not authorized"
        );
        _;
    }
}
