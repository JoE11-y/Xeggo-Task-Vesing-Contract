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

    address[] private vestedAddresses;

    uint256 public tokenReleaseInterval;

    uint256 public lastReleaseTimeStamp;

    uint256 public amountToRelease;

    /**
     * @notice Constructor that sets the initial states for the contract
     * @param _initialSupply: initial supply of the token
     * @param _vestingPeriod: vesting period of token
     * @param _amountToRelease: amount of tokens to release at each release interval
     * @param _tokenReleaseInterval: release schedule in minutes
     */
    constructor(
        uint256 _initialSupply,
        uint256 _vestingPeriod,
        uint256 _amountToRelease,
        uint256 _tokenReleaseInterval
    ) ERC20("XYZ", "XYZ") {
        _mint(address(this), _initialSupply * (10**decimals()));
        tokenDeployer = msg.sender;
        vestingPeriod = block.timestamp + (_vestingPeriod * 1 days);
        lastReleaseTimeStamp = block.timestamp;
        amountToRelease = _amountToRelease * 1 ether;
        tokenReleaseInterval = _tokenReleaseInterval * 1 minutes;
    }

    /**
     * @notice set admin address
     * @param _address: address of admin
     */
    function setAdmin(address _address) public onlyAdminOrDeployer {
        admin = _address;
    }

    /**
     * @notice adds vested address to array
     * @param _address: new address
     */
    function addVestedAddress(address _address) public onlyAdminOrDeployer {
        require(
            vestedAddresses.length < 10,
            "You can only add up to 10 addresses"
        );
        require(_address != address(0), "not zero address");
        vestedAddresses.push(_address);
    }

    /**
     * @notice sends token to vested addresses
     */
    function sendTokens() external {
        require(block.timestamp < vestingPeriod, "Vesting period over");
        require(
            (block.timestamp - lastReleaseTimeStamp) > tokenReleaseInterval,
            "Too Recent"
        );

        for (uint256 i = 0; i < vestedAddresses.length; i++) {
            transfer(vestedAddresses[i], amountToRelease);
        }
        lastReleaseTimeStamp = block.timestamp;
    }

    /**
     * @notice changes release interval
     * @param _minutes: new interval in minutes
     */
    function updateReleaseInterval(uint256 _minutes)
        public
        onlyAdminOrDeployer
    {
        tokenReleaseInterval = _minutes * 1 minutes;
    }

    /**
     * @notice changes amount of token to release
     * @param _amountToRelease: new amount to release
     */
    function updateAmount(uint256 _amountToRelease) public onlyAdminOrDeployer {
        amountToRelease = _amountToRelease * 1 ether;
    }

    /**
     * @notice returns array of vested addresses
     */
    function getVestedAddresses() public view returns (address[] memory) {
        return vestedAddresses;
    }

    modifier onlyAdminOrDeployer() {
        require(
            msg.sender == admin || msg.sender == tokenDeployer,
            "address not authorized"
        );
        _;
    }
}
