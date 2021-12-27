// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

import "./fawa.sol";

contract Claim {
    event ClaimAirdropE(address toAddress, uint256 claimAmount, string refId);
    event ClaimIngameE(address toAddress, uint256 claimAmount, string refId, string userId);

    struct ClaimAirdropS {  
        uint256 status;
        uint256 amount;
    }
    
    struct ClaimIngameS {
        string[] refIds;
        uint256 status;
        uint256 totalAmount;
    }

    mapping(string => ClaimAirdropS) public claimAirdropMap;
    mapping(string => ClaimIngameS) public claimIngameMap;


    address public owner;
    IERC20 public token;

    constructor() {
        owner = msg.sender;
        token = new FAWATest(owner);
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "No permission");
        _;
    }

    function claimAirdrop(address toAddress, uint256 claimAmount, string memory refId) public payable OnlyOwner {
        require(claimAirdropMap[refId].status == 0, "It seems you've already done claim, please contact admin if something went wrong");
        claimAirdropMap[refId].status = 1;

        token.transfer(toAddress, claimAmount);
        emit ClaimAirdropE(toAddress, claimAmount, refId);

        claimAirdropMap[refId].amount = claimAmount;
    }

    function claimIngame(address toAddress, uint256 claimAmount, string memory refId, string memory userId) public payable OnlyOwner {
        require(claimIngameMap[userId].status != 0, "It seems you've already done claim, please contact admin if something went wrong");
        claimIngameMap[userId].status = 1;

        token.transfer(toAddress, claimAmount);
        emit ClaimIngameE(toAddress, claimAmount, refId, userId);

        claimIngameMap[userId].totalAmount += claimAmount;
        claimIngameMap[userId].refIds.push(refId);
        claimIngameMap[userId].status = 0;
    }

}
